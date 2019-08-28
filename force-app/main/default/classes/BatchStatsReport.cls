/*********************************************************************************************
*	This batch calculates the monthly stats report...counts/dollars per month
*    
*   To test:
*			id batchinstanceid = database.executeBatch(new BatchStatsReport(),1); 
*
* ChangeLog:
*
*	8/27/19 - MRM Created Class
*
************************************************************************************************/
global class BatchStatsReport implements Database.Batchable<SObject>,Database.Stateful{
    /*********************************************************************************************
  	*	QUERY
  	*
  	*
  	************************************************************************************************/
    static final string QUERY = 'Select id, name  from Annual_View__c';
	
    /*********************************************************************************************
  	*	START
  	*
  	************************************************************************************************/				
    global Database.QueryLocator start(Database.BatchableContext c) {    
        
		
		System.debug('****** in constructor ******');

        List<cllease__Period_Status__c> buckets = new List<cllease__Period_Status__c>();

		Integer year = date.today().year();
		Integer startyear = year - 1;
		Integer endYear = year + 1;
		Date startYearSearch =  date.valueOf(startyear + '-12-31');
		Date endYearSearch =    date.valueOf(endYear + '-01-01');
		 

        buckets = [select cllease__start_date__c from cllease__Period_Status__c where cllease__start_date__c > :startYearSearch and cllease__start_date__c < :endYearSearch];
		
		List<Annual_View__c> aList = new List<Annual_View__c>();
		List<Annual_View__c> dList = new List<Annual_View__c>();

		dList = [select id from Annual_View__c];
		delete dList;

		for (cllease__Period_Status__c b : buckets){
			annual_view__c a = new annual_view__c(name = string.valueOf(b.cllease__start_date__c));
			alist.add(a);
		}
 		
	
		insert aList;
    	
		
		return Database.getQueryLocator(QUERY);        
    }
  	/*********************************************************************************************
  	*	EXECUTE
  	*
  	*
  	************************************************************************************************/
    global void execute(Database.BatchableContext c, List<Annual_View__c> scope) {
        
        system.debug('scope is: ' + scope);

		Annual_View__c a = [select id, name, booked_amount__c, funding_amount__c from Annual_View__c where id = :scope[0].id];

		Date startDate = date.valueOf(a.name);
		Date tempDate = date.valueOf(a.name);
		Date endDate = tempDate.addMonths(1);

		/* Applicaitons Received */
		List<genesis__Quick_Quotes__c> qList = new List<genesis__Quick_Quotes__c>();
		qList = [select Estimated_Financed_Amount__c from genesis__Quick_Quotes__c where createddate >= :startDate and createddate < :enddate ];
		a.applications_received__c = qList.size();
		
		a.applications_received_amount__c = 0;
		for (genesis__Quick_Quotes__c q:qList){
			if (q.Estimated_Financed_Amount__c != null)
				a.applications_received_amount__c += decimal.valueOf(q.Estimated_Financed_Amount__c);
		}

		/*Applications Approved */
		qList = [select Approved_Credit_Amount__c from genesis__Quick_Quotes__c where createddate >= :startDate and createddate < :enddate 
		and genesis__Status__c = 'CREDIT APPROVED'];
		a.approved__c = qList.size();
		
		a.approved_amount__c = 0;
		for (genesis__Quick_Quotes__c q:qList){
			if (q.Approved_Credit_Amount__c != null)
				a.approved_amount__c += q.Approved_Credit_Amount__c;
		}


		/*Booked and Funded */
		List<cllease__Lease_Account__c> lList = new List<cllease__Lease_Account__c>();
		lList = [select Booking_Date__c
					,cllease__Financed_Amount__c
					,cllease__Total_Dealer_Charges__c
					,cllease__Delinquent_Amount__c
					,cllease__Amount_to_Current__c
				from cllease__Lease_Account__c
				where booking_Date__c >= :startDate and createdDate < :enddate
				];

	 	a.booked__c = lList.size();
		a.net_investment__c = llist.size();
		a.funding__c = lList.size();
		a.booked_amount__c = 0;
		a.funding_amount__c = 0;
		a.net_investment_amount__c = 0;

		for (cllease__Lease_Account__c l:lList){
			if (l.cllease__Financed_Amount__c != null)
				a.booked_amount__c += l.cllease__Financed_Amount__c;
			if (l.cllease__Total_Dealer_Charges__c != null)
				a.funding_amount__c += l.cllease__Total_Dealer_Charges__c;
			if (l.cllease__Amount_to_Current__c != null)
				a.net_investment_amount__c += l.cllease__Amount_to_Current__c;
		}


		/*Delinquent */
		lList = [select cllease__Delinquent_Amount__c
				from cllease__Lease_Account__c
				where booking_Date__c >= :startDate and createdDate < :enddate
				and 	cllease__Lease_Status__c like '%Bad Standing%'
				];
		a.delinquency__c = lList.size();
		a.delinquency_amount__c = 0;

		for (cllease__Lease_Account__c l:lList){
			if (l.cllease__Delinquent_Amount__c != null)
				a.delinquency_amount__c += l.cllease__Delinquent_Amount__c;
		}

		


		update a;	

    }
     
    /*********************************************************************************************
  	*	FINISH
  	*
  	*
  	************************************************************************************************/
    global void finish(Database.BatchableContext c) {
    }
  
}