public with sharing class FacebookConnect {

    public String blurbid { get; set; }
    
    public String enterpriseblurbid { get; set; }
    
    public String code { get; set; }
    
    public String status { get; set; }
    
    public String expiresin{ get; set; }
    
    public String callbackUrl  { get; set; } 
    
    public String mybody{ get; set; }
    public String fbtokenbody{ get; set; }
    
    public String accesstoken { get; set; }
    
    public String fbid { get; set; }
    public String fbname { get; set; }
    public String fbpicture { get; set; }
    public String fbconnectbody{ get; set; }
    public String scope {get; set;}
    
    
     

     public facebookconnect()
     {

   
     
      
      

     }
     
     
     public pagereference fbconnect() {
      
      
      callbackUrl = EncodingUtil.urlEncode('https://'+ApexPages.currentPage().getHeaders().get('Host')+
                                                 Page.FacebookConnector.getUrl(),'UTF-8');
      code = ApexPages.currentPage().getParameters().get('code');
      blurbid = ApexPages.currentPage().getParameters().get('blurbid');
      enterpriseblurbid = ApexPages.currentPage().getParameters().get('ebid');
      //accesstoken = ApexPages.currentPage().getParameters().get('access_token');
      scope = 'email public_profile user_friends publish_actions';
      
      
      
      if(code==null)
      {
         system.debug('SUCCESS'); 
         string callbackUrl = EncodingUtil.urlEncode('https://'+ApexPages.currentPage().getHeaders().get('Host')+
                                                     Page.facebookconnector.getUrl(),'UTF-8');
                                                     
         //string callbackUrl = 'http://chelsea.com/Account/ExternalLoginCallback';
                                                     
         system.debug('URL IS###'+ApexPages.currentPage());
         system.debug('Callbackurl:::'+ callbackurl);
         utilityclass util = new utilityclass();
         util.getAppsettings();
         socxoAppsettings__c sett= socxoAppsettings__c.getValues('socxoAppsettings');
         
         String url = 'https://www.facebook.com/dialog/oauth?';
         //url += 'client_id=755760694472509';
         url += 'client_id='+sett.FbAppkey__c;
         url += '&scope=' + EncodingUtil.urlEncode(scope, 'UTF-8');
         url +='&redirect_uri='+ callbackUrl;
         url +='&state='+blurbid;
         system.debug('URLLL ::'+url);
         return new pagereference(url);
     }
     
     else {
        
        
        utilityclass util = new utilityclass();
        fbtokenbody = util.getmefacebooktoken(code,callbackurl);
        

        
        //splitting the response.
        
        Map<String,String> rp = getUrlParams(fbtokenbody);
        system.debug('00000000'+rp);
        
        //Now we have the access token inside a map.Calling the fb api to get the avatharimage url and stuff.
        
        if(rp.size() > 0)
        
        {  
        mybody =util.getmybody(rp.get('access_token'));
        system.debug('mmmmmmmm'+mybody);
        
       
       //parsing down the response.
       
       

         
     //Parsing seems not the best of choices. So going with wrapper classes.
     
      response m = (response)JSON.deserialize(mybody,response.class);   
      system.debug('JSON########'+m); 
      system.debug('JSON1########'+m.picture);  
      system.debug('JSON1########'+m.picture.data);  
      system.debug('JSON1########'+m.picture.data.url);
      system.debug('JSON1########'+m.id);
      system.debug('JSON1########'+m.name);
      
      //fbconnectbody = util.fbconnect(rp.get('access_token'),m.picture.data.url,m.id,m.name);
      socxoAppsettings__c sett= socxoAppsettings__c.getValues('socxoAppsettings'); 
      fbconnectbody = util.fbconnect(m.id, rp.get('access_token'), m.name, sett.FbAppSecret__c); 
      system.debug('fbconnectbody  :' +fbconnectbody); 
       } 
        
      return null;
     
     
     
     } 
     }
     
     
// to get the token since fb is returning the in urlencoded form


private Map<String,String> getUrlParams(String value) {

        Map<String,String> res = new Map<String,String>();
        if(value==null || value=='') {
            return res;
        }
        for(String s : value.split('&')) {
            System.debug('getUrlParams: '+s);
            List<String> kv = s.split('=');
            if(kv.size()>1) {
              // RFC 5849 section 3.4.1.3.1 and 3.4.1.3.2 specify that parameter names 
              // and values are decoded then encoded before being sorted and concatenated
              // Section 3.6 specifies that space must be encoded as %20 and not +
              String encName = EncodingUtil.urlEncode(EncodingUtil.urlDecode(kv[0], 'UTF-8'), 'UTF-8').replace('+','%20');
              String encValue = EncodingUtil.urlEncode(EncodingUtil.urlDecode(kv[1], 'UTF-8'), 'UTF-8').replace('+','%20');
              System.debug('getUrlParams:  -> '+encName+','+encValue);
              res.put(encName,encValue);
            }
        }
        return res;
    }
    


//Wrappers

public class response{
     
     public wrapper picture{get;set;}
     public string id{get;set;}
     public string name{get;set;}
     } 

Public class wrapper{
   public DATA data {get;set;}
   }
   
 public class DATA{
 
 public boolean is_silhouette {get;set;}       
 public string url {get;set;}
     
     }
     
}