public class DMBIStaticVariables {
    
    //Public static string FINANCE_LEASE='FINANCE LEASE';
    Public static string Empty_str = '';//generic
    Public static string test_value = 'Test';
    public static string SourceSystem = 'Cloud Lending Lease';
    public static string NetInvestmentJobBatch_query_str = ' SELECT id,name,cllease__Product_Type__c,cllease__Product_Sub_Type__c,cllease__Dealer__r.genesis__Vendor_Type__c,cllease__Dealer__r.Account_Number__c,Business_Unit_Name__c,cllease__Excess__c,cllease__Days_Convention__c,Bill_Not_Paid_Rent__c,cllease__Payment_Amount__c,Dealer_Program__r.name,cllease__Down_Payment__c,DLL_Reference_Number__c,cllease__Amort_Start_Date__c,cllease__Days_Past_Due__c,cllease__Lease_Account__c.cllease__Payment_Method__c,Account_Number__c,'+
        'cllease__Account__r.name,cllease__Residual_Amount__c,Unbilled_Receivable__c,cllease__Number_of_Pieces_of_Equipment__c,Source_System__c, cllease__Currency_Code__c, cllease__Delinquent_Amount__c, cllease__Lease_Status__c,'+  
        'Application__r.genesis__ID_Type__c,cllease__Commencement_Date__c,cllease__Contract_Date__c,cllease__Financed_Amount__c,Purchase_Option__c,Allowable_Soft_Cost__c,cllease__Account__r.clcommon__Legal_Entity_Type__r.name,cllease__Account__r.genesis__Total_Risk_Score__c,cllease__Payment_Frequency__c,cllease__Security_Deposit_Amount__c,cllease__Maturity_Date__c,Booking_Date__c,cllease__Term__c,cllease__Current_Term_Total_Payment__c,Cost_of_Funds__c,cllease__Yield__c,Termination_Date__c ,'+        
        '(SELECT cllease__Contract__r.name,cllease__Debit_GL_Account__r.name,Movement_Code_DR_Segment__c,CL_Lease_Transaction_Type__c from cllease__GL_Transaction_Details__r where CL_Lease_Transaction_Type__c = \'BOOKING\' AND cllease__Debit_GL_Account__r.name = \'Gross Receivables - CLS\'), '+
        'cllease__Total_Dealer_Charges__c,cllease__Subsidy1__c,Interim_Rent__c,Billed_Not_Paid__c,cllease__First_Payment_Date__c,Net_Trade_Up_Amount__c,Net_Dealer_Funding__c,Exposure__c, '+
        'cllease__Account__r.clcommon__direct_Exposure__c,cllease__Account__r.clcommon__Indirect_Exposure__c,cllease__Account__r.All_Address__c,cllease__Address__r.clcommon__Zip_Code__c,cllease__Address__r.clcommon__City__c,cllease__Address__r.clcommon__State_Province__c,cllease__Account__r.Industry_Code__c,cllease__Account__r.Industry_Code_Type__c '+
        ' FROM cllease__Lease_Account__c '+ //select () FROM cllease__Lease_Account__c limit 26
        ' WHERE cllease__Lease_Status__c in (\'ACTIVE - GOOD STANDING\',\'ACTIVE - BAD STANDING\', \'ACTIVE – MATURED\',\'EVERGREEN\',\'TERMINATED\',\'CHARGED OFF\') ';//NetInvestmentJobbatch AND id=\'a6J550000004tsb\'
    
    /*-------Rental stremas query ---- */
    public static list<cllease__Rental_Stream__c> getRentalStreams(list<cllease__Lease_Account__c> clleaseContractsList){
        return [SELECT cllease__Contract__c,
                    cllease__Capital_Recovery__c,
                    cllease__Date__c,
                    cllease__Payment_Amount__c,
                    cllease__Lease_Income__c,
                    cllease__Accrued_Flag__c,
                    cllease__Contract__r.name,Name 
                FROM cllease__Rental_Stream__c 
                WHERE cllease__Contract__c IN : clleaseContractsList 
                ORDER BY cllease__Date__c DESC];
    }
    
    /*-------Residul stremas query ---- */
    public static list<cllease__Residual_Stream__c> getResidualStreams(list<cllease__Lease_Account__c> clleaseContractsList){
        return [SELECT cllease__Contract__c,
                cllease__Beginning_Unearned_Residual_Income__c,
                name,
                cllease__Contract__r.name,
                cllease__Accrued_Flag__c,
                cllease__Date__c,
                cllease__Residual_Income__c 
                FROM cllease__Residual_Stream__c
                WHERE cllease__Contract__c IN : clleaseContractsList 
                ORDER BY cllease__Date__c DESC ];
    }
    
    /*------- conract parties query ---- */
    public static list<cllease__Contract_Parties__c> getContractParties(list<cllease__Lease_Account__c> ContractList){
        return [SELECT cllease__Contract__c,
                cllease__Party_Type__c,
                Name,cllease__Contract__r.name,
                cllease__Party_Account_Name__r.Account_Number__c,
                cllease__Party_Account_Name__r.name,
                cllease__Party_Account_Name__r.Primary_Address__r.Address_Line_1__c,
                cllease__Party_Account_Name__r.Primary_Address__r.Address_Line_2__c,
                cllease__Party_Account_Name__r.Primary_Address__r.Address_Line_3__c,
                cllease__Party_Account_Name__r.Primary_Address__r.Address_Line_4__c,
                cllease__Party_Account_Name__r.Primary_Address__r.City__c,
                cllease__Party_Account_Name__r.Primary_Address__r.State__c,
                cllease__Party_Account_Name__r.Primary_Address__r.Zip_Code__c,
                cllease__Party_Account_Name__r.EIN__c 
                FROM cllease__Contract_Parties__c 
                WHERE cllease__Contract__c IN : ContractList];
    }
    
    /*------- Assets query ---- */
    public static list<int_asset__c> getAssets(){
        return [SELECT Asset_Number__c 
                FROM int_asset__c 
                LIMIT 50000]; 
    }
    
    /*------- agreement lines query ---- */
    public static list<Int_Agreement_Line__c> getAgreementLines(list<Int_Agreement_Line__c> AgreementLinesList){
        return [SELECT id,
                name,
                Agreement_Name__c,
                Agreement_Number__c,
                Agreement_Source_System__c,
                Agreement_Line_Number__c 
                FROM Int_Agreement_Line__c 
                WHERE ID IN:AgreementLinesList];
    }
    
    /*------- Object Mapping Equipment query ---- */
    public static list<IntObjectMapping__mdt> getIntObjectMapping(){
        return [Select 
                MasterLabel,
                value__c 
                FROM IntObjectMapping__mdt 
                LIMIT 100];
    }
    
    /*------- Contract Equipment query ---- */
    public static list<cllease__Contract_Equipment__c> GetContractEquipments(list<cllease__Lease_Account__c> ContractList){
        return [SELECT id,
                    cllease__Contract__c,
                    cllease__Residual_Amount__c,
                    Rent_Amount__c,
                    Bill_Residual_Amount__c,
                    Name,
                    Asset_ID__c,
                    Master_Asset_Type__c,
                    Object_Category_ID__c,
                    Object_Category_Name__c,
                    Asset_Type_ID__c,
                    Asset_Type_Name__c,
                    cllease__Make__c,
                    Manufacturer__c,
                    cllease__Model__c,
                    Equipment_Description1__c,
                    cllease__Equipment_Serial_Number__c,
                    cllease__Year__c,
                    cllease__Status__c,
                    cllease__Estimated_Selling_Price__c,
                    cllease__Equipment_Calculated_Cost__c,
                    cllease__Total_Dealer_Charges__c,
                    cllease__Subsidy__c,
                    cllease__Contract__r.Name,
                    Invoice_Date__c,
                    Upfront_Tax_Amount__c,
                    Net_Trade_Up_Amount__c,
                    Dealer_Charges__c,
                    Contract_Status__c 
                FROM cllease__Contract_Equipment__c 
                WHERE cllease__Contract__c IN : ContractList Order by createddate DESC];
    }
    
    /*------- paryment transaction query ---- */
    public static list<cllease__Lease_Payment_Transaction__c> getPaymentTransactions(list<cllease__Lease_Account__c> contracts){
        return [SELECT cllease__Contract__c,
                cllease__Transaction_Amount__c,
                cllease__Contract__r.name,
                cllease__Payment_Mode__r.name 
                FROM cllease__Lease_Payment_Transaction__c 
                WHERE cllease__Contract__c IN : contracts 
                Order by createddate DESC];
    }
    
    /*------- Asset workbenches query ---- */
    public static list<cllease__Asset_workbench__c> getAssetWorkbenches(list<cllease__Lease_Account__c> contracts){
        return [SELECT Id,
                Name,
                cllease__Contract__r.name,
                cllease__Contract_Equipment__r.name,
                cllease__Return_Status__c,
                Sale_Price__c 
                FROM cllease__Asset_workbench__c 
                WHERE cllease__Contract__c IN : contracts];
    }
}