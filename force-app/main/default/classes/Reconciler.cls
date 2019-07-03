/**************************************************************************************************************
*
*  Reconciler - compares a pnc reciept file to cloud lending
*
*  log:
*
* 	5/9/19 - MRM Created Class 
*
****************************************************************************************************************/
global class Reconciler implements Messaging.InboundEmailHandler {
    
    String finalEmailTextBody;
    String fromAddress;
    Boolean attachment = false;
    List<String> lineList = new List<String>();
    Integer linesSubmitted = 0;
    List<PNC_Recon_Detail__c> insertList = new List<PNC_Recon_Detail__c>();
    ID reconBatchId;

    //*********************************
    //* handleInboundEmail
    //********************************* 
     
    
    /**************************************************************************
    *HANDEL INBOUND EMAIL
    **************************************************************************/
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
       
        Boolean emailSent = false; 
        finalEmailTextBody = 'Your detailed results....\n\n';
        fromAddress = email.fromAddress;
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        system.debug(email);
        system.debug(envelope);

        system.debug(email.binaryAttachments); 

        Messaging.InboundEmail.BinaryAttachment[] bAttachments = email.BinaryAttachments; 
        

        if (email.binaryAttachments != null && email.binaryAttachments.size() > 0)
            attachment = true;
        else{
            sendShortEmail('Missing Attachment; Try again!');
            return result;
        }

        String theBody = bAttachments[0].body.toString();
        system.debug(theBody);
            
        //validEmail checks for some standard items before processing  
        if (attachment){
          	lineList = theBody.split('\n',0); //tab attachment format
        }
        else  
          	lineList = theBody.split('\n\n',0);  //microsoft outlook format
            
        ID hId = createHeader();

        Integer i = 0;  
        for (String s:lineList){
        	system.debug('line is:' + i + s);
          	s = s.replace('\n','');
            	
           	List <String> fieldList = new List<String>();
               	
            fieldList = s.split(',',-1);
               		
           	system.debug('field list size is:' + fieldList.size());
                	
           	system.debug('id is:' + fieldList[0]); 
            if (fieldList[0] == 'ACH-CCD'){
                createDetail(hId,fieldList);
                linesSubmitted++;
            }

          	i++;	
        }//end for loop linelist
            	
        insert insertList;
        
        List<PNC_Recon_Detail__c> checklist = new List<PNC_Recon_Detail__c>();
        checklist = [select invoice_number__c
                    ,Invoice_Payment__c
                    ,Confirmation_number__c
                    ,Int_PX_Remit__r.name
                    ,status__c
                    from PNC_Recon_Detail__c
                    where  pnc_recon_batch__c = :reconBatchId
                    order by invoice_number__c
                    ]; 

        if (!emailSent){ //send final email
        	
            finalEmailTextBody += standardEmailText();

            finalEmailTextBody += 'Invoice' + '\t\t\t' + 'Payment' + '\t' + 
                'Confirmation Nbr' + '\t' + 'Matched To' + '\t'  +  'Status' + '\n';

            Integer total = 0;
            Integer ok = 0;
            Integer failures = 0;

            total = checkList.size();

            for (PNC_Recon_Detail__c r:checkList){
                if (r.status__c == 'OK')
                    ok++;
                else
                    failures++;    
                
                String message = '';

                if (r.int_px_remit__r.name == null)
                    message = 'No Match';
                else {
                    message = r.int_px_remit__r.name;
                }

                finalEmailTextBody += r.invoice_number__c + '\t' + r.invoice_payment__c + '\t\t' + 
                r.confirmation_number__c + '\t\t' + message + '\t'  +  r.status__c + '\n';
            }
        	
            finalEmailTextBody += '\n\nTotal Number of Records: ' + total + '\n';
            finalEmailTextBody += 'Total Number OK: ' + ok + '\n';
            finalEmailTextBody += 'Total Number of Mismatches: ' + failures + '\n';

            sendShortEmail(finalEmailTextBody);
        }
        
        return result;
    }
    
    /**************************************************************************
    *CREATE HEADER
    **************************************************************************/
        ID createHeader(){

        PNC_Recon_Batch__c h = new PNC_Recon_Batch__c();
        h.name = string.valueOf(DateTime.now());
        insert h;
        reconBatchId = h.id;

        return h.id;

    } 
    
    /**************************************************************************
    *CREATE DETAIL
    **************************************************************************/
    void  createDetail(ID h, List<String> fieldList ){

        PNC_Recon_Detail__c d = new PNC_Recon_Detail__c();
         
        d.pnc_recon_batch__c = h;
        d.Payment_Method__c = fieldList[0];
        d.Payment_Channel__c = fieldList[1];
        d.Processing_Date__c = date.parse(fieldList[2]);
        d.Capture_Date__c = date.parse(fieldList[3]);
        d.Biller_Account_Number__c = fieldList[4];
        d.Invoice_Number__c = fieldList[5];
        d.Account_Name__c = fieldList[6];
        Integer i = 8;
        if (fieldList[6].contains('"')){
            i = 8; 
        }
        else {
            i = 7;
        }
        if (fieldList[i] != null)
            d.Invoice_Payment__c = decimal.valueOf(fieldList[i]);

         if (fieldList[i+1] != null)
            d.Reversal_Amount__c = decimal.valueOf(fieldList[i+1]);


        d.Confirmation_Number__c = fieldList[i+2];
        d.Reversal_Reason__c = fieldList[i+3];

        system.debug(fieldList[i+4]);
        if (fieldList[i+4] == '0')
            if (fieldList[i+4] == '0')
                d.fee__c = 0;
            else
                d.Fee__c = decimal.valueOf(fieldList[i+4]);

        insertList.add(d);
    
    }
    
    
    /**************************************************************************
    * SENDSHORTEMAIL 
    *
    * this sends the user an email with a special error message
    *
    ***************************************************************************/
    public void sendShortEmail(String msg){
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        OrgWideEmailAddress o = [select id, address from OrgWideEmailAddress where displayName = 'NewCo Customer Service'];

        mail.setOrgWideEmailAddressId(o.id);

        String[] toAddress = new String[] {fromAddress};
        
        mail.setToAddresses(toAddress);
        
        mail.setSubject('Recon Results');
        
        mail.setBccSender(false);
     
        mail.setPlainTextBody(msg);

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
           
    }
    
    
    
    /****************************************************************************
    *STANDARD TEXT
    *
    * standard email text
    *
    ****************************************************************************/
    public String standardEmailText(){
    	
    	String finalEmailTextBody = '';
    	
    	
    	return finalEmailTextBody;
    }
   
}