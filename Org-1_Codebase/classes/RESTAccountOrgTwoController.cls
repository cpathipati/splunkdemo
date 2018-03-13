/***********************************************************************************************
* author : Chandrasekar Pathipati 02/28
* purpose: To retrieve accounts from Org-2 by names and returns the Org-2 accounts with their Id's
* 			method getAccountbyName can either query single or multiple accounts at same time.
***********************************************************************************************/

public class RESTAccountOrgTwoController {
    
    public static map<String,Id> getAccountbyName(String mode,list<account> listOfAccounts){
        map<String,Id> org2AccntReferance=new map<String,Id>();
        try{
            GetAccessToken.GetAccessTokenValues accessToken=GetAccessToken.getAccessTokenForOrg('Org-2');
            HttpRequest req =new HttpRequest();
            HttpResponse response=new HttpResponse();
            Http http = new Http();
            req.setMethod('GET');
            req.setHeader('Authorization', 'Bearer '+accessToken.access_token);
            //system.debug('/services/apexrest/Accounts?mode='+mode+'&accountName='+urlParms+'&listOfAccounts='+EncodingUtil.urlEncode((String)JSON.serialize(listOfAccounts),'UTF-8'));
            req.setEndpoint(accessToken.instance_url +'/services/apexrest/Accounts?mode='
                            +mode+'&listOfAccounts='
                            +EncodingUtil.urlEncode((String)JSON.serialize(listOfAccounts),'UTF-8'));
            
            try{
                response=http.send(req);
                String listOfAccountsResponse = response.getBody();
            } catch (CalloutException e) {
                //use client logging mechanism - Log all Callout Exceptions to custom log object or sending email according to your needs.
            }
            GetAccountsForJSON.GetAccounts accountDetails=GetAccountsForJSON.parse(response.getBody());
            list<Account> rtnListOfAccounts = (list<Account>)JSON.deserialize(response.getBody(),list<Account>.class);
            rtnListOfAccounts.remove(rtnListOfAccounts.size()-1);
            for (account eachAcnt:rtnListOfAccounts){
                org2AccntReferance.put(eachAcnt.name,eachAcnt.id);
            }
            
        }
        catch(Exception e){
            //use client logging mechanism - Log to other generic exceptions in a custom log object or sending email
        }
        return (org2AccntReferance);
    }
    
    public static WSUtils.Account doInsertAccounts(list<account> listOfAccounts){
        WSUtils.Account postStatus=new WSUtils.Account();
        GetAccessToken.GetAccessTokenValues accessToken=GetAccessToken.getAccessTokenForOrg('Org-2');
        HttpRequest req =new HttpRequest();
        HttpResponse response=new HttpResponse();
        Http http = new Http();
        req.setMethod('POST');
        req.setHeader('Authorization', 'Bearer '+accessToken.access_token);
        req.setEndpoint(accessToken.instance_url +'/services/apexrest/Accounts?listOfAcnts='+ 
                        EncodingUtil.urlEncode((String)json.serialize(listOfAccounts),'UTF-8'));
        req.setBody(EncodingUtil.urlEncode((String)json.serialize(listOfAccounts),'UTF-8'));
        try{
            response=http.send(req);
            system.debug(String.valueOf(response.getBody()));
		    //postStatus = (WSUtils.Account) JSON.deserialize(response.getBody(), WSUtils.Account.class);
        } catch (CalloutException e) {
            //use client logging mechanism - Log all Callout Exceptions to custom log object or sending email according to your needs.
        }
        return(postStatus);
    }
}