({
	doInit: function(component, event, helper) {
		try {
			component.set('v.showError',false);
			component.set('v.errorMessage',null);
			//helper.loadApplication(component);
			helper.loadDocuments(component);
		} catch (e) {
			console.log(e);
		}
	},
	saveAndValidate: function(component, event, helper) {
		try {
            console.log('notearea: ' + component.get('v.notearea'));
			var result = false;
			if (component.get('v.notearea') == '') {
                console.log('error');
				component.set('v.showError',true);
			    component.set('v.errorMessage','You must add a note!');
				result = false;
			} else {
				console.log('clear');
			    component.set('v.showError',false);
                component.set('v.errorMessage',null);
				result = true;
			}

			if (component.get('v.documents') == ''){
				console.log('no attachments');
				component.set('v.showError',true);
			    component.set('v.errorMessage','You must add an attachment!');
				result = false;	
			}
			else{
				console.log('attachments found');	
				component.set('v.showError',false);
                component.set('v.errorMessage',null);
				result = true;
			}

			return result;

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
        console.log('handle upload');
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
	}

})