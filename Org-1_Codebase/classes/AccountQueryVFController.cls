/**************************************************************************************
author: Chandrasekar Pathipati
description: AccountQueryVFController will fetch live date from Org2 for access in Org1 
			 this controller will get all accounts at once.
**************************************************************************************/

public class AccountQueryVFController {
    public String[] fetchAcnts{
        get{
            
            GetAccessToken.GetAccessTokenValues accessToken=GetAccessToken.getAccessTokenForOrg('Org-2');
            HttpRequest req =new HttpRequest();
            HttpResponse response=new HttpResponse();
            Http http = new Http();
            req.setMethod('GET');
            req.setHeader('Authorization', 'Bearer '+accessToken.access_token);
            req.setEndpoint(accessToken.instance_url +'/services/apexrest/Accounts?mode=angularFetchAll'); //Fetch all the accounts (Max Limit 50000)
            try{
                response=http.send(req);
                String listOfAccounts = response.getBody();
                system.debug(listOfAccounts);
            } catch (Exception e) {
                system.debug(e.getMessage());
                //use client logging mechanism - Log to custom log object or sending email
            }
            GetAccountsForJSON.GetAccounts accountDetails=GetAccountsForJSON.parse(response.getBody());
            list<Account> rtnListOfAccounts = (list<Account>)JSON.deserialize(response.getBody(),list<Account>.class);

            String [] rtnNames=new String[]{};
            for (account a:rtnListOfAccounts){
               rtnNames.add('\''+a.name+'\'');   
            }  
            return (rtnNames);
        }
    
    }
}