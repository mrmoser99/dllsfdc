public class LeaseAccountObjectHierarchy extends mfiflexUtil.ObjectHierarchy {

    public override List<Schema.SObjectType> getInsertionOrder() {
        return new List<SObjectType> {
            	clcommon__Consolidated_Invoice__c.sobjectType,
                cllease__Lease_Account__c.SObjectType,
                cllease__Expense_Fees__c.SObjectType,
                cllease__Contract_Fees__c.SObjectType,
                cllease__Payment_Schedule__c.SObjectType,
                cllease__Lease_Trx_Header__c.SObjectType,
                cllease__Lease_Trx_Lines__c.SObjectType,
                cllease__Cash_Account_Balance__c.SObjectType,
                cllease__Non_Cash_Account_Balance__c.SObjectType,
                cllease__Lease_Payment_Transaction__c.SObjectType,
                cllease__Lease_Payment_Detail__c.SObjectType,
                cllease__Repayment_Transaction_Adjustment__c.SobjectType,
                cllease__Termination_Quote_Header__c.SObjectType,
                cllease__Lease_Account_Due_Details__c.SObjectType,
                cllease__Due_Detail_Lines__c.SObjectType,
                cllease__Charge__c.SObjectType,
                cllease__NPA_Header__c.SObjectType,
                cllease__NPA_Detail__c.SObjectType,
                cllease__NPA_History__c.SObjectType,
                cllease__Aging_History__c.SObjectType,
                cllease__Fee_Payment__c.SObjectType,
                cllease__Bill_Payment__c.SObjectType,
                cllease__Rental_Stream__c.SObjectType,
                cllease__Rental_Accrual_Stream1__c.SObjectType,
                cllease__Residual_Stream__c.SObjectType,
                cllease__Subsidy_Stream__c.SObjectType,
                cllease__Payment_Stream__c.SObjectType,
                cllease__Initial_Direct_Cost_Stream__c.SObjectType,
                cllease__Fee_Stream__c.SObjectType,
                cllease__Dep_Streams__c.SObjectType,
                cllease__Amz_Stream__c.SObjectType,
                cllease__Other_Transaction__c.SObjectType,
                cllease__Contract_Equipment__c.SObjectType,
                //Termination_Quote_Header__c.SObjectType,
                cllease__Termination_Quote_Line__c.SObjectType,
                cllease__Termination_Quote_Equipment__c.SObjectType,
                cllease__Asset_Return__c.SObjectType,
                clcommon__Disbursement_Transaction__c.SObjectType,
                cllease__Expense_Fee_Transaction__c.SObjectType,
                cllease__Invoice_Credit__c.SObjectType
        };
    }

    public override void setRegisteredRelationships() {
        registerRelationship(cllease__Payment_Schedule__c.SObjectType,
        cllease__Payment_Schedule__c.cllease__Contract__c,  
        cllease__Lease_Account__c.SObjectType);
        registerRelationship(cllease__NPA_Detail__c.SObjectType,
        cllease__NPA_Detail__c.cllease__NPA_Header__c,
        cllease__NPA_Header__c.SObjectType);
        registerRelationship(cllease__Expense_Fees__c.SObjectType,
        cllease__Expense_Fees__c.cllease__Contract__c,  
        cllease__Lease_Account__c.SObjectType);
        registerRelationship(cllease__Contract_Fees__c.SObjectType,
        cllease__Contract_Fees__c.cllease__Contract__c, 
        cllease__Lease_Account__c.SObjectType);
        registerRelationship(cllease__Lease_Payment_Transaction__c.SObjectType,
        cllease__Lease_Payment_Transaction__c.cllease__Contract__c,
        cllease__Lease_Account__c.SObjectType); // payments to contracts
        registerRelationship(cllease__Fee_Payment__c.SObjectType,
        cllease__Fee_Payment__c.cllease__Lease_Payment_Transaction__c,
        cllease__Lease_Payment_Transaction__c.SObjectType); // fee payments to lease payments
        registerRelationship(cllease__Bill_Payment__c.SObjectType,
        cllease__Bill_Payment__c.cllease__Payment_Transaction__c,
        cllease__Lease_Payment_Transaction__c.SObjectType); // bill payments to lease payments
        registerRelationship(cllease__Invoice_Credit__c.SObjectType,
        cllease__Invoice_Credit__c.cllease__Payment_Transaction__c,
        cllease__Lease_Payment_Transaction__c.SObjectType); // Invoice generation
        registerRelationship(cllease__Lease_Trx_Header__c.SObjectType,
        cllease__Lease_Trx_Header__c.cllease__Contract__c,
        cllease__Lease_Account__c.SObjectType); // Lease Accrual Transaction Headers to Contract
        registerRelationship(cllease__Lease_Trx_Lines__c.SObjectType,
        cllease__Lease_Trx_Lines__c.cllease__Trx_Header__c,
        cllease__Lease_Trx_Header__c.SObjectType); // Lease Accrual Transaction Lines to Headers
        registerRelationship(cllease__Lease_Trx_Lines__c.SObjectType,
        cllease__Lease_Trx_Lines__c.cllease__Contract__c,
        cllease__Lease_Trx_Header__c.SObjectType); // Lease Accrual Transaction Lines to Headers
        registerRelationship(cllease__NPA_History__c.SObjectType,
        cllease__NPA_History__c.cllease__LS_Contract__c,
        cllease__Lease_Account__c.SObjectType); // NPA History to contracts
        registerRelationship(cllease__Aging_History__c.SObjectType,
        cllease__Aging_History__c.cllease__Lease__c,
        cllease__Lease_Account__c.SObjectType); // NPA History to contracts
        registerRelationship(cllease__Contract_Equipment__c.SObjectType,
        cllease__Contract_Equipment__c.cllease__Contract__c,
        cllease__Lease_Account__c.SObjectType); // Equipment to contracts

        registerRelationship(cllease__Due_Detail_Lines__c.SObjectType,
        cllease__Due_Detail_Lines__c.cllease__Bill__c,
        cllease__Lease_Account_Due_Details__c.SObjectType);
        registerRelationship(cllease__Due_Detail_Lines__c.SObjectType,
        cllease__Due_Detail_Lines__c.cllease__Contract__c,
        cllease__Lease_Account__c.SObjectType);

        registerRelationship(cllease__Other_Transaction__c.SObjectType,
        cllease__Other_Transaction__c.cllease__Lease_Account__c,
        cllease__Lease_Account__c.SObjectType);
        registerRelationship(clcommon__Disbursement_Transaction__c.SObjectType,
        clcommon__Disbursement_Transaction__c.cllease__Contract__c,
        cllease__Lease_Account__c.SObjectType);
        registerRelationship(cllease__Expense_Fee_Transaction__c.SObjectType,
        cllease__Expense_Fee_Transaction__c.cllease__Disbursement_Transaction__c,
        clcommon__Disbursement_Transaction__c.SObjectType);

        //Streams related
        registerRelationship(cllease__Amz_Stream__c.SObjectType,
        cllease__Amz_Stream__c.cllease__Contract__c,
        cllease__Lease_Account__c.SObjectType);
        registerRelationship(cllease__Payment_Stream__c.SObjectType,
        cllease__Payment_Stream__c.cllease__Contract__c,
        cllease__Lease_Account__c.SObjectType);
        registerRelationship(cllease__Rental_Accrual_Stream1__c.SObjectType,
        cllease__Rental_Accrual_Stream1__c.cllease__Contract__c,
        cllease__Lease_Account__c.SObjectType);
        registerRelationship(cllease__Rental_Stream__c.SObjectType,
        cllease__Rental_Stream__c.cllease__Contract__c,
        cllease__Lease_Account__c.SObjectType);
        registerRelationship(cllease__Initial_Direct_Cost_Stream__c.SObjectType,
        cllease__Initial_Direct_Cost_Stream__c.cllease__Contract__c,
        cllease__Lease_Account__c.SObjectType);
        registerRelationship(cllease__Subsidy_Stream__c.SObjectType,
        cllease__Subsidy_Stream__c.cllease__Contract__c,
        cllease__Lease_Account__c.SObjectType);
        registerRelationship(cllease__Residual_Stream__c.SObjectType,
        cllease__Residual_Stream__c.cllease__Contract__c,
        cllease__Lease_Account__c.SObjectType);
        registerRelationship(cllease__Fee_Stream__c.SObjectType,
        cllease__Fee_Stream__c.cllease__Contract__c,
        cllease__Lease_Account__c.SObjectType);
        registerRelationship(cllease__Dep_Streams__c.SObjectType,
        cllease__Dep_Streams__c.cllease__Contract__c,
        cllease__Lease_Account__c.SObjectType);

        //Termination related
        registerRelationship(cllease__Termination_Quote_Line__c.SObjectType,
        cllease__Termination_Quote_Line__c.cllease__Quote_Header__c,
        cllease__Termination_Quote_Header__c.SObjectType);
        registerRelationship(cllease__Termination_Quote_Equipment__c.SObjectType,
        cllease__Termination_Quote_Equipment__c.cllease__Termination_Quote_Header__c,
        cllease__Termination_Quote_Header__c.SObjectType);
        registerRelationship(cllease__Lease_Account_Due_Details__c.SObjectType,
        cllease__Lease_Account_Due_Details__c.cllease__Quote_Header__c,
        cllease__Termination_Quote_Header__c.SObjectType);
        registerRelationship(cllease__Charge__c.SObjectType,
        cllease__Charge__c.cllease__Quote_header__c,
        cllease__Termination_Quote_Header__c.SObjectType);
        registerRelationship(cllease__Asset_Return__c.SObjectType,
        cllease__Asset_Return__c.cllease__Quote_header__c,
        cllease__Termination_Quote_Header__c.SObjectType);
        registerRelationship(cllease__Asset_Return__c.SObjectType,
        cllease__Asset_Return__c.cllease__Contract__c,
        cllease__Lease_Account__c.SObjectType);
    }

}