public with sharing class utilityclass {


Public string getmetoken(string s,string url)
 {
  
 Http ht = new Http();
    HttpRequest req = new HttpRequest();
    HttpResponse res =new HttpResponse();
    req.setHeader('content-type','text/plain');
    req.setMethod('POST');
    req.setBody(s);
    req.setEndpoint(url);
    system.debug('Request1'+req);
    system.debug('sssssss'+s);
    try {
           res = ht.send(req);
           string postbody=res.getBody();
           system.debug('PPPPPPP'+postbody);
     } catch(Exception e) {
            System.debug('Callout error: '+ e);
            System.debug(res.toString());
        }
    return res.getBody();
 }

public string getmerelatedblurbs (Id recid, string category) {

    List<SOCXO_token__c> currenttoken1 = [select Access_Token__c,expireson__c,tenanentendpoint__c from SOCXO_token__c where Id =:recid];

    //string categoryendpoint = 'http://testenv.socxo.com/api/blurb/private/1/'+Integer.valueof(category);
    string categoryendpoint ='http://testenv.socxo.com/api/2.0/company/'+Integer.valueof(category)+'/blurbs';
   
    Http h = new Http();
    HttpRequest req = new HttpRequest();
    req.setHeader('content-type','application/json');
   // req.setHeader('content-type','message/rfc822');
    req.setHeader('Accept','application/json');
    req.setHeader('Authorization', 'Bearer ' +currenttoken1[0].Access_Token__c);
    req.setMethod('GET');
    req.setEndpoint(categoryendpoint); 
    System.debug('Sending request...');
    HttpResponse res = h.send(req);
    string body2 = res.getBody();
    System.debug('Received response ('+res.getStatusCode()+' '+res.getStatus()+')');        
    system.debug('Related Blurbs Response::'+body2);
    return body2;
    }


    public string getAllBlurbs(Id recId){
      List<SOCXO_token__c> currenttoken1 = [select Access_Token__c,expireson__c,tenanentendpoint__c from SOCXO_token__c where Id =:recid];
      string categoryendpoint = 'http://testenv.socxo.com/api/2.0/company/blurbs';
      Http h = new Http();
    HttpRequest req = new HttpRequest();
    req.setHeader('content-type','application/json');
   // req.setHeader('content-type','message/rfc822');
    req.setHeader('Accept','application/json');
    req.setHeader('Authorization', 'Bearer ' +currenttoken1[0].Access_Token__c);
    req.setMethod('GET');
    req.setEndpoint(categoryendpoint); 
    System.debug('Sending request...');
    HttpResponse res = h.send(req);
    string body2 = res.getBody();
    System.debug('Received response ('+res.getStatusCode()+' '+res.getStatus()+')');        
    system.debug('All Blurbs Response::'+body2);
    return body2;
    }
  
  //method to gather user information necessary to connect with facebook.
  
  public string togetuserinformation() {
  
     List<SOCXO_token__c> currenttoken1 = [select Access_Token__c,expireson__c,tenanentendpoint__c from SOCXO_token__c where  SOCXO_Service__r.SFuser__r.Id =:userinfo.getuserid()];

    string categoryendpoint = 'http://testenv.socxo.com/api/2.0/user/profile';
    Http h = new Http();
    HttpRequest req = new HttpRequest();
    req.setHeader('content-type','application/json');
    req.setHeader('content-type','message/rfc822');
    req.setHeader('Accept','application/json');
    req.setHeader('Authorization', 'Bearer ' +currenttoken1[0].Access_Token__c);
    req.setMethod('GET');
    req.setEndpoint(categoryendpoint); 
    System.debug('Sending request...');
    HttpResponse res = h.send(req);
    string body2 = res.getBody();
    System.debug('Received response ('+res.getStatusCode()+' '+res.getStatus()+')');        
    system.debug('User Information Response::'+body2);
    return body2;
    }  
    
   //Method to post in facebook.
   
   public string facebookpost(string userBlurbId, string title, string description,string comment) {
   
   String s;
        /*s='BlurbId='+par1;
        s+='&EnterpriseBlurbId=';
        s+=par2; */
         
       // s= '{"UserBlurbId":"'+userBlurbId+'","Title":"'+title+'","Description":"'+description+'","Comment":"'+comment+'"}';
        
        s = '{\"UserBlurbId\":';
        s+='\"'+userBlurbId+'\"';
        
        if(title!=NULL){
        s+=',\"Title\":';
        s+='\"'+title+'\"';
        }
        
        if(description!=NULL){
        s+=',\"Description\":';
        s+='\"'+description+'\"';
        }
        
        if(comment!=NULL){
        s+=',\"Comment\":';
        s+='\"'+comment+'\"';
        }
        
        s+='}';
    
   
   system.debug('SSSSSSSS'+s);
    List<SOCXO_token__c> currenttoken1 = [select Access_Token__c,expireson__c,tenanentendpoint__c from SOCXO_token__c where  SOCXO_Service__r.SFuser__r.Id =:userinfo.getuserid()];

    string categoryendpoint = 'http://testenv.socxo.com/api/2.0/socialmedia/facebook/post';
    Http h = new Http();
    HttpRequest req = new HttpRequest();
    system.debug('Accesstoken::::' + currenttoken1[0].Access_Token__c);
    req.setHeader('content-type','application/json');
    //req.setHeader('content-type','message/rfc822');
    req.setHeader('Accept','application/json');
    req.setHeader('Authorization', 'Bearer ' +currenttoken1[0].Access_Token__c);
    req.setMethod('POST');
    req.setBody(s);
    req.setEndpoint(categoryendpoint); 
    System.debug('Sending request...');
    HttpResponse res = h.send(req);
    string body2 = res.getBody();
    System.debug('Received response ('+res.getStatusCode()+' '+res.getStatus()+')');        
    system.debug('body22222'+body2);
    return body2;
   
   
   }

   //Method to post in twitter

   public string twitterpost(string userBlurbId, string title) {
    
    String s;
      /*blurbids='BlurbId='+par1;
      blurbids+='&EnterpriseBlurbId='+par2;*/

     // blurbids = '{"UserBlurbId":"'+userBlurbId+'","Title":"'+title+'"}';

        s = '{\"UserBlurbId\":';
        s+='\"'+userBlurbId+'\"';
        
        if(title!=NULL){
        s+=',\"Title\":';
        s+='\"'+title+'\"';
        }
        
        s+= '}';
    System.debug('BlurbidsTwitter'+s);

    List <SOCXO_token__c> currenttoken1 = [SELECT Access_Token__c,expireson__c,tenanentendpoint__c from SOCXO_token__c where  SOCXO_Service__r.SFuser__r.Id =:userinfo.getuserid()];

    string categoryendpoint = 'http://testenv.socxo.com/api/2.0/socialmedia/twitter/post';
    Http h = new Http();
    HttpRequest req = new HttpRequest();
    req.setHeader('Accept','application/json');
    req.setHeader('content-type', 'application/json');
    req.setHeader('Authorization','Bearer '+currenttoken1[0].Access_Token__c);
    req.setMethod('POST');
    req.setBody(s);
    req.setEndpoint(categoryendpoint); 
    System.debug('Sending request...');
    HttpResponse res = h.send(req);
    string body2 = res.getBody();
    System.debug('Received response ('+res.getStatusCode()+' '+res.getStatus()+')');        
    system.debug('body22222'+body2);
    return body2;

   }

   public string linkedinPost(string userBlurbId, string title, string description,string comment) {
    String s;
    /*blurbids = 'BlurbId='+par1;
    blurbids+='&EnterpriseBlurbId='+par2;*/

   // blurbids = '{"UserBlurbId":"'+userBlurbId+'","Title":"'+title+'","Description":"'+description+'","Comment":"'+comment+'"}';
   
        s = '{\"UserBlurbId\":';
        s+='\"'+userBlurbId+'\"';
        
        if(title!=NULL){
        s+=',\"Title\":';
        s+='\"'+title+'\"';
        }
        
        if(description!=NULL){
        s+=',\"Description\":';
        s+='\"'+description+'\"';
        }
        
        if(comment!=NULL){
        s+=',\"Comment\":';
        s+='\"'+comment+'\"';
        }
        
        s+='}';

    List <SOCXO_token__c> currenttoken1 = [SELECT Access_Token__c,
                                                  expireson__c 
                                                  FROM SOCXO_token__c 
                                                  WHERE SOCXO_Service__r.SFuser__r.ID =:userinfo.getuserid()];

    string categoryendpoint = 'http://testenv.socxo.com/api/2.0/socialmedia/linkedin/post';
    Http h = new Http();
    HttpRequest req = new HttpRequest();

    req.setEndpoint(categoryendpoint);
    req.setHeader('Accept','application/json');
    req.setHeader('content-type', 'application/json');
    req.setHeader('Authorization','Bearer '+currenttoken1[0].Access_Token__c);
    req.setMethod('POST');
    req.setBody(s);
    System.debug('Sending request(linkedin)....');
    HttpResponse res = h.send(req);
    string body2 = res.getBody();
    System.debug('Received response ('+res.getStatusCode()+' '+res.getStatus()+')');        
    system.debug('body22222'+body2);

    return body2;
    
   }

   
   

   //Method to get token from facebook if the user is not logged in.
   
   public string getmefacebooktoken(string code,string call) {
   
   socxoAppsettings__c sett= socxoAppsettings__c.getValues('socxoAppsettings');
   String s;
        s='https://graph.facebook.com/oauth/access_token?';
        //s+='client_id=755760694472509';
        s+='client_id='+sett.FbAppkey__c;
        
        s+='&redirect_uri=';
        s+=call;
        s+='&code=';
        s+=code;
        s+='&client_secret=';
        s+=sett.FbAppSecret__c;
        
   
   system.debug('SSSSSSSS'+s);

    Http h = new Http();
    HttpRequest req = new HttpRequest();
    //req.setHeader('content-type','application/json');
    //req.setHeader('content-type','message/rfc822');
    req.setHeader('Accept','application/json');
    //req.setHeader('Authorization', 'Bearer ' +currenttoken1[0].Access_Token__c);
    req.setMethod('GET');
    //req.setBody(s);
    req.setEndpoint(s); 
    System.debug('Sending request...');
    HttpResponse res = h.send(req);
    string body2 = res.getBody();
    System.debug('Received response ('+res.getStatusCode()+' '+res.getStatus()+')');        
    system.debug('Facebook Token response'+body2);
    return body2;
   
   }

    public String fetchLinkedinToken(string code,string redirectPage){
        String getToken;
         socxoAppsettings__c sett= socxoAppsettings__c.getValues('socxoAppsettings'); 
        getToken = 'https://www.linkedin.com/uas/oauth2/accessToken?';
        getToken+='grant_type=authorization_code';
        getToken+='&code='+code;
        getToken+='&redirect_uri='+redirectPage;
        getToken+='&client_id='+ sett.LinkedInAppKey__c;
        getToken+='&client_secret='+ sett.LinkedInAppSecret__c;
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(getToken);
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        
        HttpResponse res = h.send(req);
        string body = res.getBody();
        System.debug('linkedinbody('+res.getStatusCode()+''+ res.getStatus()+')');
        System.debug('linkedinbody:::'+body);
        return body;
        
    }
   

   /*public string getmetwittertoken(string code, string call) {

   }
*/
   
   public string getmybody(string accesstoken)
   
   {
   
   //string s = 'https://graph.facebook.com/me';
   //string s = 'https://graph.facebook.com/v1.0/100006293131598?username';
   string s = 'https://graph.facebook.com/v1.0/me?fields=id,name,picture';
   Http h = new Http();
   HttpRequest req = new HttpRequest();
   req.setHeader('content-type','application/json');
   req.setHeader('Accept','application/json');
   req.setHeader('Authorization', 'Bearer ' +accesstoken);
   req.setMethod('GET');
    //req.setBody(s);
   req.setEndpoint(s); 
   System.debug('Sending request...');
   HttpResponse res = h.send(req);
   string body2 = res.getBody();
   System.debug('Received response ('+res.getStatusCode()+' '+res.getStatus()+')');        
   system.debug('mybody'+body2);
   return body2;
   
   }

   public string getLinkedinbody(string accesstoken)        
    {
        System.debug('linked accesstoken ' + accesstoken);
        String endpoint = 'https://api.linkedin.com/v1/people/~:(id,email-address)?format=json&oauth2_access_token=' + accesstoken;
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setHeader('content-type','application/json');
        req.setHeader('Accept','application/json');
        //req.setHeader('Authorization', 'Bearer ' +accesstoken);
        req.setMethod('GET');
        //req.setBody(s);
        req.setEndpoint(endpoint); 
        System.debug('Sending request...');
        HttpResponse res = h.send(req);
        string body2 = res.getBody();
        System.debug('Received response ('+res.getStatusCode()+' '+res.getStatus()+')');        
        system.debug('mybody'+body2);
        return body2;        
    }
   
 
    public string fbconnect(string id, string accesstoken, string name, string secret)
    {
    
       List<SOCXO_token__c> currenttoken1 = [select Access_Token__c,expireson__c,tenanentendpoint__c from SOCXO_token__c where  SOCXO_Service__r.SFuser__r.Id =:userinfo.getuserid()];

       string connectendpoint = 'http://testenv.socxo.com/api/2.0/socialmedia/facebook/connect';
       String s;

        s='{\"ProviderUserId\":';
        s+='\"'+id+'\"';

        s+=',\"AccessToken\":';
        s+='\"'+accesstoken+'\"';

        s+=',\"ProviderUserName\":';
        s+='\"'+name+'\"';

        s+=',\"TokenSecret\":';
        s+='\"'+secret+'\"';
        s+='};';

    system.debug('sssssss'+s);    
    Http h = new Http();
    HttpRequest req = new HttpRequest();
    req.setHeader('content-type','application/json');
    //req.setHeader('content-type','message/rfc822');
    req.setHeader('Accept','application/json');
    req.setHeader('Authorization', 'Bearer ' +currenttoken1[0].Access_Token__c);
    req.setMethod('POST');
    req.setBody(s);
    req.setEndpoint(connectendpoint); 
    System.debug('Sending request...');
    HttpResponse res = h.send(req);
    string body2 = res.getBody();
    System.debug('Received response ('+res.getStatusCode()+' '+res.getStatus()+')');        
    system.debug('body22222'+body2);
    return body2;
        
        
        
           
   }

   public string twitterconnect(string accesstoken, string id, string tokensecret){

    List<SOCXO_token__c> currenttoken1 = [select Access_Token__c,expireson__c,tenanentendpoint__c from SOCXO_token__c where  SOCXO_Service__r.SFuser__r.Id =:userinfo.getuserid()];

       /*TwitterDetails tdetails = new TwitterDetails();
       Map <String,String> twittermap = new Map <String,String>();*/
       string connectendpoint = 'http://testenv.socxo.com/api/2.0/socialmedia/twitter/connect';
       String s;

        s='{\"AccessToken\":';
        s+='\"'+accesstoken+'\"';

        /*s+=',\"AvatharImageUrl\":';
        s+='\"'+url+'\"';

        s+=',\"ProviderUserName\":';
        s+='\"'+name+'\"';*/

        s+=',\"ProviderUserId\":';
        s+='\"'+id+'\"';

        s+=',\"TokenSecret\":'; 
        s+='\"'+tokensecret+'\"';
        s+='};';

        /*twittermap = tdetails.getUrlParams(s);
        s = (string)twittermap;*/

        system.debug('bodytwitter###'+s);
        Http h = new Http();
    HttpRequest req = new HttpRequest();
    req.setHeader('content-type','application/json');
    //req.setHeader('content-type','message/rfc822');
    req.setHeader('Accept','application/json');
    req.setHeader('Authorization', 'Bearer ' +currenttoken1[0].Access_Token__c);
    req.setMethod('POST');
    req.setBody(s);
    req.setEndpoint(connectendpoint); 
    System.debug('Sending request...');
    HttpResponse res = h.send(req);
    string body2 = res.getBody();
    System.debug('Received response ('+res.getStatusCode()+' '+res.getStatus()+')');        
    system.debug('body22222'+body2);
    return body2;
   }

   public string linkedinConnect(string id, string accesstoken, string secret)
    {    
        List<SOCXO_token__c> currenttoken1 = [select Access_Token__c,expireson__c,tenanentendpoint__c from SOCXO_token__c where  SOCXO_Service__r.SFuser__r.Id =:userinfo.getuserid()];
        
        string connectendpoint = 'http://testenv.socxo.com/api/2.0/socialmedia/linkedin/connect';
        String s;
        
        s='{\"ProviderUserId\":';
        s+='\"'+id+'\"';
        
        s+=',\"AccessToken\":';
        s+='\"'+accesstoken+'\"';
        
        /*s+=',\"ProviderUserName\":';
        s+='\"'+name+'\"';*/
        
        s+=',\"TokenSecret\":';
        s+='\"'+secret+'\"';
        s+='};';
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setHeader('content-type','application/json');    
        req.setHeader('Accept','application/json');
        req.setHeader('Authorization', 'Bearer ' +currenttoken1[0].Access_Token__c);
        req.setMethod('POST');
        req.setBody(s);
        req.setEndpoint(connectendpoint); 
        
        HttpResponse res = h.send(req);
        string body = res.getBody();
        System.debug('Received response ('+res.getStatusCode()+' '+res.getStatus()+')');            
        return body;   
    }


   //Method to fetch Linkedin access Token
   
//This function will send email ids to SoCXO for sending invites
  public string sendInvite (string emailList) {

    List<SOCXO_token__c> currenttoken1 = [select Access_Token__c,expireson__c,tenanentendpoint__c from SOCXO_token__c ];

    string categoryendpoint = 'http://testenv.socxo.com/api/2.0/invitation/externalinvite';
    Http h = new Http();
    HttpRequest req = new HttpRequest();
    req.setHeader('content-type','application/json');
   // req.setHeader('content-type','message/rfc822');
    req.setHeader('Accept','application/json');
    req.setHeader('Authorization', 'Bearer ' +currenttoken1[0].Access_Token__c);
    req.setMethod('GET');
    req.setEndpoint(categoryendpoint);
    wrapper wra = new wrapper();
    wra.InvitationUrl ='https://c.ap2.visual.force.com/apex/RegisterSocxo';
    wra.CSVEmails=emailList;
   // string bdy = JSON.Stringify(wra);
   // system.debug('bdy '+bdy);
    string bdy ='{ "InvitationUrl": "https://c.ap2.visual.force.com/apex/RegisterSocxo", "CSVEmails": "'+emailList+'"}';  
    req.setBody(bdy);
    System.debug('Sending request...');
    HttpResponse res = h.send(req);
    string body2 = res.getBody();
    System.debug('Received response ('+res.getStatusCode()+' '+res.getStatus()+')');
    system.debug('body22222'+body2);
    return body2;
    }
   public class wrapper{
   public string InvitationUrl{get; set;}
   public string CSVEmails{get; set;}

   }
   
   // User registration of already invited users
    public string userRegister(string email, string pwd, string fullname, string firstname) {
      List<SOCXO_token__c> currenttoken1 = [select Access_Token__c,expireson__c,tenanentendpoint__c from SOCXO_token__c ];

    string categoryendpoint = 'http://testenv.socxo.com/api/2.0/account/register';
    Http h = new Http();
    HttpRequest req = new HttpRequest();
    req.setHeader('content-type','application/json');
    //req.setHeader('content-type','message/rfc822');
    req.setHeader('Accept','application/json');
    req.setHeader('Authorization', 'Bearer ' +currenttoken1[0].Access_Token__c);
    req.setMethod('POST');
    req.setEndpoint(categoryendpoint); 
    string body = '{  "UserName":"'+email+'", "Password":"'+pwd+'","FullName":"'+fullname+'", "FirstName":"'+firstname+'", "LocalTime":null }';
    req.setBody(body);
    req.setTimeout(6000); 
    System.debug('Sending request...');
    HttpResponse res = h.send(req);
    string body2 = res.getBody();
    registrationwrapper wra = new registrationwrapper();
    wra = (registrationwrapper)Json.deserialize(res.getBody(),registrationwrapper.class);
    System.debug('Received response ('+res.getStatusCode()+' '+res.getStatus()+')');
    system.debug('body22222'+body2);
    return String.valueof(wra.status);


    }


 public string getAppsettings() {
      List<SOCXO_token__c> currenttoken1 = [select Access_Token__c,expireson__c,tenanentendpoint__c from SOCXO_token__c ];
      List<socxoAppsettings__c > sett= socxoAppsettings__c.getall().values();  
       if(sett.size()==0)
    {
      
    string categoryendpoint = 'http://testenv.socxo.com/api/2.0/tenant/appsettings';
    Http h = new Http();
    HttpRequest req = new HttpRequest();
    req.setHeader('content-type','application/json');
    //req.setHeader('content-type','message/rfc822');
    req.setHeader('Accept','application/json');
    req.setHeader('Authorization', 'Bearer ' +currenttoken1[0].Access_Token__c);
    req.setMethod('GET');
    req.setEndpoint(categoryendpoint); 
    
    //req.setBody(body);
    req.setTimeout(6000); 
    System.debug('Sending request...');
    HttpResponse res = h.send(req);
    string body2 = res.getBody();
    socxoAppSettings wra = new socxoAppSettings();
    wra = (socxoAppSettings)Json.deserialize(res.getBody(),socxoAppSettings.class);
    System.debug('Received response ('+res.getStatusCode()+' '+res.getStatus()+')');
    system.debug('wra.AppKeys  '+wra.AppKeys );
    System.Debug('wra.Status:'+wra.Status);
    if(wra.Status=='1000')
    {
   
       
        socxoAppsettings__c settings= new socxoAppsettings__c ();
        settings.Name='socxoAppsettings';
        settings.FbAppkey__c=wra.AppKeys.FbAppkey;
        settings.FbAppSecret__c=wra.AppKeys.FbAppSecret;
        settings.TwitterAppkey__c=wra.AppKeys.TwitterAppkey;
        settings.TwitterAppSecret__c=wra.AppKeys.TwitterAppSecret;
        settings.LinkedInAppKey__c =wra.AppKeys.LinkedInAppKey;
        settings.LinkedInAppSecret__c =wra.AppKeys.LinkedInAppSecret;
        System.Debug('settings:'+settings);
        insert settings;
         return String.valueof(wra.Status);
    }
     return String.valueof(wra.Status);
    }
    else
    {
        return 'already have the keys';
    
    }

    }

public class registrationwrapper{

public string errorId {get;set;}
public string status {get;set;}
public string message{get;set;}

}
public class socxoAppSettings{

public socxoAppkeys AppKeys {get;set;}
public string Status{get;set;}
public string Message{get;set;}

}
public class socxoAppkeys{
public string FbAppkey{get;set;}
public string FbAppSecret{get;set;}
public string TwitterAppkey{get;set;}
public string TwitterAppSecret{get;set;}
public string LinkedInAppKey{get;set;}
public string LinkedInAppSecret{get;set;}

}

 public class loginError {
              public String error{get; set;}
              public String error_description {get; set;}
            }


    //to get code
   
   public PageReference getmecode(string url)
   {
   return new PageReference(url);
   }
   
    
    
    
    
    
    }