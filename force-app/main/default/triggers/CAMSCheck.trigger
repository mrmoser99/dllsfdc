/*********************************************************************************************
*
* CAMS Trigger
*
* Change Log:
*
* 9/24/19 - MRM created
**********************************************************************************************/
trigger CAMSCheck on CAMS_Check__c (before update) {

    List<Group> gList = [Select Id
								,developername
								From
								Group g 
								where type = 'QUEUE' and developerName in ('CAMS_Queue', 'CAMS_History')
								];
    Map<String,ID> qMap = new Map<String,ID>();

    for (Group g:gList){
        qMap.put(g.developername, g.id);
    }
    String qId = gList[0].id;

    Integer i=0;
    for (CAMS_Check__c cc:trigger.new){
        if (trigger.new[i].status__c.contains('Held'))
            trigger.new[i].ownerId = qMap.get('CAMS_Queue');
        else {
            if (trigger.new[i].status__c.contains('Clear') && !trigger.old[i].status__c.contains('Clear'))
                trigger.new[i].ownerId = qMap.get('CAMS_History');
        }

        i++;
    }  
            
         
     
}