public without sharing class IC_ClaimNotesController {
	
	
	@AuraEnabled
	public static List<Attachment> getDocuments(Id recordId) {

        String tempName = 'temp_' + recordId + '_%';

        system.debug('looking for =' + tempName);
		List<Attachment> documents = [
				SELECT Id, Name, CreatedDate, Description
				FROM Attachment
				WHERE ParentId = :recordId
                and name like :tempName
				ORDER BY CreatedDate DESC
		];

		for (Attachment a:documents)
			a.name = a.name.replace('temp_' + recordId + '_','');
		
		return documents;

	}

	@AuraEnabled
	public static void uploadAttachment(String recordId, String fileName, String contentType, String base64Body){
		
        Attachment att = new Attachment(
				ParentId = recordId,
				Name = 'temp_' + recordId + '_' + fileName,
				Body = EncodingUtil.base64Decode(base64Body),
				ContentType = contentType
		);
        system.debug('added document =' + att.name);
		insert att;

        system.debug('added document =' + att.name);
		

	}

}