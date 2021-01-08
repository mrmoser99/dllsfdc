trigger VendorPointsUpdateApplicationWithCLSTradeUp on genesis__Applications__c (After update, before Insert, after Insert) {
    
    Savepoint sp = database.setsavepoint();
    genesis__Applications__c app = Trigger.new[0];
    genesis__Applications__c app1 = new genesis__Applications__c();
    app1.id = app.id;
    app1.CLS_Trade_Up_Quote_Number__c = app.CLS_Trade_Up_Quote_Number__c;
    List<cllease__Termination_Quote_Header__c> quoteHeader;
    try{ 
        //create missing point record logic
        if(Trigger.isAfter && (Trigger.isUpdate || Trigger.isInsert)){
            ApplicationCustomTriggerHandler.populateMissingPointRecord(trigger.new);
        }
       
        
          
        /*List<genesis__Application_Pricing_Detail__c> pricingList = [select id,name,genesis__Term__c,genesis__Payment_Amount_Derived__c,genesis__Application__c from
                                                                   genesis__Application_Pricing_Detail__c where genesis__Application__c=:app.id];  */ 
        if(Trigger.isUpdate && CLVendorPoint.isDefaultProgram){
          CLVendorPoint.isDefaultProgram = false;
          genesis__Applications__c oldApp = Trigger.oldMap.get(app.id);
          Decimal totalPointAmount = 0.00;
          Decimal totalVendorPoint = 0.00;
          Decimal totalVendorPointPercentage = 0.00;
         
                                                                   
            if(app.Total_Equipment_Selling_Price__c != oldApp.Total_Equipment_Selling_Price__c){
                List<Application_Fee__c> appFeeList = [select id,name,Frequency__c,Equipment__c,Application__c,Amount__c,Fee__c,Fee__r.name from Application_Fee__c where Application__c=:app.id];

                List<clcommon__Points__c> pointList = [select id,name,clcommon__Points_Type__c,genesis__Application__c,clcommon__Points_Amount__c,clcommon__Points__c from
                                                clcommon__Points__c where genesis__Application__c=:app.id];
                if(pointList.size()>0){                             
                    for(integer i=0;i<pointList.size();i++){
                       pointList[i].clcommon__Points_Amount__c = app.Total_Equipment_Selling_Price__c * pointList[i].clcommon__Points__c/100;

                       if(pointList[i].clcommon__Points_Type__c=='Vendor'){
                          totalPointAmount = totalPointAmount + (Decimal)pointList[i].clcommon__Points_Amount__c;
                          totalVendorPoint  += (Decimal)pointList[i].clcommon__Points_Amount__c;
                          totalVendorPointPercentage += pointList[i].clcommon__Points__c;
                       }
                       
                    }
                    Update pointList;
                    
                    for(integer i=0;i<appFeeList.size();i++){
                        if(appFeeList[i].Fee__r.name =='Vendor Points'){
                           appFeeList[i].Amount__c = totalPointAmount;
                            
                        }
                       
                    }
                    Update appFeeList;
                    app1.genesis__Total_Vendor_Points__c = totalVendorPoint;
                    app1.Total_Vendor_Point__c = totalVendorPointPercentage;
                    update app1;
                
                }
                
            }else{
                
                try{
                    if(app.CLS_Trade_Up_Quote_Number__c != oldApp.CLS_Trade_Up_Quote_Number__c){
                        if(app.CLS_Trade_Up_Quote_Number__c !=null){
                            quoteHeader = [select id,name,cllease__Effective_To__c,cllease__Status__c,cllease__Quote_Amount__c,cllease__Contract__r.name from cllease__Termination_Quote_Header__c
                                                                                           where id=:app1.CLS_Trade_Up_Quote_Number__c];
                            System.debug('quoteHeader ='+quoteHeader); 
                            if(quoteHeader[0].cllease__Effective_To__c>=cllease.SystemDateUtil.getCurrentSystemDate()){
                                if(app.Trade_Up_From__c!=null && app.Trade_Up_From__c=='CL Lease' && quoteHeader.size()>0){
                                    app1.CLS_Trade_Up_Lease_Number__c = quoteHeader[0].cllease__Contract__r.name;
                                    app1.CLS_Trade_Up_Quote_Amount__c = quoteHeader[0].cllease__Quote_Amount__c;
                                    System.debug('CLS_Trade_Up_Quote_Number__c=' + app.CLS_Trade_Up_Quote_Number__c);
                                    update app1;
                                }
                            }else{
                                if(quoteHeader[0].cllease__Effective_To__c<cllease.SystemDateUtil.getCurrentSystemDate()){
                                    app.addError('Outdated Effective-To Date! Can not Process.');
                                }
                                    
                            }
                        }else{
                            app1.CLS_Trade_Up_Lease_Number__c = '';
                            app1.CLS_Trade_Up_Quote_Amount__c = 0.00;
                            System.debug('CLS_Trade_Up_Quote_Number__c=' + app.CLS_Trade_Up_Quote_Number__c);
                            update app1;
                        }
                        
                    }
                }catch(Exception ex){
                    Database.rollback(sp);
                    System.debug('Exception : ' + ex + ' Error Message  :' +ex.getMessage() + ' LineNumber :' + ex.getLineNumber());
                    if(quoteHeader.size()!=0 && quoteHeader!=null){
                       app.addError('Error Message :' + ex.getMessage());
                    }
                    /*else{
                       app.addError('Please enter the correct Quote Number??');
                    }*/
                }
                
                
            }
              
        }else if(Trigger.isInsert && Trigger.isBefore){
            if(app.genesis__Quick_Quote__c!=null){
               genesis__Quick_Quotes__c quickQuote = [select id,name,Dealer__c from genesis__Quick_Quotes__c where id=:app.genesis__Quick_Quote__c];
               
               app.genesis__Vendor__c = quickQuote.Dealer__c;
               
               List<clcommon__Vendor_Program_Association__c> vendorAssoList = [select id,name,Default_Program__c,clcommon__Program__c,clcommon__Vendor__c
                                                                               from clcommon__Vendor_Program_Association__c where clcommon__Vendor__c=:app.genesis__Vendor__c and Default_Program__c=true];
               if(vendorAssoList.size()>0){
                  for(Integer i=0;i<vendorAssoList.size();i++){
                     app.genesis__Program__c = vendorAssoList[i].clcommon__Program__c;
                  }
               }                                                                
            }
        }
    
    }catch(Exception ex){
        database.rollback(sp);
        System.debug('Exception : ' + ex + ' Error Message  :' +ex.getMessage() + ' LineNumber :' + ex.getLineNumber());
        app.addError('Exception : ' +ex + ' LineNumber :' + ex.getLineNumber());
    }
}