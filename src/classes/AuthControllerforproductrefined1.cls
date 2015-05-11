public with sharing class AuthControllerforproductrefined1 {
 Map<String,string> categorymap1 = new map<String,string> ();
 public map<string,string> categorymap{get{return categorymap1;}set;} 
 public String userbody {get;set;}
 //public String body1 { get; set; }
 public string x1 { get; set;} 
 public String body2 { get; set; } 
 list<url__c>categorylist1 = new list<url__c>(); 
 public list<url__c> categorylist { get {return categorylist1;} set; }
 public List <SOCXO_token__c> currenttoken1{get;set;}
 
 public AuthControllerforproductrefined1() {
     currenttoken1 = [select Access_Token__c,expireson__c,tenanentendpoint__c from SOCXO_token__c where  SOCXO_Service__r.SFuser__r.Id =:userinfo.getuserid()]; 
 }

 public PageReference Categories(String body1) {
    
     /*utilityclass1 u = new utilityclass1();
     userbody = u.togetuserinformation();
     system.debug('USER:::'+userbody);*/
    
   

    /*string blurbendpoint = 'http://'+currenttoken1[0].tenanentendpoint__c+'/api/category/private';
    system.debug('UUUUUUUUUU'+blurbendpoint);
    Http h = new Http();
    HttpRequest req = new HttpRequest();
    req.setHeader('content-type','application/json');
    req.setHeader('content-type','message/rfc822');
    req.setHeader('Accept','application/json');
    req.setHeader('Authorization', 'Bearer ' +currenttoken1[0].Access_Token__c);
    req.setMethod('GET');
    req.setEndpoint(blurbendpoint);
    System.debug('Sending request...');
    HttpResponse res = h.send(req);
    body1 = res.getBody();
    System.debug('Received response ('+res.getStatusCode()+' '+res.getStatus()+')');*/
    system.debug('body1111'+body1);
    response m = (response)JSON.deserialize(body1,response.class);
    system.debug('JSON########'+m); 
    system.debug('JSON1########'+m.Categories);
    list<category__c> savecategory = new list<category__c>();
    for(wrapper w : m.Categories)
    {
    categorymap1.put(w.CategoryId,w.Name);
    category__c c = new category__c();
    c.name = w.name;
    c.categoryId__c = w.CategoryId; 
    savecategory.add(c);  
    }
    list<category__c> deletecategory=  [select id from category__c];
    delete deletecategory; 
    insert savecategory;
    system.debug('categorymap########'+categorymap1);
    return null;     
    }
    
 
    
    public class wrapper {
     
     public string CategoryId{get;set;}
     public string Name {get;set;}
     
     }
    
    public class response{
     
     public List<wrapper>Categories{get;set;}
     public string Status {get;set;}
     public string Message {get;set;}
     }       
    
    public class response1{
     
     public List<wrapper1>blurbs{get;set;}
     public string Status {get;set;}
     public string Message {get;set;}
     } 
     
     public class wrapper1 {
     
     public string BlurbId{get;set;}
     public string EnterpriseBlurbId{get;set;}
     public string Title{get;set;}
     public string Description{get;set;}
     public string ImageUrl{get;set;}
     public string Url{get;set;}
     public string FeedName{get;set;}
     public string CategoryId{get;set;}
     
     } 
}