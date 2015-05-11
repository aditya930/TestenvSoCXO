global class sendEmail {
    //global String subject { get; set; }
    //public static String body { get; set; }
    private final lead lead1;
    //public static lead lead2 { get; set; }
    private final Lead lead;

    // Create a constructor that populates the Account object
    public sendEmail() {
        lead = [select Name, email from lead where id = :ApexPages.currentPage().getParameters().get('id')];
    }
    
      public sendEmail(ApexPages.StandardController stdController) {
        this.lead1 = (lead)stdController.getRecord();}

    public lead getlead() {
        return lead1;
    }

   /* public PageReference send() {
        // Define the email
    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 

    String addresses;
    if (lead1.Email != null)
    {
        addresses = lead1.Email;
        
    }

        String[] toAddresses = addresses.split(':', 0);

        // Sets the paramaters of the email
        email.setSubject( subject );
        email.setToAddresses( toAddresses );
        email.sethtmlBody( body );
    
        // Sends the email
        Messaging.SendEmailResult [] r = 
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
        
        return null;
    }*/
    
     @RemoteAction
    global static string send(string body1,string subject,string id1) {
      // Define the email
    system.debug('body1:::::::::'+body1);
    system.debug('subject:::::::::'+subject);
    lead lead2 = [select Name, email from lead where id =: id1];
    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 

    String addresses;
    if (lead2.Email != null)
    {
        addresses = lead2.Email;
        
    }

        String[] toAddresses = addresses.split(':', 0);

        // Sets the paramaters of the email
        email.setSubject( subject );
        email.setToAddresses( toAddresses );
        email.sethtmlBody( body1);
    
        // Sends the email
        Messaging.SendEmailResult [] r = 
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
     System.debug('body1.unescapeHtml4() : ' + body1.unescapeHtml4());
     
     if(body1!=null){
      return 'success';
     } else{
      return 'error';
     }  
    }
    
    
}