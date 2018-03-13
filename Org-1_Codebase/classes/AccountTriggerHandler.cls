/***************************************************************************************
* Created By - Chandrasekar Pathipati
* Created On - March 01, 2018
* Purpose - TriggerHandler for Account Object to keep all logic at one place and to better handle exception
* Added For - Write down Story Number / Issue Number / Task Number for referance.
****************************************************************************************/

public class AccountTriggerHandler {

    public static void onBeforeInsert(List<Account> newAccountList) {

    }

    public static void onBeforeUpdate(List<Account> newAccountList, Map<Id, Account> oldAccountMap) {
    }

    public static void onAfterUpdate(List<Account> newList, Map<Id, Account> mapOld, Map<Id,Account> newMap) {
    }

    public static void onAfterInsert(List<Account> newList) {
         updateOrg2Referance((String)json.serialize(newList));
        //pushNewAccountsToOrg2((String)json.serialize(newList));
    }

    @future(callout=true)
    private static void updateOrg2Referance(String accountList){
        try{
            list<account> newAccountList =(list<account>)json.deserialize(accountList, list<account>.class);
            list<account> tempAccountList=new list<account>(); //Create temp account list with extract of only Name (to avoid any additional payload during API callout)
            list<account> accountsToPushToOrg2=new list<account>();
            for (account eachAcnt:newAccountList){
                tempAccountList.add(new account(name=eachAcnt.Name));
                if(eachAcnt.External_Org_Id__c=='PushToOrg2'){ //Accounts to be pushed for Org-2
                    eachAcnt.External_Org_Id__c=eachAcnt.id;
                    system.debug(eachAcnt.id);
                    accountsToPushToOrg2.add(new account(name=eachAcnt.Name,type=eachAcnt.Type,site=eachAcnt.Site,External_Org_Id__c=eachAcnt.id));
                }
            }
            map<string,id> org2Accnts=RESTAccountOrgTwoController.getAccountbyName('query',tempAccountList);
            list<account> accountsToUpdate=new list<account>();
            for (account eachAcnt:newAccountList){
                system.debug(eachAcnt.Name);
                if(org2Accnts.containsKey(eachAcnt.Name)){
                    accountsToUpdate.add(new account(External_Org_Id__c=org2Accnts.get(eachAcnt.Name),id=eachAcnt.id));
                }
            }
            if(accountsToUpdate.size()>0){
                update accountsToUpdate;
            }
        if(accountsToPushToOrg2.size()>0){
            system.debug(accountsToPushToOrg2);
            WSUtils.Account rtnServiceAction=RESTAccountOrgTwoController.doInsertAccounts(accountsToPushToOrg2);
            if(rtnServiceAction.returnCode!=WSUtils.STATUS_ACCEPTED){
                //Some issue with REST API Callout. log the error message. can reterive message from (rtnServiceAction.message)
            }
        }

        }catch(AsyncException e){
            //use client logging mechanism - Log all AsyncExceptions to custom log object or sending email according to your needs.
        }

    }
}