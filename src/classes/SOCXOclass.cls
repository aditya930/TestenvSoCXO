//controller for the SOCXO VF page.

public class SOCXOclass
{
//Variables and properties
 public String password   { get; set; }
 public String username { get; set; } 
 public boolean req1 {get;set;}
 public boolean req2 {get;set;}
 public  string accsToken {get;set;}
 public string tenenpoint  {get;set;}
 public string expiresin  {get;set;}
 public String postbody {get;set;}
 


//private static final String AUTH_URL = 'http://mobile.socxo.com/api/Account/login'; //Login URL 

private static final String AUTH_URL = 'http://testenv.socxo.com/api/2.0/oauth/login'; //Login URL 

//Constructor
 
Public SOCXOclass()
{
    
 // getting username password from url parameters
 if(System.currentPagereference().getParameters().get('username')!=null)
 {
     password =System.currentPagereference().getParameters().get('password');
     username =System.currentPagereference().getParameters().get('username');
      ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.CONFIRM,System.currentPagereference().getParameters().get('message')+'.click Authorise to connect with your Socxo account' );
      ApexPages.addmessage(msg);
        
 }

List<SOCXO_token__c> currenttoken = [select Access_Token__c,expireson__c from SOCXO_token__c where  SOCXO_Service__r.SFuser__r.Id =:userinfo.getuserid()];

//Checking whether the user is logging in for the first time and also whether the existing token is a valid one. If the token is not valid, prompt the user to the login again.

   if(currenttoken.size() > 0)
        {  system.debug('SoCXO access token is:::');
            if(currenttoken[0].Access_Token__c=='' || currenttoken[0].Access_Token__c==null)
               {
               // system.debug('SoCXO access token is null:::');
               this.req2 = true;
               system.debug('%%%%%%%%%%%'+req2);
               }  
            else if(currenttoken[0].Access_Token__c!=null)
               {
                    if(currenttoken[0].expireson__c > datetime.now())
                       {
                       this.req2=false;
                       }
                    else 
                       {
                       this.req2=true;
                       }  
                }}
        else if (currenttoken.size() == 0)
         { 
          this.req1 = true;
         }
} //end of constructor



// For Authorizing the SOCXO APP
    
     public PageReference authorize() {
      
     List<SOCXO_Service__c > currentservice = [select password__c,username__c, (select access_token__c,expireson__c from SOCXO_tokens__r) from SOCXO_Service__c where  SFuser__c =:userinfo.getuserid()];
     
     if(username!=null && password !=null)
     {
    
    String s;
        s='grant_type=';
        s+='password';
        s+='&username='+EncodingUtil.urlEncode(username, 'UTF-8');
        s+='&password='+EncodingUtil.urlEncode(password, 'UTF-8');
   
   utilityclass u = new utilityclass();
   postbody = u.getmetoken(s,AUTH_URL);
   
   system.debug('Login Response::'+ postbody);
   
   //Parsing the response

      loginError err = (loginError)JSON.deserialize(postbody,loginError.class);
      ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.INFO, err.error_description );
      system.debug('errordescp::::' +err.error_description );
      ApexPages.addmessage(msg);
   
     JSONParser parser1 = JSON.createParser(postbody);
             while (parser1.nextToken() != null) {
             if ((parser1.getCurrentToken() == JSONToken.FIELD_NAME) && (parser1.getText() == 'access_token')) {
                  parser1.nextToken();
                  accsToken = parser1.getText();
               }
             
             if ((parser1.getCurrentToken() == JSONToken.FIELD_NAME) && (parser1.getText() == 'tenantEndPoint')) {
                  parser1.nextToken();
                  tenenpoint = parser1.getText();
               }  
              if ((parser1.getCurrentToken() == JSONToken.FIELD_NAME) && (parser1.getText() == 'expires_in')) {
                  parser1.nextToken();
                  expiresin = parser1.getText();
               }    
               
               }

           }
           
           
           List<SOCXO_Service__c > currentservice1  = [SELECT ID FROM SOCXO_Service__c WHERE  SFuser__c =:userinfo.getuserid()]; 
           SOCXO_Service__c s = new SOCXO_Service__c();
           s.password__c = password;
           s.username__c = username;
           s.SFuser__c = userinfo.getuserid();
           system.debug('Entering a new user');
           delete currentservice1;
           insert s;
           system.debug('SSSSS'+s);
           
           
            
          //Inserting the new token and deleting the expired one.
            
           SOCXO_token__c t = new SOCXO_token__c(); 
           t.Access_Token__c = accsToken ;
           t.expireson__c = datetime.now().addseconds(Integer.valueof(expiresin.trim()));
           t.tenanentendpoint__c = tenenpoint ;
           t.SOCXO_Service__c = s.id;
           delete s.SOCXO_tokens__r;
           insert t; 
           system.debug('PPPPPPP'+t);
           System.debug('XXXXXXXXXXXXXX access token '+ accsToken);
           return null;
            }

            public class loginError {
              public String error{get; set;}
              public String error_description {get; set;}
            }



}