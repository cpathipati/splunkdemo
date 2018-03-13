/***********************************************************************************************
* author : Chandrasekar Pathipati 02/28
* purpose: vfNewAccountCreation.page Controller Extension for New Account Creation in Org-1
***********************************************************************************************/

public with sharing class newAccountCreation {
    public account newAccnt {get; set;}

    public newAccountCreation(ApexPages.StandardController controller) {
        newAccnt = new Account();
    }

    public PageReference saveOrg2Account() { //push account to Org-2
        try{
            if(newAccnt.Name!=null){
                newAccnt.External_Org_Id__c='PushToOrg2';
                insert newAccnt;
            }
        }
        catch (Exception ex) {
            ApexPages.addMessages(ex);
            system.debug(ex);
            return null;
        }
        return (new PageReference('/apex/vfOrg2Accounts'));
    }

}