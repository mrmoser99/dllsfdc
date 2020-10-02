
/***********************************************************************************************************************************
* 
* Change Log:

  10/1/2020 - MRM Created


*******************************************************************************************************************************/ 
public without sharing class FMZ_ExistingCustomerController {

    @AuraEnabled
    public static String getListViews() {
        List<ListView> listviews =
        [SELECT Id, Name FROM ListView WHERE SobjectType = 'Account' and DeveloperName = 'SearchMyAccounts'];

        system.debug(listViews);

     
        return listviews[0].id;
    } 

}