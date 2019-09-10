//batch apex ..
global with sharing class DMBIInterfaceJob implements Database.Batchable<sObject>,Database.Stateful
{
    //query string
    global static String query;
    public map<string,string> IntCodeMapping = new map<string,string>();
    global map<string,integer> SobjectCountMap = new map<string,integer>();
    global set<String> DataObjSet = new set<String>{'Int_Agreement__c','Int_Agreement_Classification__c','Int_Agreement_Exposure__c','Int_Agreement_Feature__c','Int_Agreement_Interest__c','Int_Agreement_Line__c','Int_Agreement_Line_Asset__c','Int_Agreement_Party__c','Int_Agreement_Payment_Schedule__c','Int_Asset__c','Int_Party__c','Int_Party_External_Reference__c','Int_Party_Street_Address__c','Int_Collateral__c','Int_Collateral_Party__c','Int_Collateral_Agreement__c'};
        global map<string,string> SobjectHashMap = new map<string,string>();
    global boolean isSuccess = true;
    global datetime BatchstartTime = system.now();  
    global map<String,Int_Party__c> insertedPartiesMap = new map<String,Int_Party__c>();  
    //Start method for fetching records.
    global Database.QueryLocator start(Database.BatchableContext BC){
        IntCodeMapping = DMBIInterfaceRecordGeneratorJob.getIntMapping();
        query = DMBIInterfaceRecordGeneratorJob.ConstructQuery() ;       
        return Database.getQueryLocator(query);
    }
    //Execute method 
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        //system.debug('scope---->'+scope.size());
        List<cllease__Lease_Account__c> contracts = (List<cllease__Lease_Account__c>)scope;
        List<sobject> AgreementsToInsert = new list<sobject>();
        List<sobject> AgreementsToInsert1 = new list<sobject>();
        List<sobject> AgreementsToInsert2 = new list<sobject>();
        List<sobject> AgreementsToInsert3 = new list<sobject>();
        List<sobject> AgreementsToInsert4 = new list<sobject>();
        List<sobject> AgreementsToInsert5 = new list<sobject>();
        List<sobject> AgreementsToInsert6 = new list<sobject>();
        List<sobject> AgreementsToInsert7 = new list<sobject>();
        //List<sobject> AgreementsToInsert8 = new list<sobject>();
        Savepoint sp = database.setsavepoint();        
        try {
            //system.debug('contracts-->'+contracts);
            if(!scope.isEmpty()){
                //AGREEMENTS
                list<Int_Agreement__c> AgreementRecords = DMBIInterfaceRecordGeneratorJob.CreateAgreements(contracts,IntCodeMapping);
                ConstructControlMap('Int_Agreement__c',DMBIInterfaceRecordGeneratorJob.CountInsertedRecords(AgreementRecords));
                if(!AgreementRecords.isEmpty()){
                    list<Int_Asset__c> AssetRecords = DMBIInterfaceRecordGeneratorJob.CreateAssets(contracts,IntCodeMapping);
                    ConstructControlMap('Int_Asset__c',DMBIInterfaceRecordGeneratorJob.CountInsertedRecords(AssetRecords));                    
                    if(!AssetRecords.isEmpty()){
                        list<Int_Agreement_Line__c> AgreementLinesList = DMBIInterfaceRecordGeneratorJob.CreateAgreementlines(AgreementRecords,contracts,IntCodeMapping);                           
                        if(!AgreementLinesList.isEmpty()){
                            Database.Insert(AgreementLinesList,false);
                            ConstructControlMap('Int_Agreement_Line__c',DMBIInterfaceRecordGeneratorJob.CountInsertedRecords(AgreementLinesList));                            
                            list<sobject> AgrLineAssetsAndCollateralsList = DMBIInterfaceRecordGeneratorJob.CreateAgrLineAssetsAndCollaterals(AgreementLinesList,contracts,AssetRecords);
                            database.insert(AgrLineAssetsAndCollateralsList,false);
                            CalculateObjectCount(AgrLineAssetsAndCollateralsList);
                        }
                    }
                }
                if (!AgreementRecords.IsEmpty() && !contracts.IsEmpty()){
                    //PARTIES
                    list<Int_Party__c> IntParties = DMBIInterfaceRecordGeneratorJob.CreateParties(contracts,insertedPartiesMap.keyset(),IntCodeMapping);
                    if(!IntParties.isEmpty()){
                        ConstructControlMap('Int_Party__c',DMBIInterfaceRecordGeneratorJob.CountInsertedRecords(IntParties));//  
                        UpdateInsertedParties(IntParties);  
                    }
                    AgreementsToInsert.AddAll(DMBIInterfaceRecordGeneratorJob.CreateIntAgreementPaymentSchedules(AgreementRecords,contracts,IntCodeMapping));
                    if(!AgreementsToInsert.isEmpty()){
                        CalculateObjectCount(AgreementsToInsert); 
                        CalculateHashCode(AgreementsToInsert);     
                    }
                    AgreementsToInsert5.AddAll(DMBIInterfaceRecordGeneratorJob.CreateIntAgreementPartyExternalReferences(IntParties,contracts,IntCodeMapping));
                    if(!AgreementsToInsert5.isEmpty()){
                        CalculateHashCode(AgreementsToInsert5); 
                    }
                    
                    AgreementsToInsert1.AddAll(DMBIInterfaceRecordGeneratorJob.CreateIntAgreementPartyStreetAddressDetails(IntParties,contracts,IntCodeMapping));
                    
                    AgreementsToInsert2.AddAll(DMBIInterfaceRecordGeneratorJob.CreateIntAgreementParties(AgreementRecords,contracts,IntParties,insertedPartiesMap.values(),IntCodeMapping));
                    
                    AgreementsToInsert6.AddAll(DMBIInterfaceRecordGeneratorJob.CreateAgreementClassifications(AgreementRecords,contracts,IntCodeMapping));
                    if(!AgreementsToInsert6.isEmpty()){
                        CalculateObjectCount(AgreementsToInsert6);    
                    }
                    AgreementsToInsert7.AddAll(DMBIInterfaceRecordGeneratorJob.CreateAgreementExposures(AgreementRecords,contracts,IntCodeMapping));                 
                    if(!AgreementsToInsert7.isEmpty()){
                        CalculateObjectCount(AgreementsToInsert7);  
                        CalculateHashCode(AgreementsToInsert7);     
                    }
                    AgreementsToInsert3.AddAll(DMBIInterfaceRecordGeneratorJob.CreateAgreementInterests(AgreementRecords,contracts));
                    if(!AgreementsToInsert3.isEmpty()){
                        CalculateObjectCount(AgreementsToInsert3);  
                        CalculateHashCode(AgreementsToInsert3);     
                    }
                    AgreementsToInsert4.AddAll(DMBIInterfaceRecordGeneratorJob.CreateAgreementFeatures(AgreementRecords,contracts,IntCodeMapping));
                    if(!AgreementsToInsert4.isEmpty()){
                        CalculateObjectCount(AgreementsToInsert4);    
                    }
                }
            }
            if(!AgreementsToInsert.isEmpty()){
                Insert AgreementsToInsert;
            }
            if(!AgreementsToInsert1.isEmpty()){
                //Insert AgreementsToInsert1;
                Database.insert(AgreementsToInsert1,False);
                ConstructControlMap('Int_Party_Street_Address__c',DMBIInterfaceRecordGeneratorJob.CountInsertedRecords(AgreementsToInsert1));//    
            }
            if(!AgreementsToInsert2.isEmpty()){
                Database.insert(AgreementsToInsert2,False);
                ConstructControlMap('Int_Agreement_Party__c',DMBIInterfaceRecordGeneratorJob.CountInsertedRecords(AgreementsToInsert2));//    
            }
            if(!AgreementsToInsert3.isEmpty()){
                database.insert(AgreementsToInsert3,false);
            }
            if(!AgreementsToInsert4.isEmpty()){
                Insert AgreementsToInsert4;
            }
            if(!AgreementsToInsert5.isEmpty()){
                Database.insert(AgreementsToInsert5, false);
                ConstructControlMap('Int_Party_External_Reference__c',DMBIInterfaceRecordGeneratorJob.CountInsertedRecords(AgreementsToInsert5));
            }
            if(!AgreementsToInsert6.isEmpty()){
                Insert AgreementsToInsert6;
            }
            if(!AgreementsToInsert7.isEmpty()){
                Insert AgreementsToInsert7;
            }
        }
        Catch(exception eX){
            database.rollback(sp);
            if(!eX.getMessage().contains('Party number')){
                isSuccess = false;
            }
            Int_Batch_Exception_Log__c  log = new Int_Batch_Exception_Log__c();
            if (ex.getMessage()!=null && ex.getMessage().length()>255)
                log.Exception__c = ex.getMessage().substring(0,255);
            else
                log.Exception__c = ex.getMessage();
            
            log.Execution_Type__c='CREATE DMBI RECORDS';
            log.Stack_Trace__c=ex.getStackTraceString();
            log.Run_Date__c=System.now();
            log.Status__c='Failed';
            insert log;
        }
    }
    public void ConstructControlMap(string ObjectName, integer sizeOfList){
        if(SobjectCountMap.containskey(ObjectName)){
            SobjectCountMap.put(ObjectName, SobjectCountMap.get(ObjectName)+sizeOfList);    
        }
        else{
            SobjectCountMap.put(ObjectName, sizeOfList);
        }
    }
    Public void CalculateObjectCount(list<sobject> SobjectList){
        Map<string,integer> CountMap = new Map<string,integer>();
        for(sobject obj:SobjectList){
            if(obj!=Null){
                string objname = string.valueof(obj.getSObjectType()); 
                if(!countMap.containskey(objname)){
                    CountMap.put(objname,1);
                }
                else{
                    CountMap.put(objname,CountMap.get(objname)+1);
                }
            }   
        }
        if(!CountMap.isEmpty()){
            for(string ObjName : CountMap.keyset()){
                ConstructControlMap(ObjName,CountMap.get(ObjName));
            }
        }
    }
    //Update insertedPartiesMap
    Public void UpdateInsertedParties(List<Int_Party__c> Parties){
        If(!Parties.isEmpty()){
            for(Int_Party__c party: Parties){
                If(party.Id != Null){
                    insertedPartiesMap.put(party.Party_Number__c,party);   
                }    
            }    
        } 
    }
    //Calculate Hashtotal1 for file control
    Public void CalculateHashCode(list<sobject> SobjectList){
        Map<string,string> HashMap = new Map<string,string>();
        Decimal ScheduleAmount=0;
        Decimal ExposureBooked=0;
        Decimal InterestAmount=0;
        for(sobject obj:SobjectList){
            string objname = string.valueof(obj.getSObjectType()); 
            if (objname == 'Int_Agreement_Payment_Schedule__c') {
                ScheduleAmount = ScheduleAmount + Integer.valueOf(obj.get('Schedule_Amount__c')); }
            else if (objname == 'Int_Agreement_Exposure__c')    
                ExposureBooked = ExposureBooked + Integer.valueOf(obj.get('Exposure_Booked__c'));
            else if (objname == 'Int_Agreement_Interest__c')    
                InterestAmount = InterestAmount + Integer.valueOf(obj.get('Interest_Amount__c'));     
        }        
        if (!SobjectHashMap.containskey('Int_Agreement_Payment_Schedule__c') && ScheduleAmount > 0) {
            SobjectHashMap.put('Int_Agreement_Payment_Schedule__c',String.valueOf(system.hashcode(ScheduleAmount)));
        }                        
        if (!SobjectHashMap.containskey('Int_Agreement_Exposure__c') && ExposureBooked > 0) {
            SobjectHashMap.put('Int_Agreement_Exposure__c',String.valueOf(system.hashcode(ExposureBooked)));
        }
        if (!SobjectHashMap.containskey('Int_Agreement_Interest__c') && InterestAmount > 0) {
            SobjectHashMap.put('Int_Agreement_Interest__c',String.valueOf(system.hashcode(InterestAmount)));
        }
    }
    //Finish method
    global void finish(Database.BatchableContext BC){
        try{
            if(isSuccess ){
                Datetime BatchEndTime = system.now();
                SobjectCountMap.put('Int_Delivery_Control__c',1);
                SobjectCountMap.put('Int_Facility__c',0);
                SobjectCountMap.put('Int_Agreement_Non_IFRS__c',0);  
                SobjectCountMap.put('Int_Agreement_Provision__c',0); 
                SobjectCountMap.put('Int_Asset_Feature__c',0);   
                SobjectCountMap.put('Int_Asset_Usage__c',0);                     
                SobjectCountMap.put('Int_Facility_Feature__c',0);    
                SobjectCountMap.put('Int_Facility_Party__c',0);  
                SobjectCountMap.put('Int_Party_Feature__c',0);   
                SobjectCountMap.put('Int_Risk_Costs_Movements__c',0);   
                SobjectCountMap.put('Int_Agreement_Line_Feature__c',0);
                for(String obj: DataObjSet){
                    If(!SobjectCountMap.containskey(obj)){
                        SobjectCountMap.put(obj,0);
                    }
                }
                if(!SobjectCountMap.isEmpty()){
                    list<sobject> ControlObjectsToInsert = new list<sobject>();
                    for(string ObjectName : SobjectCountMap.keySet()){
                        //Create file control objects here
                        ControlObjectsToInsert.add(DMBIInterfaceRecordGeneratorJob.createFileControlObjects(ObjectName,SobjectCountMap.get(ObjectName),SobjectHashMap,BatchstartTime,BatchEndTime,IntCodeMapping));
                    }
                    //Create delivery control objects here
                    ControlObjectsToInsert.add(DMBIInterfaceRecordGeneratorJob.createDeliveryControlObjects(BatchstartTime,IntCodeMapping));
                    if(!ControlObjectsToInsert.isEmpty()){
                        Insert ControlObjectsToInsert; 
                    }
                }
            }
        }
        catch(exception e){
            System.debug(LoggingLevel.ERROR, 'Exception while processing batch finish method: '+e.getMessage());
            System.debug(LoggingLevel.ERROR, 'Exception StackTrace: '+e.getStackTraceString()+ ' '+e.getLineNumber());
        }
    }
}