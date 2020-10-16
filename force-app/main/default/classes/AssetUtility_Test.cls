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

        
    }

    @isTest static void testGetModels(){

        Test.startTest();
        Boolean  b=AssetUtility.getModels(1);
        Test.stopTest();

        System.assertNotEquals(false, b, 'There is access Token found');

        
    }*/
}