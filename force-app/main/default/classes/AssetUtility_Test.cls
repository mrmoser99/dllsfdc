@isTest private class AssetUtility_Test {

  
           
    
    @isTest static void testMakeCallout(){
        // Create the mock response based on a static resource
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ModelList');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');

        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);
        HttpResponse result= AssetUtility.makeCallout('Models');
        System.assertNotEquals(null, result, 'The callout returned a null response');
        // Verify status code
        System.assertEquals(200,result.getStatusCode(),'The status code is not 200.');
        // Verify content type   
        System.assertEquals('application/json;charset=UTF-8',result.getHeader('Content-Type'));


    }
    /*
    @isTest static void testGetAccessToken(){

        Test.startTest();
        String  at=AssetUtility.getAccessToken();
        Test.stopTest();

        System.assertNotEquals(null, at, 'There is access Token found');

        
    }*/
     
    Static testmethod void testGetModels(){

        Test.startTest();
        Id batchJobId= Database.executeBatch(new BatchAssetUpdate(), 100);
        System.debug('Batch JobId '+batchJobId);
        Test.stopTest();
        System.assertNotEquals(Null, batchJobId, 'There is no job id found');
        
    }
    @isTest(SeeAllData=true) static void testGetModelsDetailsData(){

        StaticResource sr=[select id, Name, body from StaticResource Where name='ModelsModelCodeDetails' ];
        String fekeResponse=sr.body.tostring();   

        Test.startTest();
        Map<Integer,ModelsModelCodeDetailsJSON2Apex.Data>  mdldetail=AssetUtility.getModelsDetailsData(fekeResponse);
        Test.stopTest();

        System.assertNotEquals(Null, mdldetail, 'There is no access Token found');

        
    }
}