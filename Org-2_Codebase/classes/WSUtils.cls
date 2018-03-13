/*************************************************************
Name: WSUtils()
author: Chandrasekar Pathipati
Purpose: Utility class for WebServices classes
***********************************************************************/

global with sharing class WSUtils {
    /** HTTP status codes for returnCode field */
    global final static Integer STATUS_OK = 200;
    global final static Integer STATUS_CREATED = 201;
    global final static Integer STATUS_ACCEPTED = 202;
    global final static Integer STATUS_BAD = 400;
    global final static Integer STATUS_FORBIDDEN = 403;
    global final static Integer STATUS_NOTFOUND = 404;
    global final static Integer STATUS_NOTALLOWED = 405;
    global final static Integer STATUS_ISE = 500;
    
    global class Account {
        WebService Integer returnCode;
        WebService String message;
        
        //WebService String jsonStringResponse;
        Webservice Id externalAccountId;        
        public Account() {}
    }
}