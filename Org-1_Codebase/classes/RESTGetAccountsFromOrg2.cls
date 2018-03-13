/**************************************************************************************
author: Chandrasekar Pathipati
description: RESTGetAccountsFromOrg2 will fetch live date from Org2 for access in Org1 
**************************************************************************************/

public class RESTGetAccountsFromOrg2 {
    private integer counter=0;  //keeps track of the offset
    private integer list_size=20; //sets the page size or number of rows
    private integer total_size; //used to show user the total size of the list
    
    
    public list<account> accounts{	//Construct List Of Accounts for Visuvalforce page
        get{
            GetAccessToken.GetAccessTokenValues accessToken=GetAccessToken.getAccessTokenForOrg('Org-2');
            HttpRequest req =new HttpRequest();
            HttpResponse response=new HttpResponse();
            Http http = new Http();
            req.setMethod('GET');
            req.setHeader('Authorization', 'Bearer '+accessToken.access_token);
            system.debug(counter);
            req.setEndpoint(accessToken.instance_url +'/services/apexrest/Accounts?mode=queryAll&'+
                            '&list_size='+ list_size+
                            '&counter='+ counter);
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
            if(total_size==null)
                total_size=Integer.valueOf(rtnListOfAccounts[rtnListOfAccounts.size()-1].name);
            rtnListOfAccounts.remove(rtnListOfAccounts.size()-1);
            system.debug('total_size:'+ total_size);
            return (rtnListOfAccounts);
        }
        set;}
   
    public PageReference newOrg2Account(){
        PageReference newAccount = new PageReference('/apex/vfNewAccountCreation');
		newAccount.setRedirect(true);
		return newAccount;
    }

    public PageReference Beginning() { //user clicked beginning
        counter = 0;
        return null;
    }
    
    public PageReference Previous() { //user clicked previous button
        counter -= list_size;
        return null;
    }
    
    public PageReference Next() { //user clicked next button
        system.debug('before counter:'+counter);
        counter += list_size;
        system.debug('counter:'+counter);
        return null;
    }
    
    public PageReference End() { //user clicked end
        counter = total_size - math.mod(total_size, list_size);
        system.debug('End counter:'+counter);
        return null;
    }
    
    public Boolean getDisablePrevious() { 
        //this will disable the previous and beginning buttons
        if (counter>0) return false; else return true;
    }
    
    public Boolean getDisableNext() { //this will disable the next and end buttons
        if (counter + list_size < total_size) return false; else return true;
    }
    
    public Integer getTotal_size() {
        return total_size;
    }
    
    public Integer getPageNumber() {
        return counter/list_size + 1;
    }
    
    public Integer getTotalPages() {
        if (math.mod(total_size, list_size) > 0) {
            return total_size/list_size + 1;
        } else {
            return (total_size/list_size);
        }
    }	
    
}