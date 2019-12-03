trigger populateCLproduct on genesis__Quick_Quotes__c (after insert, after update) {
    System.debug(LoggingLevel.ERROR, 'Updating CL product in case of CA created through Portal');
    /*Set<Id> QQIds = new Set<Id>();
    for(genesis__Quick_Quotes__c QQlist : trigger.new)
        if(QQlist.genesis__Quick_Quotes__c != null) {
            QQIds.add(QQlist.genesis__Quick_Quotes__c);*/
      
         list<genesis__Quick_Quotes__c> QQlist = [SELECT id , CL_Product__c, genesis__CL_Product__c from  genesis__Quick_Quotes__c ];
         for(genesis__Quick_Quotes__c UpdatelistCLP : QQlist ){ 
         if(UpdatelistCLP.CL_Product__c==null){ 
                 UpdatelistCLP.CL_Product__c= UpdatelistCLP.genesis__CL_Product__c ; 
             }
             else if(UpdatelistCLP.genesis__CL_Product__c==null){
                 UpdatelistCLP.genesis__CL_Product__c= UpdatelistCLP.CL_Product__c ;
             }
         }
          
          update(QQlist);
          
      
}