({
    doInit: function(component, event, helper) {
        
        helper.loadApplicationFees(component);
        helper.loadPicklistOptions(component);
        var action = component.get('c.getApp');
        action.setParams({
            applicationId: component.get('v.applicationId')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                console.log('hello');
                component.set('v.customerInsurance', response.getReturnValue().Customer_Provided_Insurance__c);
                console.log('getting term:' + response.getReturnValue().genesis__Term__c);
                component.set('v.term', response.getReturnValue().genesis__Term__c);
            } else if (state === 'ERROR') {
                let error = response.getError();
                if (error && error[0]) {
                    console.log(error[0].message);
                }
            }
        });
        $A.enqueueAction(action);
    },

    handleRefresh: function(component, event, helper){
        var source = event.getParam('source');
        console.log('!!!'+source);
        if(source === 'FMZ_ApplicationEquipment') {
            var data = event.getParam('data').map(function(d) { 
                return {label: helper.formatData(d), value: d.Id};
            });
            component.set('v.equipmentOpts', data);
        } else if(source === 'FMZ_ApplicationServiceAndFees_New') {
        	helper.loadApplicationFees(component);
        	var onChangeAction = component.get('v.onchange');
            $A.enqueueAction(onChangeAction);
        } else {
            helper.loadApplicationFees(component);
        }
    },

    // search for fees
    lookupSearch: function(component, event, helper) {
        let lookup = component.find('lookup');
        // get the search server action
        const serverSearchAction = component.get('c.search');
        // pass the action to the Lookup component by its search method
        lookup.search(serverSearchAction);
        $A.util.removeClass(lookup, 'slds-has-error');
        component.set('v.error', null)
    },

    // add equipment
    handleAdd: function(component, event, helper) {
        var applicationId = component.get('v.applicationId'),
            lookup = component.find('lookup'),
            selection = lookup.get('v.selection');
        $A.util.removeClass(lookup, 'slds-has-error');
        component.set('v.error', null)
        //helper.addFees(component, selection[0].id);
        let modalBody;
     
        
        console.log('calling add:' + component.get('v.nbrofpayments'));
        $A.createComponent('c:FMZ_ApplicationServiceAndFees_New',{
            applicationId : applicationId,
            feeDefId : selection[0].id,
            nbrofpayments: component.get('v.nbrofpayments')
        },
            function(content, status, errorMessage) {
                if (status === 'SUCCESS') {
                    modalBody = content;
                    component.find('overlayLib').showCustomModal({
                        body: modalBody,
                        showCloseButton: false,
                        cssClass: 'mymodal',
                        closeCallback: function() {
                        }
                    })
                } else if (status === 'ERROR') {
                    let toast = $A.get('e.force:showToast');
                    toast.setParams({
                        title: 'Error',
                        message: errorMessage,
                        type: 'error'
                    });
                    toast.fire();
                }
            }
        );
    },

    // delete fee
    handleDelete: function(component, event, helper) {
        component.set('v.processing', true);
        var val = event.getSource().get('v.value');
        var deleteButtons = component.find('deleteBtn');
        var fee = component.get('v.fees');

        try {
            if (Array.isArray(deleteButtons)) {
                for (var i = 0; i < deleteButtons.length; i++) {
                    if (val == deleteButtons[i].get('v.value')) {
                        helper.deleteFee(component, fee[i].Id);
                        break;
                    }
                }
            } else {
                if (event.getSource().getLocalId() == deleteButtons.getLocalId()) {
                    helper.deleteFee(component, fee[0].Id)
                }
            }
        } catch(e) {
            console.log(e);
            component.set('v.processing', false);
        }
    },

    // validate required fields and at least one piece of equipment
    saveAndValidate: function(component, event, helper) {
        let equipment = component.get('v.equipment'),
            lookup = component.find('lookup');
        try {
            if (!Boolean(equipment) || equipment.length == 0) {
                $A.util.addClass(lookup, 'slds-has-error');
                component.set('v.error', 'Please add equipment to the application.')
                return false;
            } else if (!helper.isEquipmentValid(component)) {
                return false;
            } else {
                $A.util.removeClass(lookup, 'slds-has-error');
                component.set('v.error', null)
                return true;
            }
        } catch (e) {
            console.log(e);
        }
    },

    // mark components with equipment-changed css class
    handleEquipmentChange: function(component, event, helper) {
        console.log('handle equipment change');
        try {
            let inputControl = event.getSource();
            $A.util.addClass(inputControl, 'equipment-changed');
        } catch (e) {
            console.log(e);
        }
    },

    // do update on blur if the field is changed
    handleEquipmentBlur: function(component, event, helper) {
        console.log('handle equipment blur');
        try {
            let inputControl = event.getSource(),
                localId = inputControl.getLocalId(),
                isChanged = $A.util.hasClass(inputControl, 'equipment-changed'),
                globalId = inputControl.getGlobalId(),
                inputControls = component.find(localId),
                feeRecords = component.get('v.fees'),
                newValue = inputControl.get('v.value'),
                feeId,
                feeUpdate = {},
                i;

            console.log('HERE!!');
            console.log('Global Id: '+globalId);
            if (Array.isArray(inputControls)) {
                for (i = 0; i < inputControls.length; i++) {
                    if (globalId == inputControls[i].getGlobalId()) {
                        feeId = feeRecords[i].Id;
                        break;
                    }
                }
            }else{
                
            }
            console.log('Fee Id: '+feeId);
            if (!feeId) {
                return;
            }

            feeUpdate.Id = feeId;

            console.log('AT SWITCH');

            switch(localId) {
                case 'equipmentSelect':
                    feeUpdate.Equipment__c = newValue;
                    break;
                case 'paymentCount':
                    feeUpdate.Number_of_Payments__c = Number(newValue);
                    break;
                case 'frequency':
                    feeUpdate.Frequency__c = newValue;
                    break;
                case 'amount':
                    feeUpdate.Amount__c = Number(newValue);
                    break;
                case 'dueDate':
                    feeUpdate.Start_Date__c = newValue;
                    break;
                case 'serviceEscalate':
                    feeUpdate.Service_Escalate__c = newValue;
                    if(newValue == 'YES'){
                        feeUpdate.Escalation_Frequency__c = component.get('v.escalateFreqOpts')[0].value;
                        feeUpdate.Escalate_Service_On__c = component.get('v.escalateOnOpts')[0].value;
                        feeUpdate.Escalation_Type__c = component.get('v.escalateTypeOpts')[0].value;
                        feeUpdate.Escalation_Value__c = 0.1;
                    }else{
                        feeUpdate.Escalation_Frequency__c = '';
                        feeUpdate.Escalate_Service_On__c = '';
                        feeUpdate.Escalation_Type__c = '';
                    }
                    break;
                case 'escalateFreq':
                    feeUpdate.Escalation_Frequency__c = newValue;
                    break;
                case 'escalateOn':
                    feeUpdate.Escalate_Service_On__c = newValue;
                    break;
                case 'escalateType':
                    feeUpdate.Escalation_Type__c = newValue;
                    break;
                case 'escalateValue':
                    feeUpdate.Escalation_Value__c = newValue;
                    break;
                default:
                    return;
            }

            console.log('ABOUT TO UPDATE');
            helper.updateFee(component, feeUpdate, localId);

            $A.util.removeClass(inputControl, 'equipment-changed');

        } catch (e) {
            console.log(e);
        }
    },
    handleInsuranceChange : function(component, event, helper){
        component.set('v.processing', true);
        console.log('handleInsuranceChange');
        var action = component.get('c.updateApplication');
        var customerInsurance = component.get('v.customerInsurance');
        action.setParams({
            appId: component.get('v.applicationId'),
            customerInsurance: customerInsurance
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                console.log('SUCCESS');
                var onChangeAction = component.get('v.onchange');
                        $A.enqueueAction(onChangeAction);
                if(customerInsurance){
                    var fees = component.get('v.fees');
                    console.log('Fees: '+fees);
                    for(var x in fees){
                        console.log(fees[x].Fee__r.Name);
                        if(fees[x].Fee__r.Name == 'Insurance Fees'){
                            helper.deleteFee(component, fees[x].Id);
                        }
                    }
                }
            } else if (state === 'ERROR') {
                let error = response.getError();
                if (error && error[0]) {
                    console.log(error[0].message);
                }
            }
        });
        $A.enqueueAction(action);
    }
})