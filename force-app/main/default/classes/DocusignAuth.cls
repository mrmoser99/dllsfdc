@RestResource(urlMapping='/DocusignAuth/*')
global class DocusignAuth{
    @HttpPost
    global static String createNewDocusignAuth(String name){
        system.debug ('namne is: ' + name);
        return 'Done Post';
    }

    @HttpGet
    global static String getWidgets() {
        
        return 'Done Get';
    }
}