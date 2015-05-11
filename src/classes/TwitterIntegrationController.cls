public with sharing class TwitterIntegrationController {

    private String nonce;
    private String timestamp;
    private String signature;
    private String consumerKey;
    public string callbackUrl;
    public string RefreshToken;
    public string verifier;
    public string verifier_body;
    public string twitter_status;
    public string screen_name;
    public string twitterbody;
    public string twittertoken;
    public string twittertokensecret;
    public string urlname;
    public string twitterconnectbody;
    public string test;
    
    private String request_token;
    private String verifier_token;
    private String tokenSecret;
    private String consumerSecret;
    private Map<String,String> parameters = new Map<String,String>();
    private Map<String,String> params1 = new Map<String,String>();
    public Map<String,String> t_details = new Map <String,String>();
    //public Map<String,String> twitteruserdetails = new Map <String,String>();
    
    public TwitterIntegrationController() {
      socxoAppsettings__c sett= socxoAppsettings__c.getValues('socxoAppsettings');
      consumerKey= sett.TwitterAppkey__c;
        //tokenSecret='v5BQW2l5Dh80mCDMKM26NGPUvp17ubjewsh93lVYThHtD';
        consumerSecret= sett.TwitterAppSecret__c;
        //t_token = '';
        //callbackUrl = 'https://c.ap1.visual.force.com/apex/twitterconnector';
        //verifier='';
        callbackurl= EncodingUtil.urlEncode('https://'+ApexPages.currentPage().getHeaders().get('Host')+
                                              Page.twitterconnector.getUrl(),'UTF-8');


    
         HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.twitter.com/oauth/request_token');
        req.setMethod('POST');
    //req.setHeader('Content-length', '0');
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        sign(req);
    
    }


    public pagereference twitterUserDetails(){
      

      verifier = ApexPages.currentPage().getParameters().get('oauth_verifier');
    verifier_token = ApexPages.currentPage().getParameters().get('oauth_token');
      System.debug('verifier:::'+verifier);
      System.debug('token:::'+verifier_token);
      
        
    /*if(request_token==NULL){
    HttpRequest req = new HttpRequest();
    req.setEndpoint('https://api.twitter.com/oauth/request_token');
    req.setMethod('POST');
    //req.setHeader('Content-length', '0');
    req.setHeader('Content-Type','application/x-www-form-urlencoded');
    sign(req);
    
    
    }
*/

    if(verifier==NULL){
  system.debug('inside authenticate:::::');
      
 //HttpRequest req = new HttpRequest();
 string url = 'https://api.twitter.com/oauth/authenticate?';
 url+='oauth_token='+request_token;
 //req.setEndpoint(url);
 //req.setMethod('GET');
 //req.setHeader('Content-Type','application/x-www-form-urlencoded');
 //sign(req);
  
 return new pagereference(url);

}    

    if(verifier!=NULL && screen_name==NULL) {
            
            getVerifierBody();
            return NULL;

        }

        return NULL;

   }

   public void getVerifierBody() {
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://api.twitter.com/oauth/access_token');
            req.setMethod('POST');
            req.setHeader('Content-Type','application/x-www-form-urlencoded');
            sign(req);
            System.debug('verifier_body11111' + verifier_body);
            t_details  =getUrlParams(verifier_body);

            if(t_details.size() > 0 ) {
                //utilityclass util = new utilityclass();

               // util.twitterconnect(t_details.get('screen_name'),t_details.get('oauth_token'));
               
               screen_name = t_details.get('screen_name');
               twittertoken = t_details.get('oauth_token');
               twittertokensecret = t_details.get('oauth_token_secret');
               system.debug('tokens###'+twittertoken + 'tokensecret##'+ twittertokensecret);
               HttpRequest req1 = new HttpRequest();
            req1.setEndpoint('https://api.twitter.com/1.1/users/show.json?screen_name='+screen_name);
            req1.setMethod('GET');
            req1.setHeader('Content-Type','application/x-www-form-urlencoded');
            sign(req1);
               
            }

   }


public void sign(HttpRequest req) {
        
        nonce = String.valueOf(Crypto.getRandomLong());
        timestamp = String.valueOf(DateTime.now().getTime()/1000);

        refreshParameters();
        system.debug('parameters111'+parameters);
        String s = createBaseString(parameters, req);
        
        System.debug('Signature base string: '+s);
        
        Blob sig = Crypto.generateMac('HmacSHA1', Blob.valueOf(s), 
                       Blob.valueOf(consumerSecret+'&'+
                                    (tokenSecret!=null ? tokenSecret : '')));
        signature = EncodingUtil.urlEncode(EncodingUtil.base64encode(sig), 'UTF-8');
        System.debug('Signature: '+signature);
        
        String header = 'OAuth ';
        for (String key : parameters.keySet()) {
            header = header+key+'="'+parameters.get(key)+'",';
        }
        header = header + 'oauth_signature="'+signature+'"';
        System.debug('Authorization: '+header);
        req.setHeader('Authorization',header);
        Http h = new Http();
        HttpResponse res = h.send(req);
        string body1 = res.getBody();
        System.debug('Received response ('+res.getStatusCode()+' '+res.getStatus()+')');
        system.debug('body1111'+body1);
        
        if(screen_name!=NULL) {
         twitterbody = body1;
         system.debug('twitterbody::::'+twitterbody);
         utilityclass util = new utilityclass();

        /* twitteruserdetails = getUrlParams(twitterbody);
         
         system.debug('twitterbody1:::'+twitteruserdetails );
         urlname = twitteruserdetails.get('created_at');
         system.debug('profileurl::::' + urlname);

         //response m = (response)JSON.deserializeUntyped(body1,response.class);
         //String tb = JSON.serialize(twitterbody);
         Map<object,object> m = (Map<object,object>)JSON.deserializeUntyped(twitterbody);
         system.debug('mmm11::' + m.get('user'));
         
         
         String userDetail = JSON.serialize(m);
           
         system.debug('JSON123###'+ userDetail);
         //system.debug('JSONid##'+ m.id);
         //system.debug('JSONtext###' + m.text);*/
         
         response m = (response)JSON.deserialize(twitterbody,response.class);
         system.debug('JSON####'+m);
         system.debug('JSON####'+m.id);
         system.debug('JSON####'+m.profile_image_url);
         
         twitterconnectbody = util.twitterconnect(twittertoken,m.id,twittertokensecret);

         
        }
        
       else if(verifier!=NULL) 
        {
            verifier_body = body1;
        system.debug('verifier_body::' + body1);

        }
        
        params1 = getUrlParams(body1);
        system.debug('params1::'+params1);
        request_token = params1.get('oauth_token');
        tokenSecret = params1.get('oauth_token_secret'); 

        system.debug('requesttoken###'+request_token+'tokensecret###'+tokenSecret); 
            
  
       }   
    
    

     
private void refreshParameters() {
        parameters.clear();
        parameters.put('oauth_consumer_key',consumerKey);
        if(verifier_token!=null) {
            parameters.put('oauth_token',verifier_token);
        }
        if(twittertoken !=NULL){
          parameters.put('oauth_token',twittertoken);
        }
        if(verifier!=null) {
            parameters.put('oauth_verifier',verifier);
        }
        parameters.put('oauth_signature_method','HMAC-SHA1');
        parameters.put('oauth_timestamp',timestamp);
        parameters.put('oauth_nonce',nonce);
        parameters.put('oauth_version','1.0');
        
        //string callbackurl1 = EncodingUtil.urlEncode(callbackurl,'UTF-8');
        
        parameters.put('oauth_callback',callbackUrl);
    }

    private String createBaseString(Map<String,String> oauthParams, HttpRequest req) {
        Map<String,String> p = oauthParams.clone();
        if(req.getMethod().equalsIgnoreCase('post') && req.getBody()!=null && 
           req.getHeader('Content-Type')=='application/x-www-form-urlencoded') {
            p.putAll(getUrlParams(req.getBody()));
        }
        String host = req.getEndpoint();
        Integer n = host.indexOf('?');
        if(n>-1) {
            p.putAll(getUrlParams(host.substring(n+1)));
            host = host.substring(0,n);
        }
        List<String> keys = new List<String>();
        keys.addAll(p.keySet());
        keys.sort();
        String s = keys.get(0)+'='+p.get(keys.get(0));
        for(Integer i=1;i<keys.size();i++) {
            s = s + '&' + keys.get(i)+'='+p.get(keys.get(i));
        }

        // According to OAuth spec, host string should be lowercased, but Google and LinkedIn
        // both expect that case is preserved.
        return req.getMethod().toUpperCase()+ '&' + 
            EncodingUtil.urlEncode(host, 'UTF-8') + '&' +
            EncodingUtil.urlEncode(s, 'UTF-8');
    }
    
    public Map<String,String> getUrlParams(String value) {

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

    public class response{
        public string id{get;set;}
        public string profile_image_url{get;set;}
        
    }

}