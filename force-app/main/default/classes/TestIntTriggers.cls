@isTest
public with sharing class TestIntTriggers {
 		
	static testmethod void test1(){
		Int_OFAC_FINCEN__c f = new Int_OFAC_FINCEN__c();
		insert f;
		
 		 
 		f.committed__c = true;
 		
 		update f;
 	} 
 	
 	static testmethod void test2(){
		Int_OFAC__c f = new Int_OFAC__c();
		insert f;
		
 		 
 		f.committed__c = true;
 		
 		update f;
 	} 
 	
 	
 	static testmethod void test3(){
		Int_OLMN_Payment_Confirmation__c f = new Int_OLMN_Payment_Confirmation__c();
		
		f.text_payment_date__c = '20180203';
		f.text_void_date__c = '20180203';
		f.text_invoice_date__c = '20180203';
		insert f;
		
 	
 	} 
 	
 	static testmethod void test4(){
		Int_PX_Remit__c f = new Int_PX_Remit__c();
		f.line_data__c = '1|0000000457|3100313855-001|20180316|20180316:130214|PX|70246|INV-0000003087|70246|70246';
		insert f;
		
 	
 	} 
 	
 	static testmethod void test5(){
		
		NewCoUtility.convertDate('10/22/18');
		
 	
 	} 
 	
 	static testmethod void test6(){
		
		Property_Tax__c p = new Property_Tax__c();
		String myDate = '04/02/2018';
		
		
		cllease__Lease_Account__c contract = TestHelper.createContract();
		cllease__Contract_Equipment__c contractEquipment = [SELECT Id
														FROM cllease__Contract_Equipment__c
                                                        WHERE cllease__Contract__c = :contract.Id
                                                        LIMIT 1];
		
	
		 
		p.Contract_Equipment__c = contractEquipment.id;
		p.ap_export_date__c = NewCoUtility.convertDate(myDate);
		p.exported_to_ar_date__c = NewCoUtility.convertDate(myDate);
		p.installment_due_date__c = NewCoUtility.convertDate(myDate);
		p.installment_mail_by_date__c = NewCoUtility.convertDate(myDate);
		p.lease_end_date__c = NewCoUtility.convertDate(myDate);
		p.lease_start_date__c = NewCoUtility.convertDate(myDate);
		p.processed_date__c = NewCoUtility.convertDate(myDate);		
 	
 		insert p;
 		
 	} 
 	
 	static testmethod void test7(){ 
 		
 		cllease__Lease_Account__c contract = TestHelper.createContract();
 		
 	}
 	
 	static testmethod void test8(){ 
 	
 		List<Int_PX_Billing__c> bList = new List<Int_PX_Billing__c>();
 		
 		 
 		
 		Int_PX_Billing__c b = new Int_PX_Billing__c();
 	
 		b.line_data__c = '1|BILLDATA|PNC|3517|SUM|05162018|110105';
 		bList.add(b);
 		
 		b = new Int_PX_Billing__c();
 		b.line_data__c = 'RecordType|ReferenceNumber|OtherData|dtStatement|dtDue|BillerInvoiceNo|NameFirst|MiddleName|NameLast|CompanyName|Address|Address2|City|State|Zip|Phone|Fax|PreviousBalance|PaymentReceived|CurrentCharges|AmountDue|EmailAddress|FDICode|PmtTypeAllowed|BillStatus|MasterNumber|OpenField1|OpenField2|Message|CustomerCode|SalesTax|PurchaseID|DeliveryZip|Discount Amount|FreightShippingAmt|DutyAmt|ItemCommodityCode|ProductName|ProductCode|Quantity|UnitofMeasure|UnitCost|DiscPerLineItem|LineItemTotal|DisplayField1';
 		bList.add(b);
 		
 		b = new Int_PX_Billing__c();
 		b.line_data__c = '6|0000000419|0000000419|05/10/2018|05/11/2018|INV-0000000060||||THE EVANGELICAL LUTHERAN CHURCH OF THE REDEMPTION IN PHILADELPHIA|8001 Bustleton Ave||Philadelphia|PA|19152-2801||||||75.00|||CC;DEBIT;CREDIT|Expired||||||||||||||||||||LES-0000000306';
 		bList.add(b);
 		
 		b = new Int_PX_Billing__c();
 		b.committed__c = true;
 		b.line_data__c = '6|0000000418|0000000418|04/17/2018|05/12/2018|INV-0000000058||||AMERICAN HOME HEALTH SERVICES LLC|261 Old York Rd, Ste 824||Jenkintown|PA|19046-3713||||||661.48|rhammond@angelsoncall.com||CC;DEBIT;CREDIT|Expired||||||||||||||||||||LES-0000000304';
 		bList.add(b);
 		
 		b = new Int_PX_Billing__c();
 		b.line_data__c = '9|2|736.48|0|0';
 		bList.add(b);
 		
 		insert bList;
 		
 		update bList;
 	}
 	
 	static testmethod void test9(){
 		
 		cllease__calendar__c c = new cllease__calendar__c();
 		c.cllease__type__c = 'Fiscal';
 		c.cllease__Frequency__c = 'Monthly';
 		c.cllease__Start_Day__c = 1;
 		c.cllease__Start_Month__c = 1;
 		c.cllease__Start_Year__c = 2018;
 		c.cllease__Start_Year_Fiscal__c = 2018;
 		insert c;
 		
 		cllease__Period_Status__c p = new cllease__Period_Status__c();
 		p.cllease__Calendar_Name__c = c.id;
 		
 		p.cllease__End_Date__c = date.newInstance(2016, 1, 31);
 		p.cllease__Period_Month__c = 1;
 		p.cllease__Period_Number__c = 1;
 		p.cllease__Period_Year__c = 2016;
 		p.cllease__Quarter__c = 1;
 		p.cllease__Start_Date__c = date.newInstance(2016, 1, 1);
 		
 		p.cllease__Status__c = 'Open';
 		
 		insert p;
 		
 		cllease__Period_Status__c p2 = new cllease__Period_Status__c();
 		p2.cllease__Calendar_Name__c = c.id;
 		
 		p2.cllease__End_Date__c = date.newInstance(2016, 2, 28);
 		p2.cllease__Period_Month__c = 1;
 		p2.cllease__Period_Number__c = 1;
 		p2.cllease__Period_Year__c = 2016;
 		p2.cllease__Quarter__c = 1;
 		p2.cllease__Start_Date__c = date.newInstance(2016, 2, 1);
 		p2.cllease__status__c = 'Never Open';
 		
 		insert p2;
 		
 		p.cllease__Status__c = 'Closed';
 		update p;
 		
 	}

	 static testmethod void test10(){

		 Int_PX_NSF__c n = new INT_PX_NSF__c();
		 n.line_data__c = '1|19191919|3100349750|20190315|20190315:121124|PX|20000||20000|20000|20000';
		 insert n;

	 }
}