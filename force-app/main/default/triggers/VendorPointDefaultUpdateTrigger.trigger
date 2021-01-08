trigger VendorPointDefaultUpdateTrigger  on clcommon__Program_Or_Product_Points_Association__c (After Update, After Insert) {

  Savepoint sp = database.setsavepoint();
    clcommon__Program_Or_Product_Points_Association__c vendorProg = Trigger.new[0];
    try{
    
        /*if(Trigger.isUpdate || Trigger.isInsert){
        
            //create missing default point record based on associated program with App
            Map<Id, List<Id>> appProgMap = new Map<Id, List<Id>>();
            Set<clcommon__Program_Or_Product_Points_Association__c> pppAssoc = new Set<clcommon__Program_Or_Product_Points_Association__c>();
            Set<Id> programIdSet = new Set<Id>();
            List<genesis__Applications__c> appList = new List<genesis__Applications__c>();
            List<clcommon__Points__c> points = new List<clcommon__Points__c>();
            List<clcommon__Points__c> possiblePoints = new List<clcommon__Points__c>();
            List<clcommon__Points__c> pointToInsert = new List<clcommon__Points__c>();
            Map<ID, clcommon__Points_Setup__c> pointSetupMap = new Map<ID, clcommon__Points_Setup__c>([Select Id, clcommon__Enabled__c, clcommon__Points__c, clcommon__Points_Type__c from clcommon__Points_Setup__c]);
            system.debug('pointSetupMap-->' + pointSetupMap);
            
            for(clcommon__Program_Or_Product_Points_Association__c  assoc : trigger.new){
                if(assoc.Default_Vendor_Point__c == True){
                    programIdSet.add(assoc.clcommon__Program__c);
                    pppAssoc.add(assoc);
                }   
                
            }
            if(programIdSet.size()>0){
                //fetch all apps with given program set
                appList = [Select Id, genesis__Program__c from genesis__Applications__c where genesis__Program__c IN : programIdSet];
                system.debug('appList -->' + appList.size() );
                if(appList.size()>0){
                    for(Id programId : programIdSet){
                        List<Id> appListForMap = new List<Id>();
                        for(genesis__Applications__c app : appList){
                            if(app.genesis__Program__c == programId){
                                appListForMap.add(app.Id);
                            }
                        }
                        appProgMap.put(programId, appListForMap);
                    }
                }
            }
            
            //fetch points data based on appProgMap
            if(appList.size()>0){
                points = [Select Id, Name, clcommon__Points__c, genesis__Application__c, 
                                                clcommon__Points_Amount__c, genesis__Points_Setup__c, clcommon__Points_Type__c from clcommon__Points__c 
                                                where genesis__Application__c IN : appList];
                system.debug('points -->' + points.size() );
            }                                    
            
                                                       
            for(clcommon__Program_Or_Product_Points_Association__c  assoc : pppAssoc){  
            
                //create all possible point records in memory
                if(appProgMap.get(assoc.clcommon__Program__c).size() > 0 && assoc.Default_Vendor_Point__c == True){
                    for(Id appId : appProgMap.get(assoc.clcommon__Program__c)){
                        system.debug('appId-->' + appId);
                        clcommon__Points__c pt = new clcommon__Points__c();
                        pt.Name = 'Auto Created' ;
                        pt.clcommon__Points__c = pointSetupMap.get(assoc.clcommon__Points_Setup__c).clcommon__Points__c;
                        pt.clcommon__Points_Type__c = pointSetupMap.get(assoc.clcommon__Points_Setup__c).clcommon__Points_Type__c;
                        pt.genesis__Application__c = appId;
                        pt.genesis__Points_Setup__c = assoc.clcommon__Points_Setup__c;  
                        possiblePoints.add(pt);             
                    }
                }
                
                system.debug('possiblePoints-->' + possiblePoints);
                system.debug('possiblePoints.size()-->' + possiblePoints.size());
                
                    
                for(clcommon__Points__c ptVirtual : possiblePoints){
                    Boolean pointForAssocExist = False;
                    for(clcommon__Points__c ptReal : points){
                        if(ptReal.genesis__Application__c == ptVirtual.genesis__Application__c && 
                           ptReal.genesis__Points_Setup__c == ptVirtual.genesis__Points_Setup__c){
                           pointForAssocExist = True;
                           //break;
                        }
                    }  
                    system.debug('pointForAssocExist -->' + pointForAssocExist);
                    if(pointForAssocExist == False){
                        pointToInsert.add(ptVirtual);
                    } 
                                 
                }   
                system.debug('pointToInsert-->' + pointToInsert);
                insert pointToInsert;                                                      
            }           
        }*/
            
         
        List<clcommon__Program_Or_Product_Points_Association__c> vendorProgList  = new List<clcommon__Program_Or_Product_Points_Association__c>();
        
        if(Trigger.isUpdate){
                if(CLVendorPoint.isDefaultProgram){
                    CLVendorPoint.isDefaultProgram = false;
                    vendorProgList = [select id,name,Default_Vendor_Point__c,clcommon__Points_Setup__c,clcommon__Program__c
                                                                               from clcommon__Program_Or_Product_Points_Association__c where clcommon__Program__c=:vendorProg.clcommon__Program__c
                                                                               and Default_Vendor_Point__c=true];                                      
                    if(vendorProgList.size()>0){
                       
                        for(clcommon__Program_Or_Product_Points_Association__c venProg : vendorProgList){
                            if(venProg.id==trigger.new[0].id){
                               venProg.Default_Vendor_Point__c=trigger.new[0].Default_Vendor_Point__c;
                            }else{
                                venProg.Default_Vendor_Point__c=false;
                            } 
                            
                        }
                        update vendorProgList;
                    }
                }
        }else if(Trigger.isInsert && Trigger.new[0].Default_Vendor_Point__c==true){
            if(CLVendorPoint.isDefaultProgram){
                CLVendorPoint.isDefaultProgram = false;
                vendorProgList = [select id,name,Default_Vendor_Point__c,clcommon__Points_Setup__c,clcommon__Program__c
                                                                               from clcommon__Program_Or_Product_Points_Association__c where clcommon__Program__c=:vendorProg.clcommon__Program__c
                                                                               and Default_Vendor_Point__c=true];
                if(vendorProgList.size()>0){
                    for(clcommon__Program_Or_Product_Points_Association__c venProg : vendorProgList){
                        if(venProg.id==trigger.new[0].id){
                           venProg.Default_Vendor_Point__c=trigger.new[0].Default_Vendor_Point__c;
                        }else{
                            venProg.Default_Vendor_Point__c=false;
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