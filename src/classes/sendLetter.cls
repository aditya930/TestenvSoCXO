global class sendLetter{
    //global String subject { get; set; }
    //public static String body { get; set; }
    private final lead lead1;
    //public static lead lead2 { get; set; }
    private final Lead lead;
    //Variable declaration
    public List<ContactWrapper> contactList {get; set;}
    public Map<String, ContactWrapper> selectedContactsMap {get; set;}
    public Set<string> selectedContactIds {get; set;}
    List<Contact> contacts {get; set;}

    // Create a constructor that populates the Account object
    public sendLetter() {
        //selectedContactIds = new Set<string>();
        ///selectedContactsMap = new Map<String, ContactWrapper>();
        lead = [select Name, email from lead where id = :ApexPages.currentPage().getParameters().get('id')];
    }
    
      public sendLetter(ApexPages.StandardController stdController) {
        this.lead1 = (lead)stdController.getRecord();}

    public lead getlead() {
        return lead1;
    }
    @RemoteAction
    global static Account getAccount(String accountName) {
       NewsLetter__c sapmleobj = new NewsLetter__c();
       sapmleobj.images1__c= accountName;
       INSERT sapmleobj ;
        return null;
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
    
    
    //Code to pick selected contacts
    //Display contacts to VF page
    public list<ContactWrapper> getContacts(){
        contactList = new List<ContactWrapper>();
        ContactWrapper contact;  

        for(Contact c : [SELECT Id, Name, Email FROM Contact WHERE Email != '']){
            contact = new ContactWrapper();
            contact.Id = c.Id;
            contact.Name = c.Name;
            contact.Email = c.Email;
        
            contactList.add(contact);
        }
        return contactList;
    }
    
    //Pick only selected contacts
    public void addSelectedContacts(){

        if(contactList != null && contactList.size() != 0){
        System.debug(contactList);
        selectedContactIds = new Set<string>();
        selectedContactsMap = new Map<String, ContactWrapper>();
            for(ContactWrapper c : contactList){
                if(c.checked == TRUE){
                    selectedContactIds.add(c.Id);
                    selectedContactsMap.put(c.id, c);
                }
                else if(selectedContactsMap.containsKey(c.Id)){
                    selectedContactIds.remove(c.Id);
                    selectedContactsMap.remove(c.Id);
                }
            }
        }
        System.debug(selectedContactIds.size());        
    }
    
    //Send newsletter to selected contacts
    public void sendNewsLetter() {
    
        addSelectedContacts();
       /* if(selectedContactIds.size() == 0){
            apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Warning,'No contacts selected. Please selest atleast one to proceed..!!');
            apexpages.addmessage(msg);
        } */
        contacts = [SELECT Id, Name, Email FROM Contact WHERE Id IN : selectedContactIds];
        
        if(contacts.size() > 0) {
        
            for(Contact c : contacts){
        
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                List<String> sendTo = new List<String>();
                sendTo.add(c.Email);
                email.setToAddresses(sendTo);
                email.setSubject('This month news letter');
                email.setSenderDisplayName('NewsLetter Support');              
                String body = '<html><body>Hi ' + c.Name + ',<br><br>Changes have been made to your details. <br>Contact administrator if you are not responisble.</body></html>';               
                email.setHtmlBody(body);
                
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
            }
        }
    }
    //Wrapper class for contacts
    public class ContactWrapper{
        public String Id {get; set;}
        public String Name {get; set;}
        public String Email {get; set;}
        public boolean checked {get; set;}
    }
    
}