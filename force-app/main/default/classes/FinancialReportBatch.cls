/**
 * Owner: Cloud Lending Solutions
 * Usage: Following job helps in Creating Finacial report
 * Script to Run Job:
 *
 *     List<String> contractNames = List<String>{''};
 *     FinancialReportBatch job = new FinancialReportBatch(contractNames);
 *     Database.executeBatch(job);
 *    
 **/
global with sharing class FinancialReportBatch extends clcommon.DynamicJob {
    private static String query;
    private static final String JOB_NAME = 'FINANCIAL REPORT GENERATOR JOB';
    
    global FinancialReportBatch() {
        super(JOB_NAME, initialize(null));
        doInitialize();
    }

    global FinancialReportBatch(List<String> contractNames) {
        super(JOB_NAME, initialize(contractNames));
        doInitialize();
    }
    
    global virtual override String getRuntimeQuery() {
        System.debug(LoggingLevel.ERROR, 'FinancialReportBatch query in getRuntimeQuery : ' + query);
        return query; 
    }

    public static String initialize(List<String> contractNames) {

        String contractStatuses = '';

        // limit and tracking contract records.. delete also and date and error logs 
        for(LSContract_Status_For_Reportig__mdt LSConStatu: [SELECT MasterLabel FROM LSContract_Status_For_Reportig__mdt]) {
            contractStatuses += '\''+ LSConStatu.MasterLabel +'\',';
        }

        contractStatuses = contractStatuses.subString(0, contractStatuses.length() - 1);

        // Incase of running the test cases
        if(Test.isRunningTest()) {
            contractStatuses = '\'Active - Bad Standing\', \'Active - Good Standing\', \'Active - Matured\', \'Approved\', \'Terminated\'';
        }
        // Creating Query for Financial Report to delete
        query = 'SELECT Id, Name, cllease__Lease_Status__c, cllease__Maturity_Date__c '+
                ' FROM cllease__Lease_Account__c '+
                ' WHERE cllease__Lease_Status__c IN ( '+ contractStatuses +' ) ';

        // Filtering specific contracts for batch processing
        if(contractNames!=null && contractNames.size() > 0) {
            String contractNamesStr = '';
            for (String contractName : contractNames) {
              contractNamesStr = contractNamesStr + '\'' + String.escapeSingleQuotes(contractName) + '\'' + ',';
            }
            contractNamesStr = contractNamesStr.subString(0, contractNamesStr.length() - 1);
            query += ' AND Name IN ('+ contractNamesStr + ')';
        }

        query += ' ORDER BY Name ';

        System.debug(LoggingLevel.ERROR, 'FinancialReportBatch query in getRuntimeQuery : ' + query);
        return query;
    }

    public override void doExecute(Database.BatchableContext bc, List<sObject> scope) {

        Savepoint sp = database.setsavepoint();
        try {

          Set<Id> lsContractIds = new Set<Id>();
          Date maturityDate ;
          Date currentSystemDate = cllease.SystemDateUtil.getCurrentSystemDate();
          System.debug('***currentSystem.Date****'+currentSystemDate);
          String DATE_FILTER = 'DATEFILTER';
          cllease__Lease_Account__c leaseAcc;

          for(Sobject s : scope) { 
              leaseAcc = (cllease__Lease_Account__c)s ;
              //  system.debug('Contract Status ::::'+leaseAcc.cllease__Lease_Status__c);
              maturityDate = leaseAcc.cllease__Maturity_Date__c ;
              lsContractIds.add(leaseAcc.id);
          }
           
          system.debug('All Procced Contracts...'+ lsContractIds);  
    
          // fetching field FROM Mapping table 
          //Map<String,List<String>> sourceFields = new Map<String,List<String>>();
          //Map<String,List<String>> targetFields = new Map<String,List<String>>();
          Map<String,String> sourceTargetApis = new Map<String,String>();
          List<sObject> targetObjectInsert = new List<sObject>();
         
          // Map<String,Set<String>> withOutCondSourceFields = new Map<String,Set<String>>();
          Map<String,List<Lease_Financial_Report_Mapping__c>> withOutCondSourceFields = new Map<String,List<Lease_Financial_Report_Mapping__c>>();
          Map<String,Set<String>> withOutCondTargetFields = new Map<String,Set<String>>();
          Map<String,Set<String>> withCondSourceFields = new Map<String,Set<String>>();
          Map<String,Set<String>> withCondTargetFields = new Map<String,Set<String>>();
  
          Map<String, List<Lease_Financial_Report_Mapping__c>> conditionToParentMapping = new Map<String, List<Lease_Financial_Report_Mapping__c>>();
          Map<String,List<Lease_Financial_Report_Mapping__c>> whrConditionMap = new Map<String,List<Lease_Financial_Report_Mapping__c>>();
  
          conditionToParentMapping.put('NOCONDITION', new List<Lease_Financial_Report_Mapping__c>());
                 
          for(Lease_Financial_Report_Mapping__c FRM:[SELECT Source_Object_Name__c,Source_Field_Name__c, is_Ending_Balance__c, Target_Object_Name__c,Target_Field_Name__c,Source_Child_Relation__c,Sum_All_Child_Records__c,Where_Condition__c,Count_All_Child_Records__c,Child_Parent_Contract_API__c,Current_Year__c,Current_Period__c FROM Lease_Financial_Report_Mapping__c]) {
              sourceTargetApis.put(FRM.Target_Field_Name__c,FRM.Source_Field_Name__c);
              if(FRM.Source_Child_Relation__c) {
                  if(FRM.Where_Condition__c !=null) {
                     
                      //Source child fields with Condition 
                      if(withCondSourceFields.containskey(FRM.Source_Object_Name__c)) {
                          Set<String> sourceListchild = withCondSourceFields.get(FRM.Source_Object_Name__c);
                          sourceListchild.add(FRM.Source_Field_Name__c);
                          withCondSourceFields.put(FRM.Source_Object_Name__c,sourceListchild);
                          
                          List<Lease_Financial_Report_Mapping__c> ReprtMapList = whrConditionMap.get(FRM.Source_Object_Name__c);
                          ReprtMapList.add(FRM);
                          whrConditionMap.put(FRM.Source_Object_Name__c,ReprtMapList);
                      } else {
                          Set<String> sourceListchild = new Set<String>();
                          sourceListchild.add(FRM.Source_Field_Name__c);
                          withCondSourceFields.put(FRM.Source_Object_Name__c,sourceListchild);
                          
                          List<Lease_Financial_Report_Mapping__c> ReprtMapList = new List<Lease_Financial_Report_Mapping__c>();
                          ReprtMapList.add(FRM);
                          whrConditionMap.put(FRM.Source_Object_Name__c,ReprtMapList);
                      }   
                    
                      // For Target child fields
                      if(withCondTargetFields.containskey(FRM.Target_Object_Name__c)) {
                          Set<String> TargetList = withCondTargetFields.get(FRM.Target_Object_Name__c);
                          TargetList.add(FRM.Target_Field_Name__c);
                          withCondTargetFields.put(FRM.Target_Object_Name__c,TargetList);
                      } else {
                          Set<String> TargetList = new Set<String>();
                          TargetList.add(FRM.Target_Field_Name__c);
                          withCondTargetFields.put(FRM.Target_Object_Name__c,TargetList); 
                      }  

                 } else {
                    // For Source child fields with out Condition fields 
                    if(withOutCondSourceFields.containskey(FRM.Source_Object_Name__c)) {
                        List<Lease_Financial_Report_Mapping__c> sourceListchild = withOutCondSourceFields.get(FRM.Source_Object_Name__c);
                        sourceListchild.add(FRM);
                        withOutCondSourceFields.put(FRM.Source_Object_Name__c,sourceListchild);
                    } else {
                        List<Lease_Financial_Report_Mapping__c> sourceListchild = new List<Lease_Financial_Report_Mapping__c>();
                        sourceListchild.add(FRM);
                        withOutCondSourceFields.put(FRM.Source_Object_Name__c,sourceListchild);
                    }   
                    
                    // For Target child fields
                    if(withOutCondTargetFields.containskey(FRM.Target_Object_Name__c)) {
                        Set<String> TargetList = withOutCondTargetFields.get(FRM.Target_Object_Name__c);
                        TargetList.add(FRM.Target_Field_Name__c);
                        withOutCondTargetFields.put(FRM.Target_Object_Name__c,TargetList);
                    } else {
                        Set<String> TargetList = new Set<String>();
                        TargetList.add(FRM.Target_Field_Name__c);
                        withOutCondTargetFields.put(FRM.Target_Object_Name__c,TargetList);
                    }
                    
                 }

             } else {   

                if(FRM.Where_Condition__c !=null) {
                    List<Lease_Financial_Report_Mapping__c> tempParentMapping = conditionToParentMapping.get(FRM.Where_Condition__c);
                    if(tempParentMapping == null) {
                        tempParentMapping = new List<Lease_Financial_Report_Mapping__c>();
                    }
                    tempParentMapping.add(FRM);
                    conditionToParentMapping.put(FRM.Where_Condition__c, tempParentMapping);

                } else {
                    List<Lease_Financial_Report_Mapping__c> tempParentMapping = conditionToParentMapping.get('NOCONDITION');
                    tempParentMapping.add(FRM);
                    conditionToParentMapping.put('NOCONDITION', tempParentMapping);
                }

                /*
                // For Source fields 
                if(sourceFields.containskey(FRM.Source_Object_Name__c))
                {
                    List<String> sourceList = sourceFields.get(FRM.Source_Object_Name__c);
                    sourceList.add(FRM.Source_Field_Name__c);
                    sourceFields.put(FRM.Source_Object_Name__c,sourceList);
                }
                else
                {
                    List<String> sourceList = new List<String>();
                    sourceList.add(FRM.Source_Field_Name__c);
                    sourceFields.put(FRM.Source_Object_Name__c,sourceList);
                }   
                
                // For Target Fields
                if(targetFields.containskey(FRM.Target_Object_Name__c))
                {
                    List<String> TargetList = targetFields.get(FRM.Target_Object_Name__c);
                    TargetList.add(FRM.Target_Field_Name__c);
                    targetFields.put(FRM.Target_Object_Name__c,TargetList);
                }
                else
                {
                    List<String> TargetList = new List<String>();
                    TargetList.add(FRM.Target_Field_Name__c);
                    targetFields.put(FRM.Target_Object_Name__c,TargetList);
                }  
                */ 
             }
          }
         if(withOutCondSourceFields.keyset() != null && withOutCondTargetFields.keySet() != null){
              system.debug('--- withOutCondSourceFields ---'+withOutCondSourceFields.keyset());
              system.debug('--- withOutCondTargetFields ---'+withOutCondTargetFields.keySet());
              System.debug('**withOutCondSourceFieldsvalues**'+withOutCondSourceFields.Values());
              System.debug('**withOutCondTargetFieldsvalues***'+withOutCondTargetFields.Values());
          }
         

          System.debug(LoggingLevel.ERROR, ' key size: '+conditionToParentMapping.size());
          System.debug(LoggingLevel.ERROR, ' values size: '+conditionToParentMapping.values().size());
          String sourceFields, destFields;
          String sourceObjectName, targetObjectName;
          SObject objApi;
          // Processing Parent Field Mapping for report generation
          for(String condition : conditionToParentMapping.keySet()) {
              sourceFields = '';
              destFields  = '';
              // Process the Field Report Mapping objects and update the target field
              for(Lease_Financial_Report_Mapping__c fieldMapping : conditionToParentMapping.get(condition)) {
                  // Retrieve the source fields and target fields FROM here
                  sourceObjectName = fieldMapping.Source_Object_Name__c;
                  targetObjectName = fieldMapping.Target_Object_Name__c;

                  sourceFields += fieldMapping.Source_Field_Name__c +' ,';
                  destFields   += fieldMapping.Target_Field_Name__c +' ,';

              }

              system.debug('sourceFields ^^^^'+sourceFields);
              system.debug('destFields ^^^^'+destFields);

              sourceFields = sourceFields.subString(0, sourceFields.length() - 1);
              destFields  = destFields.subString(0, destFields.length() - 1);

              // Do query on the source object for object retrieval
              String query = 'SELECT '+sourceFields +' FROM '+sourceObjectName +' WHERE Id IN: lsContractIds ' +(condition == 'NOCONDITION' ? '' :' AND '+condition);

              system.debug('Source query ^^^^'+query);

              List<sObject> sobjList = database.query(query);
              if(sobjList.size() == 0) {
                  continue; // skipping current field update
              }
              sObject sourceObjInfo = sobjList[0];


              // Initialize target objct if null
              if(objApi == null) {
                  objApi = Schema.getGlobalDescribe().get(targetObjectName).newSObject();
              }
              // Loop again Field Mapping for updating the destination object
              for(Lease_Financial_Report_Mapping__c fieldMapping : conditionToParentMapping.get(condition)) {
                  objApi.put(fieldMapping.Target_Field_Name__c ,sourceObjInfo.get(fieldMapping.Source_Field_Name__c));
              }

              system.debug('Source Objects ^^^^'+sourceObjInfo);
              system.debug('target Objects^^^^'+objApi);

          }

          // Source fields query  
          /*Set<String> sourceObjectName = sourceFields.keyset() ;
          
          String sourcefieldAPIs = '' ;
          
          for(List<String> flds:sourceFields.values())
          {   
              for(Integer i=0;i<flds.size();i++)
              sourcefieldAPIs += flds[i]+',' ;
          }
          
          sourcefieldAPIs = sourcefieldAPIs.removeEnd(',');  
          
          String sourceObjApi = (new List<String>(sourceObjectName))[0] ; 
      
          String soqlQuery = 'SELECT '+sourcefieldAPIs+' FROM '+sourceObjApi;
                 soqlQuery+=' where id in:lsContractIds'; 
          
         // System.debug('--soqlQuery--'+soqlQuery);
          
          List<sObject> sobjList = database.query(soqlQuery);
          sObject sourceObjInfo = sobjList[0];
          
          //  System.debug('--sourceObjInfo --'+sourceObjInfo );
          Set<String> targetObjectName = targetFields.keyset() ; 
          //  system.debug('target Objects Name^^^^'+targetObjectName);
          String tObj = (new List<String>(targetObjectName))[0]  ;
          
          SObject objApi ;
          
          if(tobj !=null)
          {    
              objApi = Schema.getGlobalDescribe().get(tObj).newSObject() ;
              for(String fldsApi: targetFields.get(tobj))
              {  
               //   system.debug('Parent Field API Names^^^^'+fldsApi);
                  objApi.put(fldsApi,sourceObjInfo.get(sourceTargetApis.get(fldsApi))); //sourceTargetApis
                  
                 // system.debug('Obj API details mapping details ^^^^^'+objApi);
              } 
          }
       
          */
          // targetObjectInsert.add(objApi); 
          // Source Childs Aggregation Results
          // Map<String,Map<String,Decimal>> AggrSourWithOutCondResults = new Map<String,Map<String,Decimal>>();
          
          Map<String,Decimal> AggrSourWithOutCondResults = new Map<String,Decimal>();
          Map<String,Integer> AggrSourWithOutCondResultsCount = new Map<String,Integer>();
          Map<String,Decimal> sourceObjWithOutCondResults = new Map<String,Decimal>();
          Map<String,String> sourceObjWithOutCondResultsString = new Map<String,String>();
          Map<String,Date> sourceObjWithOutCondResultsDate = new Map<String,Date>();
          // sObject sourceObjWithOutCondResults ;
          
          for(String obj:withOutCondSourceFields.keyset())
          {
              for(Lease_Financial_Report_Mapping__c child:withOutCondSourceFields.get(obj))
              {
                  String conId = String.valueof((new List<Id>(lsContractIds))[0]) ;
                  if(child.Sum_All_Child_Records__c)
                  { 
                      String query = 'SELECT '+child.Child_Parent_Contract_API__c+',sum('+child.Source_Field_Name__c+')sum FROM '+child.Source_Object_Name__c+' where '+child.Child_Parent_Contract_API__c+' ='+'\''+conId+'\'' + ' group by '+child.Child_Parent_Contract_API__c ;    
                      
                    //  system.debug('***** Dynamic Query****'+query);
                      
                      List<AggregateResult> AggrList=new List<AggregateResult>();
                      
                      AggrList = Database.query(query);
                      //AggregateResult AggreResult = [SELECT cllease__Contract__c,sum(child)child FROM obj where cllease__Contract__c in:lsContractIds group by cllease__Contract__c ];
                      
                      if(AggrList.size()>0)
                      {
                          Decimal AggResult = ((decimal)AggrList[0].get('sum')) ;
                         // AggrSourWithOutCondResults.put(child,((decimal)AggrList[0].get('sum')));
                           AggrSourWithOutCondResults.put(child.Target_Field_Name__c,AggResult);
                      }
                  }
                  else if(child.Count_All_Child_Records__c)
                  {
                      String queryCount = 'SELECT '+child.Child_Parent_Contract_API__c+',count('+child.Source_Field_Name__c+')countVal FROM '+child.Source_Object_Name__c+' where '+child.Child_Parent_Contract_API__c+' ='+'\''+conId+'\'' +' group by '+child.Child_Parent_Contract_API__c ;    
                                        
                    //  system.debug('***** Dynamic Query****'+queryCount);
                      
                      List<AggregateResult> AggrListCount=new List<AggregateResult>();
                      
                      AggrListCount = Database.query(queryCount);
                      
                      if(AggrListCount.size()>0)
                      {
                          Integer AggResultCount = ((Integer)AggrListCount[0].get('countVal')) ;
                          AggrSourWithOutCondResultsCount.put(child.Target_Field_Name__c,AggResultCount);                    
                      }
                  }
                  else
                  {
                      String queryFieldVal = 'SELECT '+child.Source_Field_Name__c+ ' FROM '+child.Source_Object_Name__c+' where '+child.Child_Parent_Contract_API__c+' ='+'\''+conId+'\'' ;  

                      List<sobject> sobjSourceWithoutResults = database.query(queryFieldVal);
                      
                      Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                      Schema.SObjectType leadSchema = schemaMap.get(child.Target_Object_Name__c);
                      Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
                      String fielddataType = fieldMap.get(child.Target_Field_Name__c).getDescribe().getType().name().ToLowerCase();
                      
                      if(sobjSourceWithoutResults.size()>0)
                      {
                          if(fielddataType == 'String')
                          {
                              sourceObjWithOutCondResultsString.put(child.Target_Field_Name__c,(String)sobjSourceWithoutResults[0].get(child.Source_Field_Name__c));
                          }
                          else if(fielddataType == 'currency' || fielddataType == 'double' || fielddataType == 'percent' || fielddataType == 'decimal')
                          {
                              sourceObjWithOutCondResults.put(child.Target_Field_Name__c,(Decimal)sobjSourceWithoutResults[0].get(child.Source_Field_Name__c));  
                          }
                          else if(fielddataType == 'date')
                          {
                              sourceObjWithOutCondResultsDate.put(child.Target_Field_Name__c,(Date)sobjSourceWithoutResults[0].get(child.Source_Field_Name__c)); 
                          }
                      }
                      
                      //system.debug('$$$$$$4 sobjSourceWithoutResults4444 $$$$$$'+sobjSourceWithoutResults[0].get(child.Source_Field_Name__c));
                      
                  }                       
              }
          } 
        
          // system.debug('***** AggrSourWithOutCondResults ****'+AggrSourWithOutCondResults);
          // Source Childs Aggregation Results withOutCondSourceFields
        
          Set<String> withOutCondTargetName = withOutCondTargetFields.keyset() ;
          String withOutConTargObj;
          if(withOutCondTargetName.size() > 0) {
               withOutConTargObj = (new List<String>(withOutCondTargetName))[0]  ;
          }
           
        
          //  SObject withOutConTargobjApi ;
        
          if(withOutConTargObj !=null)
          {
              //withOutConTargobjApi = Schema.getGlobalDescribe().get(withOutConTargObj).newSObject() ;
              
              for(String fldsApi: withOutCondTargetFields.get(withOutConTargObj))
              {
                  if(AggrSourWithOutCondResults.containskey(fldsApi))
                      objApi.put(fldsApi,AggrSourWithOutCondResults.get(fldsApi));
                  else if(AggrSourWithOutCondResultsCount.containskey(fldsApi))
                      objApi.put(fldsApi,AggrSourWithOutCondResultsCount.get(fldsApi)); 
                  else if(sourceObjWithOutCondResults.containskey(fldsApi))  
                      objApi.put(fldsApi,sourceObjWithOutCondResults.get(fldsApi));
                  else if(sourceObjWithOutCondResultsString.containskey(fldsApi)) 
                      objApi.put(fldsApi,sourceObjWithOutCondResultsString.get(fldsApi));  
                  else if(sourceObjWithOutCondResultsDate.containskey(fldsApi))
                      objApi.put(fldsApi,sourceObjWithOutCondResultsDate.get(fldsApi));       
                    // system.debug('^^^sourceObjWithOutCondResults^^^^^^^^^^^^:'+sourceObjWithOutCondResults);    
                     
              } 
          } 
        
          Map<String,Decimal> AggrSourWithCondResults = new Map<String,Decimal>();
          Map<String,Integer> AggrSourWithCondResultsCount = new Map<String,Integer>();
          Map<String,Decimal> sourceObjWithCondResults = new Map<String,Decimal>();
          //  Map<String,sobject> sourceObjWithCondResults = new Map<String,sobject>();
          Map<String,String> sourceObjWithCondResultsString = new Map<String,String>();
          Map<String,Date> sourceObjWithCondResultsDate = new Map<String,Date>();

          for(String obj:whrConditionMap.keyset())
          {
              for(Lease_Financial_Report_Mapping__c child:whrConditionMap.get(obj))
              {
                  String conId = String.valueof((new List<Id>(lsContractIds))[0]) ;
                  if(child.Sum_All_Child_Records__c)
                  {
                      if(child.Current_Year__c !=null)
                      {
                          Date yearStartDate = Date.newInstance(currentSystemDate.year(), 1, 1);
                          String whereCondition = child.Where_Condition__c;
                          system.debug('***** 347 whereCondition****'+whereCondition + ' if value: '+whereCondition.containsIgnoreCase('DATEFILTER'));
                          if(whereCondition.containsIgnoreCase('DATEFILTER')) {
                              String dateCondition = '';
                              if(leaseAcc.cllease__Lease_Status__c == 'Terminated') {
                                  dateCondition = child.Current_Year__c+ ' >= : yearStartDate ';
                              } else {
                                  dateCondition = child.Current_Year__c+ ' >= : yearStartDate AND '+ child.Current_Year__c +' <= : currentSystemDate ';
                              }
                              whereCondition = whereCondition.replace('DATEFILTER', dateCondition);
                          }
                          String queryCY = 'SELECT '+child.Child_Parent_Contract_API__c+',sum('+child.Source_Field_Name__c+')sum FROM '+child.Source_Object_Name__c+' where '+child.Child_Parent_Contract_API__c+' ='+'\''+conId+'\'' + ' and '+ whereCondition +'  group by '+child.Child_Parent_Contract_API__c ;    
                          
                          system.debug('***** 358 Dynamic Query****'+queryCY);
                          
                          List<AggregateResult> AggrListCY=new List<AggregateResult>();
                          
                          AggrListCY = Database.query(queryCY);
                          
                          if(AggrListCY.size()>0)
                          {
                              Decimal AggResultCY = ((decimal)AggrListCY[0].get('sum')) ;
                              AggrSourWithCondResults.put(child.Target_Field_Name__c,AggResultCY);
                              
                           //   system.debug('********Aggregate Results with Current Year &&&&&******'+((decimal)AggrListCY[0].get('sum'))+'****** childs ****'+child.Source_Field_Name__c+'&&& AggResult &&&&'+AggResultCY);
                          }    
                      }
                      else if(child.Current_Period__c !=null)
                      {
                          Date monthStartDate = Date.newInstance(currentSystemDate.year(), currentSystemDate.month(), 1);
                          String whereCondition = child.Where_Condition__c;
                          system.debug('***** 376 whereCondition****'+whereCondition+ ' if value: '+whereCondition.containsIgnoreCase('DATEFILTER'));
                          if(whereCondition.containsIgnoreCase('DATEFILTER')) {
                              String dateCondition = '';
                              if(leaseAcc.cllease__Lease_Status__c == 'Terminated') {
                                  dateCondition = child.Current_Period__c+ ' >= : monthStartDate ';
                              } else {
                                  dateCondition = child.Current_Period__c+ ' >= : monthStartDate AND '+ child.Current_Period__c +' <= : currentSystemDate ';
                              }
                              system.debug('***** dateCondition*'+dateCondition);
                              system.debug('***** whereCondition before replace*'+whereCondition);
                              whereCondition = whereCondition.replace('DATEFILTER', dateCondition);
                              system.debug('***** whereCondition after replace*'+whereCondition);
                          }
                          
                          String queryMN = 'SELECT '+child.Child_Parent_Contract_API__c+',sum('+child.Source_Field_Name__c+')sum FROM '+child.Source_Object_Name__c+' where '+child.Child_Parent_Contract_API__c+' ='+'\''+conId+'\'' + ' and '+whereCondition+'  group by '+child.Child_Parent_Contract_API__c ;    
                          
                         system.debug('***** ^^^^ ' +child.Child_Parent_Contract_API__c+ '^^^^^^^^^^^ Dynamic Query Monthly****'+queryMN);
                          
                          List<AggregateResult> AggrListMN=new List<AggregateResult>();
                          
                          AggrListMN = Database.query(queryMN);
                          
                          if(AggrListMN.size()>0)
                          {
                              Decimal AggResultMN = ((decimal)AggrListMN[0].get('sum')) ;
                              AggrSourWithCondResults.put(child.Target_Field_Name__c,AggResultMN);
                              
                            //  system.debug('********Aggregate Results with Current Month &&&&&******'+((decimal)AggrListMN[0].get('sum'))+'****** childs ****'+child.Source_Field_Name__c+'&&& AggResult &&&&'+AggResultMN);
                          }   
                      }
                      else
                      {   

                          Date monthStartDate = Date.newInstance(currentSystemDate.year(), currentSystemDate.month(), 1);
                          String whereCondition = child.Where_Condition__c;
                          system.debug('***** 412 whereCondition****'+whereCondition+ ' if value: '+whereCondition.containsIgnoreCase('DATEFILTER'));
                          
                          if(whereCondition.containsIgnoreCase('DATEFILTER')) {
                              String dateCondition = '';
                              //if(leaseAcc.cllease__Lease_Status__c == 'Terminated') {
                              //    dateCondition = child.Current_Period__c+ ' >= : monthStartDate AND '+ child.Current_Period__c +' <= : maturityDate ';
                              //} else {
                                  dateCondition = 'cllease__Date__c > : currentSystemDate ';
                              //}
                              system.debug('***** dateCondition*'+dateCondition);
                              system.debug('***** whereCondition before replace*'+whereCondition);
                              whereCondition = whereCondition.replace('DATEFILTER', dateCondition);
                              system.debug('***** whereCondition after replace*'+whereCondition);
                          }

                          String query = 'SELECT '+child.Child_Parent_Contract_API__c+',sum('+child.Source_Field_Name__c+')sum FROM '+child.Source_Object_Name__c+' where '+child.Child_Parent_Contract_API__c+' ='+'\''+conId+'\'' + ' and '+whereCondition+' group by '+child.Child_Parent_Contract_API__c ;    
                          
                          system.debug('*****406 Dynamic Query****'+query);
                          
                          List<AggregateResult> AggrList=new List<AggregateResult>();
                          
                          AggrList = Database.query(query);
                          
                          if(AggrList.size()>0)
                          {
                              Decimal AggResult = ((decimal)AggrList[0].get('sum')) ;
                              // updating the aggResult to = 0 incase of Ending Balances for terminated contract 
                              if(leaseAcc.cllease__Lease_Status__c == 'Terminated' && child.is_Ending_Balance__c) {
                                  AggResult = 0.00;
                              }
                              AggrSourWithCondResults.put(child.Target_Field_Name__c, AggResult);
                              
                          //   system.debug('********Aggregate Results with Condition******'+((decimal)AggrList[0].get('sum'))+'****** childs ****'+child.Source_Field_Name__c+'&&& AggResult &&&&'+AggResult);
                          }
                        }  
                  }    
                  else if(child.Count_All_Child_Records__c)  
                  {
                      String queryCount = 'SELECT '+child.Child_Parent_Contract_API__c+',count('+child.Source_Field_Name__c+')countVal FROM '+child.Source_Object_Name__c+' where '+child.Child_Parent_Contract_API__c+' ='+'\''+conId+'\'' + ' and '+child.Where_Condition__c+' group by '+child.Child_Parent_Contract_API__c ;    
                                        
                     // system.debug('***** Dynamic Query****'+queryCount);
                      
                      List<AggregateResult> AggrListCount=new List<AggregateResult>();
                      
                      AggrListCount = Database.query(queryCount);
                      
                      if(AggrListCount.size()>0)
                      {
                          Integer AggResultCount = ((Integer)AggrListCount[0].get('countVal')) ;
                          AggrSourWithCondResultsCount.put(child.Target_Field_Name__c,AggResultCount);                    
                      }     
                   }
                   else
                   {

                      Integer currentMonth = currentSystemDate.month();
                      String whereCondition = child.Where_Condition__c;
                      //system.debug('***** 412 whereCondition****'+whereCondition+ ' if value: '+whereCondition.containsIgnoreCase('DATEFILTER'));
                      
                      if(whereCondition.containsIgnoreCase('DATEFILTER')) {
                          String dateCondition = '';
                          //if(leaseAcc.cllease__Lease_Status__c == 'Terminated') {
                          //    dateCondition = child.Current_Period__c+ ' >= : monthStartDate AND '+ child.Current_Period__c +' <= : maturityDate ';
                          //} else {
                              dateCondition = 'CALENDAR_MONTH(cllease__Date__c) = : currentMonth ';
                          //}
                          system.debug('***** dateCondition*'+dateCondition);
                          system.debug('***** whereCondition before replace*'+whereCondition);
                          whereCondition = whereCondition.replace('DATEFILTER', dateCondition);
                          system.debug('***** whereCondition after replace*'+whereCondition);
                      }

                      String queryFieldVal = 'SELECT '+child.Source_Field_Name__c+ ' FROM '+child.Source_Object_Name__c+' where '+child.Child_Parent_Contract_API__c+' ='+'\''+conId+'\''+ ' and '+whereCondition ;  
                      
                      System.debug('^^^^^^^^ Query child records ^^^^^^^^'+queryFieldVal);
                      
                      List<sobject> sobjSourceWithResults = database.query(queryFieldVal);
                      
                      Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                      
                      Schema.SObjectType leadSchema = schemaMap.get(child.Target_Object_Name__c);
                      
                      Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
                      //Schema.DisplayType fielddataType
                       String fielddataType = fieldMap.get(child.Target_Field_Name__c).getDescribe().getType().name().ToLowerCase();
                      
                      if(sobjSourceWithResults.size()>0)
                      {
                          System.debug('^^^^^^^^ Query child records value ^^^^^^^^'+sobjSourceWithResults[0].get(child.Source_Field_Name__c));
                          
                          if(fielddataType == 'String')  //Schema.DisplayType.String
                          {
                              sourceObjWithCondResultsString.put(child.Target_Field_Name__c,(String)sobjSourceWithResults[0].get(child.Source_Field_Name__c));   
                              system.debug('^^^^^^^^ Query child records value ^^^^^^^^ String ***'+sourceObjWithCondResultsString);
                          }
                          else if(fielddataType == 'currency' || fielddataType == 'double' || fielddataType == 'percent' || fielddataType == 'decimal' )
                          {
                              sourceObjWithCondResults.put(child.Target_Field_Name__c,(Decimal)sobjSourceWithResults[0].get(child.Source_Field_Name__c));   
                              system.debug('^^^^^^^^ Query child records value ^^^^^^^^ Decimal ***'+sourceObjWithCondResultsString);
                          }
                          else if(fielddataType == 'date')
                          {
                               system.debug('^^^^^^^^ Query child records Date^^^^^^^^ Target field Name***'+child.Target_Field_Name__c+'**** and Values *****'+sobjSourceWithResults[0].get(child.Source_Field_Name__c));
                               sourceObjWithCondResultsDate.put(child.Target_Field_Name__c,(Date)sobjSourceWithResults[0].get(child.Source_Field_Name__c)); 
                          }
                      }       
                   } 
                 }
              }    
        
          Set<String> withCondTargetName = withCondTargetFields.keyset() ;
          String withConTargObj = (new List<String>(withCondTargetName))[0] ;
          
          if(withConTargObj !=null)
          {
              for(String fldsApi: withCondTargetFields.get(withConTargObj))
              {
                  if(AggrSourWithCondResults.containskey(fldsApi))
                      objApi.put(fldsApi,AggrSourWithCondResults.get(fldsApi));
                  else if(AggrSourWithCondResultsCount.containskey(fldsApi))
                      objApi.put(fldsApi,AggrSourWithCondResultsCount.get(fldsApi));
                  else if(sourceObjWithCondResults.containskey(fldsApi))
                  {   
                      //system.debug('&&&&&&& fldsApi Decimal &&&&& ' +fldsApi+ ' $$ and values of field &&&&'+sourceObjWithCondResults.get(fldsApi));
                      objApi.put(fldsApi,sourceObjWithCondResults.get(fldsApi));           
                  }  
                  else if(sourceObjWithCondResultsString.containskey(fldsApi))
                  {
                      objApi.put(fldsApi,sourceObjWithCondResultsString.get(fldsApi)); 
                  }
                  else if(sourceObjWithCondResultsDate.containskey(fldsApi))
                      objApi.put(fldsApi,sourceObjWithCondResultsDate.get(fldsApi));  
              }
          }
             
          //Integer RemainingMonths = maturityDate.monthsBetween(currentDate);
          Integer RemainingMonths = currentSystemDate.monthsBetween(maturityDate);
          //Date myDate = currentSystemDate.newinstance(currentSystemDate.year(), currentSystemDate.month(), currentSystemDate.day());             
          
          objApi.put('Period_Date__c',currentSystemDate);
          objApi.put('Remaining_Months__c',RemainingMonths);
                   
          targetObjectInsert.add(objApi);
        
          // system.debug('--targetObjectInsert--'+targetObjectInsert);
        
          insert targetObjectInsert; 

        } catch(Exception e) {
            database.rollback(sp);   
            System.debug(LoggingLevel.ERROR, 'Exception: '+e.getMessage());    
            System.debug(LoggingLevel.ERROR, 'Exception Stack: '+e.getStackTraceString());      
            //insert batch process log for exceptions
            insert new cllease__Batch_Process_Log__c(Name = 'FinancialReportBatch Creating: ', cllease__Date__c = System.today(),
            cllease__Message__c = 'Error is '+e.getMessage() +' in line number: '+ e.getLineNumber());
        }
    }

    public override void doInitialize() { }
    public override void doStart(Database.BatchableContext bc) { }
    public override void doFinish(Database.BatchableContext bc) { }

}