/**
 * Owner: CLS-Q2
 * Date : 09/24/2019
 * Handler to move excess back to cash receipt and making it to 0.
 **/
public class LPTTriggerHandler {
    class MyException extends Exception{}
    
    private List<cllease__Lease_Payment_Transaction__c> pmtList = new List<cllease__Lease_Payment_Transaction__c>();
    
    public LPTTriggerHandler(List<cllease__Lease_Payment_Transaction__c> pmtList){
        this.pmtList = pmtList;
    }
    
    public void process(){
        for(cllease__Lease_Payment_Transaction__c lpt : pmtList){       
            if(lpt.cllease__Cleared__c && lpt.Cllease__Excess__c > 0){
                lpt.cllease__Excess__c = 0;
            }
        }
    }
}