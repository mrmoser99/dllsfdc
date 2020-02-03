({
    // load or reload equipment associated with this application
    loadApplicationFees: function(component) {
        var action = component.get('c.getFees');
        action.setParams({
            applicationId: component.get('v.applicationId')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                component.set('v.fees', response.getReturnValue());
            } else if (state === 'ERROR') {
                let error = response.getError();
                if (error && error[0]) {
                    console.log(error[0].message);
                }
            }
        });
        $A.enqueueAction(action);
    },
    loadFieldOpts : function(component, field, opts){
        var action = component.get('c.getPicklistOptions');
        action.setParams({
            fieldName : field
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                component.set(opts, response.getReturnValue());
            } else if (state === 'ERROR') {
                let error = response.getError();
                if (error && error[0]) {
                    console.log(error[0].message);
                }
            }
        });
        $A.enqueueAction(action);
    },
    // load or reload installation addresses for the application account
    loadPicklistOptions: function(component) {
        this.loadFieldOpts(component, 'Service_Escalate__c', 'v.serviceEscalateOpts');
        this.loadFieldOpts(component, 'Frequency__c', 'v.frequencyOpts');
        this.loadFieldOpts(component, 'Escalation_Frequency__c', 'v.escalateFreqOpts');
        this.loadFieldOpts(component, 'Escalate_Service_On__c', 'v.escalateOnOpts');
        this.loadFieldOpts(component, 'Escalation_Type__c', 'v.escalateTypeOpts');
        var action = component.get('c.getEquipmentOptions');
        action.setParams({
            applicationId : component.get('v.applicationId')
        });
      
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                component.set('v.equipmentOpts', response.getReturnValue());
            } else if (state === 'ERROR') {
                let error = response.getError();
                if (error && error[0]) {
                    console.log(error[0].message);
                }
            }
        });
        $A.enqueueAction(action);
    },
    addFees: function(component, feeId) {
        let applicationId = component.get('v.applicationId'),
            action = component.get('c.addFees');
            console.log('Application ID: '+applicationId);
        action.setParams({
            applicationId: applicationId,
            feeId: feeId
        });
        action.setCallback(this, function(response) {
            let state = response.getState(),
                onChangeAction = component.get('v.onchange');
            component.set('v.processing', false);
            if (state === 'SUCCESS') {
                let lookup = component.find('lookup');
                lookup.set('v.selection', []);
                this.loadApplicationFees(component);
                if (onChangeAction) {
                    $A.enqueueAction(onChangeAction);
                }
            } else if (state === 'ERROR') {
                console.log(response.getError());
            }
        });
        component.set('v.processing', true);
        $A.enqueueAction(action);
    },
    deleteFee: function(component, appFeeId) {
        let action = component.get('c.deleteFee');
        action.setParams({
            appFeeId: appFeeId
        });
        action.setCallback(this, function(response) {
            let state = response.getState(),
                onChangeAction = component.get('v.onchange');
            component.set('v.processing', false);
            if (state === 'SUCCESS') {
                this.loadApplicationFees(component);
                if (onChangeAction) {
                    $A.enqueueAction(onChangeAction);
                }
            } else if (state === 'ERROR') {
                let error = response.getError();
                if (error && error[0]) {
                    console.log(error[0].message);
                }
            }
        });
        component.set('v.processing', true);
        $A.enqueueAction(action);
    },
    updateEquipment: function (component, equipment, changeType) {
console.log('update equipment');
//TODO: set error on field if update fails
        let action = component.get('c.updateEquipment');
        action.setParams({
            equipmentString: JSON.stringify(equipment)
        });
        action.setCallback(this, function(response) {
            let state = response.getState(),
                onChangeAction = component.get('v.onchange');
            //component.set('v.processing', false);
            if (state === 'SUCCESS') {
                if (onChangeAction) {
                    if (changeType) {
                        onChangeAction.setParam('changeType', changeType);
                    }
                    $A.enqueueAction(onChangeAction);
                }
            } else if (state === 'ERROR') {
                let error = response.getError();
                if (error && error[0]) {
                    console.log(error[0].message);
                }
            }
        });
        //component.set('v.processing', true);
        $A.enqueueAction(action);
    },

    isEquipmentValid: function(component) {
        var locationsValid = component.find('location').reduce(function (validFields, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validFields && inputCmp.get('v.validity').valid;
        }, true);
        var serialNumsValid = component.find('serialnum').reduce(function (validFields, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validFields && inputCmp.get('v.validity').valid;
        }, true);
        var pricesValid = component.find('price').reduce(function (validFields, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validFields && inputCmp.get('v.validity').valid;
        }, true);
        var installDatesValid = component.find('installDate').reduce(function (validFields, inputCmp) {
            let value = inputCmp.get('v.value');
            if (!value) {
                inputCmp.set('v.errors', [new Error('Install Date is required.')])
                return false;
            } else if (value.match(/^\d{4}-\d{2}-\d{2}$/i) == null) {
                inputCmp.set('v.errors', [new Error('Invalid Date.')])
                return false;
            } else {
                inputCmp.set('v.errors', null)
                return validFields;
            }
        }, true);
        return locationsValid && serialNumsValid && pricesValid && installDatesValid;
    },
    renderError: function(component) {
        component.find('notifLib').showToast({
            'variant': 'error',
            'message': 'ERROR: An error has occurred processing your request. Try again later, or report this issue to a System Administrator.',
            'mode': 'sticky'
        });
    },
    validate: function(component) {
        //perform client side validation so we can catch required fields before they get to the database
        //find all required components, return true if all are valid, false if any are invalid
        var requiredIds = ['equipmentList', 'amount', 'frequency', 'paymentCount', 'escalateFreq', 'escalateOn', 'escalateType', 'escalateValue'];
        var valid = true;
        requiredIds.reduce(function(a, id) {
            //show invalid message if component is invalid
            var c = component.find(id);
            if(!c) return a;

            var validity = c.get('v.validity');

            console.log(validity.valid);

            if(!validity.valid){
                valid = false;
                c.showHelpMessageIfInvalid();
            }
            return a && validity.valid;

        }, true);
        console.l
        return valid;
	}

})