public class PDFemailerChangeOrderCont{
    public ID OrderId {get;set;}
    public LookupObject__c lookup{ get; set;}
    public List <String> CcAddress {get;set;} 
    public String EmailBody {get;set;}

    public PDFemailerChangeOrderCont(){
    OrderId=ApexPages.currentPage().getParameters().get('id');
    
    lookup = [SELECT Id,
                     Contact__c
                     FROM
                     LookupObject__c
                     WHERE Id =:OrderId
                     ];
    }

    public void emailSend(){
        Messaging.SingleEmailMessage email = 
        new Messaging.SingleEmailMessage();

        //email.setToAddresses();
        system.debug('ccaddress:::'+CcAddress);
        email.setCcAddresses(CcAddress);
    }
    
    
}