/***************************************************************************************
* Created By - Chandrasekar Pathipati
* Created On - March 01, 2018
* Purpose - Trigger on Account Object
* Added For - Write down Story Number / Issue Number / Task Number for reference.
****************************************************************************************/

trigger AccountTrigger on Account (before insert, before update, after insert, after update) {
    // Include logic for bypass this trigger for data loads and skip trigger code execution - by having custom object setting
    
	  //CaseTriggerHandler handler = new CaseTriggerHandler();
	
	  if(Trigger.isBefore) {		// All before events
	  
	      if(Trigger.isInsert) { //Make calls to necessary Handler Classes
	      }
	      if(Trigger.isUpdate) {//Make calls to necessary Handler Classes

	      }          
	  }    
    
	  
    if(Trigger.isAfter) { 			// All After events
	  
	      if(Trigger.isInsert) {	//Make calls to necessary Handler Classes
	        AccountTriggerHandler.onAfterInsert(Trigger.new);
	      }
	      if(Trigger.isUpdate) {	//Make calls to necessary Handler Classes

	      }        
	  }    

}