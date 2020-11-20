trigger UpdateDefaultProgramTrigger on clcommon__Program__c (After Update) {
    List<clcommon__Program__c> programList = [select id,name,Default_Program__c from clcommon__Program__c where Default_Program__c=true];
        if(CLVendorPoint.isDefaultProgram && programList.size()>0){
            CLVendorPoint.isDefaultProgram = false;
            for(clcommon__Program__c prog : programList){
                if(prog.id==trigger.new[0].id){
                    prog.Default_Program__c=trigger.new[0].Default_Program__c;
                }else{
                    prog.Default_Program__c=false;
                }
             }
       		 update programList; 
        }
 }