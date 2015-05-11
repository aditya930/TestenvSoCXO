global with sharing class socxo_admin_settings {
    @RemoteAction
    global static List<User> getUserDetails(){    
        List <User> lst_users = [SELECT Id, Email, LastName, FirstName, Profile.Name FROM User];
        return lst_users;
    }
    
    @RemoteAction
    global static String pushEmails(String emails){
        /*
        if(emails.length() > 0){
        	return 'success';
        }
        else{
            return 'failure';
        }
		*/
        utilityclass uc = new utilityclass();
        String response = uc.sendInvite(emails);
        return response;
    }
}