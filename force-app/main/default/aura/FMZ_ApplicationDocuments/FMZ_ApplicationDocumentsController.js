({
	doInit: function(component, event, helper) {
		try {
			helper.loadApplication(component);
			helper.loadDocuments(component);
		} catch (e) {
			console.log(e);
		}
	},

	handleGenerate: function(component, event, helper) {
		try {
			//if (!helper.isInputValid(component)) {
			//	return;
			//}
            console.log('handleGenerate AppId: '+component.get('v.applicationId'));
			component.set('v.processing', true);
			helper.updateApplication(component)
				.then($A.getCallback(function (result) {
					return helper.generateAgreement(component);
				}))
				.then($A.getCallback(function (result) {
					return helper.loadDocuments(component);
				}))
				.then($A.getCallback(function (result) {
					component.set('v.processing', false);
				}))
				.catch($A.getCallback(function (error) {
					let toast = $A.get('e.force:showToast');
					toast.setParams({
						type: 'error',
						mode: 'dismissable',
						message: 'There was an error generating agreement.'
					});
					component.set('v.processing', false);
					toast.fire();

				}));
		} catch (e) {
            console.log('CLICK CATCH');
			console.log(e);
		}
	},

	handleGenerateEsign: function(component, event, helper) {
		try {
			//if (!helper.isInputValid(component)) {
			//	return;
			//}
            console.log('handleGenerate Esign for AppId: '+component.get('v.applicationId'));
			component.set('v.processing', true);
			helper.updateApplication(component);
			helper.generateAgreementEsign(component);
				
		} catch (e) {
            console.log('CLICK CATCH');
			console.log(e);
		}
	},
	// validate required fields and at least one document
	saveAndValidate: function(component, event, helper) {
		try {
			let documents = component.get('v.documents');
			if (!helper.isInputValid(component)) {
				return false;
			} else if (!Boolean(documents) || documents.length == 0) {
				component.set('v.error', 'Please upload documentation for this lease.')
				return false;
			} else {
				component.set('v.error', null);
				helper.updateApplication(component);
				return true;
			}
		} catch (e) {
			console.log(e);
		}
	},

	handlePreview: function(component, event, helper) {
		$A.get('e.lightning:openFiles').fire({
			recordIds: ['00P0v000002A7vUEAS']
		});
	},

	handleUpload: function(component, event, helper) {
		component.set('v.processing', true);
		helper.uploadFile(component, event.getSource().get('v.files')[0])
			.then($A.getCallback(function (result) {
				return helper.loadDocuments(component);
			}))
			.then($A.getCallback(function (result) {
				component.set('v.processing', false);
			}))
			.catch($A.getCallback(function (result) {
				let toast = $A.get('e.force:showToast');
				toast.setParams({
					type: 'error',
					mode: 'dismissable',
					message: 'There was an error uploading the file.'
				});
				component.set('v.processing', false);
				toast.fire();
			}));
	},

	handleDelete: function(component, event, helper) {
		
		component.set('v.processing', true);
		var ctarget = event.currentTarget;
		var id_str = ctarget.dataset.value;
		component.set('v.selectedDocumentId', id_str);
		
		helper.deleteDocument(component);
		
		let toast = $A.get('e.force:showToast');
		toast.setParams({
					type: 'success',
					mode: 'dismissable',
					duration: '2000',
					message: 'Document was deleted!'
		});
				
		toast.fire();
		
		
		
		helper.loadDocuments(component);

		component.set('v.processing', false);
		
		
		
	}

	
})