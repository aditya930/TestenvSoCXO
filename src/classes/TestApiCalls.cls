public class TestApiCalls
{
    
    public static  HttpResponse utilityclass()
    {
        HttpResponse response = new HttpResponse();
    String Email='abc@gmail.com';
    String Password='123';
    String Fullname='testfn';
    String Firstname='testname';
    
      List<String> contents = new List<String>();
      contents.add(Email);
       contents.add(Password);
        contents.add(Fullname);
         contents.add(Firstname);
       String responses= JSON.serialize(contents);
           response.setBody(responses);
        return response;
      
    
    }
     
}