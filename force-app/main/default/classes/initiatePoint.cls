public class initiatePoint{

    public List<clcommon__Points__c> addPoints(List<Id> listOfIds, Id AppId) {
        
        List<clcommon__Points__c> newlist = new List<clcommon__Points__c>();
        
        for(Id a : listOfIds){
            clcommon__Points__c point = new clcommon__Points__c();
            point.genesis__Application__c = AppId;
            point.genesis__Points_Setup__c = a;
            newlist.add(point);
        }
        
        return newlist;  
    }   

}