/*****************************************************************************************************************
* Date: Nov'20
* Description - Handler class for VendorPointsUpdateApplicationWithCLSTradeUp on genesis__Applications__c  object
* Update History - 
*****************************************************************************************************************/ 
public class ApplicationCustomTriggerHandler{
    public static boolean UpdatedDuetoPointDeletion = false; 
    public static void populateMissingPointRecord(List<genesis__Applications__c> appList) {
        Set<Id> programIdSet = new Set<Id>();
        List<clcommon__Program_Or_Product_Points_Association__c> pppAssoc = new List<clcommon__Program_Or_Product_Points_Association__c>();
        Map<Id, List<Id>> appProgMap = new Map<Id, List<Id>>();
        List<clcommon__Points__c> points = new List<clcommon__Points__c>();
        List<clcommon__Points__c> possiblePoints = new List<clcommon__Points__c>();
        List<clcommon__Points__c> pointToInsert = new List<clcommon__Points__c>();
        
        Map<ID, clcommon__Points_Setup__c> pointSetupMap = new Map<ID, clcommon__Points_Setup__c>([Select Id, clcommon__Enabled__c, clcommon__Points__c, clcommon__Points_Type__c from clcommon__Points_Setup__c]);
        system.debug('pointSetupMap-->' + pointSetupMap);
        
        for(genesis__Applications__c app: appList){
            System.debug('app.genesis__Program__c-->' + app.genesis__Program__c);
            if(app.genesis__Program__c != null){
                programIdSet.add(app.genesis__Program__c);                
            }
        }
               
        //create map for app based on program
        if(programIdSet.size()>0){
            if(appList.size()>0){
                for(Id programId : programIdSet){
                    List<Id> appListForMap = new List<Id>();
                    for(genesis__Applications__c app : appList){
                        if(app.genesis__Program__c == programId && !ByPassUtils.isByPassed('VendorPointsUpdateApplicationWithCLSTradeUp')){
                            system.debug('Static flag from App trigger-->' + ByPassUtils.isByPassed('VendorPointsUpdateApplicationWithCLSTradeUp'));
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
        
        //fetch all Program Or Product Points Association records for given program list
        pppAssoc = [Select Id, clcommon__CL_Product__c, Default_Vendor_Point__c, clcommon__Points_Setup__c, clcommon__Program__c 
                    from clcommon__Program_Or_Product_Points_Association__c where clcommon__Program__c IN: programIdSet];
        
        if(pppAssoc.size()>0){            
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
            }
        }
        system.debug('possiblePoints-->' + possiblePoints);
        system.debug('possiblePoints.size()-->' + possiblePoints.size());
        
        if(possiblePoints.size()>0){
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
        }  
        system.debug('pointToInsert-->' + pointToInsert);
        insert pointToInsert;                                                      
    }                        
}