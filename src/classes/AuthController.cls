public with sharing class AuthController {


   private static final String AUTH_URL = 'http://mobile.socxo.com/api/Account/login';

    public String username { get; set; }
    
    public String method { get; set; }
    
    public String password { get; set; }
    
    public String postbody {get;set;}
    
    public  string accsToken {get;set;}
 
    public string tenenpoint  {get;set;}
    
    public String postParam { get; set;}
    
    public String url { get; set; }
    
    public String body { get; set; } 
    
    
    public List<SelectOption> methodList {
     get {
     if(methodList==null) {
     methodList = new List<SelectOption>();
     methodList.add(new SelectOption('GET','GET'));
     methodList.add(new SelectOption('POST','POST'));
     methodList.add(new SelectOption('PUT','PUT'));
         }
     return methodList;
         }
         set;
         }
    
    
    
    
    //method
    
    public PageReference authorize() {
    
     String s;
        s='grant_type=';
        s+='password';
        s+='&username='+EncodingUtil.urlEncode(username, 'UTF-8');
        s+='&password='+EncodingUtil.urlEncode(password, 'UTF-8');
   
   
   //Callout
    Http ht = new Http();
    HttpRequest req = new HttpRequest();
    HttpResponse res =new HttpResponse();
    req.setMethod('POST');
    req.setBody(s);
    req.setEndpoint(AUTH_URL);
    system.debug('Request1'+req);
    system.debug('sssssss'+s);
    try {
           res = ht.send(req);
           postbody=res.getBody();
           system.debug('PPPPPPP'+postbody);
     } catch(Exception e) {
            System.debug('Callout error: '+ e);
            System.debug(res.toString());
        }
        
   //Parsing the response
   
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
               
               
               }
            System.debug('XXXXXXXXXXXXXX access token '+ accsToken);
            return null;
            }
            
    //Method to execute the REST call 
    
    public PageReference execute() {
    
    
    System.debug('Method: '+method+',,,,,URL: '+url);
    System.debug('Bodddy '+body);

    Http h = new Http();
    HttpRequest req = new HttpRequest();
    req.setHeader('content-type','application/json');
    req.setHeader('content-type','message/rfc822');
    req.setHeader('Accept','application/json');
    req.setHeader('Authorization', 'Bearer ' +accsToken);
    req.setMethod(method);
    req.setEndpoint(url);
   //req.setHeader('Content-Type','application/x-www-form-urlencoded');

    if(method=='POST' || method=='PUT') {
    if(postParam!=null & postParam!='') {
    req.setBody(postParam);
    //system.debug('PPPPPPPPPPPPPPPPP'+accss[0].token__c);
    } else {
    req.setBody(body);
      }
      }
    System.debug('Sending request...');
    HttpResponse res = h.send(req);
    body = res.getBody();
    System.debug('Received response ('+res.getStatusCode()+' '+res.getStatus()+')');
    return null;
    }
            
              
              
 }