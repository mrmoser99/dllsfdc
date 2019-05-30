/*******************************************************************************************************************
*   PNC Utility
*       This class holds methods to peform functions with PNC Payer Express
* 
*	Change Log: 
*	4/4/19 - MRM Created
    4/5/19 - added void invoice method
*   5/20/19 - changesd 120 days to 365 days to look back on history.     
*
********************************************************************************************************************/
public with sharing class PNCUtility { 
    
       
    /*************************************************************************************************
    * 
    * voidInvoice  in PNC
    *
    * if rInvoice is true then the invoice will be reversed.  
    * for a check payment the invoice will not be reversed.
    * for a replacement invoice, the old invoice needs to be reversed
	*	
	* 
    *************************************************************************************************/
    public static boolean voidInvoice( String invoiceId, Boolean rInvoice){    

        // create these lines for the invoice into the interface table, the job runs every 10 minutes so it will be picked up
         /*
        1|BILLDATA|PNC|3517|SUM|04132018|110039 
        RecordType|ReferenceNumber|OtherData|dtStatement|dtDue|BillerInvoiceNo|NameFirst|MiddleName|NameLast|CompanyName|Address|Address2|City|State|Zip|Phone|Fax|PreviousBalance|PaymentReceived|CurrentCharges|AmountDue|EmailAddress|FDICode|PmtTypeAllowed|BillStatus|MasterNumber|OpenField1|OpenField2|Message|CustomerCode|SalesTax|PurchaseID|DeliveryZip|Discount Amount|FreightShippingAmt|DutyAmt|ItemCommodityCode|ProductName|ProductCode|Quantity|UnitofMeasure|UnitCost|DiscPerLineItem|LineItemTotal|DisplayField1
        6|0000000419|0000000419|04/16/2018|05/11/2018|INV-0000000057||||THE EVANGELICAL LUTHERAN CHURCH OF THE REDEMPTION IN PHILADELPHIA|8001 Bustleton Ave||Philadelphia|PA|19152-2801||||||249.19|||CC;DEBIT;CREDIT|||||||||||||||||||||LES-0000000306
        9|1|249.19|0|0
        */
        List<Int_PX_Billing__c> bList = new List<Int_PX_Billing__c>();

        
        Int_PX_Billing__c b = new Int_PX_Billing__c();
        Datetime dt = DateTime.now();
        b.line_data__c = ' 1|BILLDATA|PNC|3517|SUM|' + dt.format('MMddyyyy') + '|' + dt.format('hhmmss');
        bList.add(b);

        b = new Int_PX_Billing__c();
        b.line_data__c = 'RecordType|ReferenceNumber|OtherData|dtStatement|dtDue|BillerInvoiceNo|NameFirst|MiddleName|NameLast|CompanyName|Address|Address2|City|State|Zip|Phone|Fax|PreviousBalance|PaymentReceived|CurrentCharges|AmountDue|EmailAddress|FDICode|PmtTypeAllowed|BillStatus|MasterNumber|OpenField1|OpenField2|Message|CustomerCode|SalesTax|PurchaseID|DeliveryZip|Discount Amount|FreightShippingAmt|DutyAmt|ItemCommodityCode|ProductName|ProductCode|Quantity|UnitofMeasure|UnitCost|DiscPerLineItem|LineItemTotal|DisplayField1';
        bList.add(b);


        Invoice__c i = [SELECT Balance_Amount__c
            ,Balance_Due_Amount__c
            ,Billed_Amount__c
            ,Bill_To_Account__c
            ,Charged_Amount__c
            ,Customer_Name__c
            ,Id
            ,LS_Contract__c
            ,LS_Contract__r.name 
            ,Name
            ,invoice_due_date__c
            ,total_invoiced_amount__c
            ,Total_Amount_Due__c 
            ,voided_in_pnc__c
            FROM Invoice__c
            where id = :invoiceId 
            ]; 

       
        /* need to get the original line since it has to match exactly...name adddress, zip.......*/
        /* then add expired to the bill status and wamo...the invoice will be void */
        /* limit to 120 days to void */

        List<Int_PX_Billing__c> lineList = new List<Int_PX_Billing__c>();

        lineList = [Select line_data__c
                                        from Int_PX_Billing__c 
                                        where createdDate = last_n_days: 365 
                                        and committed__c = true
                                    ];

       
        String origLine = '';
        for (Int_PX_Billing__c l: lineList){
            if(l.line_data__c.contains(i.name)){
                origLine = l.line_data__c;
                break;
            }              
        }

        b = new Int_PX_Billing__c();
       
        list<String> myList = new List<String>();
        myList = origLine.split('CC;DEBIT;CREDIT');
        
        b.line_data__c =  myList[0] +
            'CC;DEBIT;CREDIT' + '|' + 'Expired' + 
            '|' + '|' + '|' + '|' + '|' + '|' + '|' + '|' + '|' + '|' + '|' + '|' + '|' + '|' + '|' + '|' + '|' + '|' + '|' + '|' +
            i.LS_Contract__r.name;


        bList.add(b);

        b = new Int_PX_Billing__c();
        
        b.line_data__c =  '9|1|' + string.valueOf(i.total_invoiced_amount__c) + '|0|0';

        blist.add(b);

        insert bList;
        
        if (rInvoice)
            reverseInvoice(invoiceId);

        return true;

    }    

    /*************************************************************************************************
    * 
    * reverseInvoice in CLS
    *
    *   remove invoice from bills
    *   remove invoice from charges
    *   set void flag date/time on invoice
	*	
	* 
    *************************************************************************************************/
    public static boolean reverseInvoice( ID invoiceId){ 

        /* void the invoice */

        Invoice__c i = [SELECT id
                        FROM Invoice__c
                        where id = :invoiceId 
                       ]; 

        i.voided_in_Pnc__c = true;
        i.voided_in_pnc_date_time__c = datetime.now();
       

        List<cllease__Lease_account_Due_Details__c> billList = new List<cllease__Lease_Account_Due_Details__c>();
        billList = [select id from cllease__Lease_Account_Due_Details__c
                    where invoiced_in__c = :invoiceId];

        /* removed the invoice from all bills & charges */

        for (cllease__Lease_Account_Due_Details__c d:billList)
            d.invoiced_in__c = null;
        
        list<cllease__charge__c> chargeList = new List<cllease__Charge__c>();
        chargeList = [select id from cllease__Charge__c where invoiced_in__c = :invoiceId];
        for (cllease__Charge__c c:chargeList){
            c.invoiced_in__c = null;
        }

        update i;
        update billList;
        update chargeList;

        return true;


    }  
}