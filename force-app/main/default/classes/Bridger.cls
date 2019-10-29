/**************************************************************************************************************
*
*  Bridger Class - this class simplifies calls to bridger
*
*  log:
*
* 	6/25/18 - MRM Created Class 
    5/9/2019 - MRM Added force change password feature so i can see it change....expirations were occurning
*
****************************************************************************************************************/
public with sharing class Bridger {
	
    /************************************************************************************************************
    * Bridger Search Input
    ************************************************************************************************************/
 	public class bridgerInput{

		public string requestType;  //Individual or Business
		/* business */
 		public string street1;
 		public string street2;
 		public string city;
 		public string stateprovincedistrict;
 		public string postalcode;
 		public string addresstype;
 		public string county;
 		public string ein; 
 		public string fullname;
 		
 		/* individual */
 		public string first;
		public string middle;
 		public string last;
 		public string title;
 	}
 	/************************************************************************************************************
    * Bridger Search Result
    ************************************************************************************************************/
 	public class bridgerResult{

		public string result;   
 		public boolean hit;
 		
 	}     
 	/************************************************************************************************************
    * Maintain Bridger Password
    ************************************************************************************************************/
    public static void maintainPassword(){
    	 
    	Bridger_Setting__c bridgerSettings = [
 		
 			Select b.User_Id__c
			, b.Predefined_Search_Name__c
			, b.Password__c
			, b.Notification_Type__c
			, b.Notification_Role__c
			, b.End_Point__c
			, b.Division__c
			, b.Client_Id__c 
			, b.account_endpoint__c
			, b.force_password_change__c
			From Bridger_Setting__c b
			limit 1
		
			];
		
    	XgServicesAccount.BasicHttpBinding_IAccount  AccountClient = new XgServicesAccount.BasicHttpBinding_IAccount();

		AccountClient.endpoint_x = bridgerSettings.account_endpoint__c;

		XgServicesAccount.ClientContext Context = new XgServicesAccount.ClientContext();
		Context.ClientID = bridgerSettings.client_id__c;
		Context.UserID = bridgerSettings.user_id__c;
		Context.Password = bridgerSettings.password__c;

		//Boolean result = AccountClient.changePassword(Context,'Welcome01!');
		//system.debug(result);

		//Context.Password = 'Welcome01!'; 
		
		integer daysUntilExpiration = 4;
		
		if (!Test.isRunningTest())
			daysUntilExpiration =AccountClient.GetDaysUntilPasswordExpires(Context);
		
		system.debug('Days to Expiration = ' + daysUntilExpiration);
		system.debug(daysUntilExpiration);
		system.debug('pass is:' + bridgerSettings.password__c);
		
		if (daysUntilExpiration < 5 || bridgerSettings.force_password_change__c == true){  //NewCo2018!
			String part1 = 'NewCo';
			Integer sequence = integer.valueOf(bridgerSettings.password__c.mid(5,4));
			sequence ++;
			String part2 = '!';
			String newPassword = part1 + sequence + part2;
		
			system.debug('New Password = ' + newPassword);
			 
			Boolean result;
			
			if (!Test.isRunningTest())
				result = AccountClient.changePassword(Context,newPassword);
				
			bridgerSettings.password__c = newPassword;
			update bridgerSettings;
			system.debug('password chagned to:' + newPassword);
		} 
		else{
			system.debug('no password change required');
		}
    	 
    }
    
    /************************************************************************************************************
    * Bridger Search
    ************************************************************************************************************/
    public static bridgerResult bridgerSearch(Bridger.bridgerInput input, Boolean pep){
    	
    	bridger.bridgerResult result = new bridger.bridgerResult();
    	 
    	boolean hit; 
     
		Bridger_Setting__c bridgerSettings = [
 		
 			Select b.User_Id__c
			, b.Predefined_Search_Name__c
			, b.Predefined_Search_Name_pep__c
			, b.Password__c
			, b.Notification_Type__c
			, b.Notification_Role__c
			, b.End_Point__c
			, b.Division__c
			, b.Client_Id__c 
			
			From Bridger_Setting__c b
			limit 1
		
			];
		
    	XgServicesSearch.BasicHttpBinding_ISearch SearchClient = new XgServicesSearch.BasicHttpBinding_ISearch();
		SearchClient.endpoint_x = bridgerSettings.end_point__c; 
		SearchClient.timeout_x = 120000;
		XgServicesSearch.ClientContext Context = new XgServicesSearch.ClientContext();
		Context.ClientID = bridgerSettings.client_id__c; 
		//Context.UserID = 'mmoser01'; 
		//Context.Password = 'Welcome02!'; 
		Context.UserID = bridgerSettings.user_id__c;
		Context.Password = bridgerSettings.password__c;

		//Config Section

		XgServicesSearch.SearchConfiguration Config = new XgServicesSearch.SearchConfiguration();

		if (pep)
			Config.PredefinedSearchName = bridgerSettings.predefined_search_name_pep__c;
		else
			Config.PredefinedSearchName = bridgerSettings.predefined_search_name__c;
		Config.WriteResultsToDatabase =true;

		//Assignment
		//Set the alert assignment.

		Config.AssignResultTo = new XgServicesSearch.AssignmentInfo();
		Config.AssignResultTo.division = bridgerSettings.division__c;
		Config.AssignResultTo.emailNotification = true;
		Config.AssignResultTo.RolesOrUsers = new XgServicesSearch.ArrayOfString();
		Config.AssignResultTo.RolesOrUsers.string_x = new List<String>();
		Config.AssignResultTo.Type_x = bridgerSettings.notification_type__c;
		Config.AssignResultTo.RolesOrUsers.string_x.add(bridgerSettings.notification_role__c);
		//Config.AssignResultTo.Type_x = 'User';
		//Config.AssignResultTo.RolesOrUsers.string_x.add('mmoser01');
		//system.debug('**** assignment info ' + Config.AssignResultTo);

		XgServicesSearch.SearchResults results;
		
		if (input.requestType == 'Business'){
			XgServicesSearch.inputAddress inputAddress = new XgServicesSearch.inputAddress();	
			inputAddress.street1 = input.street1;
			inputAddress.street1 = input.street2;
			inputAddress.city = input.city;   //'San Mateo';
			inputAddress.stateprovincedistrict = input.stateprovincedistrict;
			inputAddress.postalcode = input.postalcode;
			inputAddress.type_x = input.addresstype;
			inputAddress.county = input.county;

			XgServicesSearch.ArrayOfinputAddress aInputAddress = new XgServicesSearch.ArrayOfInputAddress();
			ainputAddress.inputaddress =  new List<XgServicesSearch.InputAddress>();
			ainputAddress.inputaddress.add(inputAddress);
		 
			//Entity
			XgServicesSearch.InputEntity e = new XgServicesSearch.InputEntity();
			e.EntityType = input.requestType;
			e.Name = new XgServicesSearch.InputName();
			e.Name.Full = input.fullname;
			e.addresses = new XgServicesSearch.ArrayOfinputAddress();
			e.addresses = ainputAddress;
	    	e.IDS = new XgServicesSearch.ArrayOfInputId();
	   
	    	XgServicesSearch.ArrayOfInputId inputEin = new XgServicesSearch.ArrayOfInputId();
	    	inputEin.inputId = new List<XgServicesSearch.InputID>();
	    	XgServicesSearch.inputID sid = new XgServicesSearch.inputID();
	   	 	sid.type_x = 'EIN';
	    	sid.number_x =input.ein;
	    	inputEin.inputId.add(sid);
	    	e.IDS.inputId = inputEin.inputId;
	    
	    	//array of input records

			XgServicesSearch.ArrayOfInputRecord aRecords = new XgServicesSearch.ArrayOfInputRecord();

			List<XgServicesSearch.InputRecord> rList = new List<XgServicesSearch.InputRecord>();

			//new input record

			XgServicesSearch.InputRecord inputRecord = new XgServicesSearch.InputRecord();	
			InputRecord.Entity = e;
			
			//Add Record 
			rList.add(inputRecord);
			aRecords.InputRecord = rList;
		
			//SearchInput
		
			XgServicesSearch.SearchInput searchInput = new XgServicesSearch.SearchInput();
			SearchInput.blockID = '1';
			SearchInput.records =aRecords;
			if (!Test.isRunningTest())
				results = SearchClient.Search_x(Context, Config, SearchInput);
    	}
    	else{
    		if (input.requestType == 'Individual'){
    			XGServicesSearch.InputName inputB = new XgServicesSearch.InputName();
    			inputB.first = input.first;
    			inputB.last = input.last;
    			inputB.middle = input.middle;
    			inputB.title = input.title;
    			
    			XgServicesSearch.InputEntity e = new XgServicesSearch.InputEntity();
				e.EntityType = input.requestType;
				e.name = inputB;
				
				XgServicesSearch.ArrayOfInputRecord aRecords = new XgServicesSearch.ArrayOfInputRecord();

				List<XgServicesSearch.InputRecord> rList = new List<XgServicesSearch.InputRecord>();

				//new input record

				XgServicesSearch.InputRecord inputRecord = new XgServicesSearch.InputRecord();	
				InputRecord.Entity = e;
				
				//Add Record 
				rList.add(inputRecord);
				aRecords.InputRecord = rList;
		
				//SearchInput
    			XgServicesSearch.SearchInput searchInput = new XgServicesSearch.SearchInput();
				SearchInput.blockID = '1';
				SearchInput.records =aRecords;
				
				if (!Test.isRunningTest())
					results = SearchClient.Search_x(Context, Config, SearchInput);
					system.debug('Individual Results:' + results);
    		}
    	} 
    	  
		XgServicesSearch.ArrayOfResultRecord resultList = new XgServicesSearch.ArrayOfResultRecord();

		//system.debug(XgServicesSearch.ArrayOfEntityMatchInfo.EntityMatchInfo); 

		system.debug('Results = ' + results);

		if (!Test.isRunningTest()){
			resultList = results.records;
		 
			if (resultList  != null){
				hit = true;		
				system.debug('*** HIT ***');
				system.debug(resultList);
				system.debug(resultList.resultRecord[0].recordDetails);
				system.debug(resultList.resultRecord[0].record);
				system.debug(resultList.resultRecord[0].watchList);
				system.debug('Result id = ' + resultList.resultRecord[0].resultId);
				result.result = string.valueOf(resultList.resultRecord[0].resultId);
				integer a = resultList.resultRecord.size();
				system.debug(a);
			}
			else{
				hit = false;
		 		system.debug('*** CLEAR ***');
		 		result.result = 'Clear';
			}
			result.hit = hit;
		} 
		return result;
	}

}