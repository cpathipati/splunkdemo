/*
    author: Chandrasekar Pathipati
    description: GetAccessToken is a generic utility to get access token info for transactions
*/

public class GetAccessToken {

	public class GetAccessTokenValues {
		public String access_token;
		public String instance_url;
		public String id;
		public String token_type;
		public String issued_at;
		public String signature;
        public String error;
        public String error_description;
	}

    
    public static GetAccessToken.GetAccessTokenValues getAccessTokenForOrg(String orgName){
        String endpointURL = 'https://login.salesforce.com/services/oauth2/token?'; //Change the link based on constants depending on Sandbox versus Production
        Remote_API_Keys__c rAPIkeys=Remote_API_Keys__c.getOrgDefaults();//getInstance(UserInfo.getUserId()); //Ensure the Requested Org. Details are already present
        endpointURL+='grant_type=password';
        endpointURL+='&client_id='+rAPIkeys.client_id__c;
        endpointURL+='&client_secret='+rAPIkeys.client_secret__c;
        endpointURL+='&username='+rAPIkeys.username__c;
        endpointURL+='&password='+rAPIkeys.SecurityToken__c;
        endpointURL+='&X-PrettyPrint:1';
    
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        req.setEndpoint(endpointURL);
        req.setMethod('POST');
        //req.setBody(body);
        try {
            res = http.send(req);
        }
        catch (Exception e) {
            system.debug(e.getMessage());
             // Log to Client based exception logging framework
        }
        return GetAccessToken.parse(res.getBody());
    }
	
	public static GetAccessTokenValues parse(String json) {
		return (GetAccessTokenValues) System.JSON.deserialize(json, GetAccessTokenValues.class);
	}
}