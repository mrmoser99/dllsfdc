({
    onInit: function(component, event, helper) {
       
        helper.loadCompletion(component);
        helper.getApp(component);
    },
    handlePartiesNext: function(component, event, helper) {
        let parties = component.find('parties'),
            partiesForm = component.find('partiesForm');
        try {
            if (partiesForm.saveAndValidate()) {
                parties.set('v.complete', true);
                helper.checkCompletion(component);
            } else {
                parties.set('v.complete', false);
                helper.checkCompletion(component);
            }
        } catch (e) {
            console.log(e);
        }
    },
    handleTermsNext: function(component, event, helper) {
        
        
        let terms = component.find('terms'),
            termsForm = component.find('termsForm');
        
        console.log('terms' + termsForm.get('v.nbrofpayments'));
        component.set('v.nbrofpayments', termsForm.get('v.nbrofpayments'));
        try {
            if (termsForm.saveAndValidate()) {
                terms.set('v.complete', true);
                helper.checkCompletion(component);
            } else {
                terms.set('v.complete', false);
                helper.checkCompletion(component);
            }
        } catch (e) {
            console.log(e);
        }
    },
    handleLocationsNext: function(component, event, helper) {
        let locations = component.find('locations'),
            locationsForm = component.find('locationsForm');
        try {
            if (locationsForm.saveAndValidate()) {
                locations.set('v.complete', true);
                helper.checkCompletion(component);
            } else {
                locations.set('v.complete', false);
                helper.checkCompletion(component);
            }
        } catch (e) {
            console.log(e);
        }
        helper.checkCompletion(component);
    },
    handleEquipmentNext: function(component, event, helper) {
        let equipmentForm = component.find('equipmentForm'),
            equipment = component.find('equipment');
        try {
            if (equipmentForm.saveAndValidate()) {
                equipment.set('v.complete', true);
                helper.checkCompletion(component);
            } else {
                equipment.set('v.complete', false);
                helper.checkCompletion(component);
            }
        } catch (e) {
            console.log(e);
        }
    },
    handleServicesNext: function(component, event, helper) {
        let services = component.find('services');
        services.set('v.complete', true);
        helper.checkCompletion(component);
    },
	handleDocumentsNext: function(component, event, helper) {
		let documentsForm = component.find('documentsForm'),
			documents = component.find('documents');
		try {
			if (documentsForm.saveAndValidate()) {
				documents.set('v.complete', true);
				helper.checkCompletion(component);
			} else {
				documents.set('v.complete', false);
				helper.checkCompletion(component);
			}
		} catch (e) {
			console.log(e);
		}
	},
    handleChange: function(component, event, helper) {
        console.log('form change');
        let termsForm = component.find('termsForm');
        console.log('terms' + termsForm.get('v.nbrofpayments'));
        component.set('v.nbrofpayments', termsForm.get('v.nbrofpayments'));
        
        try {
    	    console.log('Caught handleChange!!!');
			let appSummary = component.find('appSummary');
			appSummary.set('v.pricingMessage', null);
			appSummary.set('v.recalculating', true);

			helper.clearPricing(component)
				.then($A.getCallback(function (result) {
					helper.updatePricing(component);
				}))
				.catch($A.getCallback(function (error) {
					appSummary.set('v.recalculating', false);
				}));

		} catch (e) {
    		console.log(e);
		}
    },
    navigateToRecord: function(component, event, helper) {
        component.set('v.processing', true);
        let action = component.get('c.moveToOFACCheck');
        action.setParams({
            appId: component.get('v.applicationId')
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            console.log(state);
            if (state === 'SUCCESS') {
                var evt = $A.get("e.force:navigateToSObject");
                evt.setParams({
                    recordId: component.get("v.applicationId")
                });
                evt.fire();
            } else if (state === 'ERROR') {
                let error = response.getError();
                if (error && error[0]) {
                    console.log(error[0].message);
                }
            }
            component.set('v.processing', false);
        });
        $A.enqueueAction(action);
    },
    handleRefresh: function(component, event, helper){
        var source = event.getParam('source');
        console.log('handleRefresh source: '+source);
        if (source === 'FMZ_ApplicationEquipment:InstallAddressChange') {
            let equipmentForm = component.find('equipmentForm'),
                equipment = component.find('equipment');
            try {
                if (equipmentForm.saveAndValidate()) {
                    equipment.set('v.complete', true);
                    helper.checkCompletion(component);
                } else {
                    equipment.set('v.complete', false);
                    helper.checkCompletion(component);
                }
            } catch (e) {
                console.log(e);
            }
        }
    }
})