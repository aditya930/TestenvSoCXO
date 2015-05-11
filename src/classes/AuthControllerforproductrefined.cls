public with sharing class AuthControllerforproductrefined {

// main class
//Properties and variables
    private final List<mailer__c> linkforemail;
    private final lead lead1;
    String[] categories = new String[]{};
    public boolean req {get;set;}
    //public string x1 { get; set{x1=value;}}
    public string x1 { get; set;} 
    public string xfb1 { get; set;}
    public string xfb2 { get; set;}
    public string blurbString {get; set;}
    
    public wrapper1 blurbBody {get; set;}
    public List <wrapper1> lstBlurbs {get; set;}
    public wrapper1  editblurb {get;set;}
    //Pop up
    
    public boolean displayPopup {get; set;}
    public boolean displayPopup1 {get; set;}
    
    private static final String AUTH_URL = 'http://mobile.socxo.com/api/Account/login'; //Login URL

    Map<String,string> categorymap1 = new map<String,string> (); 
    //list<string>categorylist1 = new list<string>(); 
    list<url__c>categorylist1 = new list<url__c>();
    public String code { get; set; }
    public String username { get; set; } 
    public map<string,string> categorymap{get{return categorymap1;}set;}
    //public list<string> categorylist { get {return categorylist1;} set; }
    public list<url__c> categorylist { get {return categorylist1;} set; }
    public String password   { get; set; }
    
    public String postbody {get;set;}
    public String userbody {get;set;}
    public String facebookbody {get;set;}
    public String fbaccesstoken {get;set;}
    
     public  string accsToken {get;set;}
     public  string fbmessage {get;set;}
     public  string fbstatus {get;set;}

     public String twitterbody {get;set;}
     public String twitteraccesstoken {get;set;}

     public String twittermessage {get;set;}
     public String twitterstatus {get;set;}

     public String linkedinbody {get;set;}
     public String linkedinMessage {get;set;}
     public String linkedinStatus {get;set;}
     
     public String body2 { get; set; } 
   
     public string tenenpoint  {get;set;}
     
     public string expiresin  {get;set;}
     
     public String body1 { get; set; } 
     
     private category__c selcategory {get;set;}

     public String blurbLink {get;set;}
     public String blurbTitle {get;set;}
     public String blurbDesc {get;set;}
     public String blurbComment {get;set;}
     public String blurbDetailId {get;set;}
     public List <url__c> blurbDetails {get;set;}
     public boolean showeditpanel{get;set;}
     public boolean showselectedblurb{get;set;}
     public wrapper1 blurbtopopup {get;set;}
     public String bluridtoshow {get;set;}

    /*  public string blurbTitle {get; set;}
     public string blurbDesc {get; set;}
     public string blurbComment {get; set;} */

    public String[] getCategories() {
        return categories;
    }

    public void setCategories(String[] categories) {
        this.categories = categories;
    }


    //Constructor


    public AuthControllerforproductrefined() {
        System.Debug('test1:' + ApexPages.currentPage().getParameters().get('CategoryId') + ' ' + ApexPages.currentPage().getParameters().get('BlurbId'));
        showselectedblurb = true;


        //blurbString = blurbs!!!!!;
        showeditpanel = false;
        string callbackUrl1 = EncodingUtil.urlEncode('https://' + ApexPages.currentPage().getHeaders().get('Host') + Page.paneltest.getUrl(), 'UTF-8');


        linkforemail = [select id, link__c from mailer__c];
        string code = ApexPages.currentPage().getParameters().get('code');
        string state = ApexPages.currentPage().getParameters().get('state');
        system.debug('code:::' + code);
        //system.debug('hi');
        //system.debug('')
        //categorylist = new list<url__c>();

        if (code != '' && state == 'facebook') {
            utilityclass util1 = new utilityclass();
            fbaccesstoken = util1.getmefacebooktoken(code, callbackurl1);
            system.debug('fbtoken:::' + fbaccesstoken);

        }


        /*if(code!='' && state=='twitter') {
    utilityclass util1 = new utilityclass();
    twitteraccesstoken = util1.getmetwittertoken(code,callbackurl1);

  }  
  */


    }

    public List < mailer__c > getcategoryblurbs() {
        //system.debug('WWWWW'+linkforemail[0].URLs__r);
        return linkforemail;
    }

    public boolean getstatusofblurb() {
        if (ApexPages.currentPage().getParameters().get('BlurbId') != null && ApexPages.currentPage().getParameters().get('CategoryId') != null) {
            return true;
        } else {
            return false;
        }

    }

    public AuthControllerforproductrefined(ApexPages.StandardController stdController) {
        showselectedblurb = true;
        this.lead1 = (lead) stdController.getRecord();

        List < SOCXO_token__c > currenttoken = [select Access_Token__c, expireson__c from SOCXO_token__c where SOCXO_Service__r.SFuser__r.Id = : userinfo.getuserid()];
        //system.debug('%%%%%%%%%%%'+currenttoken);
        //system.debug('%%%%%%%%%%%'+currenttoken[0]);
        //currenttoken = [select Access_Token__c,expireson__c from SOCXO_token__c  where  SOCXO_Service__r.SFuser__r.Id =:userinfo.getuserid()];

        if (currenttoken.size() > 0) {
            if (currenttoken[0].Access_Token__c == '' || currenttoken[0].Access_Token__c == null) {
                this.req = true;
                system.debug('%%%%%%%%%%%' + req);
            } else if (currenttoken[0].Access_Token__c != null) {
                if (currenttoken[0].expireson__c > datetime.now()) {
                    this.req = false;

                } else {
                    this.req = true;
                }
            }
        } else if (currenttoken.size() == 0) {
            this.req = true;
        }
    }


    // For Authorizing the SOCXO APP

    public PageReference authorize() {

        List < SOCXO_Service__c > currentservice = [select password__c, username__c, (select access_token__c, expireson__c from SOCXO_tokens__r) from SOCXO_Service__c where SFuser__c = : userinfo.getuserid()];

        if (username != null && password != null) {

            String s;
            s = 'grant_type=';
            s += 'password';
            s += '&username=' + EncodingUtil.urlEncode(username, 'UTF-8');
            s += '&password=' + EncodingUtil.urlEncode(password, 'UTF-8');

            utilityclass u = new utilityclass();
            postbody = u.getmetoken(s, AUTH_URL);

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
                if ((parser1.getCurrentToken() == JSONToken.FIELD_NAME) && (parser1.getText() == 'expires_in')) {
                    parser1.nextToken();
                    expiresin = parser1.getText();
                }

            }


        }


        List < SOCXO_Service__c > currentservice1 = [SELECT ID FROM SOCXO_Service__c WHERE SFuser__c = : userinfo.getuserid()];
        SOCXO_Service__c s = new SOCXO_Service__c();
        s.password__c = password;
        s.username__c = username;
        s.SFuser__c = userinfo.getuserid();
        system.debug('Entering a new user');
        delete currentservice1;
        insert s;
        system.debug('SSSSS' + s);



        //Inserting the new token and deleting the expired one.

        SOCXO_token__c t = new SOCXO_token__c();
        t.Access_Token__c = accsToken;
        t.expireson__c = datetime.now().addseconds(Integer.valueof(expiresin.trim()));
        t.tenanentendpoint__c = tenenpoint;
        t.SOCXO_Service__c = s.id;
        delete s.SOCXO_tokens__r;
        insert t;
        system.debug('PPPPPPP' + t);
        System.debug('XXXXXXXXXXXXXX access token ' + accsToken);
        return null;
    }

    public PageReference stopeditblurbtopost() {
        for (wrapper1 m: lstBlurbs) {
            if (m.BlurbId == xfb1) {
                m.Editmode = false;
            }
        }
        showeditpanel = false;
        System.Debug('showeditpanel :' + showeditpanel);
        return null;
    }
    public PageReference editblurbtopost() {
        for (wrapper1 m: lstBlurbs) {
            if (m.BlurbId == xfb1) {
                m.Editmode = true;
            }
        }
        showeditpanel = true;
        System.Debug('showeditpanel :' + showeditpanel);
        return null;
    }




    public PageReference Categories() {
        showselectedblurb = false;
        if (ApexPages.currentPage().getParameters().get('BlurbId') != '') {
            showselectedblurb = true;
        }
        System.Debug('test:' + ApexPages.currentPage().getParameters().get('CategoryId') + ' ' + ApexPages.currentPage().getParameters().get('BlurbId'));

        utilityclass u = new utilityclass();
        userbody = u.togetuserinformation();
        system.debug('USER:::' + userbody);

        List < SOCXO_token__c > currenttoken1 = [select Access_Token__c, expireson__c, tenanentendpoint__c from SOCXO_token__c where SOCXO_Service__r.SFuser__r.Id = : userinfo.getuserid()];

        string blurbendpoint = 'http://testenv.socxo.com/api/2.0/company/categories';
        system.debug('UUUUUUUUUU' + blurbendpoint);
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setHeader('content-type', 'application/json');
        req.setHeader('content-type', 'message/rfc822');
        req.setHeader('Accept', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + currenttoken1[0].Access_Token__c);
        req.setMethod('GET');
        req.setEndpoint(blurbendpoint);
        req.setTimeout(50000);
        System.debug('Sending request...');
        HttpResponse res = h.send(req);
        body1 = res.getBody();
        System.debug('Received response (' + res.getStatusCode() + ' ' + res.getStatus() + ')');
        system.debug('Category Response Body:::' + body1);
        response m = (response) JSON.deserialize(body1, response.class);
        system.debug('JSON########' + m);
        system.debug('JSON1########' + m.Categories);
        list < category__c > savecategory = new list < category__c > ();
        for (wrapper w: m.Categories) {
            categorymap1.put(w.CategoryId, w.Name);
            category__c c = new category__c();
            c.name = w.name;
            c.categoryId__c = w.CategoryId;
            savecategory.add(c);
        }
        list < category__c > deletecategory = [select id from category__c];

        if (ApexPages.currentPage().getParameters().get('BlurbId') != null && ApexPages.currentPage().getParameters().get('CategoryId') != null) {
            system.debug('entered');
            // showselectedblurb = true;
            x1 = ApexPages.currentPage().getParameters().get('CategoryId');
            bluridtoshow = ApexPages.currentPage().getParameters().get('BlurbId');
            // PageReference p = test1();
            categorylist1.clear();
            // String strX = ApexPages.currentPage().getParameters().get('x1');
            ///system.debug('[[[[[[['+strX);
            //system.debug(']]]]]]]'+x1);
            //List<SOCXO_token__c> currenttoken1 = [select Id ,Access_Token__c,expireson__c,tenanentendpoint__c from SOCXO_token__c where  SOCXO_Service__r.SFuser__r.Id =:userinfo.getuserid()];        

            //calling the utility class to make callout
            utilityclass util = new utilityclass();
            body2 = util.getmerelatedblurbs(currenttoken1[0].id, x1);

            system.debug('Blurb Response::::' + body2);


            //Using wrapper class
            map < string, Id > allcategories = new map < string, Id > ();
            for (category__c cat: [select id, categoryid__c from category__c]) {
                allcategories.put(cat.categoryid__c, cat.id);
            }

            list < URL__c > saveurl = new list < URL__c > ();
            list < mailer__c > mailerobj = new list < mailer__c > ();
            response1 m1 = (response1) JSON.deserialize(body2, response1.class);
            lstBlurbs = m1.blurbs;
            for (wrapper1 w: m1.blurbs) {

                if (showselectedblurb = true && w.BlurbID == bluridtoshow) {
                    blurbtopopup = new wrapper1();
                    blurbtopopup = w;
                    system.debug('blurbtopopup :' + blurbtopopup);
                }

                /*url__c u = new url__c();
      u.category__c = allcategories.get(w.CategoryId);
      u.BlurbId__c = w.BlurbId;
      u.Description__c = w.Description;
      u.EnterpriseBlurbId__c = w.EnterpriseBlurbId;
      u.links__c = w.Url;
      u.ImageUrl__c = w.ImageUrl;
      u.Title__c = w.Title;*/

                // blurbBody.categoryId = allcategories.get(w.CategoryId);
                /*blurbBody.BlurbId = w.BlurbId;
      blurbBody.Description = w.Description;
      blurbBody.EnterpriseBlurbId = w.EnterpriseBlurbId;
      blurbBody.Url = w.Url;
      blurbBody.ImageUrl = w.ImageUrl;
      blurbBody.Title = w.Title;*/

                // lstBlurbs.add(blurbBody);

                // saveurl.add(u);
                // categorylist1.add(u);




                // system.debug('imageurlsssss##'+u.ImageUrl__c);

                //categorylist.add(u);
                mailer__c m2 = new mailer__c();
                m2.link__c = w.url;
                mailerobj.add(m2);
            }
            /* selcategory = [select id from category__c  where categoryId__c = : categories[0]];
     delete selcategory.URLs__r;
     insert saveurl;
     list<mailer__c>formail = [select id from mailer__c];
     delete formail;
     insert mailerobj; */
            system.debug('%%%%%%%%%%' + categorylist1);
            system.debug('%%%%%%%%%%' + categorylist);

        } else {

            utilityclass util = new utilityclass();
            body2 = util.getAllBlurbs(currenttoken1[0].id);

            system.debug('Blurb Response::::' + body2);


            //Using wrapper class
            map < string, Id > allcategories = new map < string, Id > ();
            for (category__c cat: [select id, categoryid__c from category__c]) {
                allcategories.put(cat.categoryid__c, cat.id);
            }

            list < URL__c > saveurl = new list < URL__c > ();
            list < mailer__c > mailerobj = new list < mailer__c > ();
            response1 m1 = (response1) JSON.deserialize(body2, response1.class);
            lstBlurbs = m1.blurbs;

        }
        delete deletecategory;
        insert savecategory;
        system.debug('categorymap########' + categorymap1);


        return null;
    }


    public List < SelectOption > getItems() {
        List < SelectOption > options = new List < SelectOption > ();

        for (string s: categorymap1.keyset()) {
            options.add(new SelectOption(s, categorymap1.get(s)));

        }
        return options;
    }


    //test method to  check whether the selected category is picked up
    //Adding some logic to call the enpoint to get the blurbs associated with a particular category.

    public PageReference test() {
        categorylist1.clear();
        List < SOCXO_token__c > currenttoken1 = [select Id, Access_Token__c, expireson__c, tenanentendpoint__c from SOCXO_token__c where SOCXO_Service__r.SFuser__r.Id = : userinfo.getuserid()];

        //calling the utility class to make callout
        utilityclass util = new utilityclass();
        body2 = util.getmerelatedblurbs(currenttoken1[0].id, categories[0]);


        //Using wrapper class
        map < string, Id > allcategories = new map < string, Id > ();
        for (category__c cat: [select id, categoryid__c from category__c]) {
            allcategories.put(cat.categoryid__c, cat.id);
        }

        list < URL__c > saveurl = new list < URL__c > ();
        list < mailer__c > mailerobj = new list < mailer__c > ();
        response1 m1 = (response1) JSON.deserialize(body2, response1.class);
        // system.debug('blurbresponse:::' + response1);
        for (wrapper1 w: m1.blurbs) {
            url__c u = new url__c();
            u.category__c = allcategories.get(w.CategoryId);
            u.BlurbId__c = w.BlurbId;
            u.Description__c = w.Description;
            u.EnterpriseBlurbId__c = w.EnterpriseBlurbId;
            u.links__c = w.Url;
            u.ImageUrl__c = w.ImageUrl;
            u.Title__c = w.Title;


            saveurl.add(u);
            blurbDetails = saveurl;
            categorylist1.add(u);
            mailer__c m = new mailer__c();
            m.link__c = w.url;
            mailerobj.add(m);
        }
        selcategory = [select id from category__c where categoryId__c = : categories[0]];
        delete selcategory.URLs__r;
        insert saveurl;
        list < mailer__c > formail = [select id from mailer__c];
        delete formail;
        insert mailerobj;
        system.debug('%%%%%%%%%%' + categorylist1);
        return null;
    }

    //method for Sending email to the Lead
    public PageReference sendmail() {
        system.debug('cattttt' + categorylist);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.settemplateid('00XC0000001KttT');
        mail.setSaveAsActivity(true);
        mail.settargetobjectid(lead1.id);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
            mail
        });
        return null;
    }

    //dummy method to use in the paneltest page

    public PageReference test1() {
        categorylist1.clear();
        String strX = ApexPages.currentPage().getParameters().get('x1');
        system.debug('[[[[[[[' + strX);
        system.debug(']]]]]]]' + x1);
        List < SOCXO_token__c > currenttoken1 = [select Id, Access_Token__c, expireson__c, tenanentendpoint__c from SOCXO_token__c where SOCXO_Service__r.SFuser__r.Id = : userinfo.getuserid()];

        //calling the utility class to make callout
        utilityclass util = new utilityclass();
        body2 = util.getmerelatedblurbs(currenttoken1[0].id, x1);

        system.debug('Blurb Response::::' + body2);


        //Using wrapper class
        map < string, Id > allcategories = new map < string, Id > ();
        for (category__c cat: [select id, categoryid__c from category__c]) {
            allcategories.put(cat.categoryid__c, cat.id);
        }

        list < URL__c > saveurl = new list < URL__c > ();
        list < mailer__c > mailerobj = new list < mailer__c > ();
        response1 m1 = (response1) JSON.deserialize(body2, response1.class);
        lstBlurbs = m1.blurbs;
        for (wrapper1 w: m1.blurbs) {

            if (showselectedblurb = true && w.BlurbID == bluridtoshow) {
                blurbtopopup = new wrapper1();
                blurbtopopup = w;
            }



            /*url__c u = new url__c();
      u.category__c = allcategories.get(w.CategoryId);
      u.BlurbId__c = w.BlurbId;
      u.Description__c = w.Description;
      u.EnterpriseBlurbId__c = w.EnterpriseBlurbId;
      u.links__c = w.Url;
      u.ImageUrl__c = w.ImageUrl;
      u.Title__c = w.Title;*/

            // blurbBody.categoryId = allcategories.get(w.CategoryId);
            /*blurbBody.BlurbId = w.BlurbId;
      blurbBody.Description = w.Description;
      blurbBody.EnterpriseBlurbId = w.EnterpriseBlurbId;
      blurbBody.Url = w.Url;
      blurbBody.ImageUrl = w.ImageUrl;
      blurbBody.Title = w.Title;*/

            // lstBlurbs.add(blurbBody);

            // saveurl.add(u);
            // categorylist1.add(u);




            // system.debug('imageurlsssss##'+u.ImageUrl__c);

            //categorylist.add(u);
            mailer__c m = new mailer__c();
            m.link__c = w.url;
            mailerobj.add(m);
        }
        /* selcategory = [select id from category__c  where categoryId__c = : categories[0]];
     delete selcategory.URLs__r;
     insert saveurl;
     list<mailer__c>formail = [select id from mailer__c];
     delete formail;
     insert mailerobj; */
        system.debug('%%%%%%%%%%' + categorylist1);
        system.debug('%%%%%%%%%%' + categorylist);


        return null;
    }




    //method to post in facebook.

    //@RemoteAction
    public pagereference postinfb() {

        system.debug('++++++++' + xfb1);
        system.debug('++++++++' + xfb2);


        system.debug('lstblurbs:::' + lstBlurbs);
        for (wrapper1 m: lstBlurbs) {
            if (m.BlurbId == xfb1) {
                system.debug('blurbDetail:::' + m);
                blurbDetailId = m.UserBlurbId;
                blurbTitle = m.fbtittle;
                blurbDesc = m.fbdecription;
                blurbComment = m.fbcomment;
            }
        }

        utilityclass util = new utilityclass();
        facebookbody = util.facebookpost(blurbDetailId, blurbTitle, blurbDesc, blurbComment);
        system.debug('fffffffff' + facebookbody);


        //Parse down the response from facebook to check whether the user is connected to fb or not
        JSONParser parser1 = JSON.createParser(facebookbody);
        while (parser1.nextToken() != null) {
            if ((parser1.getCurrentToken() == JSONToken.FIELD_NAME) && (parser1.getText() == 'Status')) {
                parser1.nextToken();
                fbstatus = parser1.getText();
            }

            if ((parser1.getCurrentToken() == JSONToken.FIELD_NAME) && (parser1.getText() == 'Message')) {
                parser1.nextToken();
                fbmessage = parser1.getText();
            }


        }

        system.debug('fbmessage:::' + fbmessage);
        system.debug('fbstatus:::' + fbstatus);

        string callbackUrl = EncodingUtil.urlEncode('https://' + ApexPages.currentPage().getHeaders().get('Host') + Page.paneltest.getUrl(), 'UTF-8');


        if (fbstatus == '1006') {
            //string token1 = auth.AuthToken.getaccesstoken('0SOC0000000PAsc','facebook');
            //system.debug('TTTTTTTTTTTTT'+token1);

            showpopup();

            /*String url = 'https://www.facebook.com/dialog/oauth?';
        url += '&client_id=755760694472509';
        url += '&scope=' + EncodingUtil.urlEncode('email public_profile', 'UTF-8');
        //url += '&scope=' + EncodingUtil.urlEncode('full', 'UTF-8');
        url +='&redirect_uri='+ callbackUrl;
        //util.getmecode(url);
        return new pagereference('https://login.salesforce.com/services/auth/oauth/00DC00000017HRhMAM/testappfb');*/


            //PageReference pageRef = new PageReference(url);
            //pageref.setredirect(true); 
        } else {
            closepopup();
            showPopup1();
        }

        system.debug('code:::' + code);

        return null;


    }


    //method to post in twitter

    public PageReference postintwitter() {

        for (wrapper1 m: lstBlurbs) {
            if (m.BlurbId == xfb1) {
                system.debug('blurbDetail:::' + m);
                blurbDetailId = m.UserBlurbId;
                blurbTitle = m.tweeterpost;

            }
        }

        utilityclass util = new utilityclass();
        twitterbody = util.twitterpost(blurbDetailId, blurbTitle);

        System.debug('twitterbody' + twitterbody);

        JSONParser parser1 = JSON.createParser(twitterbody);
        while (parser1.nextToken() != NULL) {
            if ((parser1.getCurrentToken() == JSONToken.FIELD_NAME) && parser1.getText() == 'Status') {
                parser1.nextToken();
                twitterstatus = parser1.getText();
            }

            if ((parser1.getCurrentToken() == JSONToken.FIELD_NAME) && parser1.getText() == 'Message') {
                parser1.nextToken();
                twittermessage = parser1.getText();
            }
        }

        System.debug('twitterstatus:' + twitterstatus);
        System.debug('twittermessage:' + twittermessage);

        string callbackUrl = EncodingUtil.urlEncode('https://' + ApexPages.currentPage().getHeaders().get('Host') + Page.paneltest.getUrl(), 'UTF-8');


        if (twitterstatus == '1006') {
            showpopup();
        } else {
            closepopup();
            showPopup1();
        }

        system.debug('code:::' + code);

        return null;


    }


    //Pop  up methods

    public PageReference postinLinkedin() {
        for (wrapper1 m: lstBlurbs) {
            if (m.BlurbId == xfb1) {
                system.debug('blurbDetail:::' + m);
                blurbDetailId = m.UserBlurbId;
                blurbTitle = m.lnktittle;
                blurbDesc = m.lnkdecription;
                blurbComment = m.lnkcomment;

            }
        }
        utilityclass util = new utilityclass();
        linkedinbody = util.linkedinPost(blurbDetailId, blurbTitle, blurbDesc, blurbComment);

        System.debug('linkedinbody' + linkedinbody);

        JSONParser parser1 = JSON.createParser(linkedinbody);
        while (parser1.nextToken() != NULL) {
            if ((parser1.getCurrentToken() == JSONToken.FIELD_NAME) && parser1.getText() == 'Status') {
                parser1.nextToken();
                linkedinStatus = parser1.getText();

            }

            if ((parser1.getCurrentToken() == JSONToken.FIELD_NAME) && parser1.getText() == 'Message') {
                parser1.nextToken();
                linkedinMessage = parser1.getText();
            }
        }

        System.debug('linkedinStatus::' + linkedinStatus);
        System.debug('linkedinMessage::' + linkedinMessage);

        if (linkedinStatus == '1006') {
            showpopup();
        } else {
            closepopup();
            showPopup1();
        }

        return NULL;

    }

    public void closePopup() {
        displayPopup = false;

    }

    public void showPopup() {
        displayPopup = true;
    }

    public void showPopup1() {
        displayPopup1 = true;
    }

    public void closePopup1() {
        displayPopup1 = false;

    }



    public pagereference fbconnect() {


        string callbackUrl = EncodingUtil.urlEncode('https://' + ApexPages.currentPage().getHeaders().get('Host') + Page.paneltest.getUrl(), 'UTF-8');
        String url = 'https://www.facebook.com/dialog/oauth?';
        url += '&client_id=755760694472509';
        url += '&scope=' + EncodingUtil.urlEncode('email public_profile', 'UTF-8');
        url += '&redirect_uri=' + callbackUrl;
        url += '&state=facebook';
        return new pagereference(url);
    }

    public void postinChatter() {

        //List <url_c> blurbInfo = [SELECT ]

        system.debug('Blurb details::' + blurbLink + 'Title++' + blurbTitle);
        FeedItem post = new FeedItem();
        post.ParentId = userinfo.getUserId();
        post.Body = 'Go to this Blurb:' + 'https://c.ap2.visual.force.com/apex/paneltest002?BlurbId=' + xfb1 + '&CategoryId=' + xfb2;
        system.debug('xfb1::' + xfb1);
        post.LinkUrl = blurbLink;
        post.Title = blurbTitle;
        insert post;

    }


    /*public pagereference twitterconnect() {

     }
     */

    //wrapper classes for deserialisation.
    public class wrapper {

        public string CategoryId {
            get;
            set;
        }
        public string Name {
            get;
            set;
        }

    }
    public class response {

        public List < wrapper > Categories {
            get;
            set;
        }
        public string Status {
            get;
            set;
        }
        public string Message {
            get;
            set;
        }
    }

    public class response1 {

        public List < wrapper1 > blurbs {
            get;
            set;
        }
        public string Status {
            get;
            set;
        }
        public string Message {
            get;
            set;
        }
    }

    public class wrapper1 {

        public string BlurbId {
            get;
            set;
        }
        public string UserBlurbId {
            get;
            set;
        }
        public string EnterpriseBlurbId {
            get;
            set;
        }
        public string Title {
            get;
            set;
        }
        public string Description {
            get;
            set;
        }
        public string ImageUrl {
            get;
            set;
        }
        public string Url {
            get;
            set;
        }
        public string comment {
            get;
            set;
        }
        public string FeedName {
            get;
            set;
        }
        public string CategoryId {
            get;
            set;
        }
        public boolean Editmode {
            get;
            set;
        }
        public string fbtittle {
            get;
            set;
        }
        public string fbcomment {
            get;
            set;
        }
        public string fbdecription {
            get;
            set;
        }
        public string tweeterpost {
            get;
            set;
        }
        public string lnktittle {
            get;
            set;
        }
        public string lnkcomment {
            get;
            set;
        }
        public string lnkdecription {
            get;
            set;
        }

    }

    //fb response while trying to post a blurb in fb.

    /*public class blurbBody {
      public Id category {get; set;}
      public String description {get; set;}
      public String blurbid {get; set;}
      public String EnterpriseBlurbId {get; set;}
      public String ImageUrl {get;set;}
      public String Title {get; set;}

     }
      */




}