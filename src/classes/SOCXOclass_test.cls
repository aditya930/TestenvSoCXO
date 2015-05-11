@istest
public with sharing class SOCXOclass_test{
        public static testmethod void testmethod1(){
        
        SOCXOclass controller= new SOCXOclass();

        controller.password='pwd';
        controller.username='un';
        controller.req1=false;
        controller.req2=true;
        controller.accsToken='testtoken';
        controller.tenenpoint='testtenen';
        controller.expiresin='textexp';
        controller.postbody='testpost';
         
        PageReference testPage = Page.SOCXOmainPage;
        test.setCurrentPage(testPage);
        ApexPages.currentPage().getParameters().put('username','un');
        ApexPages.currentPage().getParameters().put('password','pw');
        controller= new SOCXOclass();

        SOCXO_Service__c service=new SOCXO_Service__c();
        service.OwnerId= UserInfo.getUserId();
        service.password__c='pwd';
        service.username__c='un';
        service.SFuser__c = userinfo.getuserid(); 
        insert service;
        System.debug('service = '+service);

        SOCXO_token__c currenttoken = new SOCXO_token__c();
        currenttoken.Access_Token__c = 'test Access_Token__c' ;
        currenttoken.expireson__c = datetime.now(); 
        currenttoken.SOCXO_Service__c = service.Id;
        //currenttoken.SOCXO_Service__r.SFuser__r.Id = UserInfo.getUserId();
        INSERT currenttoken;

        System.debug('currenttoken = '+currenttoken);

        System.debug('SFUSer'+currenttoken.SOCXO_Service__r.SFuser__r.Id);

        
        
       /*
        
        SOCXO_token__c token= new SOCXO_token__c();
        token.expireson__c=datetime.now();
        token.SOCXO_Service__c=service.Id;
        token.Access_Token__c='token';
        token.tenanentendpoint__c='tt';
        insert token;
        List<SOCXO_token__c> currenttoken= new List<SOCXO_token__c>();
        currenttoken.add(token);
        
        SOCXO_token__c token1= new SOCXO_token__c();
        token1.expireson__c=datetime.now();
        token1.SOCXO_Service__c=service.Id;
        token1.Access_Token__c='';
        token1.tenanentendpoint__c='tt';
        insert token1;
        List<SOCXO_token__c> currenttoken1= new List<SOCXO_token__c>();
        currenttoken1.add(token1);
        
       // controller.authorize();
       */
       
        
     }
      

}