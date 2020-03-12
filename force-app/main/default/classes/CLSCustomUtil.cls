/**
 *  Author: Cloud Lending Solutions
 *  Description: CLS Utilies for reusable code.
 *
 **/
public with sharing class CLSCustomUtil {
	/**
	 * Utillity to pull all fields for a object
	 * @param: ObjectAPIName
	 * @return: object fields API Names separated with comma (,)
	 */

	public static String fetchObjectFields(String objectName) {
		Schema.sObjectType sObjectType = Schema.getGlobalDescribe().get(objectName);
		Map<String, Schema.SObjectField> fieldsMap = sObjectType.getDescribe().fields.getMap();
		String fields = 'Id, Name, ';
		for (String key : fieldsMap.keySet()) {
			if (key.endsWith('__c')) {
				fields = fields + fieldsMap.get(key).getDescribe().getName() + ',';
			}
		}
		if (fields.endsWith(',')) {
			fields = fields.substring(0, fields.length() - 1);
		}
		return fields;
	}

	/**
	 * Following method helps in extracting only custom fields for specific object type
	 */
	public static String fetchAllCustomFields(String type) {
        String newType = type;
        //system.debug(logginglevel.ERROR, '#### newType: '+newType);
        Schema.sObjectType sObjectType = Schema.getGlobalDescribe().get(newType);
        Map<String, Schema.SObjectField> fieldsMap = sObjectType.getDescribe().fields.getMap();
        //because I always want name and ID to be selected
        String fields = ' Name, Id , ';
        for (String key : fieldsMap.keySet()) {
            if (key.endsWith('__c')) {
                fields = fields + key + ',';
            }
        }
        if (fields.endsWith(',')) {
            fields = fields.substring(0, fields.length() - 1);
        }
        //system.debug(logginglevel.ERROR, '#### after fields: '+fields);
        return fields;
	}
	
	/**
     * Fetch all the fields created by user as custom and fields which are added as part of other product and not the product fields which are out of the box from the product
     * @param  objectName The name of the object with nameSpace.
     * @return        Returns all custom fields.
     */
	public static List<String> getAllCustomFields(String objectName) {
        String nameSpace =  getNSWithUnderScore();
        String actualObjectName, field;
        List<String> fields = new List<String>();
        actualObjectName = objectName;
        if(nameSpace.length() > 0) {
            actualObjectName = nameSpace+objectName;
        }
        Schema.sObjectType sObjectType1 = Schema.getGlobalDescribe().get(actualObjectName);
        Map<String, Schema.SObjectField> fieldsMap = sObjectType1.getDescribe().fields.getMap();
        for(String key : fieldsMap.keySet()){
            field = String.valueof(fieldsMap.get(key));
            if(!field.startsWith(nameSpace) && field.endsWith('__c')){
                fields.add(field);
            }
        }
        return fields;
    }

	/**
	 * Internal helper for converting Set<Id> to String with comma ()
	 */
	public static String getStringFromIds(Set<Id> objectIds) {
		System.debug(LoggingLevel.ERROR, '---received IDs: '+objectIds);
		String objectIdstr = '';
		if(objectIds == null || objectIds.size() == 0) {
			return objectIdstr;
		}
		for (Id branchId : objectIds) {
			objectIdstr = objectIdstr + '\'' + String.escapeSingleQuotes(branchId) + '\'' + ',';
		}
		objectIdstr = objectIdstr + '\'\'';
		return objectIdstr;
	}

	/**
	 * Internal helper for converting Set<Id> to String with comma ()
	 */
	public static String getStringsFromList(List<String> objectNames) {
		System.debug(LoggingLevel.ERROR, '---received IDs: '+objectNames);
		String objectNamestr = '';
		if(objectNames == null || objectNames.size() == 0) {
			return objectNamestr;
		}
		for (String branchId : objectNames) {
			objectNamestr = objectNamestr + '\'' + String.escapeSingleQuotes(branchId) + '\'' + ',';
		}
		objectNamestr = objectNamestr + '\'\'';
		return objectNamestr;
	}

	/**
	 * Get the Vertex Custom Settings
	 **/
	public static VertexApi__c getVertexConfiguration() {
		VertexApi__c vertexParams = VertexApi__c.getInstance();
        if (vertexParams == null) {
            vertexParams = VertexApi__c.getOrgDefaults(); // defaulting
        }
        return vertexParams;
	}

	/**
	 * Retrieving the CL Originate Org Parameters.
	 */
	public static genesis__Org_Parameters__c getCLOriginateOrgParameters() {
		genesis__Org_Parameters__c orgParams = genesis__Org_Parameters__c.getInstance();
		 if (orgParams == null) {
			 orgParams = genesis__Org_Parameters__c.getOrgDefaults(); // defaulting
		 }
		 return orgParams;
	}

	/**
	 * Retrieving the CL Lease  Org Parameters.
	 */
	public static cllease__Org_Parameters__c getCLLeaseOrgParameters() {
		cllease__Org_Parameters__c orgParams = cllease__Org_Parameters__c.getInstance();
		 if (orgParams == null) {
			 orgParams = cllease__Org_Parameters__c.getOrgDefaults(); // defaulting
		 }
		 return orgParams;
	}

	/**
	 * Retrieving the CL Lease default batch size from  Org Parameters.
	 */
	public static String getContractsSizeForBatch() {
        cllease__Org_Parameters__c orgParams = getCLLeaseOrgParameters();
        return String.valueOf(Integer.valueOf(orgParams.cllease__Batch_job_limit__c));
	}
	
	/**
	 * CL Lease Namespace
	 */
	public static String getNSWithUnderScore() {
		return 'cllease__';
	}

	
}