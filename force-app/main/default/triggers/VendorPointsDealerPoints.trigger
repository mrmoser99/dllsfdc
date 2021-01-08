trigger VendorPointsDealerPoints on clcommon__Points__c (before update, After update,After delete, After insert) {
   System.debug('VendorPointsDealerPoints time=' + system.now());
    Decimal totalPointAmount = 0.00;
    Decimal totalVendorPointPercentage = 0.00;
    Decimal totalVendorPoint = 0.00;
    genesis__Applications__c  app = new genesis__Applications__c();    
    
    if(Trigger.isDelete){
        app.id=Trigger.old[0].genesis__Application__c;
    }else{
        app.id=Trigger.new[0].genesis__Application__c;
    }
    List<Application_Fee__c> appFeeList;
    if(app!=null){
        appFeeList = [select id,name,Frequency__c,Equipment__c,Application__c,Amount__c,Fee__c,Fee__r.name from Application_Fee__c where Application__c=:app.id
                                                   and Fee__r.name='Vendor Points'];
    }
    if(Trigger.isDelete){
       Savepoint sp = database.setsavepoint();
       clcommon__Points__c points = Trigger.old[0];
        try{
           
            clcommon__Points__c newPoint =new clcommon__Points__c();
            newPoint.genesis__Application__c = points.genesis__Application__c;
            
            app.id = newPoint.genesis__Application__c;
             
            List<clcommon__Points__c> pointList = [select id,name,genesis__Application__c,clcommon__Points_Type__c,clcommon__Points_Amount__c,clcommon__Points__c from
                                 clcommon__Points__c where genesis__Application__c=:newPoint.genesis__Application__c];      
            if(pointList.size()>0 && pointList!=null){
                for(clcommon__Points__c point : pointList){
                    if(point.clcommon__Points_Amount__c!=null){
                        if(point.clcommon__Points_Type__c=='Vendor'){
                            totalPointAmount =totalPointAmount + point.clcommon__Points_Amount__c;
                            totalVendorPoint += point.clcommon__Points_Amount__c;
                            totalVendorPointPercentage +=point.clcommon__Points__c;
                        }
                    }
                }
                   
            }
                                       
            if(appFeeList.size()>0){
                for(Integer i=0;i<appFeeList.size();i++){          
                    appFeeList[i].Amount__c = totalPointAmount;
                }
            }
            Update appFeeList;
            app.genesis__Total_Vendor_Points__c = totalVendorPoint;
            app.Total_Vendor_Point__c = totalVendorPointPercentage;
            update app;
                 
        }catch(Exception ex){
            database.rollback(sp);
            System.debug('Exception : ' + ex + ' Error Message  :' +ex.getMessage() + ' LineNumber :' +ex.getLineNumber());
            points.addError('Exception :'+ ex.getMessage() + ' LineNumber :' +ex.getLineNumber());
        }
    }else if(Trigger.isInsert){
        System.debug('VendorPointsDealerPoints After Insert time=' + system.now());
        Savepoint sp = database.setsavepoint();
        List<clcommon__Points__c> pointsList = Trigger.New;
        if(pointsList.size()>0){
            try{
                List<clcommon__Points__c> pointsListForUpdate = new List<clcommon__Points__c>();
                clcommon__Points__c points;
                List<genesis__Applications__c>  appList = [select id,name,genesis__Term__c,genesis__Vendor__c,genesis__Expected_Start_Date__c,Total_Equipment_Selling_Price__c from genesis__Applications__c
                                                               where id=:pointsList[0].genesis__Application__c];  
                                                                                              
                for(clcommon__Points__c point : pointsList){
                    points = new clcommon__Points__c();
                    points.Id = point.Id;
                    points.genesis__Application__c = point.genesis__Application__c;  
                    points.clcommon__Points__c = point.clcommon__Points__c;  
                    if(appList.size()>0){
                        points.clcommon__Points_Amount__c =appList[0].Total_Equipment_Selling_Price__c * points.clcommon__Points__c/100;                                 
                    }else{
                        points.clcommon__Points_Amount__c=0.00;
                    }
                    pointsListForUpdate.add(points);
                }
                if(pointsListForUpdate.size()>0){
                    update pointsListForUpdate;
                }
                
               Application_Fee__c vendorPointFee = new Application_Fee__c();
                if(appFeeList.size()<1){
                    clcommon__Fee_Definition__c Fee = [select id,name from clcommon__Fee_Definition__c where name='Vendor Points'];
                    List<clcommon__Points__c> pointList1 = [select id,name,clcommon__Points_Type__c,genesis__Application__c,clcommon__Points_Amount__c,clcommon__Points__c from
                                                               clcommon__Points__c where genesis__Application__c=:pointsList[0].genesis__Application__c and clcommon__Points_Type__c='Vendor'];
                    vendorPointFee.Application__c = appList[0].id;
                    vendorPointFee.Fee__c = Fee.id;
                    vendorPointFee.Number_of_Payments__c = 1;
                    vendorPointFee.Frequency__c = 'ONE TIME';
                    for(integer i=0;i<pointList1.size();i++){
                        totalPointAmount = totalPointAmount + pointList1[i].clcommon__Points_Amount__c;
                    }
                    vendorPointFee.Amount__c = totalPointAmount;
                    vendorPointFee.Start_Date__c = appList[0].genesis__Expected_Start_Date__c;
                    insert vendorPointFee;
                }
                
            }catch(Exception ex){
                database.rollback(sp);
                System.debug('Exception : ' + ex + ' Error Message  :' +ex.getMessage() + ' LineNumber :' +ex.getLineNumber());
                for(integer i=0;i<pointsList.size();i++){
                   pointsList[i].addError('Exception :'+ ex.getMessage() + ' LineNumber :' +ex.getLineNumber());
                }
               
            }
           
        }
       
    }else{
        Savepoint sp = database.setsavepoint();
        List<clcommon__Points__c> pointList1 = Trigger.new;
        try{
           
            if(pointList1.size()>0){
                List<Application_Fee__c> appFeeListForUpdate =  new List<Application_Fee__c>();
                clcommon__Points__c oldPoint;
                
                app = [select id,name,Total_Equipment_Selling_Price__c,genesis__Total_Vendor_Points__c,Total_Vendor_Point__c from genesis__Applications__c
                                                                   where id=:pointList1[0].genesis__Application__c];                              
                for(clcommon__Points__c point : pointList1){
                    oldPoint= new clcommon__Points__c();
                    oldPoint = Trigger.oldMap.get(point.id);
                    if(Trigger.isBefore){
                       System.debug('VendorPointsDealerPoints Before Update time=' + system.now());
                        if(app!=null){
                            if(point.clcommon__Points__c != oldPoint.clcommon__Points__c){
                                point.clcommon__Points_Amount__c =app.Total_Equipment_Selling_Price__c * point.clcommon__Points__c/100;
                            }
                        }
                       
                    }else if(Trigger.isAfter){
                        List<clcommon__Points__c> pointList = [select id,name,clcommon__Points_Type__c,genesis__Application__c,clcommon__Points_Amount__c,clcommon__Points__c from
                                                               clcommon__Points__c where genesis__Application__c=:pointList1[0].genesis__Application__c];  
                        
                        totalVendorPoint = 0.00;
                        totalVendorPointPercentage = 0.00;
                        totalPointAmount = 0.00;
                        for(integer i=0;i<pointList.size();i++){
                            if(pointList[i].clcommon__Points_Type__c=='Vendor'){
                                totalPointAmount = totalPointAmount + pointList[i].clcommon__Points_Amount__c;
                                totalVendorPoint+=pointList[i].clcommon__Points_Amount__c;
                                totalVendorPointPercentage +=pointList[i].clcommon__Points__c;
                            }
                        }
                       
                    }
                }
             
            }
            
                                                
            if(appFeeList.size()>0){
                for(Integer i=0;i<appFeeList.size();i++){          
                    appFeeList[i].Amount__c = totalPointAmount;
                }
                Update appFeeList;
            }
            
            app.genesis__Total_Vendor_Points__c = totalVendorPoint;
            app.Total_Vendor_Point__c = totalVendorPointPercentage;
            update app;  
            
        }catch(Exception ex){
            database.rollback(sp);
            System.debug('Exception : ' + ex + ' Error Message  :' +ex.getMessage());
            for(Integer i=0;i<pointList1.size();i++){
                pointList1[i].addError('Exception :'+ ex.getMessage() + ' LineNumber :' +ex.getLineNumber());
            }
        }
    }
}