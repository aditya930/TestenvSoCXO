@isTest

public class InsertContactTest
{
   public static List<Account> accNew  = new list<Account>();

   public  static void CreateTestData()
   {
     createTestAccount();
     UpdateAccountCreated();
   }

  static void createTestAccount()
  {
  Account Acc = new Account(); 
  acc.Name = 'My new Account1'; 
  acc.Type= 'Prospect'; 
  AccNew.add(Acc);

  Account Acc1 = new Account(); 
  acc1.Name = 'My new Account2'; 
  acc1.Type= 'Technology Partner'; 
  AccNew.add(Acc1);

 insert accNew;


}

  static void UpdateAccountCreated()
  { 
    AccNew[0].Industry = 'Banking';
    AccNew[1].Industry = 'Agriculture';
    update AccNew;
  }




testMethod  static void  TestTriggerCreateContact()
   {
  CreateTestData();

 test.startTest();

 List<contact> Conlist= [select id, firstName, lastName from contact where AccountID = : AccNew]; // Can I query this or not ?

 test.stopTest();
 system.assert(conlist[0].firstName == 'ABC');//Error on this line- list index out of bounds
system.assert(conlist[0].lastname == 'XYZ');

  }}