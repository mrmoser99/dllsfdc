/************************************************************************************************************************************************************
*   add account to quote
*
*   Change Log:
*
*   7/10/19 - MRM Created - need to associate quotes created for tradeups to the dealer account   
*
*
*************************************************************************************************************************************************************/

    
trigger LeaseOLMQuote on Lease_OLM_Quote__c (before insert) {

     User u = [select contactId
                  from User
                  where id = :userInfo.getUserId()
                 ];

    Contact c = [select accountId
        from Contact 
        where id = :u.contactId];


    for (Lease_OLM_Quote__c q:trigger.new)
        q.account__c = c.accountId;

}