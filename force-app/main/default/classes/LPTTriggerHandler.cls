/**
 * Owner: CLS-Q2
 * Date : 09/24/2019
 * Handler to move excess back to cash receipt and making it to 0.
 * 
 * Modified : 10/16/2019
 * Chnages List : Added support for "On Account" accounting and moving the excess back to new cash receipt.
 **/
public class LPTTriggerHandler {
    
    List<cllease__Transaction_Sub_Type__c> onAccountTxn = [SELECT ID FROM cllease__Transaction_Sub_Type__c WHERE NAME = 'On Account' LIMIT 1];
    List<cllease__Lease_Payment_Detail__c> lpdForOnAccount = new List<cllease__Lease_Payment_Detail__c>();
    
    class MyException extends Exception{}
    
    private List<cllease__Lease_Payment_Transaction__c> pmtList = new List<cllease__Lease_Payment_Transaction__c>();
    
    public LPTTriggerHandler(List<cllease__Lease_Payment_Transaction__c> pmtList){
        this.pmtList = pmtList;
    }
    
    public void process(){
        for(cllease__Lease_Payment_Transaction__c lpt : pmtList){     
            cllease__Lease_Payment_Detail__c newLpd = new cllease__Lease_Payment_Detail__c();
            if(lpt.cllease__Cleared__c && lpt.Invoice_Credit_Amount__c > 0 && !lpt.On_Account_Created__c){
                newLpd.cllease__Amount__c = lpt.Invoice_Credit_Amount__c;
                newLpd.cllease__Contract__c = lpt.cllease__Contract__c;
                newLpd.cllease__GL_Posted_Flag__c = false;
                newLpd.cllease__GL_Processing_Message__c  = '';
                newLpd.cllease__GL_Reversal_Posted_Flag__c  = false;
                newLpd.cllease__GL_Transaction_Flag__c = true;
                newLpd.cllease__Payment_Transaction__c = lpt.Id;
                newLpd.cllease__Restructured__c = false;
                newLpd.cllease__Reversed__c = false;
                newLpd.cllease__Transaction_Date__c = lpt.cllease__Transaction_Date__c;
              	newLpd.cllease__Transaction_Sub_Type__c = onAccountTxn[0].Id;
                lpdForOnAccount.add(newLpd);
                lpt.cllease__Excess__c = 0;
                lpt.On_Account_Created__c = true;
            }
        }
        Insert(lpdForOnAccount);
        System.debug(LoggingLevel.ERROR, '^^^^^ lpdForOnAccount : ' + lpdForOnAccount);
    }
}