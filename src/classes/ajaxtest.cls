public class ajaxtest
{
public string authurl {get;set;}
public string accstoken {get;set;}
public string tenendpoint {get;set;}

public ajaxtest()
{
list<SOCXO_token__c>tok = [select Access_Token__c,tenanentendpoint__c from SOCXO_token__c where   SOCXO_Service__r.SFuser__r.Id =:userinfo.getuserid()];
this.accstoken = tok[0].Access_Token__c;
this.tenendpoint = tok[0].tenanentendpoint__c;
}


}