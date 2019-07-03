/** 
 *  Following class will be called from skuid page "during generate pricing button click "
 *  to update the Equipment values to copy  "" --> "" on Application Pricing generated.
 * */
global class UpdateEquipmentDetails {
    
    // Following method helps in copying required formula field from trade up amount to other financed 
    // fee for correct pricing generatio from product.
    webservice static String updateEquipmentDetail(String applicationId) {

        //return with success status
        String return_msg = 'SUCCESS';
        Savepoint sp = database.setsavepoint();
        try {

            if(String.isBlank(applicationId)) {
                // throw exception incase of applciationIDs null
                throw new CLSCustomException('applicationId are not valid. Please provide valid application IDs');
            }
            
            // 1. Query application with Equipments for details to copy
            List<genesis__Applications__c> applications = [Select Id, Name, 
                                                                (Select Id, Name, genesis__Other_Financed_Fees__c, Oracle_Trade_Up_Amount__c
                                                                From genesis__Application_Equipments__r)
                                                            From genesis__Applications__c
                                                            Where Id = :applicationId];
            
            List<genesis__Application_Equipment__c> equipmentsToUpdate = new List<genesis__Application_Equipment__c>();
            // 2. loop through applications
            for(genesis__Applications__c application : applications) {
                // 3. looping through Equipments
                for(genesis__Application_Equipment__c equipment : application.genesis__Application_Equipments__r) {
                    equipment.genesis__Other_Financed_Fees__c = equipment.Oracle_Trade_Up_Amount__c;
                    equipmentsToUpdate.add(equipment);
                }
            }
            // 3  update Equipments after processing
            if(equipmentsToUpdate.size() > 0) {
                update equipmentsToUpdate;
            }

        } catch(exception e){           
            database.rollback(sp);   
            System.debug(LoggingLevel.ERROR, 'Exception: '+e.getMessage());    
            System.debug(LoggingLevel.ERROR, 'Exception Stack: '+e.getStackTraceString());            
            //insert batch process log for exceptions
            insert new cllease__Batch_Process_Log__c(Name='updateEquipmentDetails', cllease__Date__c=system.today(),
            cllease__Message__c='Error is '+e.getmessage() +' in line number: '+ e.getlinenumber());
            return_msg = e.getMessage();
       }

        return return_msg;
    }
}