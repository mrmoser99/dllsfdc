/*******************************************************************************************************************
*   CAMSCall - made this into a queable since cams need to be called in sequence
* 
*	Change Log: 
*	9/25/19 - MRM Created
* 
********************************************************************************************************************/
public class CAMSCall implements Queueable, Database.AllowsCallouts {
    
    
    private Map<ID,String> applicationMap;

    public  CAMSCall(Map<ID,String> applicationMap)
    {
        this.applicationMap = applicationMap;
    }
    
    public void execute(QueueableContext context) {
    	
        CAMSUtility.callCAMS(applicationMap);
		
    }

}