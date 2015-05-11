@istest

public with sharing class socxouserRegistration_test{
       public static testMethod void testsocxouserRegistration() {
       
       socxouserRegistration controller= new socxouserRegistration();
       
       controller.Email='testemail';
       controller.Password='testpassword';
       controller.Fullname='testfullname';
       controller.Firstname='testfn';
       controller.ConfirmPwd='testpassword';
       controller.init();
       controller.registerUser();
    } 
           
   }