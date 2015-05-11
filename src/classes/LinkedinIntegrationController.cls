public class LinkedinIntegrationController{
    
    public String authCodeUrl{get;set;}
    public String redirectPage {get;set;}
    public String state {get;set;}
    public String scope {get;set;}
    
    private String clientid {get;set;}
    public String authCode {get;set;}
    public String blurdId {get;set;}
    public String enterpriseBlurbId {get;set;}
    
    public String accessTokenBody{ get; set; }
    public String linkedInConnectBody{get; set;}
    public String linkedinBody{ get; set; }
    public String linkedinTokenBody {get; set;}

    
    public LinkedinIntegrationController() {
        
    }
    
    public pageReference linkedinUserDetails() {

        
        authCode = ApexPages.currentPage().getParameters().get('code');
        blurdId = ApexPages.currentPage().getParameters().get('blurdid');
        enterpriseBlurbId = ApexPages.currentPage().getParameters().get('ebid');
        redirectPage = EncodingUtil.urlEncode('https://'+ApexPages.currentPage().getHeaders().get('Host')+
                                                 Page.linkedinPage.getUrl(),'UTF-8');

        scope = 'w_share r_basicprofile r_emailaddress';

        if(authCode == NULL){
        socxoAppsettings__c sett= socxoAppsettings__c.getValues('socxoAppsettings'); 
            authCodeUrl = 'https://www.linkedin.com/uas/oauth2/authorization';
            scope = EncodingUtil.urlEncode(scope, 'UTF-8');
            state = String.valueOf(Crypto.getRandomLong());
            authCodeUrl += '?response_type=code';
            authCodeUrl += '&client_id='+sett.LinkedInAppKey__c;
            authCodeUrl += '&scope='+ scope;
            authCodeUrl += '&redirect_uri='+ redirectPage;
            authCodeUrl += '&state='+ state;
            
            
            pageReference p = new pageReference (authCodeUrl);
            return p;
        }
        else{
            utilityclass util = new utilityclass();
            linkedinTokenBody = util.fetchLinkedinToken(authCode,redirectPage);

            accessTokenParser accToken = (accessTokenParser)JSON.deserialize(linkedinTokenBody, accessTokenParser.class);
            
            
            
            if(accToken.access_token != NULL){
            linkedinBody = util.getLinkedinbody(accToken.access_token);
            system.debug('linkedinbody = ' + linkedinBody);
            
            linkedinUserDetail userDetail = (linkedinUserDetail)JSON.deserialize(linkedinBody, linkedinUserDetail.class);
            system.debug('linkedinDetails:::'+userDetail  );
            socxoAppsettings__c sett= socxoAppsettings__c.getValues('socxoAppsettings'); 
            linkedInConnectBody = util.linkedinConnect(userDetail.id, accToken.access_token, sett.LinkedInAppSecret__c);

            system.debug('linkedinbodyDetails::::' + linkedInConnectBody);

            }
            
            return null;
        
        }
    }
    
    /*
    */

    
    
   
    //wrapper class to parse access token response
    public class accessTokenParser{
        public String access_token {get; set;}
        public String expires_in {get; set;}
    }

    public class linkedinUserDetail {
        public string id {get;set;}
       // public string emailaddress {get; set;}
    }    
}