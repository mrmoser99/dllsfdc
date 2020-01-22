({
	// load application data
	loadApplication: function(component) {
		try {
			var action = component.get('c.getApplication');
			action.setParams({
				applicationId: component.get('v.applicationId')
			});
			action.setCallback(this, function (response) {
				var state = response.getState();
				if (state === 'SUCCESS') {
					component.set('v.application', response.getReturnValue());
				} else if (state === 'ERROR') {
					let error = response.getError();
					if (error && error[0]) {
						console.log(error[0].message);
					}
				}
			});
			$A.enqueueAction(action);
		} catch (e) {
			console.log(e);
		}
	},

	// load application documents
	loadDocuments: function(component) {
		try {
			
			console.log('getting documents background');
			var action = component.get('c.getDocuments');
			action.setParams({
				recordId: component.get('v.recordId')
			});
			action.setCallback(this, function(response) {
				var state = response.getState();
				if (state === 'SUCCESS') {
					component.set('v.documents', response.getReturnValue());
				} else if (state === 'ERROR') {
					let error = response.getError();
					if (error && error[0]) {
						console.log(error[0].message);
                    }
                }
			});
			$A.enqueueAction(action);
			
		} catch (e) {
			console.log(e);
		}
	},


	isInputValid: function(component) {
		let inputFields = component.find('docInput'),
			inputDates = component.find('inputDate'),
			inputFieldsValid = true,
			inputDatesValid = true;
		if (inputFields) {
			if(!Array.isArray(inputFields)){
				inputFields = [inputFields];
			}
			inputFieldsValid = inputFields.reduce(function (validFields, inputCmp) {
				inputCmp.showHelpMessageIfInvalid();
				return validFields && inputCmp.get('v.validity').valid;
			}, true);
		}
		if (inputDates) {
			if(!Array.isArray(inputDates)){
				inputDates = [inputDates];
			}
			inputDatesValid = inputDates.reduce(function (validFields, inputCmp) {
				let value = inputCmp.get('v.value');
				if (!value) {
					inputCmp.set('v.errors', [new Error('Date is required.')])
					return false;
				} else if (value.match(/^\d{4}-\d{2}-\d{2}$/i) == null) {
					inputCmp.set('v.errors', [new Error('Invalid Date.')])
					return false;
				} else {
					inputCmp.set('v.errors', null)
					return validFields;
				}
			}, true);
		}
		return inputFieldsValid && inputDatesValid;
	},

	
	uploadFile: function(component, file) {
        console.log('file: '+file);
		try {
			let p = new Promise($A.getCallback(function(resolve, reject) {
				let reader = new FileReader(),
					that = this;
				reader.onloadend = $A.getCallback(function() {
					console.log('finished reading');
					var action = component.get('c.uploadAttachment');
					action.setParams({
						recordId: component.get('v.recordId'),
						fileName: file.name,
						contentType: file.type,
						base64Body: btoa(reader.result)
					});
					action.setCallback(that, function (response) {
						console.log('finished upload');
						let state = response.getState();
						if (state === 'SUCCESS') {
							resolve(response.getReturnValue());
						} else if (state === 'ERROR') {
							let error = response.getError();
							if (error && error[0]) {
								console.log(error[0].message);
							}
							reject(error);
						}
					});
					console.log('uploading');
					$A.enqueueAction(action);
				});
                if (!FileReader.prototype.readAsBinaryString) {
                    FileReader.prototype.readAsBinaryString = function (fileData) {
                       var binary = "";
                       var pt = this;
                       var reader = new FileReader();      
                       reader.onload = function (e) {
                           var bytes = new Uint8Array(reader.result);
                           var length = bytes.byteLength;
                           for (var i = 0; i < length; i++) {
                               binary += String.fromCharCode(bytes[i]);
                           }
                        //pt.result  - readonly so assign binary
                        pt.content = binary;
                        console.log('HERE!');
                        $(pt).trigger('onloadend'); 
                        console.log('HERE!!!');
                    }
                    reader.readAsArrayBuffer(fileData);
                    }
                }
				reader.readAsBinaryString(file);
			}));
			return p;
		} catch (e) {
			console.log(e);
		}

	}

})