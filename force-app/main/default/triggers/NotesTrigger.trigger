/***************************************************************************************************
 * 
 *  Trigger on ConentDocument Link
 *  This makes notes visible to all users
 * 
 *  Change Log:
 *
 *  1/27/2020 - MRM Created Trigger
 * 
 **************************************************************************************************/
 trigger NotesTrigger on ContentDocumentLink (before insert) {
   
	for(ContentDocumentLink cont : Trigger.new)
	{ 
		cont.Visibility = 'AllUsers'; 
	}

}
