@isTest private  class BatchAssetUpdate_Test {
    @testSetup
    static void setup(){
       List<genesis__Equipment_Master__c> equpmntList= new List<genesis__Equipment_Master__c>();
       genesis__Equipment_Master__c equpmnt= new genesis__Equipment_Master__c();

        equpmnt.genesis__Model__c='7130cdn Color Printer';
        equpmnt.Asset_Type_ID__c ='40000671';
        equpmnt.Asset_Type_Name__c ='Color Printer';
        equpmnt.MSRP__c =1999.99;
        equpmnt.Manufacturer__c ='Dell';
        equpmnt.Master_Asset_Type_ID__c='107';
        equpmnt.Master_Asset_Type__c ='Office Equipment';
        equpmnt.Object_Category_ID__c ='800102';
        equpmnt.Object_Category_Name__c='Printers';
        equpmnt.Economic_Life__c=64;
        equpmnt.Composite_Key__c='Dell-7130cdn Color Printer';
        //equpmnt.Gard_External_Id__c';

        equpmntList.add(equpmnt);
        insert equpmntList;


}
    Static testmethod void test(){

        Test.startTest();
        //List<genesis__Equipment_Master__c> Eq=[SELECT genesis__Model__c, Asset_Type_ID__c, Asset_Type_Name__c, MSRP__c, Manufacturer__c, Master_Asset_Type_ID__c, Master_Asset_Type__c, Object_Category_ID__c, Object_Category_Name__c, Economic_Life__c, Composite_Key__c, Gard_External_Id__c FROM genesis__Equipment_Master__c];
        Id batchJobId= Database.executeBatch(new BatchAssetUpdate(), 100);
        System.debug('Batch JobId '+batchJobId);
        Test.stopTest();
        System.assertNotEquals(Null, batchJobId, 'There is no job id found');
        
    }
    
}