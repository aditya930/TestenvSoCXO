public with sharing class socxouserRegistration {
    public String Email {get; set;}
    public String Password {get; set;}
    public String Fullname {get; set;}
    public String Firstname {get; set;}
    public String ConfirmPwd {get; set;}

    public PageReference init(){
        Email = UserInfo.getUserEmail();
        
        Fullname = UserInfo.getName();
        Firstname = UserInfo.getFirstName();
        return null;

    }

    public PageReference registerUser(){
        if(Password == ConfirmPwd) {
            utilityclass util = new utilityclass();
            string statuscode =util.userRegister(Email, Password, Fullname, Firstname );
            
           if(statuscode =='1000')
            {
               
                PageReference authorisePage= new pagereference('/apex/SOCXOmainPage');
                authorisePage.setRedirect(true);
                authorisePage.getParameters().put('username',Email );
                authorisePage.getParameters().put('password',Password );
                authorisePage.getParameters().put('message','Successfully registered');
                
                ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.CONFIRM,'Successfully registered' );
                ApexPages.addmessage(msg);
                return authorisePage;       
            }
            else if(statuscode =='1002')
            {
            
            ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.INFO,'please contact your administrator for getting an invite' );
             ApexPages.addmessage(msg);
            }
             else if(statuscode =='1005')
            {
                
                 ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.INFO,'you have already registered' );
                  ApexPages.addmessage(msg);
            }
              else if(statuscode =='1004'||statuscode =='1003')
            {
                
                 ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR,'please try again' );
                  ApexPages.addmessage(msg);
            }
        
            ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR,'please try again' );
            return null;
        }
        
        else {
            ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Warning,'Password mismatch' );
            ApexPages.addmessage(msg);
              return null; 
        }
        
        return null;
    }
}