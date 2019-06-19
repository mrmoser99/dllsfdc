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

       
        update i;
        
        if (rInvoice)
            reverseInvoice(invoiceId);

        return true;

    }    

    /*************************************************************************************************
    * 
    * reverseInvoice in CLS
    *
    *    
    *   set void flag date/time on invoice
	*	
	* 
    *************************************************************************************************/
    public static boolean reverseInvoice( ID invoiceId){ 

        /* void the invoice */

        Invoice__c i = [SELECT id
                        ,total_invoiced_amount__c
                        FROM Invoice__c
                        where id = :invoiceId 
                       ]; 

        i.voided_in_Pnc__c = true;
        i.voided_in_pnc_date_time__c = datetime.now();
        i.file_generated__c = 'No';
        i.file_generated_on__c = null;
        i.invoice_emailed__c = false;
        i.sent_to_pnc__c = false;
        i.Sent_To_PNC_Date_Time__c = null;
        i.sent_to_pnc_amount__c = i.Total_Invoiced_Amount__c;        

        update i;
       
        return true;

    }  

    /*************************************************************************************************
    * 
    * reverseTaxCharges
    *
	* 
    *************************************************************************************************/
    public static boolean reverseTaxes( ID invoiceId){ 
    
        List<adjustment__c> aList = new List<adjustment__c>();
        aList = [select Id
                ,adjustment_type__c
                ,credit__c
                ,debit__c
                ,Charge__r.Name  
                ,Due_Detail_Line__r.Name  
                ,tax_amount__c
                ,equipment__c
                ,Charge_Bill_Name__c
                from adjustment__c
                where invoice__c = :invoiceId
                order by equipment__c, charge_bill_name__C
        ];
        
        Set<ID> chargeSet = new set<ID>();
        for (adjustment__c a:aList)
            chargeSet.add(a.charge__c);

        List<cllease__Charge__c> clist = [SELECT AR_Type__c
                                  , cllease__Lease_Account__r.cllease__Maturity_Date__c
                                  , cllease__Lease_Account__r.cllease__First_Payment_Date__c
                                  , cllease__Lease_Account__r.cllease__Account__r.Tax_Exempt__c
                                  , cllease__Contract_Equipment__r.Name
                                  , cllease__Contract_Equipment__r.GARD__c
                                  , cllease__Fee_Definition__r.name
                                  , cllease__Lease_Account__r.Name
                                  ,BillingType__c
                                  ,cllease__Accrue_Interest_From__c
                                  ,cllease__Branch__c
                                  ,cllease__Calculated_Interest2__c,cllease__Calculated_Interest3__c,cllease__Charge_Type__c,cllease__Contract_Equipment__c,cllease__Contract_Fee__c,cllease__Contract_Status__c,cllease__Date__c,cllease__Dues_Details__c,cllease__Expense_Fee__c,cllease__Fee_Definition__c,cllease__Fee_Due__c,cllease__Fee_Paid_Amount__c,cllease__Fee__c,cllease__GL_Posted_Flag__c,cllease__GL_Processing_Message__c,cllease__GL_Process_Date__c,cllease__GL_Reversal_Posted_Flag__c,cllease__GL_Reversal_Process_Date__c,cllease__GL_Transaction_Flag__c,cllease__Interest_Bearing__c,cllease__Interest_Due__c,cllease__Interest_Rate__c,cllease__Last_Accrual_Date__c,cllease__LeaseApplicationNumber__c,cllease__Lease_Account__c,cllease__Maturity_Date__c,cllease__Original_Amount__c,cllease__Original_Tax_Amount__c,cllease__Paid_Amount__c,cllease__Paid__c,cllease__Passthrough_Paid_Amount__c,cllease__Passthrough_Paid__c,cllease__Principal_Due__c,cllease__Quote_header__c,cllease__Reference__c,cllease__Remarks__c,cllease__Start_Date__c,cllease__Tax_Due__c,cllease__Tax_Paid_Amount__c,cllease__Tax_Processed__c,cllease__Tax_Rate__c,cllease__Total_Due_Amount__c,cllease__Transaction_Date__c,cllease__Transaction_Sub_Type__c,cllease__Waive__c,CompanyCode__c,Contract_Equipment__c,Contract_Type__c,CreatedById,CreatedDate,Current_Fee_Paid__c,Current_Tax_Paid__c,DestinationCity__c,DestinationCounty__c,DestinationState__c,DestinationZipCode__c,Equipment__c,Fee_Paid__c,Fee_Type_for_Term_Quote__c,Finance_Fee_created__c,Id,Invoiced_In__c,Invoice_Period_End_Date__c,Invoice_Period_Start_Date__c,IsDeleted,LastModifiedById,LastModifiedDate,LeaseType__c,MessageS__c,Name,Original_Tax_Amount__c,Overdue__c,Passthrough_Charge__c,Property_Tax__c,SystemModstamp,Taxbasis__c,Tax_APO__c,Tax_BOROUGH__c,Tax_CITY__c,Tax_Component__c,Tax_COUNTRY__c,Tax_COUNTY__c,Tax_DISTRICT__c,Tax_FPO__c,Tax_LOCAL_IMPROVEMENT_DISTRICT__c,Tax_Paid__c,Tax_PARISH__c,Tax_Payment_Type__c,Tax_Processed__c,Tax_PROVINCE__c,Tax_Rate_APO__c,Tax_Rate_BOROUGH__c,Tax_Rate_CITY__c,Tax_Rate_COUNTRY__c,Tax_Rate_COUNTY__c,Tax_Rate_DISTRICT__c,Tax_Rate_FPO__c,Tax_Rate_LOCAL_IMPROVEMENT_DISTRICT__c,Tax_Rate_PARISH__c,Tax_Rate_PROVINCE__c,Tax_Rate_SPECIAL_PURPOSE_DISTRICT__c,Tax_Rate_STATE__c,Tax_Rate_TERRITORY__c,Tax_Rate_TOWNSHIP__c,Tax_Rate_TRADE_BLOCK__c,Tax_Rate_TRANSIT_DISTRICT__c,Tax_SPECIAL_PURPOSE_DISTRICT__c,Tax_STATE__c,Tax_TERRITORY__c,Tax_TOWNSHIP__c,Tax_TRADE_BLOCK__c,Tax_TRANSIT_DISTRICT__c,Total_Amount__c,Total_Original_Amount__c,Transaction_Code__c,Transaction_SubType_Name__c
                                  ,Withheld_Amount__c 
                                FROM cllease__Charge__c 
                                where id in :chargeSet];
 
        for (cllease__Charge__c c1:cList)
            c1.cllease__Waive__c = true;
        
      
        for (cllease__Charge__c c:cList){
        
    
            List<cllease__Charge__c> temp = new List<cllease__Charge__c>();
            temp.add(c);
            Dom.document methoddoc = VertexUtil.getChargesXml(temp);  
            VertexApi__c vertexConfig = CLSCustomUtil.getVertexConfiguration();
            VertexUtil.validateVertexConfig(vertexConfig);

            System.debug(LoggingLevel.ERROR,'methoddoccc'+methoddoc.toXmlString());
        
            HttpResponse res;    
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint(vertexConfig.End_Point__c);
            req.setHeader('Content-Type', 'text/xml');
            req.setBody(methoddoc.toXMlString());

            Http http = new Http();
            res = http.send(req);

	        system.debug('res:' + res.getBody());
        }

        update cList;

        return true;

    }
}