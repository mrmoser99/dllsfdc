global with sharing class DMBIDataCleanUpJob implements Database.Batchable<sObject>,Database.Stateful{
    global string ObjectToQuery;
    global integer NumberOfRecordsDeleted;
    //Start method for fetching records.
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        string query = 'SELECT Id FROM '+ObjectToQuery ;//+ ' LIMIT 20000';
        //system.debug('query--->'+query);
        return database.getquerylocator(query);
    }
    //Parametarized constructor
    global DMBIDataCleanUpJob(string ObjectName){
        ObjectToQuery = ObjectName;
        NumberOfRecordsDeleted = 0;
    }
    //Execute method 
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        try{
            /*if(!scope.isEmpty()&&scope.size()>10000){
DMBIInterfaceRecordGeneratorJob.HandleBulkDML(scope,'Delete');    
}
else{*/                                        
            NumberOfRecordsDeleted += scope.size();
            If(ObjectToQuery!='Int_Agreement__c'){
                DELETE Scope;
            }
            Else{
                Datetime dt = system.now().addseconds(40);
                While(dt > system.now()){               
                }
                DELETE Scope;
            }
        }
        catch(Exception ex){
            System.debug(LoggingLevel.ERROR, 'Exception in execute method : '+ex.getMessage());
            System.debug(LoggingLevel.ERROR, 'Exception in linenumber : '+ex.getLineNumber());
        }
    }
    //Finish method
    global void finish(Database.BatchableContext BC){
        system.debug(ObjectToQuery + ' Delete Batch Finished. Number of records Deleted : '+NumberOfRecordsDeleted);
        If(ObjectToQuery =='Int_Agreement__c'){
            Datetime dt = system.now().addseconds(25);
            
            While(dt > system.now()){               
            }
            
            Database.executeBatch(new DMBIInterfaceJob(),3);
            
        }
    }
    
}