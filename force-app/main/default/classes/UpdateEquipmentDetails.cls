/** 
 *  Following class will be called from skuid page "during generate pricing button click "
 *  to update the Equipment values to copy  "" --> "" on Application Pricing generated.
 * 
 *  Change Log:
 * 
 *  5/7/2020 - added retry logic to prevent locking issues
 * */
global class UpdateEquipmentDetails {
    
    // Following method helps in copying required formula field from trade up amount to other financed 
    // fee for correct pricing generatio from product.
    webservice static String updateEquipmentDetail(String applicationId) {

        //return with success status
        String return_msg = 'SUCCESS';
       
        if(String.isBlank(applicationId)) {
            // throw exception incase of applciationIDs null
            throw new CLSCustomException('applicationId are not valid. Please provide valid application IDs');
        }
            
        // 1. Query application with Equipments for details to copy
        List<genesis__Applications__c> applications = [Select Id, Name,Oracle_Trade_Up_Amount__c, 
                                                                (Select Id, Name, genesis__Other_Financed_Fees__c, Oracle_Trade_Up_Amount__c
                                                                From genesis__Application_Equipments__r)
                                                            From genesis__Applications__c
                                                            Where Id = :applicationId];
        Integer TotalEquipments = [select count() from genesis__Application_Equipment__c where genesis__Application__c =:applicationId ];
        Integer Counter=1;
        Decimal TotalEquipmentTradeup=0;
        List<genesis__Application_Equipment__c> equipmentsToUpdate = new List<genesis__Application_Equipment__c>();
        // 2. loop through applications
        for(genesis__Applications__c application : applications) {
            // 3. looping through Equipments
            for(genesis__Application_Equipment__c equipment : application.genesis__Application_Equipments__r) {
                if(Counter<TotalEquipments){
                    TotalEquipmentTradeup += (equipment.Oracle_Trade_Up_Amount__c != null ? equipment.Oracle_Trade_Up_Amount__c : 0);
                    equipment.genesis__Other_Financed_Fees__c = (application.Oracle_Trade_Up_Amount__c != null ? equipment.Oracle_Trade_Up_Amount__c : NULL) ;
                    equipmentsToUpdate.add(equipment);
                }
                else if(Counter == TotalEquipments ){
                         equipment.genesis__Other_Financed_Fees__c = (application.Oracle_Trade_Up_Amount__c != null ? (application.Oracle_Trade_Up_Amount__c - TotalEquipmentTradeup) : NULL);
                         equipmentsToUpdate.add(equipment);
                }
                counter ++;
            }
        }
        
        // 3  update Equipments after processing
        if(equipmentsToUpdate.size() > 0) {
            // Only ever seen one retry needed this should be lots
            Integer n = 20;
            Integer sleepMs = 100;

            Exception lastException;
            for (Integer i = 0; i < n; i++) {
                try {
                    insert new cllease__Batch_Process_Log__c(Name='updateEquipmentDetails retry', cllease__Date__c=system.today()
                        , cllease__Message__c='This is information only, Retry count is: ' + i);
                    update equipmentsToUpdate;
                    system.debug('******************** retry count is: ' +  i);
                    return return_msg;
                } catch (DmlException e) {  
                    if (!e.getMessage().contains('UNABLE_TO_LOCK_ROW')) {
                        //insert batch process log for exceptions
                        insert new cllease__Batch_Process_Log__c(Name='updateEquipmentDetails', cllease__Date__c=system.today(),
                        cllease__Message__c=' Update Equipment Details Error is '+e.getmessage() +' in line number: '+ e.getlinenumber());
                    }
                    lastException = e;
                    sleep(sleepMs);
                }
            }
            throw lastException;
        }
        return return_msg;
    }

    private static void sleep(Integer ms) {

        Long start = System.currentTimeMillis();
        while (System.currentTimeMillis() < start + ms) {
            // Throw away CPU cycles
        }
    }

}