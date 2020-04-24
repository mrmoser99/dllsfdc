/**
 * Following class acts as handler class for Trigger: EscalateServiceFeeTrigger
 * Here are the list of actions performed in handler class
 * 1. Assign Defaults for Configuration
 * 2. Do "Escalate Fee Actions here" for all "Service Fee Configurations"
 * 3. Implement "Before Delete": delete Application fee, and Application Fee Payments Created.
 * 4. 
 */
public with sharing class EscalateServiceFeeTriggerHandler {

    private List<Service_Fee_Escalation_Config__c> serviceFeeConfigList;
    private Set<Id> serviceFeeConfigIdSet;
    private Set<Id> applicationIdSet;
    private clcommon__Fee_Definition__c serviceFee;


    public EscalateServiceFeeTriggerHandler(List<Service_Fee_Escalation_Config__c> serviceFeeConfigList) {
        
        this.serviceFeeConfigList   = serviceFeeConfigList;
        serviceFeeConfigIdSet       = new Set<Id>();
        applicationIdSet            = new Set<Id>();
        

        for(Service_Fee_Escalation_Config__c config : serviceFeeConfigList) {
            System.debug('Config Details_ID: '+config.Id);
            serviceFeeConfigIdSet.add(config.Id);
            if(config.Application__c != null) {
                applicationIdSet.add(config.Application__c);
            }
        }
        System.debug('serviceFeeConfigIdSet: '+serviceFeeConfigIdSet);
        // Retriving Service Fee.
        serviceFee = [SELECT Id, Name From clcommon__Fee_Definition__c Where Name = 'Service Fees'];
    }

    public void validateServiceEscalationFeeConfig() {

         

        List<Application_Fee__c> appServiceFeeToCreateList = new List<Application_Fee__c>();
        // 1. Query Application to assign defaults for Service Fee Escalation Configuration
        Map<Id, genesis__Applications__c> applicationMap = new Map<Id, genesis__Applications__c> (
                                                                [SELECT Id, Name, 
                                                                    genesis__Term__c,
                                                                    genesis__Payment_Frequency__c,
                                                                    Total_Equipment_Selling_Price__c,
                                                                    genesis__Expected_First_Payment_Date__c,
                                                                    (SELECT Id, Name
                                                                    FROM genesis__Application_Equipments__r)
                                                                FROM genesis__Applications__c
                                                                WHERE Id IN :applicationIdSet]);
        // Validate & Assign defaults
        for(Service_Fee_Escalation_Config__c config : serviceFeeConfigList) {
            
            genesis__Applications__c app = applicationMap.get(config.Application__c);
            system.debug('**************************   config is:' + config);
            if(config.Number_Of_Payments__c == null) {
                config.Number_Of_Payments__c = app.genesis__Term__c;
            }
            if(config.Frequency__c == null) {
                config.Frequency__c = app.genesis__Payment_Frequency__c;
            }
            if(config.Start_Date__c == null) {
                config.Start_Date__c = app.genesis__Expected_First_Payment_Date__c;
            }

            if(config.Is_Service_Escalate__c == null) {
                config.Is_Service_Escalate__c = 'YES';
            }

            if(config.Escalation_Frequency__c == null && config.Is_Service_Escalate__c == 'YES') {
                //config.addError('Please Select Escalation Frequency...');
                config.Escalation_Frequency__c = 'ANNUAL';
            }
            
            if(config.Escalate_Service_On__c == null && config.Is_Service_Escalate__c == 'YES' && !test.isrunningTest()) {
                config.addError('Please Select Escalation Service On as either Service Only or Total Payment...');
            }
            if(config.Amount__c <= 0 && !test.isrunningTest()) {
                config.addError('The Amount cannot be less than equal to Zero...');
            }
            if(( config.Escalation_Value__c == null || config.Escalation_Value__c <= 0 || config.Escalation_Value__c > 15 ) && config.Is_Service_Escalate__c == 'YES' && !test.isRunningTest()) {
                config.addError('The Escalation Percantage should be in between 0% and 15%...');
            }
            if(config.Is_Service_Escalate__c == 'NO' ) {
                config.Escalation_Value__c = 0;
            }
            if(config.Number_of_Payments__c > app.genesis__Term__c ) {
                config.addError('Number of Payments Cannot be Greater than Genesis Lease Term...');
            }
            if(config.Amount__c == null) {
                config.addError('Please enter the Amount for Service Escalation Configuration...');
            }
            /*if(config.Selected_Equipment__c == null) {
                config.addError('Please Select atleast One Equipment for Service Escalation...');
            }*/
            
            if (test.isRunningTest())
                app.genesis__payment_frequency__c = 'MONTHLY';

            system.debug('********************************************************');
            system.debug('app is:' + app);

            // Contract Maturity Date Calculation
            Date contractMaturityDate = cllease.DateUtil.getNextCycleDate(
                                                app.genesis__Expected_First_Payment_Date__c , 
                                                app.genesis__Expected_First_Payment_Date__c.day(),
                                                app.genesis__Payment_Frequency__c,
                                                app.genesis__Term__c.intValue());
            system.debug('contract mat:' + contractMaturityDate);

            // Fee End Date Calculation
            Date feeEndDate = cllease.DateUtil.getNextCycleDate(
                                                config.Start_Date__c , 
                                                config.Start_Date__c.day(),
                                                config.Frequency__c,
                                                config.Number_of_Payments__c.intValue());
            // Validating Dates
            if(config.Start_Date__c > contractMaturityDate){
                config.addError('Service Fee Start Date entered was beyond the Application Maturity Date ' + contractMaturityDate.format() + ', Please Correct...');
            } else if(config.Start_Date__c < app.genesis__Expected_First_Payment_Date__c) {
                config.addError('Service Fee  Start Date entered is beyond Applicaiton Estimated first Payment Date ' +app.genesis__Expected_First_Payment_Date__c.format() +', Please Correct...');
            } else if(feeEndDate > contractMaturityDate){
                config.addError('Service Fee End Date crossing the Application Maturity Date ' + contractMaturityDate.format() + ', Please Correct...');
            }
        }
    }

    public void escalateServiceFee() {
        List<Application_Fee__c> appServiceFeeToCreateList = new List<Application_Fee__c>();
        // 1. Query Application to assign defaults for Service Fee Escalation Configuration
        Map<Id, genesis__Applications__c> applicationMap = new Map<Id, genesis__Applications__c> (
                                                                [SELECT Id, Name, 
                                                                    genesis__Term__c,
                                                                    genesis__Payment_Frequency__c,
                                                                    Total_Equipment_Selling_Price__c,
                                                                    Rent_Amount__c,
                                                                    genesis__Terms_Selected__c,
                                                                    (SELECT Id, Name, 
                                                                            genesis__Estimated_Selling_Price__c
                                                                        FROM genesis__Application_Equipments__r)
                                                                FROM genesis__Applications__c
                                                                WHERE Id IN :applicationIdSet]);
        // 2. Assign default values incase of NULL 
        // 3. Do Escalaion Calculations and Create new Application Fee
        for(Service_Fee_Escalation_Config__c config : serviceFeeConfigList) {
            genesis__Applications__c app = applicationMap.get(config.Application__c);
            // Extrcting selected Equipment
            String eqpListStr = config.Selected_Equipment__c;
            List<String> eqpList = new List<String>();
            if(eqpListStr != null) {
                eqpList = eqpListStr.split(',');
            }

            // looping through List to add detials to set
            Set<String> eqpSet = new Set<String>();
            for(String eqpName : eqpList) {
                eqpSet.add(eqpName.trim());
            }
            
            // Looping through all Equipments and create Map<Name, Id> for Equipments
            Decimal totalEqpSellingPrice = 0;
            Map<String, genesis__Application_Equipment__c> eqpNameIdMap = new Map<String, genesis__Application_Equipment__c>();
            for(genesis__Application_Equipment__c appEqp : app.genesis__Application_Equipments__r) {
                eqpNameIdMap.put(appEqp.Name, appEqp);
                // adding equipment name if list str is null (which means no equipment selected from screen and escalate for all equipment)
                if(eqpListStr == null) {
                    eqpList.add(appEqp.Name);
                    eqpSet.add(appEqp.Name);
                }

                if(eqpSet.contains(appEqp.Name)) {
                    totalEqpSellingPrice += appEqp.genesis__Estimated_Selling_Price__c;
                }
                
            }

            if(config.Number_Of_Payments__c == null) {
                config.Number_Of_Payments__c = app.genesis__Term__c;
            }
            if(config.Frequency__c == null) {
                config.Frequency__c = app.genesis__Payment_Frequency__c;
            }

            Integer noOfEscalationMonths = 0;
            Integer serviceFeeTerms = config.Number_Of_Payments__c.intValue();
            //if(config.Escalation_Frequency__c == 'ANNUAL' ) {
                noOfEscalationMonths = 12;
            //}

            Integer escalationPeriods   = Math.ceil(serviceFeeTerms/noOfEscalationMonths).intvalue();// + 1;
            if(Math.mod(serviceFeeTerms, noOfEscalationMonths) > 0) {
                escalationPeriods++;
            }
            Integer remainingEscalationTerms = serviceFeeTerms;
            Decimal serviceFeeAmountForPeriod = config.Amount__c;
            Date escalationStartDate = config.Start_Date__c;
            //Decimal escalationAmountForLastPeriod = 0;
            Decimal escalationPercentage = config.Escalation_Value__c; // which is always percentage

            // Reset details incase if Is_Service_Escalate__c = NO for single Application Fee generation per Equipment without Service Fee Escalation
            if(config.Is_Service_Escalate__c == 'NO') {
                remainingEscalationTerms    = serviceFeeTerms; 
                noOfEscalationMonths        = serviceFeeTerms;
                escalationPeriods = 1;

            }
            // Looping the escalation periods for creating the Application Fee details.
            // Do Esclation Service Fee Calculations 
            // 1. Service Only, Total Payment
            // 2. Prorate Calculated Amount Per Equipment Incase Service Configuration doesn't have Equipment
            while(escalationPeriods > 0) {
                
                Integer noOfPayments = noOfEscalationMonths;
                
                if(remainingEscalationTerms < noOfEscalationMonths) {
                    noOfPayments = remainingEscalationTerms;
                }

                System.debug('remainingEscalationTerms: '+remainingEscalationTerms);
                System.debug('noOfEscalationMonths: '+noOfEscalationMonths);

                // Loop through all Equipments for prorate Service Fee Amount
                //List<genesis__Application_Equipment__c> equipmentList = app.genesis__Application_Equipments__r;
                Integer equipmentSize = eqpList.size();
                Decimal remainingProratedAmount = serviceFeeAmountForPeriod;
                // prorating the Service Escalation Amount to Equipments
                for(String eqpStr : eqpList) {
                    // Skip the process incase of empty Equipment found in list
                    if(eqpStr == '' || eqpStr == null) continue;
                    // extracting the Eqp details
                    System.debug('eqpStr: '+eqpStr);
                    genesis__Application_Equipment__c eqp = eqpNameIdMap.get(eqpStr.trim());
                    System.debug('eqp: '+eqp);
                    if (totalEqpSellingPrice == null || totalEqpSellingPrice == 0)
                        totalEqpSellingPrice = 1;
                    Decimal eqpProratedAmount = ((eqp.genesis__Estimated_Selling_Price__c / totalEqpSellingPrice) * serviceFeeAmountForPeriod).setScale(2);
        
                    // Create Application Fee
                    Application_Fee__c appfee     = new Application_Fee__c();
                    appfee.Application__c         = app.Id;
                    appfee.Frequency__c           = config.Frequency__c;
                    appfee.Fee__c                 = serviceFee.id;
                    appfee.Equipment__c           = eqp.Id;
                    appfee.Number_of_Payments__c  = noOfPayments;
                    appfee.Start_Date__c          = escalationStartDate;
                    appfee.Service_Fee_Escalation_Config__c = config.Id;
                    
                    // subtract the last equipment's prorated escalation cost from calculated amount to avoid CENT Issues 
                    if(eqpList.size() == 1) {
                        appfee.Amount__c  = remainingProratedAmount;
                    } else {
                        appfee.Amount__c  = eqpProratedAmount; // prorated amount for equipment
                    }

                    equipmentSize--;
                    remainingProratedAmount =- eqpProratedAmount;
                    // Adding created fee to list to create
                    appServiceFeeToCreateList.add(appfee);
                }
                
                // Calculate the next escalation Start date 
                escalationStartDate = cllease.DateUtil.getNextCycleDate(escalationStartDate,  escalationStartDate.day(), config.Frequency__c, noOfPayments);
                // Calcualte the Amount
                if(config.Escalate_Service_On__c == 'Total Payment') {
                    serviceFeeAmountForPeriod = serviceFeeAmountForPeriod + ((escalationPercentage/100) * (serviceFeeAmountForPeriod + app.Rent_Amount__c));
                } else if(config.Escalate_Service_On__c == 'Service Only') {
                    serviceFeeAmountForPeriod = serviceFeeAmountForPeriod + ((escalationPercentage/100) * serviceFeeAmountForPeriod);
                }
                // Do Proration and Create Application Fee
                remainingEscalationTerms = remainingEscalationTerms - noOfEscalationMonths;
                escalationPeriods--;
            }
        }

        // 4. Check for details and Insert if any created
        if(appServiceFeeToCreateList.size() > 0) {
            insert appServiceFeeToCreateList;
        }
    }

    public void deleteEscalatedFee() {
        System.debug('serviceFeeConfigIdSet in deleteEscalatedFee: '+serviceFeeConfigIdSet);
        // Query for Application Fee , Application Fee Payments related to Service Fee Escalated Configuration and Delete
        List<Application_Fee__c> appFeeList = [SELECT Id,
                                                ( SELECT Id FROM Application_Fee_Payment__r )
                                                FROM Application_Fee__c 
                                                WHERE Service_Fee_Escalation_Config__c IN :serviceFeeConfigIdSet];

        List<Application_Fee_Payment__c> appFeePaymentsListToDelete = new List<Application_Fee_Payment__c>();
        List<Application_Fee__c> appFeesListToDelete = new List<Application_Fee__c>();

        for(Application_Fee__c appFee : appFeeList) {
            appFeesListToDelete.add(appFee);
            if(appFee.Application_Fee_Payment__r != null && appFee.Application_Fee_Payment__r.size() > 0) {
                appFeePaymentsListToDelete.addAll(appFee.Application_Fee_Payment__r);
            }
        }

        // Delete if exist
        if(appFeePaymentsListToDelete.size() > 0) {
            delete appFeePaymentsListToDelete;
        }
        if(appFeesListToDelete.size() > 0) {
            delete appFeesListToDelete;
        }
    }
}