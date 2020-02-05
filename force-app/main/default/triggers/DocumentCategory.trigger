trigger DocumentCategory on clcommon__Document_Category__c (after insert) {

        system.debug('*U***************************************************' + trigger.new); 
}