public with sharing class utilityclass1 {
    public string togetuserinformation() {
  
     List<SOCXO_token__c> currenttoken1 = [select Access_Token__c,expireson__c,tenanentendpoint__c from SOCXO_token__c where  SOCXO_Service__r.SFuser__r.Id =:userinfo.getuserid()];

    string categoryendpoint = 'http://'+currenttoken1[0].tenanentendpoint__c+'/api/account/user';
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
    system.debug('body22222'+body2);
    return body2;
    }  

}