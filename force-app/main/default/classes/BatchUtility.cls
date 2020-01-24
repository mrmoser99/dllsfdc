public with sharing class BatchUtility {
	@AuraEnabled 
        public static String runJob() {
		
                String dagName = 'CL Lease: Batch Jobs DAG';
		clcommon.DynamicJobAPI2 apiHandle = clcommon.APIFactory.getDynamicJobAPI2();
		apiHandle.runOnce(dagName);

		return 'Submitted';

	}  

        public class wrapJobDetail{
                
                @AuraEnabled public String ApexClassName {get;set;}
                @AuraEnabled public DateTime CompletedDate  {get;set;} 
                @AuraEnabled public String JobType {get;set;}
                @AuraEnabled public Integer NumberOfErrors {get;set;}
                @AuraEnabled public String Status {get;set;}
                @AuraEnabled public DateTime CreatedDate {get;set;}
                @AuraEnabled public String ExtendedStatus {get;set;}
                @AuraEnabled public AsyncApexJob j{ get; set; }


                public wrapJobDetail(String name, AsyncApexJob j){
                        
                        ApexClassName = name;
                        CompletedDate = j.CompletedDate;
                        JobType = j.JobType;
                        if (j.NumberOfErrors == null || j.NumberOfErrors == 0)
                                NumberOfErrors = 0;
                        else
                                NumberOfErrors = j.NumberOfErrors;
                        Status = j.Status;
                        CreatedDate = j.CreatedDate;
                        ExtendedStatus = j.ExtendedStatus;
                        j=j;
                }
        } 

        @AuraEnabled(cacheable = true)
        public static List<wrapJobDetail> getJobDetails(String refreshExecute) {

               
                                 
		List<AsyncApexJob> aList = new List<AsyncApexJob>();
		aList = [select ApexClassId     
			          ,CompletedDate
				  ,JobType
				  ,NumberOfErrors
				  ,Status
				  ,CreatedDate
				  ,ExtendedStatus
			from AsyncApexJob
			where CreatedDate = today
			and ApexClassId != null
                        and JobType = 'BatchApex'
			order by CreatedDate desc
		];
		Set<String> keySet = new Set<String>();

		for (AsyncApexJob a :aList) {
		    keySet.add(a.ApexClassId);
		}

                Map<ID,String> apexClassMap = new Map<ID,String>();
                
                List<ApexClass> apexClassList = new List<ApexClass>();
                apexClassList = [
                        Select Id       
                                ,Name
                        From ApexClass
                        where id in :keySet
                        ];      
                for (ApexClass ap:apexClassList)
                        apexClassMap.put(ap.id,ap.name);
                
                system.debug(apexClassMap);
                List<wrapJobDetail> wrapList = new List<wrapJobDetail>();
                for (AsyncApexJob j :aList) {
                        system.debug('looking for: ' + j.apexClassId);
                        system.debug(apexClassMap.get(j.ApexClassId));
                        wrapList.add(new wrapJobDetail(apexClassMap.get(j.ApexClassId),j));
                }   
                system.debug('wrap list is: ' + wrapList);
		return wrapList;

	}

}