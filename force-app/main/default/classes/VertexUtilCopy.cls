/**
 * Author: Cloud Lending Solutions
 * Description: Following has utilities for vertex callouts
 * 
 * Change Log: 
 *    MRM 3/31/2020 correct up front tax
 *    8/18/2020 - MRM changed flex date to book date again after q2 wiped out the code 
 *    9/22/2020 - MRM changed flex date to commencment date
 *    12/9/2020 - CKB Vertex XML changes- New Tag FairMarketValue added and New Section added for TradeUp Amounts
 **/
public class VertexUtilCopy { 

    // Default Hardcoded Values for Vertex Rest API Calls
    private static String transCodev = 'INV';
    private static String contrTypev = 'FMV';
    private static String taxPmtTypev= 'ST'; 
    private static String leaseTypev = 'A';
    private static String titleTxfrv = 'I';        
    private static String taxBasisv  = 'N/A';//'Stream';       
    private static String intDisclv  = 'N';            
    private static String vendPaidv  = 'N';            
    private static String alev       = 'F';            
    private static String slbc       = 'F';            
    private static String reqReasonv = 'NA';           
    private static String upTaxAmtv  = '0';            
    private static String cumulTaxv  = '0';            
    private static String slbPaidv   = '0';            
    private static String qtpCodev   = '0';            
    private static String qrsCodev   = '0';
    // upfront tax related variables
    private static String upfronttransCodev = 'ORIG';
    private static String UpfronttaxPmtTypev= 'VALUE IS BLANK';
    private static String upfrontreqReasonv = 'BOOKING';
    private static String alevFalse         = 'F';

    public static Map<String, String> taxValueFieldJurisdictionMap = new Map<String, String>{
        'APO'                           => 'Tax_APO__c',
        'BOROUGH'                       => 'Tax_BOROUGH__c',
        'CITY'                          => 'Tax_CITY__c',
        'COUNTRY'                       => 'Tax_COUNTRY__c',
        'COUNTY'                        => 'Tax_COUNTY__c',
        'DISTRICT'                      => 'Tax_DISTRICT__c',
        'FPO'                           => 'Tax_FPO__c',
        'LOCAL_IMPROVEMENT_DISTRICT'    => 'Tax_LOCAL_IMPROVEMENT_DISTRICT__c',
        'PARISH'                        => 'Tax_PARISH__c',
        'PROVINCE'                      => 'Tax_PROVINCE__c',
        'SPECIAL_PURPOSE_DISTRICT'      => 'Tax_SPECIAL_PURPOSE_DISTRICT__c',
        'STATE'                         => 'Tax_STATE__c',
        'TERRITORY'                     => 'Tax_TERRITORY__c',
        'TOWNSHIP'                      => 'Tax_TOWNSHIP__c',
        'TRADE_BLOCK'                   => 'Tax_TRADE_BLOCK__c',
        'TRANSIT_DISTRICT'              => 'Tax_TRANSIT_DISTRICT__c'
    };

    public static Map<String, String>  taxRateFieldJurisdictionMap = new Map<String, String>{
        'APO'                           => 'Tax_Rate_APO__c',
        'BOROUGH'                       => 'Tax_Rate_BOROUGH__c',
        'CITY'                          => 'Tax_Rate_CITY__c',
        'COUNTRY'                       => 'Tax_Rate_COUNTRY__c',
        'COUNTY'                        => 'Tax_Rate_COUNTY__c',
        'DISTRICT'                      => 'Tax_Rate_DISTRICT__c',
        'FPO'                           => 'Tax_Rate_FPO__c',
        'LOCAL_IMPROVEMENT_DISTRICT'    => 'Tax_Rate_LOCAL_IMPROVEMENT_DISTRICT__c',
        'PARISH'                        => 'Tax_Rate_PARISH__c',
        'PROVINCE'                      => 'Tax_Rate_PROVINCE__c',
        'SPECIAL_PURPOSE_DISTRICT'      => 'Tax_Rate_SPECIAL_PURPOSE_DISTRICT__c',
        'STATE'                         => 'Tax_Rate_STATE__c',
        'TERRITORY'                     => 'Tax_Rate_TERRITORY__c',
        'TOWNSHIP'                      => 'Tax_Rate_TOWNSHIP__c',
        'TRADE_BLOCK'                   => 'Tax_Rate_TRADE_BLOCK__c',
        'TRANSIT_DISTRICT'              => 'Tax_Rate_TRANSIT_DISTRICT__c'
    };

    /**
     * Following method helps in forming xml for DueDetail Lines
     **/
    public static Dom.Document getBillsXml(List<cllease__Due_Detail_Lines__c> dueDetailLines) {
           
        // Getting Vertex API Configuration from customerom settings & Validating
        VertexApi__c vertexConfig = CLSCustomUtil.getVertexConfiguration();
        validateVertexConfig(vertexConfig);

        System.debug(LoggingLevel.ERROR, ' Vertex Configuration: ' + vertexConfig);        

        String soapNS  = (vertexConfig.soapNS__c != null ? vertexConfig.soapNS__c : 'http://schemas.xmlsoap.org/soap/envelope/');
        String xsi     = (vertexConfig.XSI__c != null ? vertexConfig.XSI__c : 'urn:vertexinc:o-series:tps:8:0');

        DateTime currentSystemDate  =   cllease.SystemDateUtil.getCurrentSystemDate();
        String currentSystemDateStr =   formatDate(currentSystemDate);
            
        //Creating XML Formation Starts here
        String contractName, contractDate, contractTerm, contractType, transactionCode, taxPaymentType; 
        String dueAmount, assetNumber, lineItemId;

        // Creating DOM for XML
        Dom.Document scdoc = new Dom.Document();
        Dom.XmlNode envelope = scdoc.createRootElement('Envelope', soapNS, 'soapenv');
        envelope.setNamespace('urn', xsi);
        
        Dom.XmlNode header = envelope.addChildElement('Header', soapNS, null);
        
        Dom.XmlNode body = envelope.addChildElement('Body', soapNS, null);
        Dom.XmlNode vertexEnvelope = body.addChildElement('urn:VertexEnvelope',xsi,'');
        vertexEnvelope.setNamespace('xsi','http://www.w3.org/2001/XMLSchema-instance');
            
        Dom.XmlNode login =  vertexEnvelope.addChildElement('urn:Login', null,null);
        Dom.XmlNode uid =   login.addChildElement('urn:UserName',null,null).addTextNode(vertexConfig.Username__c);
        Dom.XmlNode pwd =   login.addChildElement('urn:Password', null,null).addTextNode(vertexConfig.Password__c);
            
        Dom.XmlNode invoiceRequest = vertexEnvelope.addChildElement('urn:InvoiceRequest',null,null);
        invoiceRequest.setattribute('documentDate',currentSystemDateStr);
        invoiceRequest.setattribute('transactionType','LEASE');
            
        Dom.XmlNode seller  =  invoiceRequest.addChildElement('urn:Seller',null,null);
        seller.addChildElement('urn:Company',null,null).addTextNode(vertexConfig.Company__c);
        seller.addChildElement('urn:Division',null,null).addTextNode(vertexConfig.Division__c);
        
        Date startDate, endDate;
        Integer lengthOfContract;

         set<ID> leaseSet = new Set<ID>();
        for(cllease__Due_Detail_Lines__c dueDetailLine : dueDetailLines)        
            leaseSet.add(dueDetailLine.cllease__Contract__c);

        List<cllease__lease_account__c> leaseList = new List<cllease__Lease_Account__c>();
        leaseList = [select cllease__Commencement_Date__c
                     from cllease__lease_Account__c
                     where id in: leaseSet
                    ];
        Map<Id,DateTime> leaseMap = new Map<Id,DateTime>();
        for (cllease__lease_account__c l:leaseList)
            leaseMap.put(l.id,l.cllease__Commencement_Date__c);

        // Entering Due Detail lines details    
        for(cllease__Due_Detail_Lines__c dueDetailLine : dueDetailLines) {
            // Calculating the Length of Contract from first payment date to maturity date
            startDate = dueDetailLine.cllease__Bill__r.cllease__Lease_Account__r.cllease__First_Payment_Date__c;
            endDate   = dueDetailLine.cllease__Bill__r.cllease__Lease_Account__r.cllease__Maturity_Date__c;
            lengthOfContract = startDate.daysBetween(endDate);
            //really commencement date from query....
            DateTime bookDateTime = leaseMap.get(dueDetailLine.cllease__Contract__c).addhours(5);
            String bookDate = formatDate(bookDateTime);
            
            lineItemId = (dueDetailLine.Name != null ? dueDetailLine.Name : 'VALUE IS BLANK');
            Dom.XmlNode lineItem = invoiceRequest.addChildElement('urn:LineItem', null, null);
            lineItem.setattribute('lineItemId', lineItemId);
            // Start: Customer Tag
            Dom.XmlNode customer = lineItem.addChildElement('urn:Customer',null,null);
            // Tax Exempt Check
            Boolean isTaxExempted = false;
            // 1. Always check for Tax Exemption from Account , if not exempted check for equipment
            if(dueDetailLine.cllease__Bill__c != null
                && dueDetailLine.cllease__Bill__r.cllease__Lease_Account__c != null
                && dueDetailLine.cllease__Bill__r.cllease__Lease_Account__r.cllease__Account__c != null)  {
                // TODO: Needs to change Salesforce only support 3 levels for pulling values
                isTaxExempted = dueDetailLine.cllease__Bill__r.cllease__Lease_Account__r.cllease__Account__r.Tax_Exempt__c;
                system.debug('AccountTax Exemption :'+ isTaxExempted);
            } 
            // 2. Check for Equipment's Tax Exempt only if Account is not Exempted
            if(isTaxExempted == false 
                && dueDetailLine.cllease__Contract_Equipment__c != null){
                isTaxExempted = dueDetailLine.cllease__Contract_Equipment__r.cllease__Tax_exemption__c;
                system.debug('contract Tax Exemption: '+isTaxExempted);
            }
            
            if(isTaxExempted) {
                customer.setattribute('isTaxExempt','true');
                customer.setattribute('exemptionReasonCode','MISS');
            } else {
                customer.setattribute('isTaxExempt','false');
            }

            Dom.XmlNode destination = customer.addChildElement('urn:Destination', null, null);
            String cityValue    = (dueDetailLine.DestinationCity__c != null ? dueDetailLine.DestinationCity__c : 'VALUE IS BLANK');
            Dom.XmlNode city    = destination.addChildElement('urn:City',null,null);
            city.addTextNode(cityValue);

            String mainDivisionValue = (dueDetailLine.Destinationstate__c != null ? dueDetailLine.Destinationstate__c : 'VALUE IS BLANK');
            Dom.XmlNode mainDivision = destination.addChildElement('urn:MainDivision',null,null);
            mainDivision.addTextNode(mainDivisionValue);

            String zipCodeValue  = (dueDetailLine.DestinationzipCode__c != null ? dueDetailLine.DestinationzipCode__c : 'VALUE IS BLANK');
            Dom.XmlNode zipCode  = destination.addChildElement('urn:PostalCode',null,null);
            zipCode.addTextNode(zipCodeValue);
            // End: Customer Tag

            // Product Tag
            String productValue = (dueDetailLine.cllease__Contract_Equipment__r.GARD__c!=null?dueDetailLine.cllease__Contract_Equipment__r.GARD__c:'VALUE IS BLANK');
            lineItem.addChildElement('urn:Product',null,null).addTextNode(productValue);
            
            // ExtendedPrice Tag
            Decimal ddlAmount = (dueDetailLine.cllease__Rental_Due_Amount__c !=null ? dueDetailLine.cllease__Rental_Due_Amount__c : 0.00);
            ddlAmount = cllease.ValueUtil.round(ddlAmount, 2 , 'Nearest');
            String extdPrice = String.valueof(ddlAmount);
            lineItem.addChildElement('urn:ExtendedPrice',null,null).addTextNode(extdPrice);
            
            // Start: FlexibleFields Tag
            // Start: FlexibleCodeField Tag
            Dom.XmlNode FFields =  lineItem.addChildElement('urn:FlexibleFields',null,null);
            Dom.XmlNode ffield1 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield1.setattribute('fieldId','1');
            ffield1.addTextNode(transCodev);
            Dom.XmlNode ffield2 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield2.setattribute('fieldId','2');
            ffield2.addTextNode(contrTypev);
            Dom.XmlNode ffield3 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield3.setattribute('fieldId','3');
            ffield3.addTextNode(taxPmtTypev);
            Dom.XmlNode ffield4 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield4.setattribute('fieldId','4');
            ffield4.addTextNode(leaseTypev);
            Dom.XmlNode ffield5 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield5.setattribute('fieldId','5');
            ffield5.addTextNode(titleTxfrv);
            Dom.XmlNode ffield6 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield6.setattribute('fieldId','6');
            ffield6.addTextNode(taxBasisv);
            Dom.XmlNode ffield7 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield7.setattribute('fieldId','7');
            ffield7.addTextNode(intDisclv);
            Dom.XmlNode ffield8 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield8.setattribute('fieldId','8');
            ffield8.addTextNode(vendPaidv);
            Dom.XmlNode ffield9 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield9.setattribute('fieldId','9');
            ffield9.addTextNode('CLS-cllease__Due_Detail_Lines__c');
            assetNumber = (dueDetailLine.cllease__Contract_Equipment__c != null ? dueDetailLine.cllease__Contract_Equipment__r.Name :'VALUE IS BLANK');
            Dom.XmlNode ffield10 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield10.setattribute('fieldId','10');
            ffield10.addTextNode(assetNumber);
            Dom.XmlNode ffield11 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield11.setattribute('fieldId','11');
            ffield11.addTextNode('0');
            Dom.XmlNode ffield12 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield12.setattribute('fieldId','12');
            ffield12.addTextNode('0');
            Dom.XmlNode ffield13 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield13.setattribute('fieldId','13');
            ffield13.addTextNode(alev);
            Dom.XmlNode ffield14 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield14.setattribute('fieldId','14');
            ffield14.addTextNode(slbc);
            String duetype = (dueDetailLine.cllease__Bill__r.cllease__Due_Type_Description__c != null ? dueDetailLine.cllease__Bill__r.cllease__Due_Type_Description__c : 'VALUE IS BLANK');
            Dom.XmlNode ffield15 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield15.setattribute('fieldId','15');
            ffield15.addTextNode(duetype);
            Dom.XmlNode ffield16 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield16.setattribute('fieldId','16');
            ffield16.addTextNode(reqReasonv);
            contractName = (dueDetailLine.cllease__Bill__r.cllease__Lease_Account__r.Name != null ? dueDetailLine.cllease__Bill__r.cllease__Lease_Account__r.Name : 'VALUE IS BLANK');
            Dom.XmlNode ffield17 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield17.setattribute('fieldId','17');
            ffield17.addTextNode(contractName);
            Dom.XmlNode ffield18 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield18.setattribute('fieldId','18');
            ffield18.addTextNode(upTaxAmtv);
            // End: FlexibleCodeField Tag

            // Start: FlexibleNumericField Tag
            Dom.XmlNode ffield21 = FFields.addChildElement('urn:FlexibleNumericField',null,null);
            ffield21.setattribute('fieldId','1');
            ffield21.addTextNode(String.valueOf(lengthOfContract));
            Dom.XmlNode ffield22 = FFields.addChildElement('urn:FlexibleNumericField',null,null);
            ffield22.setattribute('fieldId','2');
            ffield22.addTextNode(cumulTaxv);
            Dom.XmlNode ffield23 = FFields.addChildElement('urn:FlexibleNumericField',null,null);
            ffield23.setattribute('fieldId','3');
            ffield23.addTextNode(slbPaidv);
            Dom.XmlNode ffield24 = FFields.addChildElement('urn:FlexibleNumericField',null,null);
            ffield24.setattribute('fieldId','4');
            ffield24.addTextNode(qtpCodev);
            Dom.XmlNode ffield25 = FFields.addChildElement('urn:FlexibleNumericField',null,null);
            ffield25.setattribute('fieldId','5');
            ffield25.addTextNode(qrsCodev);
            // End: FlexibleNumericField Tag

            // FlexibleDateField Tag
            Dom.XmlNode ffield31 = FFields.addChildElement('urn:FlexibleDateField',null,null);
            ffield31.setattribute('fieldId','1');
            ffield31.addTextNode(bookDate);
            
        }

        String req = scdoc.toXmlString();
        System.debug(LoggingLevel.ERROR, ' Request Str for DueDetailLine: '+ req);

        return scdoc;
    }
        
    /**
     *  Following method helps in forming xml for Charge Details
     **/  
    public static Dom.Document getChargesXml(List<cllease__Charge__c> charges) {
          
        // Getting Vertex API Configuration from customerom settings
        VertexApi__c vertexConfig = CLSCustomUtil.getVertexConfiguration();
        validateVertexConfig(vertexConfig);

        System.debug(LoggingLevel.ERROR, ' Vertex Configuration: ' + vertexConfig);

        String soapNS  = (vertexConfig.soapNS__c != null ? vertexConfig.soapNS__c : 'http://schemas.xmlsoap.org/soap/envelope/');
        String xsi     = (vertexConfig.XSI__c != null ? vertexConfig.XSI__c : 'urn:vertexinc:o-series:tps:8:0');

        DateTime currentSystemDate  =   cllease.SystemDateUtil.getCurrentSystemDate();
        String currentSystemDateStr =   formatDate(currentSystemDate);

        //Creating XML Formation Starts here
        String contractName, contractDate, contractTerm, contractType, transactionCode, taxPaymentType; 
        String dueAmount, assetNumber, lineItemId;

        Dom.Document scdoc = new Dom.Document();
        Dom.XmlNode envelope = scdoc.createRootElement('Envelope', soapNS, 'soapenv');
        envelope.setNamespace('urn', xsi);
            
        Dom.XmlNode header = envelope.addChildElement('Header', soapNS, null);
            
        Dom.XmlNode body = envelope.addChildElement('Body', soapNS, null);
        Dom.XmlNode vertexEnvelope = body.addChildElement('urn:VertexEnvelope', xsi, '');
        vertexEnvelope.setNamespace('xsi','http://www.w3.org/2001/XMLSchema-instance');

        Dom.XmlNode login =  vertexEnvelope.addChildElement('urn:Login', null,null);
        Dom.XmlNode uid =   login.addChildElement('urn:UserName',null,null).addTextNode(vertexConfig.Username__c);
        Dom.XmlNode pwd =   login.addChildElement('urn:Password', null,null).addTextNode(vertexConfig.Password__c);
            
        Dom.XmlNode invoiceRequest = vertexEnvelope.addChildElement('urn:InvoiceRequest',null,null);
        invoiceRequest.setattribute('documentDate',currentSystemDateStr);
        invoiceRequest.setattribute('transactionType','LEASE');
            
        Dom.XmlNode seller  =  invoiceRequest.addChildElement('urn:Seller',null,null);
        seller.addChildElement('urn:Company',null,null).addTextNode(vertexConfig.Company__c);
        seller.addChildElement('urn:Division',null,null).addTextNode(vertexConfig.Division__c);

        Date startDate, endDate;
        Integer lengthOfContract;
        set<ID> leaseSet = new Set<ID>();
        for(cllease__Charge__c charge : charges)        
            leaseSet.add(charge.cllease__lease_account__c);

        List<cllease__lease_account__c> leaseList = new List<cllease__Lease_Account__c>();
        leaseList = [select  cllease__Commencement_Date__c
                     from cllease__lease_Account__c
                     where id in: leaseSet
                    ];
        Map<Id,DateTime> leaseMap = new Map<Id,DateTime>();
        for (cllease__lease_account__c l:leaseList)
            leaseMap.put(l.id,l.cllease__Commencement_Date__c);

        for(cllease__Charge__c charge : charges){
            // Calculating Length of contract
            startDate = charge.cllease__Lease_Account__r.cllease__First_Payment_Date__c;
            endDate   = charge.cllease__Lease_Account__r.cllease__Maturity_Date__c;
             //really commencement date from query....
            DateTime bookDateTime = leaseMap.get(charge.cllease__lease_account__c).addHours(5);
            String bookdate = formatDate(bookDateTime);
            

            lengthOfContract = startDate.daysBetween(endDate);


            lineItemId= (charge.Name!=null?charge.Name:'VALUE IS BLANK');
            Dom.XmlNode lineItem   =   invoiceRequest.addChildElement('urn:LineItem',null,null);
            lineItem.setattribute('lineItemId',lineItemId);
                                                     
            // Start: Customer Tag      
            Dom.XmlNode customer    =   lineItem.addChildElement('urn:Customer',null,null);

            // Tax Exempt Check
            Boolean isTaxExempted = false;
            // 1. Always check for Tax Exemption from Account , if not exempted check for equipment
            if(charge.cllease__Lease_Account__c != null
                && charge.cllease__Lease_Account__r.cllease__Account__c != null)  {
                // TODO: Needs to change Salesforce only support 3 levels for pulling values
                isTaxExempted = charge.cllease__Lease_Account__r.cllease__Account__r.Tax_Exempt__c;
                system.debug('Charge AccountTax Exemption :'+ isTaxExempted);
            } 
            // 2. Check for Equipment's Tax Exempt only if Account is not Exempted
            if(isTaxExempted == false
                && charge.cllease__Contract_Equipment__c != null){
                isTaxExempted = charge.cllease__Contract_Equipment__r.cllease__Tax_exemption__c;
                system.debug('Charge contract Tax Exemption: '+isTaxExempted);
            }
            
            if(isTaxExempted) {
                customer.setattribute('isTaxExempt','true');
                customer.setattribute('exemptionReasonCode','MISS');
            } else {
                customer.setattribute('isTaxExempt','false');
            }

            Dom.XmlNode destination = customer.addChildElement('urn:Destination', null, null);
            String cityValue    = (charge.DestinationCity__c != null ? charge.DestinationCity__c : 'VALUE IS BLANK');
            Dom.XmlNode city    = destination.addChildElement('urn:City',null,null);
            city.addTextNode(cityValue);

            String mainDivisionValue = (charge.Destinationstate__c != null ? charge.Destinationstate__c : 'VALUE IS BLANK');
            Dom.XmlNode mainDivision = destination.addChildElement('urn:MainDivision',null,null);
            mainDivision.addTextNode(mainDivisionValue);

            String zipCodeValue  = (charge.DestinationZipCode__c != null ? charge.DestinationZipCode__c : 'VALUE IS BLANK');
            Dom.XmlNode zipCode  = destination.addChildElement('urn:PostalCode',null,null);
            zipCode.addTextNode(zipCodeValue);
            // End: Customer Tag

            // Product Tag
            String productValue = (charge.cllease__Contract_Equipment__r.GARD__c != null ? charge.cllease__Contract_Equipment__r.GARD__c : 'VALUE IS BLANK');
            lineItem.addChildElement('urn:Product',null,null).addTextNode(productValue);

            // ExtendedPrice Tag
            Decimal chargeAmount = (charge.cllease__Original_Amount__c !=null ? charge.cllease__Original_Amount__c : 0.00);
            chargeAmount = cllease.ValueUtil.round(chargeAmount, 2 , 'Nearest');
            String extdPrice = String.valueof(chargeAmount);
            lineItem.addChildElement('urn:ExtendedPrice',null,null).addTextNode(extdPrice);

            // Start: FlexibleFields Tag
            // Start: FlexibleCodeField Tag
            Dom.XmlNode FFields =  lineItem.addChildElement('urn:FlexibleFields',null,null);
            Dom.XmlNode ffield1 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield1.setattribute('fieldId','1');
            ffield1.addTextNode(transCodev);
            Dom.XmlNode ffield2 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield2.setattribute('fieldId','2');
            ffield2.addTextNode(contrTypev);
            Dom.XmlNode ffield3 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield3.setattribute('fieldId','3');
            ffield3.addTextNode(taxPmtTypev);
            Dom.XmlNode ffield4 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield4.setattribute('fieldId','4');
            ffield4.addTextNode(leaseTypev);
            Dom.XmlNode ffield5 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield5.setattribute('fieldId','5');
            ffield5.addTextNode(titleTxfrv);
            Dom.XmlNode ffield6 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield6.setattribute('fieldId','6');
            ffield6.addTextNode(taxBasisv);
            Dom.XmlNode ffield7 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield7.setattribute('fieldId','7');
            ffield7.addTextNode(intDisclv);
            Dom.XmlNode ffield8 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield8.setattribute('fieldId','8');
            ffield8.addTextNode(vendPaidv);
            Dom.XmlNode ffield9 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield9.setattribute('fieldId','9');
            ffield9.addTextNode('CLS-cllease__Charge__c');
            assetNumber = (charge.cllease__Contract_Equipment__r.Name != null ? charge.cllease__Contract_Equipment__r.Name : 'VALUE IS BLANK');
            Dom.XmlNode ffield10 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield10.setattribute('fieldId','10');
            ffield10.addTextNode(assetNumber);
            Dom.XmlNode ffield11 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield11.setattribute('fieldId','11');
            ffield11.addTextNode('0');
            Dom.XmlNode ffield12 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield12.setattribute('fieldId','12');
            ffield12.addTextNode('0');
            Dom.XmlNode ffield13 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield13.setattribute('fieldId','13');
            ffield13.addTextNode(alev);
            Dom.XmlNode ffield14 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield14.setattribute('fieldId','14');
            ffield14.addTextNode(slbc);
            String txnService = (charge.cllease__Fee_Definition__r.Name != null ? charge.cllease__Fee_Definition__r.name : 'VALUE IS BLANK');
            Dom.XmlNode ffield15 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield15.setattribute('fieldId','15');
            ffield15.addTextNode(txnService);
            Dom.XmlNode ffield16 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield16.setattribute('fieldId','16');
            ffield16.addTextNode(reqReasonv);
            contractName = (charge.cllease__Lease_Account__r.Name != null? charge.cllease__Lease_Account__r.Name :'VALUE IS BLANK');
            Dom.XmlNode ffield17 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield17.setattribute('fieldId','17');
            ffield17.addTextNode(contractName);
            Dom.XmlNode ffield18 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield18.setattribute('fieldId','18');
            ffield18.addTextNode(upTaxAmtv);
            // End: FlexibleCodeField Tag

            // Start: FlexibleNumericField Tag
            Dom.XmlNode ffield21 = FFields.addChildElement('urn:FlexibleNumericField',null,null);
            ffield21.setattribute('fieldId','1');
            ffield21.addTextNode(String.valueOf(lengthOfContract));
            Dom.XmlNode ffield22 = FFields.addChildElement('urn:FlexibleNumericField',null,null);
            ffield22.setattribute('fieldId','2');
            ffield22.addTextNode(cumulTaxv);
            Dom.XmlNode ffield23 = FFields.addChildElement('urn:FlexibleNumericField',null,null);
            ffield23.setattribute('fieldId','3');
            ffield23.addTextNode(slbPaidv);
            Dom.XmlNode ffield24 = FFields.addChildElement('urn:FlexibleNumericField',null,null);
            ffield24.setattribute('fieldId','4');
            ffield24.addTextNode(qtpCodev);
            Dom.XmlNode ffield25 = FFields.addChildElement('urn:FlexibleNumericField',null,null);
            ffield25.setattribute('fieldId','5');
            ffield25.addTextNode(qrsCodev);
            // End: FlexibleNumericField Tag

            // FlexibleDateField Tag
            Dom.XmlNode ffield31 = FFields.addChildElement('urn:FlexibleDateField',null,null);
            ffield31.setattribute('fieldId','1');
            ffield31.addTextNode(bookDate);
        }
        String req = scdoc.toXmlString();
        System.debug(LoggingLevel.ERROR, ' Request Str for Charge: '+ req);

        return scdoc;
    } 

    // This method newly added for calculating Vertex Upfront tax by Q2/CLS
    /**********************************************************************************************************************
    *  UPFRONT XML QUOTE
    *******************************************************************************************************************************/
    public static Dom.Document getUpfrontXml(list<genesis__Application_Equipment__c> appEqpList) { 
           

         /*-------------- Modified By: Tesh -------------------- */
        //1. get rate factor from Applications
        Decimal appEqpListRate_Factor=[SELECT Id, Rate_Factor__c FROM genesis__Applications__c WHERE id =:appEqpList[0].genesis__Application__c LIMIT 1].Rate_Factor__c;
        
        //Payment stream
        Decimal totalSellingPrice = 0.0;
        Decimal totalGrossReceivable;
        Decimal totalrentAmount=0.0;
        Decimal totalFeeamount=0.0;
        Decimal tradeupAmount=0.0;
        List<genesis__Payment_Stream__c> paymentStreams = [Select id, genesis__Application__c, genesis__Number_of_Payments__c, genesis__Payment_Amount__c from genesis__Payment_Stream__c where genesis__Application__c = :appEqpList[0].genesis__Application__c];
        for(genesis__Payment_Stream__c payStr : paymentStreams) {
            totalrentAmount = totalrentAmount + (payStr.genesis__Number_of_Payments__c * payStr.genesis__Payment_Amount__c);
        }
        System.debug('totalrentAmount==' +totalrentAmount);
    //Application fee 
        List<Application_Fee__c> aplliFeeList= [Select id, Application__c, Fee__r.clcommon__Fee_Type__c, Number_of_Payments__c, Amount__c from Application_Fee__c where Application__c = :appEqpList[0].genesis__Application__c AND Fee__r.clcommon__Fee_Type__c includes('Passthrough')];
        for(Integer i=0; i<aplliFeeList.size(); i++) {
    
         totalFeeamount = totalFeeamount + (aplliFeeList[i].Number_of_Payments__c * aplliFeeList[i].Amount__c);
    
        }
        System.debug('totalFeeamount==' +totalFeeamount);
        totalGrossReceivable=totalrentAmount+totalFeeamount;
        
        System.debug('totalGrossReceivable='+totalGrossReceivable);
       /* for(genesis__Application_Equipment__c appEquip1 : appEqpList) {
        tradeupAmount = tradeupAmount+appEquip1.Oracle_Trade_Up_Amount__c;
    
    }*/
        
        for(genesis__Application_Equipment__c appEquip : appEqpList) {
        totalSellingPrice += appEquip.genesis__Estimated_Selling_Price__c;
    
    }
        System.debug('totalSellingPrice='+totalSellingPrice);
        System.debug('tradeupAmount='+tradeupAmount);
        /*-------------------------------------------------------------------*/
        // Getting Vertex API Configuration from customerom settings & Validating
        VertexApi__c vertexConfig = CLSCustomUtil.getVertexConfiguration();
        validateVertexConfig(vertexConfig);

        System.debug(LoggingLevel.ERROR, ' Vertex Configuration: ' + vertexConfig);        

        String soapNS  = (vertexConfig.soapNS__c != null ? vertexConfig.soapNS__c : 'http://schemas.xmlsoap.org/soap/envelope/');
        String xsi     = (vertexConfig.XSI__c != null ? vertexConfig.XSI__c : 'urn:vertexinc:o-series:tps:8:0');

       // DateTime currentSystemDate  =   cllease.SystemDateUtil.getCurrentSystemDate();
        DateTime Commencementdate  = appEqpList[0].genesis__Application__r.genesis__Expected_Start_Date__c;
        String CommencementdateStr =   formatDate(Commencementdate);
            
        //Creating XML Formation Starts here
        String AppliNumber, contractDate, contractTerm, contractType, transactionCode, taxPaymentType; 
        String dueAmount, assetNumber, lineItemId;

        // Creating DOM for XML
        Dom.Document scdoc = new Dom.Document();
        Dom.XmlNode envelope = scdoc.createRootElement('Envelope', soapNS, 'soapenv');
        envelope.setNamespace('urn', xsi);
        
        Dom.XmlNode header = envelope.addChildElement('Header', soapNS, null);
        
        Dom.XmlNode body = envelope.addChildElement('Body', soapNS, null);
        Dom.XmlNode vertexEnvelope = body.addChildElement('urn:VertexEnvelope',xsi,'');
        vertexEnvelope.setNamespace('xsi','http://www.w3.org/2001/XMLSchema-instance');
            
        Dom.XmlNode login =  vertexEnvelope.addChildElement('urn:Login', null,null);
        Dom.XmlNode uid =   login.addChildElement('urn:UserName',null,null).addTextNode(vertexConfig.Username__c);
        Dom.XmlNode pwd =   login.addChildElement('urn:Password', null,null).addTextNode(vertexConfig.Password__c);
            
        Dom.XmlNode invoiceRequest = vertexEnvelope.addChildElement('urn:QuotationRequest',null,null);
        invoiceRequest.setattribute('documentDate',CommencementdateStr);
        invoiceRequest.setattribute('transactionType','LEASE');
            
        Dom.XmlNode seller  =  invoiceRequest.addChildElement('urn:Seller',null,null);
        seller.addChildElement('urn:Company',null,null).addTextNode(vertexConfig.Company__c);
        seller.addChildElement('urn:Division',null,null).addTextNode(vertexConfig.Division__c);
        
        Date startDate, endDate;
        Integer lengthOfContract;
        // Entering Application Equipment details    
         list<genesis__Application_Equipment__c> equpmentlist = new list<genesis__Application_Equipment__c>();
         for(genesis__Application_Equipment__c appEqp : appEqpList) {
             
            // Calculating the Length of Contract from first payment date to maturity date
            //startDate =appEqp.genesis__Application__r.genesis__Expected_Start_Date__c;
            //system.debug('start date'+startDate) ;
            //endDate   = appEqp.genesis__Application__r.genesis__Expected_Close_Date__c;
            // end date going to check calculation
            // DateTime currentSystemDate  =   cllease.SystemDateUtil.getCurrentSystemDate();
            System.debug('*****appFirstPAYEMNTDATE'+appEqp.genesis__Application__r.genesis__Expected_Start_Date__c);
            Date appFirstPmtDate = appEqp.genesis__Application__r.genesis__Expected_Start_Date__c;
            System.debug('****pmtFrequency********'+appEqp.genesis__Application__r.genesis__Payment_Frequency__c);
            String pmtFrequency = appEqp.genesis__Application__r.genesis__Payment_Frequency__c;
            System.debug('****genesisterm'+appEqp.genesis__Application__r.genesis__Term__c);
            Decimal term = appEqp.genesis__Application__r.genesis__Term__c;

            endDate = cllease.DateUtil.getNextCycleDate(appFirstPmtDate,
                                                           appFirstPmtDate.day(),
                                                           pmtFrequency,
                                                           (Integer)term, true);
            system.debug('emd date'+endDate) ;
            lengthOfContract = appFirstPmtDate.daysBetween(endDate);
            system.debug('length in days'+lengthOfContract);

            lineItemId = (appEqp.id != null ? appEqp.id : 'VALUE IS BLANK');
            Dom.XmlNode lineItem = invoiceRequest.addChildElement('urn:LineItem', null, null);
            lineItem.setattribute('lineItemId', lineItemId);
            // Start: Customer Tag
            Dom.XmlNode customer = lineItem.addChildElement('urn:Customer',null,null);

            // Tax Exemption 
            Boolean isTaxExempted = false;
            // 1. Always check for Tax Exemption from Account , if not exempted check for equipment
            if(appEqp.genesis__Application__c != null
                && appEqp.genesis__Application__r.genesis__Account__c != null)  {
                // TODO: Needs to change Salesforce only support 3 levels for pulling values
                isTaxExempted = appEqp.genesis__Application__r.genesis__Account__r.Tax_Exempt__c;
                system.debug('AccountTax Exemption :'+ isTaxExempted);
            } 
            // 2. Check for Equipment's Tax Exempt only if Account is not Exempted
            if(isTaxExempted == false){
                isTaxExempted = appEqp.Tax_Exempt__c;
                system.debug('Equipment Tax Exemption: '+isTaxExempted);
            }
            
            if(isTaxExempted) {
                customer.setattribute('isTaxExempt','true');
                customer.setattribute('exemptionReasonCode','MISS');
            } else {
                customer.setattribute('isTaxExempt','false');
            }

            Dom.XmlNode destination = customer.addChildElement('urn:Destination', null, null);
            String cityValue    =  (appEqp.Install_Address1__r.City__c != null ? appEqp.Install_Address1__r.City__c : 'VALUE IS BLANK');
            Dom.XmlNode city    = destination.addChildElement('urn:City',null,null);
            city.addTextNode(cityValue);

            String mainDivisionValue = (appEqp.Install_Address1__r.State__c != null ? appEqp.Install_Address1__r.State__c : 'VALUE IS BLANK');
            Dom.XmlNode mainDivision = destination.addChildElement('urn:MainDivision',null,null);
            mainDivision.addTextNode(mainDivisionValue);

            String zipCodeValue  = (appEqp.Install_Address1__r.Zip_Code__c != null ? appEqp.Install_Address1__r.Zip_Code__c : 'VALUE IS BLANK');
            Dom.XmlNode zipCode  = destination.addChildElement('urn:PostalCode',null,null);
            zipCode.addTextNode(zipCodeValue);
            // End: Customer Tag

            // Product name value is GARD__c value in application equipment
            String productValue = (appEqp.GARD_Code__c != null ? appEqp.GARD_code__c : 'VALUE IS BLANK');
            lineItem.addChildElement('urn:Product',null,null).addTextNode(productValue);
            
            // ExtendedPrice Tag
            Decimal ddlAmount = (appEqp.genesis__Estimated_Selling_Price__c !=null ? appEqp.genesis__Estimated_Selling_Price__c : 0.00);
            ddlAmount = cllease.ValueUtil.round(ddlAmount, 2 , 'Nearest');
            /* Modified By Tesh--------------*/
            
            //The Fair Markert Value without the trade up portion of the rent
            system.debug('=====' + (appEqp.genesis__Estimated_Selling_Price__c * totalGrossReceivable) / totalSellingPrice);
            Decimal fairMartValue = (appEqp.genesis__Estimated_Selling_Price__c * totalGrossReceivable) / totalSellingPrice;
            system.debug('fairMartValue = ' + fairMartValue);
            fairMartValue = cllease.ValueUtil.round(fairMartValue, 2 , 'Nearest'); 
            system.debug('fairMartValue====' + fairMartValue);
            String fairMarketvalue = String.valueof(fairMartValue);
            system.debug('fairMarketvalue====' + fairMarketvalue);
             
            //3. set the The extended Price value as a product of Rate_Factor__c * genesis__Estimated_Selling_Price__c
            Decimal newExtendedPrice;
            if(appEqpListRate_Factor!= null){
               // newExtendedPrice=ddlAmount*tmpRate;
                newExtendedPrice=ddlAmount*appEqpListRate_Factor;
                newExtendedPrice= cllease.ValueUtil.round(newExtendedPrice, 2 , 'Nearest');
            }else {
                newExtendedPrice=0.00;
            }
            String strExtendedPrice = String.valueof(newExtendedPrice);           
           

            /*-----------------------------*/
            String extdPrice = String.valueof(ddlAmount);
             
            lineItem.addChildElement('urn:FairMarketValue',null,null).addTextNode(fairMarketvalue);
            lineItem.addChildElement('urn:ExtendedPrice',null,null).addTextNode(strExtendedPrice);
            lineItem.addChildElement('urn:Cost',null,null).addTextNode(extdPrice);
          
             
            // calculating Purchase Options flag details
            if(appEqp.genesis__Application__r.Purchase_Option__c == 'Fair Market Value') {
                contrTypev  = 'FMV';
                leaseTypev  = 'A';
            } else if(appEqp.genesis__Application__r.Purchase_Option__c == 'One Dollar Buyout') {
                contrTypev  = 'CSC';
                leaseTypev  = 'D';
            }
            
            // Start: FlexibleCodeField Tag
            Dom.XmlNode FFields =  lineItem.addChildElement('urn:FlexibleFields',null,null);
            Dom.XmlNode ffield1 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield1.setattribute('fieldId','1');
            ffield1.addTextNode('ORIG');
            Dom.XmlNode ffield2 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield2.setattribute('fieldId','2');
            ffield2.addTextNode('FMV');
            Dom.XmlNode ffield3 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield3.setattribute('fieldId','3');
            //ffield3.addTextNode('UC');
            Dom.XmlNode ffield4 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield4.setattribute('fieldId','4');
            ffield4.addTextNode('A');
            Dom.XmlNode ffield5 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield5.setattribute('fieldId','5');
            ffield5.addTextNode('I');
            Dom.XmlNode ffield6 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield6.setattribute('fieldId','6');
            ffield6.addTextNode('N/A');
            Dom.XmlNode ffield7 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield7.setattribute('fieldId','7');
            ffield7.addTextNode('N');
            Dom.XmlNode ffield8 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield8.setattribute('fieldId','8');
            ffield8.addTextNode('N');
            Dom.XmlNode ffield9 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield9.setattribute('fieldId','9');
            ffield9.addTextNode('CLS-genesis__Application_Equipment__c');
            assetNumber = (appEqp.Serial_Number__c != null ? appEqp.Serial_Number__c :'VALUE IS BLANK');
            Dom.XmlNode ffield10 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield10.setattribute('fieldId','10');
            ffield10.addTextNode(assetNumber);
            Dom.XmlNode ffield11 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield11.setattribute('fieldId','11');
            ffield11.addTextNode('0');
            Dom.XmlNode ffield12 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield12.setattribute('fieldId','12');
            ffield12.addTextNode('0');
            Dom.XmlNode ffield13 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield13.setattribute('fieldId','13');
            ffield13.addTextNode('');
            Dom.XmlNode ffield14 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield14.setattribute('fieldId','14');
            ffield14.addTextNode('F');
            String duetype = (appEqp.name != null ? appEqp.name : 'VALUE IS BLANK');
            Dom.XmlNode ffield15 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield15.setattribute('fieldId','15');
            ffield15.addTextNode(appEqp.Name);
            Dom.XmlNode ffield16 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield16.setattribute('fieldId','16');
            ffield16.addTextNode('BOOKING');
            AppliNumber = (appEqp.genesis__Application__r.Name != null ? appEqp.genesis__Application__r.Name : 'VALUE IS BLANK');
            Dom.XmlNode ffield17 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield17.setattribute('fieldId','17');
            ffield17.addTextNode(AppliNumber);
            Dom.XmlNode ffield18 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield18.setattribute('fieldId','18');
            ffield18.addTextNode('0');
            // End: FlexibleCodeField Tag

            // Start: FlexibleNumericField Tag
            /*Integer LengthofAppContract ;
            Date sdate=appEqp.genesis__Application__r.genesis__Expected_Start_Date__c;
            system.debug('starttttt date'+sdate); 
            Date mdate=appEqp.genesis__Application__r.genesis__Expected_Close_Date__c; 
            system.debug('Closeeee date'+sdate); 
            LengthofAppContract = sdate.daysBetween(Date.valueOf(mdate));
            System.debug('lengthhhhhhhh of contract'+LengthofAppContract) ;*/

            Date sdate=appEqp.genesis__Application__r.genesis__Expected_Start_Date__c;
            
            Dom.XmlNode ffield21 = FFields.addChildElement('urn:FlexibleNumericField',null,null);
            ffield21.setattribute('fieldId','1');
            ffield21.addTextNode(String.valueOf(lengthOfContract));
            Dom.XmlNode ffield22 = FFields.addChildElement('urn:FlexibleNumericField',null,null);
            ffield22.setattribute('fieldId','2');
            ffield22.addTextNode(cumulTaxv);
            Dom.XmlNode ffield23 = FFields.addChildElement('urn:FlexibleNumericField',null,null);
            ffield23.setattribute('fieldId','3');
            ffield23.addTextNode(slbPaidv);
            Dom.XmlNode ffield24 = FFields.addChildElement('urn:FlexibleNumericField',null,null);
            ffield24.setattribute('fieldId','4');
            ffield24.addTextNode(qtpCodev);
            Dom.XmlNode ffield25 = FFields.addChildElement('urn:FlexibleNumericField',null,null);
            ffield25.setattribute('fieldId','5');
            ffield25.addTextNode(qrsCodev);
            // End: FlexibleNumericField Tag

            // FlexibleDateField Tag
            string appsdate = formatDate(sdate);
            Dom.XmlNode ffield31 = FFields.addChildElement('urn:FlexibleDateField',null,null);
            ffield31.setattribute('fieldId','1');
            ffield31.addTextNode(appsdate);
            
        }
        For(Integer i=0; i<appEqpList.size(); i++){
            System.debug('*****appFirstPAYEMNTDATE'+appEqpList[i].genesis__Application__r.genesis__Expected_Start_Date__c);
            Date appFirstPmtDate = appEqpList[i].genesis__Application__r.genesis__Expected_Start_Date__c;
            System.debug('****pmtFrequency********'+appEqpList[i].genesis__Application__r.genesis__Payment_Frequency__c);
            String pmtFrequency = appEqpList[i].genesis__Application__r.genesis__Payment_Frequency__c;
            System.debug('****genesisterm'+appEqpList[i].genesis__Application__r.genesis__Term__c);
            Decimal term = appEqpList[i].genesis__Application__r.genesis__Term__c;

            endDate = cllease.DateUtil.getNextCycleDate(appFirstPmtDate,
                                                           appFirstPmtDate.day(),
                                                           pmtFrequency,
                                                           (Integer)term, true);
            system.debug('emd date'+endDate) ;
            lengthOfContract = appFirstPmtDate.daysBetween(endDate);
            system.debug('length in days'+lengthOfContract);

            lineItemId = (appEqpList[i].id != null ? appEqpList[i].id : 'VALUE IS BLANK');
            Dom.XmlNode lineItem = invoiceRequest.addChildElement('urn:LineItem', null, null);
            lineItem.setattribute('lineItemId', lineItemId);
            // Start: Customer Tag
            Dom.XmlNode customer = lineItem.addChildElement('urn:Customer',null,null);

            // Tax Exemption 
            Boolean isTaxExempted = false;
            // 1. Always check for Tax Exemption from Account , if not exempted check for equipment
            if(appEqpList[i].genesis__Application__c != null
                && appEqpList[i].genesis__Application__r.genesis__Account__c != null)  {
                // TODO: Needs to change Salesforce only support 3 levels for pulling values
                isTaxExempted = appEqpList[i].genesis__Application__r.genesis__Account__r.Tax_Exempt__c;
                system.debug('AccountTax Exemption :'+ isTaxExempted);
            } 
            // 2. Check for Equipment's Tax Exempt only if Account is not Exempted
            if(isTaxExempted == false){
                isTaxExempted = appEqpList[i].Tax_Exempt__c;
                system.debug('Equipment Tax Exemption: '+isTaxExempted);
            }
            
            if(isTaxExempted) {
                customer.setattribute('isTaxExempt','true');
                customer.setattribute('exemptionReasonCode','MISS');
            } else {
                customer.setattribute('isTaxExempt','false');
            }

            Dom.XmlNode destination = customer.addChildElement('urn:Destination', null, null);
            String cityValue    =  (appEqpList[i].Install_Address1__r.City__c != null ? appEqpList[i].Install_Address1__r.City__c : 'VALUE IS BLANK');
            Dom.XmlNode city    = destination.addChildElement('urn:City',null,null);
            city.addTextNode(cityValue);

            String mainDivisionValue = (appEqpList[i].Install_Address1__r.State__c != null ? appEqpList[i].Install_Address1__r.State__c : 'VALUE IS BLANK');
            Dom.XmlNode mainDivision = destination.addChildElement('urn:MainDivision',null,null);
            mainDivision.addTextNode(mainDivisionValue);

            String zipCodeValue  = (appEqpList[i].Install_Address1__r.Zip_Code__c != null ? appEqpList[i].Install_Address1__r.Zip_Code__c : 'VALUE IS BLANK');
            Dom.XmlNode zipCode  = destination.addChildElement('urn:PostalCode',null,null);
            zipCode.addTextNode(zipCodeValue);
            // End: Customer Tag

            // Product name value is GARD__c value in application equipment
            String productValue = (appEqpList[i].GARD_Code__c != null ? appEqpList[i].GARD_code__c : 'VALUE IS BLANK');
            lineItem.addChildElement('urn:Product',null,null).addTextNode(productValue);
            
            // ExtendedPrice Tag
            Decimal ddlAmount = (appEqpList[i].genesis__Estimated_Selling_Price__c !=null ? appEqpList[i].genesis__Estimated_Selling_Price__c : 0.00);
            //Decimal ddlCost=ddlAmount+tradeupAmount;           
            Decimal ddlCost=appEqpList[i].Oracle_Trade_Up_Amount__c+ddlAmount;
            ddlCost = cllease.ValueUtil.round(ddlCost, 2 , 'Nearest');
            System.debug('ddlCost==' +ddlCost);
            /* Modified By Tesh--------------*/
            
            //The Fair Markert Value without the trade up portion of the rent
            
            System.debug('====' + (appEqpList[i].genesis__Estimated_Selling_Price__c * totalGrossReceivable) / totalSellingPrice);
            Decimal fairMartValue1 = (appEqpList[i].genesis__Estimated_Selling_Price__c * totalGrossReceivable) / totalSellingPrice;
            //Decimal eqptradeUpAmount=(tradeupAmount+fairMartValue1);
            System.debug('fairMartValue1==' +fairMartValue1);
            Decimal eqptradeUpAmount=(appEqpList[i].Oracle_Trade_Up_Amount__c+fairMartValue1);
            eqptradeUpAmount = cllease.ValueUtil.round(eqptradeUpAmount, 2 , 'Nearest'); 
            System.debug('eqptradeUpAmount='+eqptradeUpAmount);
            String fairMarketvalue1 = String.valueof(eqptradeUpAmount);
            system.debug('fairMarketvalue1==' +fairMarketvalue1);
             
            //3. set the The extended Price value as a product of Rate_Factor__c * genesis__Estimated_Selling_Price__c
            Decimal newExtendedPrice1;
            if(appEqpListRate_Factor!= null){
               // newExtendedPrice=ddlAmount*tmpRate;
                //newExtendedPrice1=(ddlAmount*appEqpListRate_Factor)+tradeupAmount;
                 newExtendedPrice1=appEqpList[i].Oracle_Trade_Up_Amount__c+(ddlAmount*appEqpListRate_Factor);
                newExtendedPrice1= cllease.ValueUtil.round(newExtendedPrice1, 2 , 'Nearest');
            }else {
                newExtendedPrice1=0.00;
            }
            system.debug('newExtendedPrice1==' +newExtendedPrice1);
            String strExtendedPrice = String.valueof(newExtendedPrice1);           
           

            /*-----------------------------*/
            String extdPrice = String.valueof(ddlCost);
             
            lineItem.addChildElement('urn:FairMarketValue',null,null).addTextNode(fairMarketvalue1);
            lineItem.addChildElement('urn:ExtendedPrice',null,null).addTextNode(strExtendedPrice);
            lineItem.addChildElement('urn:Cost',null,null).addTextNode(extdPrice);
          
             
            // calculating Purchase Options flag details
            if(appEqpList[i].genesis__Application__r.Purchase_Option__c == 'Fair Market Value') {
                contrTypev  = 'FMV';
                leaseTypev  = 'A';
            } else if(appEqpList[i].genesis__Application__r.Purchase_Option__c == 'One Dollar Buyout') {
                contrTypev  = 'CSC';
                leaseTypev  = 'D';
            }
            
            // Start: FlexibleCodeField Tag
            Dom.XmlNode FFields =  lineItem.addChildElement('urn:FlexibleFields',null,null);
            Dom.XmlNode ffield1 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield1.setattribute('fieldId','1');
            ffield1.addTextNode('ORIG');
            Dom.XmlNode ffield2 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield2.setattribute('fieldId','2');
            ffield2.addTextNode('FMV');
            Dom.XmlNode ffield3 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield3.setattribute('fieldId','3');
            //ffield3.addTextNode('UC');
            Dom.XmlNode ffield4 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield4.setattribute('fieldId','4');
            ffield4.addTextNode('A');
            Dom.XmlNode ffield5 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield5.setattribute('fieldId','5');
            ffield5.addTextNode('I');
            Dom.XmlNode ffield6 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield6.setattribute('fieldId','6');
            ffield6.addTextNode('N/A');
            Dom.XmlNode ffield7 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield7.setattribute('fieldId','7');
            ffield7.addTextNode('N');
            Dom.XmlNode ffield8 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield8.setattribute('fieldId','8');
            ffield8.addTextNode('N');
            Dom.XmlNode ffield9 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield9.setattribute('fieldId','9');
            ffield9.addTextNode('CLS-genesis__Application_Equipment__c');
            assetNumber = (appEqpList[i].Serial_Number__c != null ? appEqpList[i].Serial_Number__c :'VALUE IS BLANK');
            Dom.XmlNode ffield10 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield10.setattribute('fieldId','10');
            ffield10.addTextNode(assetNumber);
            Dom.XmlNode ffield11 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield11.setattribute('fieldId','11');
            ffield11.addTextNode('0');
            Dom.XmlNode ffield12 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield12.setattribute('fieldId','12');
            ffield12.addTextNode('0');
            Dom.XmlNode ffield13 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield13.setattribute('fieldId','13');
            ffield13.addTextNode('');
            Dom.XmlNode ffield14 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield14.setattribute('fieldId','14');
            ffield14.addTextNode('F');
            String duetype = (appEqpList[i].name != null ? appEqpList[i].name : 'VALUE IS BLANK');
            Dom.XmlNode ffield15 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield15.setattribute('fieldId','15');
            ffield15.addTextNode(appEqpList[i].Name);
            Dom.XmlNode ffield16 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield16.setattribute('fieldId','16');
            ffield16.addTextNode('BOOKING');
            AppliNumber = (appEqpList[i].genesis__Application__r.Name != null ? appEqpList[i].genesis__Application__r.Name : 'VALUE IS BLANK');
            Dom.XmlNode ffield17 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield17.setattribute('fieldId','17');
            ffield17.addTextNode(AppliNumber);
            Dom.XmlNode ffield18 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield18.setattribute('fieldId','18');
            ffield18.addTextNode('0');
            // End: FlexibleCodeField Tag

            // Start: FlexibleNumericField Tag
            /*Integer LengthofAppContract ;
            Date sdate=appEqp.genesis__Application__r.genesis__Expected_Start_Date__c;
            system.debug('starttttt date'+sdate); 
            Date mdate=appEqp.genesis__Application__r.genesis__Expected_Close_Date__c; 
            system.debug('Closeeee date'+sdate); 
            LengthofAppContract = sdate.daysBetween(Date.valueOf(mdate));
            System.debug('lengthhhhhhhh of contract'+LengthofAppContract) ;*/

            Date sdate=appEqpList[i].genesis__Application__r.genesis__Expected_Start_Date__c;
            
            Dom.XmlNode ffield21 = FFields.addChildElement('urn:FlexibleNumericField',null,null);
            ffield21.setattribute('fieldId','1');
            ffield21.addTextNode(String.valueOf(lengthOfContract));
            Dom.XmlNode ffield22 = FFields.addChildElement('urn:FlexibleNumericField',null,null);
            ffield22.setattribute('fieldId','2');
            ffield22.addTextNode(cumulTaxv);
            Dom.XmlNode ffield23 = FFields.addChildElement('urn:FlexibleNumericField',null,null);
            ffield23.setattribute('fieldId','3');
            ffield23.addTextNode(slbPaidv);
            Dom.XmlNode ffield24 = FFields.addChildElement('urn:FlexibleNumericField',null,null);
            ffield24.setattribute('fieldId','4');
            ffield24.addTextNode(qtpCodev);
            Dom.XmlNode ffield25 = FFields.addChildElement('urn:FlexibleNumericField',null,null);
            ffield25.setattribute('fieldId','5');
            ffield25.addTextNode(qrsCodev);
            // End: FlexibleNumericField Tag

            // FlexibleDateField Tag
            string appsdate = formatDate(sdate);
            Dom.XmlNode ffield31 = FFields.addChildElement('urn:FlexibleDateField',null,null);
            ffield31.setattribute('fieldId','1');
            ffield31.addTextNode(appsdate);
        }
        String req = scdoc.toXmlString();
        System.debug(LoggingLevel.ERROR, ' Request Str for Application Equipment: '+ req);

        return scdoc;
    }
    

    /**********************************************************************************************************************
    *  UPFRONT XML BOOKING
    *   if not tax don't bother.
    *******************************************************************************************************************************/
    public static Dom.Document getUpfrontXmlBook(list<genesis__Application_Equipment__c> appEqpList) { 
        
         /*-------------- Modified By: Tesh  Modified  Date: 10/29/2020 -------------------- */

        //1. Get Rate Factor from Applications
        Decimal appEqpListRate_Factor=[SELECT Id, Rate_Factor__c FROM genesis__Applications__c WHERE id =:appEqpList[0].genesis__Application__c LIMIT 1].Rate_Factor__c;
       
         /*-------------------------------------------------------------------*/
        //Payment stream
        Decimal totalSellingPrice = 0.0;
        Decimal totalGrossReceivable;
        Decimal totalrentAmount=0.0;
        Decimal totalFeeamount=0.0;
        Decimal tradeupAmount=0.0;
        List<genesis__Payment_Stream__c> paymentStreams = [Select id, genesis__Application__c, genesis__Number_of_Payments__c, genesis__Payment_Amount__c from genesis__Payment_Stream__c where genesis__Application__c = :appEqpList[0].genesis__Application__c];
        for(genesis__Payment_Stream__c payStr : paymentStreams) {
            totalrentAmount = totalrentAmount + (payStr.genesis__Number_of_Payments__c * payStr.genesis__Payment_Amount__c);
        }
        System.debug('totalrentAmount==' +totalrentAmount);
        
        //Application fee 
        List<Application_Fee__c> aplliFeeList= [Select id, Application__c, Fee__r.clcommon__Fee_Type__c, Number_of_Payments__c, Amount__c from Application_Fee__c where Application__c = :appEqpList[0].genesis__Application__c AND Fee__r.clcommon__Fee_Type__c includes('Passthrough')];
        for(Integer i=0; i<aplliFeeList.size(); i++) {
    
         totalFeeamount = totalFeeamount + (aplliFeeList[i].Number_of_Payments__c * aplliFeeList[i].Amount__c);
    
        }
        System.debug('totalFeeamount==' +totalFeeamount);
        totalGrossReceivable=totalrentAmount+totalFeeamount;
        
        /*for(genesis__Application_Equipment__c appEquip1 : appEqpList) {
        tradeupAmount = tradeupAmount+appEquip1.Oracle_Trade_Up_Amount__c;  
    }*/
        
        System.debug('totalGrossReceivable='+totalGrossReceivable);
        for(genesis__Application_Equipment__c appEquip : appEqpList) {
        totalSellingPrice += appEquip.genesis__Estimated_Selling_Price__c;
    
    }
        System.debug('totalSellingPrice='+totalSellingPrice);
    
  
    
        Decimal totalTax = 0;
        for(genesis__Application_Equipment__c appEqp : appEqpList) {
            System.debug('******************** tax amount is: ' + appEqp.genesis__Tax_Amount__c);
            totalTax = totalTax + appEqp.genesis__Tax_Amount__c;
        }    

        if (totalTax == 0){
            system.debug('********************************************** no upfront tax for booking was found; returning! ***************************');
            return null;
        }


        // Getting Vertex API Configuration from customerom settings & Validating
        VertexApi__c vertexConfig = CLSCustomUtil.getVertexConfiguration();
        validateVertexConfig(vertexConfig);

        System.debug(LoggingLevel.ERROR, ' Vertex Configuration: ' + vertexConfig);        

        String soapNS  = (vertexConfig.soapNS__c != null ? vertexConfig.soapNS__c : 'http://schemas.xmlsoap.org/soap/envelope/');
        String xsi     = (vertexConfig.XSI__c != null ? vertexConfig.XSI__c : 'urn:vertexinc:o-series:tps:8:0');

       // DateTime currentSystemDate  =   cllease.SystemDateUtil.getCurrentSystemDate();
        DateTime Commencementdate  = appEqpList[0].genesis__Application__r.genesis__Expected_Start_Date__c;
        String CommencementdateStr =   formatDate(Commencementdate);
            
        //Creating XML Formation Starts here
        String AppliNumber, contractDate, contractTerm, contractType, transactionCode, taxPaymentType; 
        String dueAmount, assetNumber, lineItemId;

        // Creating DOM for XML
        Dom.Document scdoc = new Dom.Document();
        Dom.XmlNode envelope = scdoc.createRootElement('Envelope', soapNS, 'soapenv');
        envelope.setNamespace('urn', xsi);
        
        Dom.XmlNode header = envelope.addChildElement('Header', soapNS, null);
        
        Dom.XmlNode body = envelope.addChildElement('Body', soapNS, null);
        Dom.XmlNode vertexEnvelope = body.addChildElement('urn:VertexEnvelope',xsi,'');
        vertexEnvelope.setNamespace('xsi','http://www.w3.org/2001/XMLSchema-instance');
            
        Dom.XmlNode login =  vertexEnvelope.addChildElement('urn:Login', null,null);
        Dom.XmlNode uid =   login.addChildElement('urn:UserName',null,null).addTextNode(vertexConfig.Username__c);
        Dom.XmlNode pwd =   login.addChildElement('urn:Password', null,null).addTextNode(vertexConfig.Password__c);
            
        Dom.XmlNode invoiceRequest = vertexEnvelope.addChildElement('urn:DistributeTaxRequest',null,null);
        invoiceRequest.setattribute('documentDate',CommencementdateStr);
        invoiceRequest.setattribute('transactionType','LEASE');
            
        Dom.XmlNode seller  =  invoiceRequest.addChildElement('urn:Seller',null,null);
        seller.addChildElement('urn:Company',null,null).addTextNode(vertexConfig.Company__c);
        seller.addChildElement('urn:Division',null,null).addTextNode(vertexConfig.Division__c);
        
       
        

        Date startDate, endDate;
        Integer lengthOfContract;
        // Entering Application Equipment details    
         list<genesis__Application_Equipment__c> equpmentlist = new list<genesis__Application_Equipment__c>();
         for(genesis__Application_Equipment__c appEqp : appEqpList) {

            if (appEqp.genesis__Tax_Amount__c == 0)
                continue;
             
            // Calculating the Length of Contract from first payment date to maturity date
            //startDate =appEqp.genesis__Application__r.genesis__Expected_Start_Date__c;
            //system.debug('start date'+startDate) ;
            //endDate   = appEqp.genesis__Application__r.genesis__Expected_Close_Date__c;
            // end date going to check calculation
            // DateTime currentSystemDate  =   cllease.SystemDateUtil.getCurrentSystemDate();
            System.debug('*****appFirstPAYEMNTDATE'+appEqp.genesis__Application__r.genesis__Expected_Start_Date__c);
            Date appFirstPmtDate = appEqp.genesis__Application__r.genesis__Expected_Start_Date__c;
            System.debug('****pmtFrequency********'+appEqp.genesis__Application__r.genesis__Payment_Frequency__c);
            String pmtFrequency = appEqp.genesis__Application__r.genesis__Payment_Frequency__c;
            System.debug('****genesisterm'+appEqp.genesis__Application__r.genesis__Term__c);
            Decimal term = appEqp.genesis__Application__r.genesis__Term__c;

            endDate = cllease.DateUtil.getNextCycleDate(appFirstPmtDate,
                                                           appFirstPmtDate.day(),
                                                           pmtFrequency,
                                                           (Integer)term, true);
            system.debug('emd date'+endDate) ;
            lengthOfContract = appFirstPmtDate.daysBetween(endDate);
            system.debug('length in days'+lengthOfContract);

            lineItemId = (appEqp.id != null ? appEqp.id : 'VALUE IS BLANK');
            Dom.XmlNode lineItem = invoiceRequest.addChildElement('urn:LineItem', null, null);
            lineItem.setattribute('lineItemId', lineItemId);
            // Start: Customer Tag
            Dom.XmlNode customer = lineItem.addChildElement('urn:Customer',null,null);

            // Tax Exemption 
            Boolean isTaxExempted = false;
            // 1. Always check for Tax Exemption from Account , if not exempted check for equipment
            if(appEqp.genesis__Application__c != null
                && appEqp.genesis__Application__r.genesis__Account__c != null)  {
                // TODO: Needs to change Salesforce only support 3 levels for pulling values
                isTaxExempted = appEqp.genesis__Application__r.genesis__Account__r.Tax_Exempt__c;
                system.debug('AccountTax Exemption :'+ isTaxExempted);
            } 
            // 2. Check for Equipment's Tax Exempt only if Account is not Exempted
            if(isTaxExempted == false){
                isTaxExempted = appEqp.Tax_Exempt__c;
                system.debug('Equipment Tax Exemption: '+isTaxExempted);
            }
            
            if(isTaxExempted) {
                customer.setattribute('isTaxExempt','true');
                customer.setattribute('exemptionReasonCode','MISS');
            } else {
                customer.setattribute('isTaxExempt','false');
            }

            Dom.XmlNode destination = customer.addChildElement('urn:Destination', null, null);
            String cityValue    =  (appEqp.Install_Address1__r.City__c != null ? appEqp.Install_Address1__r.City__c : 'VALUE IS BLANK');
            Dom.XmlNode city    = destination.addChildElement('urn:City',null,null);
            city.addTextNode(cityValue);

            String mainDivisionValue = (appEqp.Install_Address1__r.State__c != null ? appEqp.Install_Address1__r.State__c : 'VALUE IS BLANK');
            Dom.XmlNode mainDivision = destination.addChildElement('urn:MainDivision',null,null);
            mainDivision.addTextNode(mainDivisionValue);

            String zipCodeValue  = (appEqp.Install_Address1__r.Zip_Code__c != null ? appEqp.Install_Address1__r.Zip_Code__c : 'VALUE IS BLANK');
            Dom.XmlNode zipCode  = destination.addChildElement('urn:PostalCode',null,null);
            zipCode.addTextNode(zipCodeValue);
            // End: Customer Tag

            // Product name value is GARD__c value in application equipment
            String productValue = (appEqp.GARD_Code__c != null ? appEqp.GARD_code__c : 'VALUE IS BLANK');
            lineItem.addChildElement('urn:Product',null,null).addTextNode(productValue);
            
            // ExtendedPrice Tag
            Decimal ddlAmount = (appEqp.genesis__Estimated_Selling_Price__c !=null ? appEqp.genesis__Estimated_Selling_Price__c : 0.00);
            ddlAmount = cllease.ValueUtil.round(ddlAmount, 2 , 'Nearest');
            /* Modified By Tesh--------------*/
      
            //Fair Markert Value
            System.debug('======' +(appEqp.genesis__Estimated_Selling_Price__c * totalGrossReceivable) / totalSellingPrice);
            Decimal fairMartValue = (appEqp.genesis__Estimated_Selling_Price__c * totalGrossReceivable) / totalSellingPrice;
            system.debug('fairMartValue==' +fairMartValue);
            fairMartValue = cllease.ValueUtil.round(fairMartValue, 2 , 'Nearest'); 
            system.debug('fairMartValue==' +fairMartValue);
            String fairMarketvalue = String.valueof(fairMartValue);
            system.debug('fairMarketvalue==' +fairMarketvalue);
      
            //2. set the The extended Price value as a product of Rate_Factor__c * genesis__Estimated_Selling_Price__c
            Decimal newExtendedPrice;
            if(appEqpListRate_Factor!= null){
               // newExtendedPrice=ddlAmount*tmpRate;
                newExtendedPrice=ddlAmount*appEqpListRate_Factor;
                newExtendedPrice= cllease.ValueUtil.round(newExtendedPrice, 2 , 'Nearest');
            }else {
                newExtendedPrice=0.00;
            }
            String strExtendedPrice = String.valueof(newExtendedPrice);         
           /*-----------------------------*/
           String extdPrice = String.valueof(ddlAmount);  
            
            lineItem.addChildElement('urn:FairMarketValue',null,null).addTextNode(fairMarketvalue);
            lineItem.addChildElement('urn:ExtendedPrice',null,null).addTextNode(strExtendedPrice);
            //Tesh commented lineItem.addChildElement('urn:ExtendedPrice',null,null).addTextNode(extdPrice);
            lineItem.addChildElement('urn:Cost',null,null).addTextNode(extdPrice);
            lineItem.addChildElement('urn:InputTotalTax',null,null).addTextNode(string.valueOf(appEqp.genesis__Tax_Amount__c));

            // calculating Purchase Options flag details
            if(appEqp.genesis__Application__r.Purchase_Option__c == 'Fair Market Value') {
                contrTypev  = 'FMV';
                leaseTypev  = 'A';
            } else if(appEqp.genesis__Application__r.Purchase_Option__c == 'One Dollar Buyout') {
                contrTypev  = 'CSC';
                leaseTypev  = 'D';
            }
            
            // Start: FlexibleCodeField Tag
            Dom.XmlNode FFields =  lineItem.addChildElement('urn:FlexibleFields',null,null);
            Dom.XmlNode ffield1 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield1.setattribute('fieldId','1');
            ffield1.addTextNode('ORIG');
            Dom.XmlNode ffield2 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield2.setattribute('fieldId','2');
            ffield2.addTextNode('FMV');
            Dom.XmlNode ffield3 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield3.setattribute('fieldId','3');
            //ffield3.addTextNode('UC');
            Dom.XmlNode ffield4 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield4.setattribute('fieldId','4');
            ffield4.addTextNode('A');
            Dom.XmlNode ffield5 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield5.setattribute('fieldId','5');
            ffield5.addTextNode('I');
            Dom.XmlNode ffield6 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield6.setattribute('fieldId','6');
            ffield6.addTextNode('N/A');
            Dom.XmlNode ffield7 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield7.setattribute('fieldId','7');
            ffield7.addTextNode('N');
            Dom.XmlNode ffield8 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield8.setattribute('fieldId','8');
            ffield8.addTextNode('N');
            Dom.XmlNode ffield9 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield9.setattribute('fieldId','9');
            ffield9.addTextNode('CLS-genesis__Application_Equipment__c');
            assetNumber = (appEqp.Serial_Number__c != null ? appEqp.Serial_Number__c :'VALUE IS BLANK');
            Dom.XmlNode ffield10 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield10.setattribute('fieldId','10');
            ffield10.addTextNode(assetNumber);
            Dom.XmlNode ffield11 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield11.setattribute('fieldId','11');
            ffield11.addTextNode('0');
            Dom.XmlNode ffield12 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield12.setattribute('fieldId','12');
            ffield12.addTextNode('0');
            Dom.XmlNode ffield13 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield13.setattribute('fieldId','13');
            ffield13.addTextNode('');
            Dom.XmlNode ffield14 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield14.setattribute('fieldId','14');
            ffield14.addTextNode('F');
            String duetype = (appEqp.name != null ? appEqp.name : 'VALUE IS BLANK');
            Dom.XmlNode ffield15 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield15.setattribute('fieldId','15');
            ffield15.addTextNode(appEqp.Name);
            Dom.XmlNode ffield16 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield16.setattribute('fieldId','16');
            ffield16.addTextNode('BOOKING');
            AppliNumber = (appEqp.genesis__Application__r.Name != null ? appEqp.genesis__Application__r.Name : 'VALUE IS BLANK');
            Dom.XmlNode ffield17 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield17.setattribute('fieldId','17');
            ffield17.addTextNode(appEqp.genesis__Application__r.Lease_Number__r.name);
            Dom.XmlNode ffield18 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield18.setattribute('fieldId','18');
            ffield18.addTextNode('0');
            // End: FlexibleCodeField Tag

            // Start: FlexibleNumericField Tag
            /*Integer LengthofAppContract ;
            Date sdate=appEqp.genesis__Application__r.genesis__Expected_Start_Date__c;
            system.debug('starttttt date'+sdate); 
            Date mdate=appEqp.genesis__Application__r.genesis__Expected_Close_Date__c; 
            system.debug('Closeeee date'+sdate); 
            LengthofAppContract = sdate.daysBetween(Date.valueOf(mdate));
            System.debug('lengthhhhhhhh of contract'+LengthofAppContract) ;*/

            Date sdate=appEqp.genesis__Application__r.genesis__Expected_Start_Date__c;
            
            Dom.XmlNode ffield21 = FFields.addChildElement('urn:FlexibleNumericField',null,null);
            ffield21.setattribute('fieldId','1');
            ffield21.addTextNode(String.valueOf(lengthOfContract));
            Dom.XmlNode ffield22 = FFields.addChildElement('urn:FlexibleNumericField',null,null);
            ffield22.setattribute('fieldId','2');
            ffield22.addTextNode(cumulTaxv);
            Dom.XmlNode ffield23 = FFields.addChildElement('urn:FlexibleNumericField',null,null);
            ffield23.setattribute('fieldId','3');
            ffield23.addTextNode(slbPaidv);
            Dom.XmlNode ffield24 = FFields.addChildElement('urn:FlexibleNumericField',null,null);
            ffield24.setattribute('fieldId','4');
            ffield24.addTextNode(qtpCodev);
            Dom.XmlNode ffield25 = FFields.addChildElement('urn:FlexibleNumericField',null,null);
            ffield25.setattribute('fieldId','5');
            ffield25.addTextNode(qrsCodev);
            // End: FlexibleNumericField Tag

            // FlexibleDateField Tag
            string appsdate = formatDate(sdate);
            Dom.XmlNode ffield31 = FFields.addChildElement('urn:FlexibleDateField',null,null);
            ffield31.setattribute('fieldId','1');
            ffield31.addTextNode(appsdate);          
              
        } 
        For(Integer i=0; i<appEqpList.size(); i++){
             if (appEqpList[i].genesis__Tax_Amount__c == 0)
                 continue;
             
            // Calculating the Length of Contract from first payment date to maturity date
            //startDate =appEqp.genesis__Application__r.genesis__Expected_Start_Date__c;
            //system.debug('start date'+startDate) ;
            //endDate   = appEqp.genesis__Application__r.genesis__Expected_Close_Date__c;
            // end date going to check calculation
            // DateTime currentSystemDate  =   cllease.SystemDateUtil.getCurrentSystemDate();
            System.debug('*****appFirstPAYEMNTDATE'+appEqpList[i].genesis__Application__r.genesis__Expected_Start_Date__c);
            Date appFirstPmtDate = appEqpList[i].genesis__Application__r.genesis__Expected_Start_Date__c;
            System.debug('****pmtFrequency********'+appEqpList[i].genesis__Application__r.genesis__Payment_Frequency__c);
            String pmtFrequency = appEqpList[i].genesis__Application__r.genesis__Payment_Frequency__c;
            System.debug('****genesisterm'+appEqpList[i].genesis__Application__r.genesis__Term__c);
            Decimal term = appEqpList[i].genesis__Application__r.genesis__Term__c;

            endDate = cllease.DateUtil.getNextCycleDate(appFirstPmtDate,
                                                           appFirstPmtDate.day(),
                                                           pmtFrequency,
                                                           (Integer)term, true);
            system.debug('emd date'+endDate) ;
            lengthOfContract = appFirstPmtDate.daysBetween(endDate);
            system.debug('length in days'+lengthOfContract);

            lineItemId = (appEqpList[i].id != null ? appEqpList[i].id : 'VALUE IS BLANK');
            Dom.XmlNode lineItem = invoiceRequest.addChildElement('urn:LineItem', null, null);
            lineItem.setattribute('lineItemId', lineItemId);
            // Start: Customer Tag
            Dom.XmlNode customer = lineItem.addChildElement('urn:Customer',null,null);

            // Tax Exemption 
            Boolean isTaxExempted = false;
            // 1. Always check for Tax Exemption from Account , if not exempted check for equipment
            if(appEqpList[i].genesis__Application__c != null
                && appEqpList[i].genesis__Application__r.genesis__Account__c != null)  {
                // TODO: Needs to change Salesforce only support 3 levels for pulling values
                isTaxExempted = appEqpList[i].genesis__Application__r.genesis__Account__r.Tax_Exempt__c;
                system.debug('AccountTax Exemption :'+ isTaxExempted);
            } 
            // 2. Check for Equipment's Tax Exempt only if Account is not Exempted
            if(isTaxExempted == false){
                isTaxExempted = appEqpList[i].Tax_Exempt__c;
                system.debug('Equipment Tax Exemption: '+isTaxExempted);
            }
            
            if(isTaxExempted) {
                customer.setattribute('isTaxExempt','true');
                customer.setattribute('exemptionReasonCode','MISS');
            } else {
                customer.setattribute('isTaxExempt','false');
            }

            Dom.XmlNode destination = customer.addChildElement('urn:Destination', null, null);
            String cityValue    =  (appEqpList[i].Install_Address1__r.City__c != null ? appEqpList[i].Install_Address1__r.City__c : 'VALUE IS BLANK');
            Dom.XmlNode city    = destination.addChildElement('urn:City',null,null);
            city.addTextNode(cityValue);

            String mainDivisionValue = (appEqpList[i].Install_Address1__r.State__c != null ? appEqpList[i].Install_Address1__r.State__c : 'VALUE IS BLANK');
            Dom.XmlNode mainDivision = destination.addChildElement('urn:MainDivision',null,null);
            mainDivision.addTextNode(mainDivisionValue);

            String zipCodeValue  = (appEqpList[i].Install_Address1__r.Zip_Code__c != null ? appEqpList[i].Install_Address1__r.Zip_Code__c : 'VALUE IS BLANK');
            Dom.XmlNode zipCode  = destination.addChildElement('urn:PostalCode',null,null);
            zipCode.addTextNode(zipCodeValue);
            // End: Customer Tag

            // Product name value is GARD__c value in application equipment
            String productValue = (appEqpList[i].GARD_Code__c != null ? appEqpList[i].GARD_code__c : 'VALUE IS BLANK');
            lineItem.addChildElement('urn:Product',null,null).addTextNode(productValue);
            
            // ExtendedPrice Tag
            Decimal ddlAmount1 = (appEqpList[i].genesis__Estimated_Selling_Price__c !=null ? appEqpList[i].genesis__Estimated_Selling_Price__c : 0.00);
            //Decimal ddCost=tradeupAmount+ddlAmount1;
            Decimal ddCost= appEqpList[i].Oracle_Trade_Up_Amount__c+ddlAmount1;
           
            ddCost = cllease.ValueUtil.round(ddCost, 2 , 'Nearest');
            System.debug('ddCost==' +ddCost);
            /* Modified By Tesh--------------*/
      
            //Fair Markert Value
            System.debug('=====' +(appEqpList[i].genesis__Estimated_Selling_Price__c * totalGrossReceivable) / totalSellingPrice);
            Decimal fairMartValue1 = (appEqpList[i].genesis__Estimated_Selling_Price__c * totalGrossReceivable) / totalSellingPrice;
            //Decimal tradeFairMarValue=(fairMartValue1+tradeupAmount);
            System.debug('fairMartValue1==' +fairMartValue1);
            Decimal tradeFairMarValue=(appEqpList[i].Oracle_Trade_Up_Amount__c + fairMartValue1);
            tradeFairMarValue = cllease.ValueUtil.round(tradeFairMarValue, 2 , 'Nearest'); 
            System.debug('tradeFairMarValue==' +tradeFairMarValue);
            String FairWithTradeMarketvalue = String.valueof(tradeFairMarValue);
            System.debug('FairWithTradeMarketvalue==' +FairWithTradeMarketvalue);
      
            //2. set the The extended Price value as a product of Rate_Factor__c * genesis__Estimated_Selling_Price__c
            Decimal newExtendedPrice;
            if(appEqpListRate_Factor!= null){
                //newExtendedPrice=ddlAmount*tmpRate;
                //newExtendedPrice=(ddlAmount1*appEqpListRate_Factor)+tradeupAmount;
                newExtendedPrice=appEqpList[i].Oracle_Trade_Up_Amount__c + (ddlAmount1*appEqpListRate_Factor);
                newExtendedPrice= cllease.ValueUtil.round(newExtendedPrice, 2 , 'Nearest');
            }else {
                newExtendedPrice=0.00;
            }
            String strExtendedPrice = String.valueof(newExtendedPrice);         
            /*-----------------------------*/
            String extdPrice = String.valueof(ddCost);  
            
            lineItem.addChildElement('urn:FairMarketValue',null,null).addTextNode(FairWithTradeMarketvalue);
            lineItem.addChildElement('urn:ExtendedPrice',null,null).addTextNode(strExtendedPrice);
            //Tesh commented lineItem.addChildElement('urn:ExtendedPrice',null,null).addTextNode(extdPrice);
            lineItem.addChildElement('urn:Cost',null,null).addTextNode(extdPrice);
            lineItem.addChildElement('urn:InputTotalTax',null,null).addTextNode(string.valueOf(appEqpList[i].genesis__Tax_Amount__c));

            // calculating Purchase Options flag details
            if(appEqpList[i].genesis__Application__r.Purchase_Option__c == 'Fair Market Value') {
                contrTypev  = 'FMV';
                leaseTypev  = 'A';
            } else if(appEqpList[i].genesis__Application__r.Purchase_Option__c == 'One Dollar Buyout') {
                contrTypev  = 'CSC';
                leaseTypev  = 'D';
            }
            
            // Start: FlexibleCodeField Tag
            Dom.XmlNode FFields =  lineItem.addChildElement('urn:FlexibleFields',null,null);
            Dom.XmlNode ffield1 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield1.setattribute('fieldId','1');
            ffield1.addTextNode('ORIG');
            Dom.XmlNode ffield2 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield2.setattribute('fieldId','2');
            ffield2.addTextNode('FMV');
            Dom.XmlNode ffield3 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield3.setattribute('fieldId','3');
            //ffield3.addTextNode('UC');
            Dom.XmlNode ffield4 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield4.setattribute('fieldId','4');
            ffield4.addTextNode('A');
            Dom.XmlNode ffield5 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield5.setattribute('fieldId','5');
            ffield5.addTextNode('I');
            Dom.XmlNode ffield6 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield6.setattribute('fieldId','6');
            ffield6.addTextNode('N/A');
            Dom.XmlNode ffield7 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield7.setattribute('fieldId','7');
            ffield7.addTextNode('N');
            Dom.XmlNode ffield8 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield8.setattribute('fieldId','8');
            ffield8.addTextNode('N');
            Dom.XmlNode ffield9 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield9.setattribute('fieldId','9');
            ffield9.addTextNode('CLS-genesis__Application_Equipment__c');
            assetNumber = (appEqpList[i].Serial_Number__c != null ? appEqpList[i].Serial_Number__c :'VALUE IS BLANK');
            Dom.XmlNode ffield10 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield10.setattribute('fieldId','10');
            ffield10.addTextNode(assetNumber);
            Dom.XmlNode ffield11 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield11.setattribute('fieldId','11');
            ffield11.addTextNode('0');
            Dom.XmlNode ffield12 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield12.setattribute('fieldId','12');
            ffield12.addTextNode('0');
            Dom.XmlNode ffield13 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield13.setattribute('fieldId','13');
            ffield13.addTextNode('');
            Dom.XmlNode ffield14 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield14.setattribute('fieldId','14');
            ffield14.addTextNode('F');
            String duetype = (appEqpList[i].name != null ? appEqpList[i].name : 'VALUE IS BLANK');
            Dom.XmlNode ffield15 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield15.setattribute('fieldId','15');
            ffield15.addTextNode(appEqpList[i].Name);
            Dom.XmlNode ffield16 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield16.setattribute('fieldId','16');
            ffield16.addTextNode('BOOKING');
            AppliNumber = (appEqpList[i].genesis__Application__r.Name != null ? appEqpList[i].genesis__Application__r.Name : 'VALUE IS BLANK');
            Dom.XmlNode ffield17 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield17.setattribute('fieldId','17');
            ffield17.addTextNode(appEqpList[i].genesis__Application__r.Lease_Number__r.name);
            Dom.XmlNode ffield18 = FFields.addChildElement('urn:FlexibleCodeField',null,null);
            ffield18.setattribute('fieldId','18');
            ffield18.addTextNode('0');
            // End: FlexibleCodeField Tag

            // Start: FlexibleNumericField Tag
            /*Integer LengthofAppContract ;
            Date sdate=appEqp.genesis__Application__r.genesis__Expected_Start_Date__c;
            system.debug('starttttt date'+sdate); 
            Date mdate=appEqp.genesis__Application__r.genesis__Expected_Close_Date__c; 
            system.debug('Closeeee date'+sdate); 
            LengthofAppContract = sdate.daysBetween(Date.valueOf(mdate));
            System.debug('lengthhhhhhhh of contract'+LengthofAppContract) ;*/

            Date sdate=appEqpList[i].genesis__Application__r.genesis__Expected_Start_Date__c;
            
            Dom.XmlNode ffield21 = FFields.addChildElement('urn:FlexibleNumericField',null,null);
            ffield21.setattribute('fieldId','1');
            ffield21.addTextNode(String.valueOf(lengthOfContract));
            Dom.XmlNode ffield22 = FFields.addChildElement('urn:FlexibleNumericField',null,null);
            ffield22.setattribute('fieldId','2');
            ffield22.addTextNode(cumulTaxv);
            Dom.XmlNode ffield23 = FFields.addChildElement('urn:FlexibleNumericField',null,null);
            ffield23.setattribute('fieldId','3');
            ffield23.addTextNode(slbPaidv);
            Dom.XmlNode ffield24 = FFields.addChildElement('urn:FlexibleNumericField',null,null);
            ffield24.setattribute('fieldId','4');
            ffield24.addTextNode(qtpCodev);
            Dom.XmlNode ffield25 = FFields.addChildElement('urn:FlexibleNumericField',null,null);
            ffield25.setattribute('fieldId','5');
            ffield25.addTextNode(qrsCodev);
            // End: FlexibleNumericField Tag

            // FlexibleDateField Tag
            string appsdate = formatDate(sdate);
            Dom.XmlNode ffield31 = FFields.addChildElement('urn:FlexibleDateField',null,null);
            ffield31.setattribute('fieldId','1');
            ffield31.addTextNode(appsdate);          
        }
        String req = scdoc.toXmlString();
        System.debug(LoggingLevel.ERROR, ' Request Str for Application Equipment: '+ req);

        return scdoc;
    }
    // formate the Date to String
    private static String formatDate(DateTime d) {
        return d.year() + '-' + d.month() + '-' + d.day();
    } 

    // Validating Vertex Configuration
    public static void validateVertexConfig(VertexApi__c vertexConfig) {
        // Do Validation on Vertex API Configuration
        if(vertexConfig.Username__c == null || vertexConfig.Username__c == '') {
            throw new CLSCustomException('Vertex UserName missing from Vertex API Custom Settings...');
        }

        if(vertexConfig.Password__c == null || vertexConfig.Password__c == '') {
            throw new CLSCustomException('Vertex Password missing from Vertex API Custom Settings...');
        }

        if(vertexConfig.Company__c == null || vertexConfig.Company__c == '') {
            throw new CLSCustomException('Vertex Company missing from Vertex API Custom Settings...');
        }

        if(vertexConfig.Division__c == null || vertexConfig.Division__c == '') {
            throw new CLSCustomException('Vertex Division missing from Vertex API Custom Settings...');
        }

        if(vertexConfig.End_point__c == null || vertexConfig.End_point__c == '') {
            throw new CLSCustomException('Vertex End Point missing from Vertex API Custom Settings...');
        }
    }

    

}