trigger VendorPointsUpdateDefaultProgram on clcommon__Vendor_Program_Association__c (after update, After insert) {
    Savepoint sp = database.setsavepoint();
    clcommon__Vendor_Program_Association__c vendorProg = Trigger.new[0];
    try{
        
        List<clcommon__Vendor_Program_Association__c> vendorProgList;
        if(Trigger.isUpdate){
            if(CLVendorPoint.isDefaultProgram){
                CLVendorPoint.isDefaultProgram = false;
                vendorProgList = [select id,name,Default_Program__c,clcommon__Program__c,clcommon__Vendor__c
                                                                       from clcommon__Vendor_Program_Association__c where clcommon__Vendor__c=:vendorProg.clcommon__Vendor__c
                                                                       and Default_Program__c=true];
                if(vendorProgList.size()>0){
                    for(clcommon__Vendor_Program_Association__c venProg : vendorProgList){
                        if(venProg.id==trigger.new[0].id){
                           venProg.Default_Program__c=trigger.new[0].Default_Program__c;
                        }else{
                            venProg.Default_Program__c=false;
                        } 
                        
                    }
                    update vendorProgList;
                }
            }
        }else if(Trigger.isInsert && Trigger.new[0].Default_Program__c==true){
            if(CLVendorPoint.isDefaultProgram){
                CLVendorPoint.isDefaultProgram = false;
                vendorProgList = [select id,name,Default_Program__c,clcommon__Program__c,clcommon__Vendor__c
                                                                       from clcommon__Vendor_Program_Association__c where clcommon__Vendor__c=:vendorProg.clcommon__Vendor__c
                                                                       and Default_Program__c=true];
                if(vendorProgList.size()>0){
                   CLVendorPoint.isDefaultProgram = false;
                    for(clcommon__Vendor_Program_Association__c venProg : vendorProgList){
                        if(venProg.id==trigger.new[0].id){
                           venProg.Default_Program__c=trigger.new[0].Default_Program__c;
                        }else{
                            venProg.Default_Program__c=false;
                        } 
                        
                    }
                    update vendorProgList;
                }
            }
        }
    }catch(Exception ex){
        database.rollback(sp);
        System.debug('Exception : ' + ex + ' Error Message  :' +ex.getMessage());
        vendorProg.addError('Exception :'+ ex.getMessage() + ' LineNumber :' +ex.getLineNumber());
    }

}