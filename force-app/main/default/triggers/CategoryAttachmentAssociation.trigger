/*****************************************************************************************************************
 * 
 * 
 * Create to trigger welcome package
 * 
 * Change Log:
 * 
 
 * 
 *****************************************************************************************************************/
trigger CategoryAttachmentAssociation on clcommon__Category_Attachment_Association__c (after insert) {

    Map<ID,clcommon__Category_Attachment_Association__c> attachMap = new Map<ID,clcommon__Category_Attachment_Association__c>(
                [
                    SELECT   clcommon__Attachment_Id__c
                            ,clcommon__Document_Category__r.clcommon__Document_Definition__r.name
                    FROM clcommon__Category_Attachment_Association__c
                    where id in :trigger.newMap.keySet()
                ]);

   
    Set<ID> attachmentIdSet = new Set<ID>();
    Set<ID> applicationIdSet = new Set<ID>();

    

   
    //get a list of attachmen ids
    for (clcommon__Category_Attachment_Association__c a: trigger.new){
        if (attachMap.get(a.id).clcommon__Document_Category__r.clcommon__Document_Definition__r.name == '01 Lease Agreement')
            attachmentIdSet.add(a.clcommon__Attachment_Id__c);
    }

    system.debug('attachment id set: ' + attachmentIdSet); 

    if (attachmentIdSet.isEmpty())
        return;
        
    //find the parents of the attachment
    Map<ID,ID> attachmentParentIdMap = new Map<ID,ID>();
    List<Attachment> aList = new List<Attachment>();
    aList = [select id
                    ,parentId
                    from Attachment
                    where id in :attachmentIdSet
                    ];
    for (Attachment a:aList){
        attachmentParentIdMap.put (a.id,a.parentId);
        applicationIdSet.add(a.parentId);
    }

    system.debug('Attachment parent map: ' + attachmentParentIdMap);

    Map<ID,genesis__Applications__c> applicationMap = new Map<ID,genesis__Applications__c>();

    List<genesis__Applications__c> appList = new List<genesis__Applications__c>([select id
                                ,lease_number__c
                                ,lease_number__r.name
                                from
                                genesis__Applications__c where id in: applicationIdSet
                                and lease_number__c != null
                                ]);

    for (genesis__Applications__c app:appList)
        applicationMap.put(app.id,app);
    
    system.debug('app id to app map' + applicationMap);

    //
    List<cllease__Lease_Account__c> lList = new List<cllease__Lease_Account__c>();

    for (clcommon__Category_Attachment_Association__c a: trigger.new){
        if (!applicationMap.isEmpty())
           
            if (applicationMap.get(attachmentParentIdMap.get(a.clcommon__Attachment_Id__c)).lease_number__c == null)
                continue;
            else{
                system.debug('found lease number' + applicationMap.get(attachmentParentIdMap.get(a.clcommon__Attachment_Id__c)).lease_number__c);
                cllease__Lease_Account__c l  = new cllease__Lease_Account__c();
                l.id = applicationMap.get(attachmentParentIdMap.get(a.clcommon__Attachment_Id__c)).lease_number__c;
                l.Trigger_New_Packet_Workflow__c= true;
                lList.add(l);
                
            }
    }

    if (!lList.isEmpty()){
        update lList;
    }
    
    
    system.debug('******************************************************************************' + trigger.new);
    
    

}