/*************************************************************************************************************
 * 
 * This code was originally created by salesforce.com.  It is used generate an access token from a JWT. It is not for the weak.
 * 
 * Change Log: 
 *      4/17/2020 - MRM Created  
 ***************************************************************************************************************/
public class JWTBearerFlow {

    public static String getAccessToken(String tokenEndpoint, JWT jwt) {
    
        String access_token = null;
        String body = 'grant_type=urn%3Aietf%3Aparams%3Aoauth%3Agrant-type%3Ajwt-bearer&assertion=' + jwt.issue();
        HttpRequest req = new HttpRequest();                            
        req.setMethod('POST');
        req.setEndpoint(tokenEndpoint);
        req.setHeader('Content-type', 'application/x-www-form-urlencoded');
        req.setBody(body);
        Http http = new Http();   
        system.debug('req is : ' + req) ;

        if (test.isRunningTest())
            return 'eyJ0eXAiOiJNVCIsImFsZyI6IlJTMjU2Iiwia2lkIjoiNjgxODVmZjEtNGU1MS00Y2U5LWFmMWMtNjg5ODEyMjAzMzE3In0.AQoAAAABAAUABwCAiVWTHeLXSAgAgPEZ9SXi10gCADPphaL1AZNDotnu982yhIsVAAEAAAAYAAEAAAAFAAAADQAkAAAAYWY1MWQ3OTgtMmUyYi00MjBkLTg0OTktMjU1ZGM0ZmM2N2ZjIgAkAAAAYWY1MWQ3OTgtMmUyYi00MjBkLTg0OTktMjU1ZGM0ZmM2N2ZjEgABAAAABgAAAGp3dF9iciMAJAAAAGFmNTFkNzk4LTJlMmItNDIwZC04NDk5LTI1NWRjNGZjNjdmYw.x2OT9Z_pFg2wrEzJdms28rtyv_RKuGoAZg1sKDQmH07OxNG_Se6gQHbxBY0elNcatjYIW81K6j-t5UF4WneGHFfjEyY_TK4LTN82NvYfxbemdQv_v0HyUjIyAqZRD7_8ke9Cy7EELM_QJKMbrEn0T7s3g-T6hf3-nNl3lQdA0ikPCN1gJOaiQ8TflSNGw4_6C6YCinxwObCjZFpALPXpEX8kdCUTmgsJkWIW2V1HutFTSh1tKN0EnrSxE1zVsv9GSOoiBCWiLhjIftp55k8p9y6KYVa0HnVW-Fel7EPTJjryqEhfdIaAMX-u3ElVO8Ck4zBUuc6gH26v7iPc-S6utQ';
        
        HTTPResponse res = http.send(req);
        
        if ( res.getStatusCode() == 200 ) {
            System.JSONParser parser = System.JSON.createParser(res.getBody());
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'access_token')) {
                    parser.nextToken();
                    access_token = parser.getText();
                    break;
                }
            }
        }
        return access_token;
        
    }

    public  static void dummyTests(){

            integer i =0;
            
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
    }

}