/*********************************************************************************************
*	This batch populates the SAI inteface tables
*    
*   To test:
*			id batchinstanceid = database.executeBatch(new BatchSAIGeneration(),100); 
*
* ChangeLog:
*
*	9/6/19 - MRM Created Class
*   3/4/2020 - MRM Revisions from feedback 
*
************************************************************************************************/
global class BatchSAIGeneration implements Database.Batchable<SObject>,Database.Stateful{
    /*********************************************************************************************
  	*	QUERY - Get all the applications  
  	* 
  	************************************************************************************************/
    static final string QUERY = 'SELECT genesis__Account__r.Account_Number__c, genesis__Application__r.lease_number__r.cllease__Lease_Status__c, dealer__r.primary_address__r.state__c,dealer__r.Account_Number__c, dealer__r.name, Approved_Credit_Amount__c,ATS_Reference_Number__c,Billing_Address__c,Business_Contacts__c,CL_Product__c,County__c,CreatedById,CreatedDate,Credit_Approval_Date__c,Credit_Approval_Expiration_Date__c,Credit_Approval__c,Days_Convention__c,Dealer_Name__c,Dealer__c,Email_Address__c,Equipment_Description__c,Estimated_Financed_Amount__c,Estimated_Monthly_Payment__c,Est_Financed_Amt__c,genesis__Account__c,genesis__Additional_cash_required__c,genesis__Address_Line_1__c,genesis__Application__c,genesis__Business_Name__c,genesis__Cap_Reduction__c,genesis__Cash_Collected_By_Dealer__c,genesis__City__c,genesis__CL_Company__c,genesis__CL_Product__c,genesis__Collateral_Value__c,genesis__Company__c,genesis__Contact__c,genesis__Country__c,genesis__Customer_cash_available__c,genesis__Customer_Cash_Used_For__c,genesis__Documentation_charges__c,genesis__Down_Payment__c,genesis__Estimated_Selling_Price__c,genesis__Expected_Start_Date__c,genesis__Fees_Amount__c,genesis__Financed_Amount__c,genesis__First_Name__c,genesis__Last_Name__c,genesis__Lending_Product__c,genesis__Minimum_cash_Required__c,genesis__Next_Step__c,genesis__No_Of_Payments_Required_Upfront__c,genesis__Number_of_Pieces_of_Equipment__c,genesis__Other_Financed_Fees__c,genesis__Payment_Amount__c,genesis__Payment_Frequency__c,genesis__Postal_Code__c,genesis__Pricing_Method__c,genesis__Product_Type__c,genesis__Selected_Pricing_Option_Id__c,genesis__Social_Security_Number__c,genesis__Source__c,genesis__State__c,genesis__Status__c,genesis__Tax_Amount__c,genesis__Terms_Selected__c,genesis__Total_Cash_Due_from_Customer__c,genesis__Total_Customer_Cash_Required__c,genesis__Total_Dealer_Payable__c,genesis__Total_Dealer_Price__c,genesis__Total_Upfront_Payments__c,genesis__Valid_Pricing_Flag__c,genesis__Warranty_Amount__c,Id,IsDeleted,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Legal_Entity__c,Name,Oracle_Trade_up_Lease_Number__c,Oracle_Trade_Up_Quote_Amount__c,Oracle_Trade_up_Quote_Expiration_Date__c,Oracle_Trade_up_Quote_Number__c,OwnerId,Primary_Phone_number__c,Quick_Quote_Number__c,Sales_Division__c,Status_Text__c,SystemModstamp,Time_Trigger_05__c,Validation_Status__c,Validation_Time_Stamp__c,View_Record__c,With_Account__c FROM genesis__Quick_Quotes__c where genesis__Status__c != ' + '\'' + 'ENTERED' + '\'';
    datetime startTime = datetime.now();
    static final String SOURCESYSTEM = 'CLND';
	
    /*********************************************************************************************
  	*	START
  	*
  	************************************************************************************************/				
    global Database.QueryLocator start(Database.BatchableContext c) {    
        
		List<SAI_Application__c> appList = new List<SAI_Application__c>();
        List<SAI_Application_Agreement__c> appAgreementList = new List<SAI_Application_Agreement__c> ();
        List<SAI_Application_Feature__c> appFeatureList = new  List<SAI_Application_Feature__c>();
        List<SAI_Application_Party__c> appPartyList = new List<SAI_Application_Party__c>();
        List<SAI_Application_Classification__c> appSSList = new List<SAI_Application_Classification__c>();
        List<SAI_Delivery_Control__c> appDCList = new List<SAI_Delivery_Control__c> ();
        List<SAI_File_Control__c> appFCList = new  List<SAI_File_Control__c> ();
        List<SAI_Party__c> partyList = new List<SAI_Party__c>();
        List<SAI_Party_Street_Address__c> partysaList = new List<SAI_Party_Street_Address__c>();
        List<SAI_Application_Asset__c> appass = new List<SAI_Application_Asset__c>();
    
		appList= [select id from SAI_Application__c ];
		appAgreementList = [select id from SAI_Application_Agreement__c]; 
        appFeatureList = [select id from SAI_Application_Feature__c];
        appPartyList = [select id from SAI_Application_Party__c];
        appSSList = [select id from SAI_Application_Classification__c];
        appDCList = [select id from SAI_Delivery_Control__c];
        appFCList = [select id from SAI_File_Control__c];
        partyList = [select id from SAI_Party__c];
        appass = [select id from SAI_Application_Asset__c];
        partysaList = [select id from SAI_Party_Street_Address__c];
        delete appList;
		delete appAgreementList;
        delete appFeatureList;
        delete appPartyList;
        delete appSSList;
        delete appDCList;
        delete appFCList;
        delete partyList;
        delete appass;
        delete partysalist;

        if (!Test.isRunningTest())
            return Database.getQueryLocator(QUERY + ' order by name');
        else {
            return Database.getqueryLocator(QUERY + ' Limit 1');
        }     
    }
  	/*********************************************************************************************
  	*	EXECUTE
  	*
  	*
  	************************************************************************************************/
    global void execute(Database.BatchableContext c, List<genesis__quick_quotes__c> scope) {
        
        Set<ID> appSet = new Set<ID>();
         system.debug('query is: ' + query + 'scope size is:' + scope.size());

        for (genesis__quick_quotes__c s:scope)
            if (s.genesis__Application__c != null)
                appSet.add(s.genesis__Application__c);

        List<genesis__Applications__c> appList = [SELECT Allowable_Soft_Cost__c
                                , dealer__r.name
                                ,  dealer__r.account_number__c
                                , lease_number__r.name
                                , lease_number__r.cost_of_funds__c
                                , lease_number__r.cllease__Residual_Amount__c
                                , lease_number__r.booking_date__c
                                , genesis__Account__r.name
                                , dealer__r.primary_address__r.state__c
                                , genesis__Account__r.Account_Number__c
                                , Application_Fee__c
                                ,Billing_Address1__c
                                ,Billing_Email_Address__c
                                ,Booking_Date__c
                                ,Capitalize_UpFront_Tax__c
                                ,Contract_Signer_Last_Name__c
                                ,Contract_Signer_Title__c
                                ,Contract_Signer__c
                                ,Contract_Type__c
                                ,CreatedById
                                ,CreatedDate
                                ,Customer_Provided_Insurance__c
                                ,Custom_Finance_Charge_Grace_Days__c
                                ,Custom_Late_Charge_Grace_Days__c
                                ,Dealer_Invoice_Date__c
                                ,Dealer_Invoice_Number__c
                                ,Dealer_Invoice__c
                                ,Dealer_Name__c
                                ,Dealer_Program__c
                                ,Dealer__c
                                ,DLL_Reference_Number__c
                                ,Duplicate_Dealer_Invoice_Number__c
                                ,EIN_Number__c
                                ,Equipment_Install_Date__c
                                ,Equipment__c
                                ,Fee_Set_Lease__c
                                ,fee_set_temp__c
                                ,Fee_Set__c,genesis__Account__c
                                ,genesis__Action__c
                                ,genesis__Additional_Cash_Required__c
                                ,genesis__Amortization_Term__c
                                ,genesis__APR__c,genesis__Arrears__c
                                ,genesis__Asset_Class__c
                                ,genesis__Asset_Liability_Info__c
                                ,genesis__Assigned_To__c,genesis__Auto_Decisioning__c,genesis__Balloon_Payment__c,genesis__Bank_Account_Number__c,genesis__Bank_Account_Type__c,genesis__Bank_Name__c,genesis__Bank_Transactions_Fetched__c,genesis__Calculation_Action__c,genesis__Call_Code__c,genesis__Cap_Reduction__c,genesis__Cash_Collected_By_Dealer__c,genesis__Charge_offs__c,genesis__Class_Code__c,genesis__CL_Company__c,genesis__CL_Product_Name__c,genesis__CL_Product__c,genesis__CL_Purpose__c,genesis__Collateral_Type__c,genesis__Collateral_Value__c,genesis__Company__c,genesis__Contact__c,genesis__Credit_Limit__c,genesis__Credit_Rating__c,genesis__Customer_Cash_Available__c,genesis__Customer_Cash_Used_For__c,genesis__Days_Convention__c,genesis__Dealer_Payment_Date__c,genesis__Description__c,genesis__Disbursement_Date__c,genesis__Discount_Rate_Based_On__c,genesis__Discount_Rate__c,genesis__Documentation_Charges__c,genesis__Down_Payment__c,genesis__Draw_Period_End_Date__c,genesis__Draw_Term__c,genesis__Due_Day__c,genesis__Employee_Loan__c,genesis__Estimated_Selling_Price__c,genesis__Expected_Close_Date__c,genesis__Expected_First_Payment_Date__c,genesis__Expected_Second_Pay_Day_Date__c,genesis__Expected_Start_Date__c,genesis__Fees_Amount__c,genesis__Financed_Amount__c,genesis__Funding_in_Tranches__c,genesis__Gross_Annual_Income__c,genesis__Healthcare_Procedure__c,genesis__ID_Number__c,genesis__ID_State__c,genesis__ID_Type__c,genesis__Initial_Advance__c,genesis__Interest_Calculation_Method__c,genesis__Interest_Compounding_Frequency__c,genesis__Interest_Only_Period__c,genesis__Interest_Rate__c,genesis__Is_Get_Yield_Enabled__c,genesis__Is_over_21__c,genesis__Landing_Sequence__c,genesis__Lending_Product__c,genesis__Loan_Amount__c,genesis__Loan_Number__c,genesis__LTV_Pledged_Collateral__c,genesis__Margin__c,genesis__Maturity_Date__c,genesis__Maximum_Loan_Amount_DTI__c,genesis__Minimum_Cash_Required__c,genesis__Monthly_Debt_Payments__c,genesis__Monthly_Income_Expense_Info__c,genesis__Net_Present_Value__c,genesis__No_Of_Payments_Required_Upfront__c,genesis__Number_of_Pieces_of_Equipment__c,genesis__Other_Financed_fees__c,genesis__Overall_Status__c,genesis__Parent_Application__c,genesis__Participation_Date__c,genesis__Payable_To_Dealer__c,genesis__Payment_Amount_Step_Up_Type__c,genesis__Payment_Amount__c,genesis__Payment_Due_Date__c,genesis__Payment_Frequency_Multiplier__c,genesis__Payment_Frequency__c,genesis__Portfolio__c,genesis__Prepaid_Interest_Option__c,genesis__Prepayment_Penalty_Description__c,genesis__Prepayment_Penalty__c,genesis__Pricing_Method__c,genesis__Primary_Collateral_Code__c,genesis__Primary_Property_Address__c,genesis__Primary_Source_of_Repayment__c,genesis__Probability__c,genesis__Product_Sub_Type__c,genesis__Product_Type__c,genesis__Quick_Quote__c,genesis__Rate_Ceiling__c,genesis__Rate_Discount__c,genesis__Rate_Floor__c,genesis__Regulation_O__c,genesis__Repayment_Procedure__c,genesis__Required_Customer_Cash__c,genesis__Residual_Amount__c,genesis__Retained_Amount__c,genesis__Routing_Number__c,genesis__Sales_Division__c,genesis__Secondary_Source_of_Repayment__c,genesis__Spread__c,genesis__Status__c,genesis__SubLimit_Total__c,genesis__Sublimit_Variance__c,genesis__Subvention_Amount__c,genesis__Subvention_Percent__c,genesis__Tax_Amount__c,genesis__Terms_Selected__c,genesis__Term__c,genesis__Total_Cash_Due_from_Customer__c,genesis__Total_Dealer_Payable__c,genesis__Total_Dealer_Price__c,genesis__Total_Estimated_Interest__c,genesis__Total_Facilities__c,genesis__Total_Facility_Amount__c,genesis__Total_Facility_Variance__c,genesis__Total_Fee_Amount__c,genesis__Total_Pledged_Collateral_Amount__c,genesis__Total_Score__c,genesis__Total_Upfront_Payments__c,genesis__Valid_Pricing_Flag__c,genesis__Warranty_Amount__c,genesis__Yield__c,Id,Insurance_Certificate__c,Invoice_Date__c,Invoice_Number__c,IsDeleted,KYC_Cleared__c,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Lease_Document_Trigger_Formula__c,Lease_Document_Trigger__c,Lease_Number__c,Lease_Product_Name__c,Lease_Type__c,Name,Net_Dealer_Funding__c,Net_Trade_Up_Amount__c,No_of_Equipments__c,Oracle_Trade_Up_Amount__c,Oracle_Trade_up_Lease_Number__c,Oracle_Trade_up_Quote_Expiration_Date__c,Oracle_Trade_up_Quote_Number__c,OwnerId,Payment_Method__c,Payment_Term__c,PO_Number__c,Pricing_Details__c,Pricing_Rate_Factor__c,Product_Name__c,Purchase_Option__c,Purchase_Order__c,Rate_Card_Selection__c,Rate_Factor__c,RecordTypeId,Rent_Amount__c,Roll_Over_Quote_Number__c,Selected_Pricing_Count__c,Service_Fee__c,Signed_D_A__c,Signed_Lease_Agreement__c,Start_Date__c,SystemModstamp,Tax_Exempt_Certificate__c,Tax_Exempt__c,Total_Application_Fee_Amount__c,Total_Equipment_Selling_Price__c,Total_Estimated_Property_Tax__c,Total_Insurance_Fees__c,Total_Lease_Payment__c,Total_Service_Fees__c,Total_Upfront_Tax_Amount__c,Trade_Up_Quote__c,Transaction_Code__c,View_Record__c 
                                ,(SELECT Asset_ID__c,Asset_Life_in_Months__c,Asset_Type_ID__c,Asset_Type_Name__c,City__c,CreatedById,CreatedDate,Dealer_Charges1__c,Dealer_Invoice_Date__c,Dealer_Invoice_Number__c,Description__c,Equip_ID__c,genesis__Application__c,genesis__Copy_data_to_VehicleValuation__c,genesis__Dealer_Fees__c,genesis__Equipment__c,genesis__Estimated_Selling_Price__c,genesis__Finance_Advance_Adjusted__c,genesis__Finance_Advance_Base__c,genesis__Finance_Advance_Mileage_Adjustment__c,genesis__Other_Financed_Fees__c,genesis__Residual_Value__c,genesis__Retail_Average_Adjusted_Amount__c,genesis__Retail_Average_Base_Amount__c,genesis__Retail_Average_Mileage_Adjustment__c,genesis__Select_Souce__c,genesis__Tax_Amount__c,genesis__Total_Dealer_Charges__c,genesis__Vehicle_Valuation__c,genesis__Warranty_Amount__c,genesis__Wholesale_Average_Adjusted_Amount__c,genesis__Wholesale_Average_Base_Amount__c,genesis__Wholesale_Average_Mileage_Adjustment__c,genesis__Wholesale_Rough_Adjusted_Amount__c,genesis__Wholesale_Rough_Base_Amount__c,genesis__Wholesale_Rough_Mileage_Adjustment__c,Id,Installation_Date__c,Install_Account__c,Install_Address1__c,Install_Address__c,Install_City__c,Install_Date_Max__c,Install_Location__c,Install_State__c,Install_Zip_Code__c,IsDeleted,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Make__c,Manufacturer1__c,Manufacturer__c,Master_Asset_Type_ID__c,Master_Asset_Type__c,Model1__c,Model_Number__c,MSRP__c,Name,Object_Category_ID__c,Object_Category_Name__c,Oracle_Trade_Up_Amount__c,Override_Upfront_Tax_Flag__c,Product_Type1__c,Quantity__c,Residual_Amount__c,Salvage_Value1__c,Serial_Number__c,Soft_Costs__c,State__c,SystemModstamp,Tax_Exempt__c,Tax_Payment_Type__c,Upfront_Tax_Amount__c,Upfront_Tax_Basis__c,Upfront_Tax_Processed__c,Vertex_State__c,Zipcode__c 
                                  FROM genesis__Application_Equipments__r
                                 )
                                FROM genesis__Applications__c
                                where id in :appSet];

        Map<ID,genesis__Applications__c> appMap = new Map<ID,genesis__Applications__c>();

        for (genesis__Applications__c a:appList){
            appMap.put(a.id,a);
        }                                 
        List<SAI_Application__c> SAIappList = new List<SAI_Application__c>();
        List<SAI_Application_Agreement__c> appAgreementList = new List<SAI_Application_Agreement__c> ();
        List<SAI_Application_Feature__c> appFeatureList = new  List<SAI_Application_Feature__c>();
        List<SAI_Application_Party__c> appPartyList = new List<SAI_Application_Party__c>();
        List<SAI_Application_Classification__c> appSSList = new List<SAI_Application_Classification__c>();
        List<SAI_Delivery_Control__c> appDCList = new List<SAI_Delivery_Control__c> ();
        List<SAI_File_Control__c> appFCList = new  List<SAI_File_Control__c> ();
        List<SAI_Party__c> partyList = new List<SAI_Party__c>();
        List<SAI_Application_Asset__c> aaLIst = new List<SAI_Application_Asset__c>();

        String status = '';
        String detailStatus = '';

        /*
        QUOTE
        SUBMITTED
        APPROVED
        TERMINATED (if credit declined and qt sumbit date is > 90 days OR qt with a lease and lease terminated)
        APPEAL
        ACTIVATED (if qt associated with an lease in '*active*' status)

        */
        //detail status code
        /*
        QUOTE - n/a
        SUBMITTED - n/a
        CREDIT-D - if CREDIT DECLINED
        CREDIT-A - if CREDIT APPROVED
        NOTIFIED - n/a
        CANCELLED - n/a
        WITHDRAWN - if approval is > 90 days and APPROVED and no lease
        EXPIRED - n/a
        DECLINED - n/a
        APPEAL - n/a
        ACTIVATED - if CONVERTED
        */

       
        boolean leaseTerminated;

        for (genesis__quick_quotes__c q:scope){
            leaseTerminated = false;
            status = '';
            detailStatus = '';
            
            genesis__Applications__c a = appMap.get(q.genesis__Application__c);
            if (q.genesis__Status__c == 'NEW' || q.genesis__status__c == 'CREDIT SUBMITTED'){
                status = 'SUBMITTED';
                detailStatus = 'SUBMITTED';
            }
            else 
            if (q.genesis__Status__c == 'CONVERTED TO APPLICATION'){
                status = 'APPROVED';
                //MRM 3/4/2020
                if (q.genesis__Application__r.lease_number__c == null)
                    detailStatus = 'APPROVED';
                else {
                    detailStatus = 'ACTIVATED';
                }
                if (q.Credit_Approval_Expiration_Date__c < date.today() && q.genesis__Application__r.lease_number__c == null)
                    detailStatus = 'WITHDRAWN';
            }
            else 
            if (q.genesis__Status__c == 'CREDIT APPROVED'){
                status = 'APPROVED';
                detailStatus = 'CREDIT-A';
                if (q.Credit_Approval_Expiration_Date__c < date.today() && q.genesis__Application__r.lease_number__c == null)
                    detailStatus = 'WITHDRAWN';
            }
            else
            if (q.genesis__Status__c == 'CREDIT DECLINED'){
                status = 'TERMINATED';
                detailStatus = 'CREDIT-D';
            }
            else
            if (q.genesis__Status__c == 'CREDIT REFERRED'){
                status = 'SUBMITTED';
                 detailStatus = 'SUBMITTED';
            }
            
            /*mrm 11/1 - feedback */
            if (q.genesis__Application__r.lease_number__c != null)
                if (q.genesis__Application__r.lease_number__r.cllease__Lease_Status__c.contains('CANCEL') ) {
                    status = 'TERMINATED';
                    detailStatus = 'CANCELLED';
                    leaseTerminated = true;            
                }

            SAI_Application__c app;

            if (a != null){
                
                if (a.genesis__Status__c  == 'CONVERTED TO CONTRACT' || a.genesis__Status__c  == 'APPROVED'  ){
                    status = 'ACTIVATED';
                }
                    
                Date activatedDate;

                if (a.genesis__Status__c  == 'TERMINATED')
                    activatedDate = null;
                
                
                app = new SAI_Application__c(
                                                agreement_Original_duration__c = a.genesis__Term__c
                                            );       
            }
            else {
                app = new SAI_Application__c();
            }
            
           

            app.net_principal_amount__c = q.Approved_Credit_Amount__c;
               
            if (q.genesis__Application__c != null)
                if (q.genesis__Application__r.lease_number__c != null)
                    if (q.genesis__Application__r.lease_number__r.cllease__Lease_Status__c.contains('ACTIVE')){
                        app.cost_of_funds_percentage__c = a.lease_number__r.cost_of_funds__c;
                        app.base_payment_amount__c = a.genesis__Payment_Amount__c.setScale(2);
                    }
            app.seasonality_indicator__c = '0';
            app.application_Internal_status_detail_date__c = date.valueOf(q.LastModifiedDate);
            
            /* changed on 11/1 based on feedback*/
            //app.application_registration_date__c =date.valueOf(q.Credit_Approval_Date__c);
            app.application_registration_date__c =date.valueOf(q.CreatedDate); 

            app.Leading_Application_Indicator__c = '1';
            
            if (a != null){
                if (a.rate_factor__c != null)
                    app.agreement_rate_percentage__c = a.Rate_Factor__c;
                else
                    app.agreement_rate_percentage__c = decimal.valueOf(system.label.default_rate);
            }
            else {
                 app.agreement_rate_percentage__c = decimal.valueOf(system.label.default_rate);   
            }

            if (app.agreement_Original_duration__c == null)
                app.agreement_Original_duration__c = 60; 
 
            if (leaseTerminated || status == 'TERMINATED'){
                app.agreement_rate_percentage__c = null;
                app.agreement_Original_duration__c = null;
                app.base_payment_amount__c = null;
            }
           



            app.Application_Internal_Status_Detail_Code__c = detailStatus;
            app.Application_Internal_Status_Date__c = date.valueOf(q.LastModifiedDate);
            app.Application_Number__c = q.name;
            app.system_selling_party_number__c = q.dealer__r.Account_Number__c;
            app.system_selling_party_description__c = q.dealer__r.name;
            app.application_entry_system_code__c = SOURCESYSTEM;
            app.application_source_system__c = SOURCESYSTEM;
            app.System_program_number__c = 'Newco';
            app.system_program_description__c = 'Newco';
            app.currency_code__c = 'USD';
            app.application_Internal_Status_Code__c = status;
            app.application_raised_code__c = 'E';
            app.hyperion_base_entity__c = 'BEQUS';
            app.fee_for_service_indicator__c = '0';
            app.payment_method_code__c = 'D';
            app.payment_frequency_code__c = 'M';
                                                          

            if (a != null){
                if (a.lease_number__r.booking_date__c != null){
                    app.agreement_activation_date__c =  a.lease_number__r.booking_date__c; 
                    app.agreement_end_date__c = a.lease_number__r.booking_date__c.addMonths(integer.valueOf(a.genesis__Term__c)); 
                    app.agreement_start_date__c =  a.Equipment_Install_Date__c;

                    if (a.genesis__Payment_Amount__c != null &&  a.genesis__Term__c   != null){
                        if (q.genesis__Application__r.lease_number__r.cllease__Lease_Status__c.contains('ACTIVE')){
                            app.gross_principal_amount__c = ((a.genesis__Payment_Amount__c *  a.genesis__Term__c) + a.Lease_Number__r.cllease__Residual_Amount__c).setScale(2);
                            app.net_principal_amount__c = a.genesis__Financed_Amount__c.setScale(2);
                        }
                         
                    }
                } 
                if (a.lease_number__c != null){
                    SAI_Application_Agreement__c ag = new SAI_Application_Agreement__c(application_source_system__c = SOURCESYSTEM
                                                                                ,application_number__c = q.name
                                                                                ,agreement_Source_system__c = 'CLCMUS'
                                                                                ,agreement_number__c = a.lease_number__r.name
                    );
                    appAgreementList.add(ag);


                }

                for (genesis__Application_Equipment__c eq:a.genesis__Application_Equipments__r){ 
                    SAI_Application_Asset__c aa = new SAI_Application_Asset__c( Application_Number__c = q.name
                                                                               ,Application_Source_System__c = SOURCESYSTEM
                                                                               ,Application_Asset_Source_System__c = SOURCESYSTEM
                                                                               ,Application_Asset_Number__c = eq.name
                                                                               ,Asset_Type__c =eq.asset_type_id__c 
                                                                               ,Dealer_Subsidy_Amount__c = null
                                                                               ,External_Reference_Asset__c = null 
                                                                               ,Global_Master_Asset_Type__c =  'Office Equipment'
                                                                               ,Global_Master_Asset_Type_Code__c = '107'
                                                                               ,Grace_Period__c = null
                                                                               ,Make__c = eq.Manufacturer1__c
                                                                               ,Manufacturing_Year__c = null
                                                                               ,Model__c = eq.Model1__c
                                                                               ,Number_Of_Units__c = 1
                                                                               ,Object_Category__c = eq.object_category_name__c
                                                                               ,Object_Category_Number__c = eq.object_category_id__c
                                                                               ,Serial_Number__c = eq.serial_number__c
                                                                               ,Vendor_Subsidy_Amount__c = null
                                                                               ,used_indicator__c = '0');

                    if (q.genesis__Application__c != null){ 
                        if (q.genesis__Application__r.lease_number__c != null){
                            if (q.genesis__Application__r.lease_number__r.cllease__Lease_Status__c.contains('ACTIVE')){                                                                     
                                aa.Net_Principal_Amount__c = eq.genesis__Estimated_Selling_Price__c;
                            }
                        }
                        
                        if (app.residual_value_amount__c == null) 
                            app.residual_value_amount__c = 0;
                        if (eq.genesis__Residual_Value__c != null)
                            app.residual_value_amount__c = (app.residual_value_amount__c + eq.Residual_Amount__c).setScale(2);

                        if (q.genesis__Application__r.lease_number__c != null){
                            if (q.genesis__Application__r.lease_number__r.cllease__Lease_Status__c.contains('CANCEL'))
                                app.residual_value_amount__c = null;                                 
                        }
                        if (app.residual_value_amount__c == 0)
                            app.residual_value_amount__c = null;

                    }

                    aaList.add(aa);
                }
            }

            SAIappList.add(app);
           
            SAI_Application_Classification__c ss1 = new SAI_Application_Classification__c(application_source_system__c = SOURCESYSTEM
                                                                                        ,application_number__c =  q.name
                                                                                        ,Application_Classification_Type_Code__c = 'COUNTRYCD'
                                                                                        ,Application_Classification_Code__c = 'US'
                                                                                        );
            appSSList.add(ss1);

            SAI_Application_Classification__c ss2 = new SAI_Application_Classification__c(application_source_system__c = SOURCESYSTEM
                                                                                        ,application_number__c =  q.name
                                                                                        ,Application_Classification_Type_Code__c = 'APT'
                                                                                        ,Application_Classification_Code__c = 'STA'
                                                                                        );
            appSSList.add(ss2);

            SAI_Application_Classification__c ss3 = new SAI_Application_Classification__c(application_source_system__c = SOURCESYSTEM
                                                                                        ,application_number__c =  q.name
                                                                                        ,Application_Classification_Type_Code__c = 'SL'
                                                                                        ,Application_Classification_Code__c = 'PHL' //'HUB-' + q.dealer__r.primary_address__r.state__c
                                                                                        );
            appSSList.add(ss3);

             SAI_Application_Classification__c ss4 = new SAI_Application_Classification__c(application_source_system__c = SOURCESYSTEM
                                                                                        ,application_number__c =  q.name
                                                                                        ,Application_Classification_Type_Code__c = 'FPT'
                                                                                        ,Application_Classification_Code__c = 'L'
                                                                                        );
            appSSList.add(ss4);

            SAI_Application_Party__c party = new SAI_Application_Party__c(application_Source_System__c = SOURCESYSTEM
                                                                        ,application_number__c = q.name
                                                                        ,party_source_system__c = SOURCESYSTEM
                                                                        ,party_number__c = q.genesis__Account__r.Account_Number__c
                                                                        ,application_party_role_type_code__c = 'LESS'
                                                                         );
            appPartyList.add(party);

            

        }
        
        insert SAIappList;

        if (!appAgreementList.isEmpty())
            insert appAgreementList;

        insert appFeatureList;
        insert appPartyList;
        insert appSSList;
        insert aaList;
       

        
    }
     
    /*********************************************************************************************
  	*	FINISH
  	*
  	*
  	************************************************************************************************/
    global void finish(Database.BatchableContext c) {

    
        List<SAI_Application__c> appList = new List<SAI_Application__c>();
        List<SAI_Application_Agreement__c> appAgreementList = new List<SAI_Application_Agreement__c> ();
        List<SAI_Application_Feature__c> appFeatureList = new  List<SAI_Application_Feature__c>();
        List<SAI_Application_Party__c> appPartyList = new List<SAI_Application_Party__c>();
        List<SAI_Application_Classification__c> appSSList = new List<SAI_Application_Classification__c>();
        List<SAI_Delivery_Control__c> appDCList = new List<SAI_Delivery_Control__c> ();
        List<SAI_File_Control__c> appFCList = new  List<SAI_File_Control__c> ();
        List<SAI_Party__c> partyList = new List<SAI_Party__c>();
        List<SAI_Party_Street_Address__c> partysaList = new List<SAI_Party_Street_Address__c>();
        List<SAI_Application_Asset__c> aaList = new List<SAI_Application_Asset__c>();


        List<Account> accounts = [select name
                                , account_number__c
                                , primary_address__r.Address_Line_1__c
                                , primary_address__r.Address_Line_2__c
                                , primary_address__r.Address_Line_3__c
                                , primary_address__r.Address_Line_4__c
                                , primary_address__r.City__c
                                , primary_address__r.State__c
                                , primary_address__r.Country__c
                                , primary_address__r.County__c
                                , primary_address__r.zip_code__c

                                from Account
                                ];
        for (account a1:accounts){
            SAI_Party__c p = new SAI_Party__c(party_number__c = a1.account_number__c   
                                            ,party_name__c = a1.name    
                                            ,party_source_system__c = SOURCESYSTEM
                                            ,individual_indicator__c = '0'
                                            ,natural_person_indicator__c = '0'
                                             );
            partyList.add(p);  

            SAI_Party_Street_Address__c sa = new SAI_Party_Street_Address__c(Address_Line_1__c = a1.primary_address__r.Address_Line_1__c
                               ,post_code__c = a1.primary_address__r.zip_code__c
                                ,town_name__c = a1.primary_address__r.City__c
                                ,region_name__c = a1.primary_address__r.state__c
                                //3/4/2020 MRM  changed to us from usa
                                ,country_code__c = 'US'
                                ,party_source_system__c = SOURCESYSTEM
                                ,party_number__c = a1.account_number__c
                                ,party_address_type_code__c = 'ESTA'
                            );
            partysalist.add(sa);                
        }
        insert partyList;
        insert partysaList;
        
		appList= [select id from SAI_Application__c ];
		appAgreementList = [select id from SAI_Application_Agreement__c]; 
        appFeatureList = [select id from SAI_Application_Feature__c];
        appPartyList = [select id from SAI_Application_Party__c];
        appSSList = [select id from SAI_Application_Classification__c];
        appDCList = [select id from SAI_Delivery_Control__c];
        appFCList = [select id from SAI_File_Control__c];
        partyList = [select id from SAI_Party__c];
        aaList = [select id from SAI_Application_Asset__c];
        partysaList = [select id from SAI_Party_Street_Address__c];

        SAI_Delivery_Control__c dc = new SAI_Delivery_Control__c();
        dc.delivery_source_system__c = SOURCESYSTEM;

        String myDate = string.valueOf(startTime);
        myDate = myDate.replace('Z', '');
        myDate = myDate.replace('T', ' ');

        String startDate = string.valueOf(startTime);
        startDate = myDate.replace('Z', '');
        startDate = myDate.replace('T', ' ');

        datetime endTime = datetime.now();
        String endDate = string.valueOf(endTime);
        endDate = myDate.replace('Z', '');
        endDate = myDate.replace('T', ' ');

        dc.Delivery_Source_System_Extraction_DateTi__c  = myDate;
        dc.interface_version__c = '3.1';
        dc.reporting_date__C = myDate;

        cllease__Office_Name__c o;
    
        if (test.isRunningTest()){
            o = new cllease__office_name__c();
            o.cllease__Current_System_Date__c = date.today();
        }
        else{
            o = [SELECT cllease__Current_System_Date__c FROM cllease__Office_Name__c];
        }
        dateTime now = date.valueOf(o.cllease__Current_System_Date__c);
        now = now.addHours(12);
        String dayOfWeek = now.format('EEEE');

        dc.end_of_week_indicator__c = '0';

        if (dayOfWeek == 'Saturday'){
            dc.end_of_week_indicator__c = '1';
        }    
       
        if (o.cllease__Current_System_Date__c.day() == 1){
            dc.end_of_month_indicator__c = '1';
       
        }
        else{
             dc.end_of_month_indicator__c = '0';
        }

        if (dc.end_of_month_indicator__c == '1' || dc.end_of_week_indicator__c == '1')
            dc.reporting_date_end_of_day_indicator__c = '0';
        else
            dc.reporting_date_end_of_day_indicator__c = '1';
        
        appDCList.add(dc);


        insert appDCList;

        

        SAI_File_Control__c fc = new SAI_File_Control__c();
        fc.source_system__c = SOURCESYSTEM;
        fc.start_datetime_extraction__c = startDate;
        fc.end_datetime_extraction__c = endDate;
        fc.file_name__c = 'US~' + SOURCESYSTEM + '~Application~' + endTime.format('YYYY-MM-dd') + '~' +  '000000' + '.dta';
        fc.number_of_records__c = string.valueOf(appList.size());
        fc.hash_total_1__c = 0;
        fc.hash_total_2__c = 0;
        fc.hash_total_3__c = 0;
        appFCList.add(fc);

        SAI_File_Control__c fc2 = new SAI_File_Control__c();
        fc2.source_system__c = SOURCESYSTEM;
        fc2.start_datetime_extraction__c = startDate;
        fc2.end_datetime_extraction__c = endDate;
        fc2.file_name__c = 'US~' + SOURCESYSTEM + '~ApplicationAgreement~' + endTime.format('YYYY-MM-dd') + '~' +  '000000' + '.dta';
        fc2.number_of_records__c = string.valueOf(appAgreementList.size());
        fc2.hash_total_1__c = 0;
        fc2.hash_total_2__c = 0;
        fc2.hash_total_3__c = 0;
        appFCList.add(fc2);

        SAI_File_Control__c fc3 = new SAI_File_Control__c();
        fc3.source_system__c = SOURCESYSTEM;
        fc3.start_datetime_extraction__c = startDate;
        fc3.end_datetime_extraction__c = endDate;
        fc3.file_name__c = 'US~' + SOURCESYSTEM + '~ApplicationClassification~' + endTime.format('YYYY-MM-dd') + '~' +  '000000' + '.dta';
        fc3.number_of_records__c = string.valueOf(appSSList.size());
        fc3.hash_total_1__c = 0;
        fc3.hash_total_2__c = 0;
        fc3.hash_total_3__c = 0;
        appFCList.add(fc3);

        SAI_File_Control__c fc4 = new SAI_File_Control__c();
        fc4.source_system__c = SOURCESYSTEM;
        fc4.start_datetime_extraction__c = startDate;
        fc4.end_datetime_extraction__c = endDate;
        fc4.file_name__c = 'US~' + SOURCESYSTEM + '~ApplicationAssetFeature~' + endTime.format('YYYY-MM-dd') + '~' +  '000000' + '.dta';
        fc4.number_of_records__c = string.valueOf(appFeatureList.size());
        fc4.hash_total_1__c = 0;
        fc4.hash_total_2__c = 0;
        fc4.hash_total_3__c = 0;
        appFCList.add(fc4);

        SAI_File_Control__c fc5 = new SAI_File_Control__c();
        fc5.source_system__c = SOURCESYSTEM;
        fc5.start_datetime_extraction__c = startDate;
        fc5.end_datetime_extraction__c = endDate;
        fc5.file_name__c = 'US~' + SOURCESYSTEM + '~ApplicationParty~' + endTime.format('YYYY-MM-dd') + '~' +  '000000' + '.dta';
        fc5.number_of_records__c = string.valueOf(appPartyList.size());
        fc5.hash_total_1__c = 0;
        fc5.hash_total_2__c = 0;
        fc5.hash_total_3__c = 0;
        appFCList.add(fc5);

        SAI_File_Control__c fc5b = new SAI_File_Control__c();
        fc5b.source_system__c = SOURCESYSTEM;
        fc5b.start_datetime_extraction__c = startDate;
        fc5b.end_datetime_extraction__c = endDate;
        fc5b.file_name__c = 'US~' + SOURCESYSTEM + '~Party~' + endTime.format('YYYY-MM-dd') + '~' + '000000' + '.dta';
        fc5b.number_of_records__c = string.valueOf(partyList.size());
        fc5b.hash_total_1__c = 0;
        fc5b.hash_total_2__c = 0;
        fc5b.hash_total_3__c = 0;
        appFCList.add(fc5b);

        SAI_File_Control__c fc5c = new SAI_File_Control__c();
        fc5c.source_system__c = SOURCESYSTEM;
        fc5c.start_datetime_extraction__c = startDate;
        fc5c.end_datetime_extraction__c = endDate;
        fc5c.file_name__c = 'US~' + SOURCESYSTEM + '~PartyStreetAddress~' + endTime.format('YYYY-MM-dd') + '~' +  '000000' + '.dta';
        fc5c.number_of_records__c = string.valueOf(partysaList.size());
        fc5c.hash_total_1__c = 0;
        fc5c.hash_total_2__c = 0;
        fc5c.hash_total_3__c = 0;
        appFCList.add(fc5c);

        SAI_File_Control__c fc6 = new SAI_File_Control__c();
        fc6.source_system__c = SOURCESYSTEM;
        fc6.start_datetime_extraction__c = startDate;
        fc6.end_datetime_extraction__c = endDate;
        fc6.file_name__c = 'US~' + SOURCESYSTEM + '~ApplicationFacility~' + endTime.format('YYYY-MM-dd') + '~' +  '000000'+ '.dta';
        fc6.number_of_records__c = '0';
        fc6.hash_total_1__c = 0;
        fc6.hash_total_2__c = 0;
        fc6.hash_total_3__c = 0;
        appFCList.add(fc6);

        SAI_File_Control__c fc7 = new SAI_File_Control__c();
        fc7.source_system__c = SOURCESYSTEM;
        fc7.start_datetime_extraction__c = startDate;
        fc7.end_datetime_extraction__c = endDate;
        fc7.file_name__c = 'US~' + SOURCESYSTEM + '~DeliveryControl~' + endTime.format('YYYY-MM-dd') + '~' +  '000000' + '.dta';
        fc7.number_of_records__c = string.valueOf(appDCList.size());
        fc7.hash_total_1__c = 0;
        fc7.hash_total_2__c = 0;
        fc7.hash_total_3__c = 0;
        appFCList.add(fc7);

        SAI_File_Control__c fc8 = new SAI_File_Control__c();
        fc8.source_system__c = SOURCESYSTEM;
        fc8.start_datetime_extraction__c = startDate;
        fc8.end_datetime_extraction__c = endDate;
        fc8.file_name__c = 'US~' + SOURCESYSTEM + '~ApplicationAsset~' + endTime.format('YYYY-MM-dd') + '~' +  '000000' + '.dta';
        fc8.number_of_records__c = string.valueOf(aaList.size());
        fc8.hash_total_1__c = 0;
        fc8.hash_total_2__c = 0;
        fc8.hash_total_3__c = 0;
        appFCList.add(fc8);

        SAI_File_Control__c fc9= new SAI_File_Control__c();
        fc9.source_system__c = SOURCESYSTEM;
        fc9.start_datetime_extraction__c = startDate;
        fc9.end_datetime_extraction__c = endDate;
        fc9.file_name__c = 'US~' + SOURCESYSTEM + '~ApplicationFeature~' + endTime.format('YYYY-MM-dd') + '~' +  '000000' + '.dta';
        fc9.number_of_records__c ='0';
        fc9.hash_total_1__c = 0;
        fc9.hash_total_2__c = 0;
        fc9.hash_total_3__c = 0;
        appFCList.add(fc9);


        SAI_File_Control__c fc10= new SAI_File_Control__c();
        fc10.source_system__c = SOURCESYSTEM;
        fc10.start_datetime_extraction__c = startDate;
        fc10.end_datetime_extraction__c = endDate;
        fc10.file_name__c = 'US~' + SOURCESYSTEM + '~ApplicationSkipBillingMonths~' + endTime.format('YYYY-MM-dd') + '~' + '000000' + '.dta';
        fc10.number_of_records__c = '0';
        fc10.hash_total_1__c = 0;
        fc10.hash_total_2__c = 0;
        fc10.hash_total_3__c = 0;
        appFCList.add(fc10);


      


        insert appFCList;
    }
  
}