trigger UpdateApplicationWithTradeUpValues on genesis__Applications__c (before insert) {
    if (trigger.isBefore){
        if (trigger.isInsert){
            SetOracleTradeUpFieldsFromQuickQuotes.setTradevalues(trigger.new);
        }
    }
}