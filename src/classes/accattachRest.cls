@RestResource(urlMapping='/attachment/*')
global class accattachRest {

   @HttpPost
     global static list<attachment> accDetail (String accId) {

         list<attachment> lstattach = [select id,parentid,body from attachment where parentid =:accId ];
         return lstattach;
  }
}