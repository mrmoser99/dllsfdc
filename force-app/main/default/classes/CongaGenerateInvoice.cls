Global Class CongaGenerateInvoice{
   
 static String version = DLLNewCoConstants.SOAP_VERSION;
 static String partnerUrl = Url.getSalesforceBaseUrl().toExternalForm()+version+UserInfo.getOrganizationId().subString(0,15);  
 static String congaUrl;
 static string InvTempId;
 static integer countSpecificStates;
 static integer countOfRIstate;
 static integer countOfOtherStates;
 
   // this  method is used to generate Credit Approval Document
  Webservice static string generateInvoiceDocument(string recordId){
    
      string BillId       = '';
      string contId       = '';
      countSpecificStates = 0;
      countOfRIstate      = 0;
      countOfOtherStates  = 0;
      String StateCodes      = CongaURL_Settings__c.getInstance().States_Prior_to_Maturity_120__c;
      String RIStateCode     = CongaURL_Settings__c.getInstance().States_Prior_to_Maturity_RI_120__c;
      Decimal Days120        = CongaURL_Settings__c.getInstance().Days_Prior_to_Maturity_120__c;
      Decimal Days60         = CongaURL_Settings__c.getInstance().Days_Prior_to_Maturity_60__c;
      List<String> Oth = new List<String>();
      List<String> Ri = new List<String>();
        for(String st : StateCodes.split(','))
        {
           if(st !=null)
           {
               Oth.add(st);
           }
           System.debug('***oth-list****'+Oth);
        }
        
        for(String stRI     : RIStateCode.split(','))
        {
           if(stRI !=null)
           {
               Ri.add(stRI);
           }
           System.debug('***Ri-list****'+Ri);
        }
      list<Invoice__c> inv =  [select id, name,LS_Contract__r.id,LS_Contract__r.Number_of_Days_TO_Mature__c,LS_Contract__r.cllease__Lease_Status__c,LS_Contract__r.Billing_Address__r.state__c,LS_Contract__r.State__c,(select id, name from Invoice_Bills__r) 
                              from Invoice__c where id =:recordId limit 1];
      if(inv.size()>0)
      {
         
      
      if(inv[0].Invoice_Bills__r.size()>0)
      {
          BillId = inv[0].Invoice_Bills__r[0].Id;
          contId = inv[0].LS_Contract__r.id;
          System.debug('Bill ID'+BillId);
          System.debug('LS Contract ID'+contId);
        //Quering all the Child records of particular Contract with Contract id  
        List<cllease__Contract_Equipment__c> ContractEquipmentList = [Select id,name,State__c,cllease__Contract__r.id,cllease__Contract__r.cllease__Lease_Status__c,cllease__Contract__r.Number_of_Days_TO_Mature__c 
                                                                      From cllease__Contract_Equipment__c Where cllease__Contract__r.id =: inv[0].LS_Contract__r.id 
                                                                       AND cllease__Contract__r.Number_of_Days_TO_Mature__c <=: Days120 
                                                                       AND cllease__Contract__r.cllease__Lease_Status__c != 'EVERGREEN'];
                                                                       
        System.debug('*********ContractEquipmentList*********'+ContractEquipmentList.size());
        //Chage for EOL-002 ticket
        //Here we are Getting the Count of Equipment as per State
        if(ContractEquipmentList.size()>0)
        {
            for(cllease__Contract_Equipment__c CE : ContractEquipmentList)
            {
                if(Oth.contains(CE.state__c) && CE.cllease__Contract__r.Number_of_Days_TO_Mature__c <= Days120)
                {
                    countSpecificStates++;
                }
                if(Ri.contains(CE.State__c) && CE.cllease__Contract__r.Number_of_Days_TO_Mature__c <= Days120)
                {
                    countOfRIstate++;
                }
                if(!Ri.contains(CE.State__c) && !Oth.contains(CE.State__c) && CE.cllease__Contract__r.Number_of_Days_TO_Mature__c <= Days60)
                {
                    countOfOtherStates++;
                }
                    
            }
        }           
        String DueDetailsLines = CongaURL_Settings__c.getInstance().DueDetailsLines__c;
        String FinanceFee      = CongaURL_Settings__c.getInstance().FinanceFee__c;
        String INSFEE          = CongaURL_Settings__c.getInstance().INSFEE__c;
        String InterimRent     = CongaURL_Settings__c.getInstance().InterimRent__c;
        String Invo            = CongaURL_Settings__c.getInstance().INV__c;
        String LateFee         = CongaURL_Settings__c.getInstance().LateFee__c;
        String OrigFee         = CongaURL_Settings__c.getInstance().OrigFee__c;
        String AD              = CongaURL_Settings__c.getInstance().AD__c;
        String Equipment       = CongaURL_Settings__c.getInstance().Equipment_contact__c;
        
        Conga_Query__c charges = [select id from Conga_Query__c where name = 'Charges'];
        
            //Change for EOL=002 Ticket
            //Based on the Count of States we assigning the template id 
            if(inv[0].LS_Contract__r.cllease__Lease_Status__c != 'EVERGREEN')
            {
             
               if(countOfRIstate > 0 && (countSpecificStates > 0 || countOfOtherStates > 0)){

                   InvTempId       = CongaURL_Settings__c.getInstance().MutipleStatesCommTempID__c;
               }
               else if(countOfRIstate > 0 && countSpecificStates == 0 && countOfOtherStates == 0){
                   
                   InvTempId       = CongaURL_Settings__c.getInstance().Specific_RI_TempID__c;   
               }
               else if(countOfRIstate == 0 && (countSpecificStates > 0 || countOfOtherStates > 0)){
                   
                   InvTempId       = CongaURL_Settings__c.getInstance().Comm_TempID__c;
               }
               else if(countOfRIstate == 0 &&  countSpecificStates == 0 && countOfOtherStates == 0){
                   
                   InvTempId     = CongaURL_Settings__c.getInstance().InvoiceEverGreenTempID__c; 
               }
            }           
            else
            {
                InvTempId       = CongaURL_Settings__c.getInstance().InvoiceEverGreenTempID__c;
                System.debug('*****i entered into the other states  else block*******');
            }
     System.debug('*****InvTempId****'+invTempId);
     congaUrl =Label.Conga_URL+userinfo.getsessionId()+'&serverUrl='+partnerUrl+'&QueryId=[INV]'+Invo+',[DueDetailsLines]'
              +DueDetailsLines+'?pv0='+BillId+',[AD]'+AD+'?pv0='+contId+',[INSFEE]'+INSFEE+'?pv0='+recordId+',[OrigFee]'
              +OrigFee+'?pv0='+recordId+',[InterimRent]'+InterimRent+'?pv0='+recordId+',[LateFee]'+LateFee+'?pv0='
              +recordId+',[Charges]' + Charges + '?pv0='recordId +',[FinanceFee]'+FinanceFee+',[EC]'+Equipment+'?pv0='+contId+'&TemplateId='
              +InvTempId+'&DS7=1&OFN=InvoiceStatement&id='+recordId.subString(0,15);
      return getCalloutToConga(congaUrl);
      }
      else{
       return 'There is no bill for this invoice';

      }
    }
    else
        return  null;
    }
    
    public static String getCalloutToConga(String url) {

    // Instantiate a new http object
    Http h = new Http();

    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
    HttpRequest req = new HttpRequest();
    req.setEndpoint(url);
    req.setMethod('GET');
    req.setTimeout(60000);
    // Send the request, and return a response
    HttpResponse res = h.send(req);
     if(res.getStatusCode() != 200){
                return res.getStatus();
     }else if(!Pattern.matches('[a-zA-Z0-9]{18}',res.getBody())){
                return res.getBody();
      }
     return 'Document generated successfully'; 
    }  
    
      }