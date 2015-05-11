public class linkedinUtility{
    public void fetchToken(string code,string redirectPage) {
        String getToken;
        getToken = 'https://www.linkedin.com/uas/oauth2/accessToken?';
        getToken+='grant_type=authorization_code';
        getToken+='&code='+code;
        getToken+='&redirect_uri='+redirectPage;
        getToken+='&client_id='+'78vmeajj9hqn2j';
        getToken+='&client_secret='+'GkNWHnSo6KdWHA5l';

        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(getToken);
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');

        HttpResponse res = h.send(req);
        string body = res.getBody();
        System.debug('linkedinbody('+res.getStatusCode()+''+ res.getStatus()+')');
        System.debug('body:::'+body);

    }
}