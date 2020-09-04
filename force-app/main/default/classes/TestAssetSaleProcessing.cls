@isTest
public class TestAssetSaleProcessing {
    public static testMethod void assetSale(){
         
         cllease__Lease_Account__c leaseContract= TestHelper.createContract();
         system.debug('a idddd'+leaseContract.id);
         cllease__Contract_Equipment__c contractEquipment= [ Select Id,name,City_InstallAddress__c,State_Code__c,Zip_Code_InstallAddress__c 
                                            From cllease__Contract_Equipment__c
                                            Where cllease__Contract__c = :leaseContract.Id];
         cllease__Asset_workbench__c asset = new cllease__Asset_workbench__c(cllease__Contract__c=leaseContract.Id,
                                                                             cllease__Return_Status__c='SOLD',
                                                                             Date_Sold__c=date.today(),Sale_Price__c=10,
                                                                             Sold_to__c=leaseContract.cllease__Account__c,
                                                                            cllease__Contract_Equipment__c=contractEquipment.Id);
         insert asset;
         cllease__Transaction_Sub_Type__c Transubtype= new cllease__Transaction_Sub_Type__c(Name='Late Fee');
         insert Transubtype;
         String assetWorkBenchid = asset.Id;
         clcommon__Fee_Definition__c fee = new clcommon__Fee_Definition__c(name='ASSET SALE',clcommon__Amount__c=5,clcommon__Class__c='Income');
         insert fee;
         List<cllease__Other_Transaction__c> rectype=[select Id, Name, RecordType.DeveloperName from cllease__Other_Transaction__c limit 1];
         // validating at least one record type from query
         system.assertEquals(rectype.size()>0, true);
         // Inserting other transaction details
         cllease__Other_Transaction__c otherTrans= new cllease__Other_Transaction__c();
         otherTrans.cllease__Lease_Account__c=leaseContract.Id;
         otherTrans.cllease__txn_date__c=asset.Date_Sold__c;
         otherTrans.cllease__Txn_Amt__c=asset.Sale_Price__c;
         otherTrans.Sold_to__c=asset.Sold_To__c;
         insert otherTrans;
         // Executing @future method
         System.Test.startTest();
         AssetSaleProcessing.processAssetSale(assetWorkBenchid);
         System.Test.stopTest();
    }

}