/*
author: chandra
about: this is a rest based api service to provide org. account data
@get : accepts url based parameters to fetch accounts and return by handling pagination.

*/
@RestResource(urlMapping='/Accounts/*')
global class AccountManager { 
    @HttpGet
    global static list<account> getAccount(){
        list<account> rtnAccount=new list<account>(); //Default return object
        rtnAccount.add(new account(name='Invalid Request'));
        try{
            RestRequest req=RestContext.request;
            if(req.params.get('mode')=='queryAll'){
                system.debug(req.params.get('list_size'));
                system.debug(req.params.get('counter'));
                Integer limt_Size=  Integer.valueOf(req.params.get('list_size'));
                Integer offset_size=Integer.valueOf(req.params.get('counter'));
                Integer total_size = [select count() from Account];
                Integer newOffset_size=offset_size;
                
                account lastOffsetAccount;
                
                while(newOffset_size>2000){ //Use Query more option to workthrough Offset Limitation for Pagination
                    if(lastOffsetAccount==null){
                        lastOffsetAccount=[select CreatedDate from account order by CreatedDate DESC limit :1 offset:2000];    
                    }else{    
                        lastOffsetAccount=[select CreatedDate from account where CreatedDate <= :lastOffsetAccount.CreatedDate order by CreatedDate DESC limit :1 offset:2000];
                    }
                    newOffset_size-=2000;
                }
                
                if(lastOffsetAccount==null){
                    rtnAccount=[SELECT name from account order by CreatedDate DESC limit :limt_Size offset:newOffset_size];
                }else{
                    if(total_size==offset_size){
                        newOffset_size=newOffset_size-limt_Size;
                    }
                    rtnAccount=[SELECT name from account where CreatedDate <= :lastOffsetAccount.CreatedDate order by CreatedDate DESC limit :limt_Size offset:newOffset_size];    
                }
                lastOffsetAccount=null;
                rtnAccount.add(new Account(name=String.valueOf(total_size)));
            }
            
            else if(req.params.get('mode')=='query'){
                list<account> accountsToQuery=(list<Account>)JSON.deserialize(EncodingUtil.urlDecode(req.params.get('listOfAccounts'), 'UTF-8'),list<account>.CLASS);
                if(accountsToQuery.size()>0){
                    String[] listOfNames=new String[]{};
                        for(account a1:accountsToQuery){
                            listOfNames.add(a1.name);
                        }
                    rtnAccount=[SELECT id,name from account where Name IN :listOfNames]; 
                }
                if(rtnAccount.size()>0)
                    rtnAccount.add(new account(name='AccountMatchFound'));
                else
                    rtnAccount.add(new account(name='AccountNotFound'));
            } 
            
            else if(req.params.get('mode')=='angularFetchAll'){
                rtnAccount=[SELECT id,name from account order by CreatedDate]; 
            }
        }
        catch(Exception e){
            // Log all exceptions to some custom log object
        }
        //system.debug(rtnAccount);
        return rtnAccount;
    }
    
@HttpPost
    global static WSUtils.account doInsertAccount(){
        WSUtils.account result = new WSUtils.account();
        try{
            RestRequest req=RestContext.request;
            list<Account> listOfAccountsToInsert = (list<Account>)JSON.deserialize(EncodingUtil.urlDecode(req.params.get('listOfAcnts'),'UTF-8'),list<Account>.class);
            system.debug(listOfAccountsToInsert);
            if(listOfAccountsToInsert.size()>0){
                insert listOfAccountsToInsert;
            }
            result.returnCode = WSUtils.STATUS_OK;
        }
        catch (Exception e) {
            result.returnCode = WSUtils.STATUS_ISE;
            result.message = e.getMessage();
        }
        return (result);
    }
}