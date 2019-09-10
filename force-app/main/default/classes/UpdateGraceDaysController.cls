public with sharing class UpdateGraceDaysController {
public string contractID = ''; 
public cllease__Lease_Account__c contractItem{get;set;}
    public UpdateGraceDaysController()
    {
      List<cllease__Lease_Account__c> contractList = new List<cllease__Lease_Account__c>();
      contractID = System.currentPageReference().getParameters().get('Id');
      System.debug('****contractID*****'+contractID);
      contractList = [Select ID,Name,
                             Custom_Late_Charge_Grace_Days__c,
                             Custom_Finance_Charge_Grace_Days__c,
                             cllease__Dealer__c,
                             Cost_of_Funds__c

                       From  cllease__Lease_Account__c 
                       Where ID = :contractID];
        if(!contractList.isEmpty())
        { 
            contractItem = contractList[0];
            System.debug('*****contractItem*******'+contractItem); 
        }
        else
        { 
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'The Contract ID is invalid.'); 
            ApexPages.addMessage(msg); 
        }
      }
      public pageReference cancelAction()
     {
        return returnToOrigination(); 
     }
     public pageReference saveItem()
    { 
    
        //Do something to the Contract object and then update it //
         try{  
             System.debug('*****contractItem*******'+contractItem); 
             update contractItem;
          } 
         catch(DmlException ex){
            ApexPages.addMessages(ex);
            return null; 
          }
          return returnToOrigination();
     } 
     private pageReference returnToOrigination()
     {
         string org = string.valueOf(Label.OrgUrl);
         PageReference page = new PageReference(org+'/'+contractID); 
         page.setRedirect(false); 
         return page; 
     }                                                                    
 }