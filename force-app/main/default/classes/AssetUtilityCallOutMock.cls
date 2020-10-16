global class AssetUtilityCallOutMock implements HttpCalloutMock{

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        String  strBody='"data": [{"id": 4030,"code": 31002218,"name": "2015","isActive": true,"titling": false, "serialized": false,"referencePrice": 0, "brandCode": 30001950,  "masterAssetTypeCode": 107,"assetTypeCode": 40000675,"programCode": 53 }]';
        response.setBody(strBody);
        response.setStatusCode(200);
        return response; 
    }
   
}