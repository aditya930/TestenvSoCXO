public with sharing class AuthControllerforproduct {

   private final Product2 prod;
   private static final String AUTH_URL = 'http://mobile.socxo.com/api/Account/login';
    
    public list<string> blurblist { get {return blurblist1;} set; }
    public list<string> categorylist { get {return categorylist1;} set; }
    list<string>blurblist1 = new list<string>();
    list<string>categorylist1 = new list<string>();
    String[] categories = new String[]{};
    Map<String,string> categorymap1 = new map<String,string> ();
    Public Map<string, String> categorymap{ get {return categorymap1;} set; }
    
    
    public String username { get; set; }
    
    public String method { get; set; }
    
    public String password { get; set; }
    
    public String postbody {get;set;}
    
    public  string accsToken {get;set;}
 
    public string tenenpoint  {get;set;}
    
    public String postParam { get; set;}
    
    public String url { get; set; }
    
    public String body { get; set; } 
    
    public String body1 { get; set; } 
    
    public String body2 { get; set; } 
    
    // to figure out the selected category
    
     public String[] getCategories() {
            return categories;
        }
            
        public void setCategories(String[] categories) {
            this.categories = categories;
        }
    
    
    
    
    //default constructor
    public AuthControllerforproduct (ApexPages.StandardController stdController) {
        this.prod = (product2)stdController.getRecord();
    }
    
    
    
    
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
            
    //Method to execute the REST call to get blurbs
    
    public PageReference blurbs() {
    
    
    string blurbendpoint = 'http://'+tenenpoint +'/api/blurb/private/1';
    system.debug('UUUUUUUUUU'+blurbendpoint);
    Http h = new Http();
    HttpRequest req = new HttpRequest();
    req.setHeader('content-type','application/json');
    req.setHeader('content-type','message/rfc822');
    req.setHeader('Accept','application/json');
    req.setHeader('Authorization', 'Bearer ' +accsToken);
    req.setMethod('GET');
    req.setEndpoint(blurbendpoint);
   //req.setHeader('Content-Type','application/x-www-form-urlencoded');

    /*if(method=='POST' || method=='PUT') {
    if(postParam!=null & postParam!='') {
    req.setBody(postParam);
    //system.debug('PPPPPPPPPPPPPPPPP'+accss[0].token__c);
    } else {
    req.setBody(body);
      }
      }*/
    System.debug('Sending request...');
    HttpResponse res = h.send(req);
    body = res.getBody();
    System.debug('Received response ('+res.getStatusCode()+' '+res.getStatus()+')');
    
    
    
    //JSON Parsing
    
    JSONParser parser1 = JSON.createParser(body);
          while (parser1.nextToken() != null) {
             if ((parser1.getCurrentToken() == JSONToken.FIELD_NAME) && (parser1.getText() == 'Url')) {
                  parser1.nextToken();
                  blurblist1.add(parser1.getText());
                  
               }}
     system.debug('%%%%%%%%%%'+blurblist1);          
     return null;        
            
    }
    
    //Categories
    
    public PageReference Categories() {
    
    string blurbendpoint = 'http://'+tenenpoint +'/api/2.0/private/categories';
    system.debug('UUUUUUUUUU'+blurbendpoint);
    Http h = new Http();
    HttpRequest req = new HttpRequest();
    req.setHeader('content-type','application/json');
    req.setHeader('content-type','message/rfc822');
    req.setHeader('Accept','application/json');
    req.setHeader('Authorization', 'Bearer ' +accsToken);
    req.setMethod('GET');
    req.setEndpoint(blurbendpoint);
   //req.setHeader('Content-Type','application/x-www-form-urlencoded');

    /*if(method=='POST' || method=='PUT') {
    if(postParam!=null & postParam!='') {
    req.setBody(postParam);
    //system.debug('PPPPPPPPPPPPPPPPP'+accss[0].token__c);
    } else {
    req.setBody(body);
      }
      }*/
    System.debug('Sending request...');
    HttpResponse res = h.send(req);
    body1 = res.getBody();
    System.debug('Received response ('+res.getStatusCode()+' '+res.getStatus()+')');
    
    
    
    //JSON Parsing(not using the code below since we are moving the JSON response to a map in place of list. This makes it easier to get the categories based on category id.
    
    /*JSONParser parser1 = JSON.createParser(body1);
          while (parser1.nextToken() != null) {
             if ((parser1.getCurrentToken() == JSONToken.FIELD_NAME) && (parser1.getText() == 'Name')) {
                  parser1.nextToken();
                  categorylist1.add(parser1.getText());
                  
               }}
     system.debug('%%%%%%%%%%'+categorylist1);*/
     
     
  //Using the JSON Deserializedtype to move the JSON response into a map using wrapper classes
  
  system.debug('body1111'+body1);
  //Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(body1);
  response m = (response)JSON.deserialize(body1,response.class);
  system.debug('JSON########'+m); 
  system.debug('JSON1########'+m.Categories);
  
  for(wrapper w : m.Categories)
  {
  categorymap1.put(w.CategoryId,w.Name); 
  }
  system.debug('categorymap########'+categorymap1);
  //system.debug('keyset########'+m.keyset());
  //List<wrapper> a = (List<wrapper>)m.get('Categories');
  //system.debug('aaaaaa########'+a);
  return null;        
            
    }
    
    public List<SelectOption> getItems() {
            List<SelectOption> options = new List<SelectOption>();
            
            for(string s : categorymap1.keyset())
            {
            options.add(new SelectOption(s,categorymap1.get(s)));
            
            }return options;
        }
    
    
    
    //moving the categorylist1 to selectoption(not using the code below since we are using a map in place of list.
    /* public List<SelectOption> getItems() {
            List<SelectOption> options = new List<SelectOption>();
            
            for(string s : categorylist1)
            {
            options.add(new SelectOption(s,s));
            
            }return options;
        }*/
    
    
    
    
    
    //test method to  check whether the selected category is picked up
    //Adding some logic to call the enpoint to get the blurbs associated with a particular category.
    
     public PageReference test() {
            
    string categoryendpoint = 'http://'+tenenpoint +'/api/blurb/private/1/'+Integer.valueof(categories[0].trim());
    system.debug('UUUUUUUUUU'+categoryendpoint);
    Http h = new Http();
    HttpRequest req = new HttpRequest();
    req.setHeader('content-type','application/json');
    req.setHeader('content-type','message/rfc822');
    req.setHeader('Accept','application/json');
    req.setHeader('Authorization', 'Bearer ' +accsToken);
    req.setMethod('GET');
    req.setEndpoint(categoryendpoint); 
    System.debug('Sending request...');
    HttpResponse res = h.send(req);
    body2 = res.getBody();
    System.debug('Received response ('+res.getStatusCode()+' '+res.getStatus()+')');        
    system.debug('body22222'+body2);        
    
    JSONParser parser1 = JSON.createParser(body2);
          while (parser1.nextToken() != null) {
             if ((parser1.getCurrentToken() == JSONToken.FIELD_NAME) && (parser1.getText() == 'Url')) {
                  parser1.nextToken();
                  categorylist1.add(parser1.getText());
                  
               }}
     system.debug('%%%%%%%%%%'+categorylist1);
     return null;
        }
        
        
     
     
     //wrapper classes for deserialisation.
     public class wrapper {
     
     public string CategoryId{get;set;}
     public string Name {get;set;}
     
     }   
     public class response{
     
     public List<wrapper>Categories{get;set;}
     public string Status {get;set;}
     public string Message {get;set;}
     }
    
    
    
    
    
    }