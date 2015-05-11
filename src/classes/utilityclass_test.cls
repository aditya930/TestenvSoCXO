@istest

public with sharing class utilityclass_test{
       public static testMethod void testutilityclass() {
              utilityclass controller= new utilityclass();

       controller.userRegister('2000.00',
           'inv',
           'cochin',
           'kerala');
       
       
       }
   }