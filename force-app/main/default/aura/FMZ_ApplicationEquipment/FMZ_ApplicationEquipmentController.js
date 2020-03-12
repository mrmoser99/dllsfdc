({
    doInit: function(component, event, helper) {
        helper.loadApplicationEquipment(component);
        helper.loadInstallAddresses(component);
    },

    // search for equipment
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
        helper.addEquipment(component, selection[0].id);
    },

    // delete equipment
    handleDelete: function(component, event, helper) {
        let deleteBtn = event.getSource().getGlobalId(),
            deleteButtons = component.find('deleteBtn'),
            equipment = component.get('v.equipment'),
            i;
        try {
            if (Array.isArray(deleteButtons)) {
                for (i = 0; i < deleteButtons.length; i++) {
                    if (deleteBtn == deleteButtons[i].getGlobalId()) {
                        helper.deleteEquipment(component, equipment[i].Id)
                        break;
                    }
                }
            } else {
                if (deleteBtn == deleteButtons.getGlobalId()) {
                    helper.deleteEquipment(component, equipment[0].Id)
                }
            }
        } catch(e) {
            console.log(e);
        }
    },

    // validate required fields and at least one piece of equipment
    saveAndValidate: function(component, event, helper) {
        console.log('SAVE AND VALIDATE')
        return helper.helpSaveAndValidate(component);
    },

    // mark components with equipment-changed css class
    handleEquipmentChange: function(component, event, helper) {
        console.log('handle equipment change');
        try {
            let inputControl = event.getSource();
            $A.util.addClass(inputControl, 'equipment-changed');
			if (inputControl.get('v.validity').customError) {
				inputControl.setCustomValidity("");
				inputControl.reportValidity();
			}
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
                isChanged = $A.util.hasClass(inputControl, 'equipment-changed')
                    || localId == 'location' || localId == 'exempt',
                globalId = inputControl.getGlobalId(),
                inputControls = component.find(localId),
                equipmentRecords = component.get('v.equipment'),
                newValue = inputControl.get('v.value'),
                validity = localId != 'installDate' ? inputControl.get('v.validity') : null,
                isValid = Boolean(validity) ? validity.valid : true,
                equipmentId,
                equipmentUpdate = {},
				msrp,
				msrpWarningPct = $A.get('$Label.c.FMZ_Price_Exceeds_MSRP_Warning_Percent'),
                i;

            if (isChanged && localId === 'installDate') {
                if (!newValue) {
                    inputControl.set('v.errors', [new Error('Install Date is required.')]);
                    return;
                } else {
                    inputControl.set('v.errors', null);
                    isValid = (newValue.match(/^\d{4}-\d{2}-\d{2}$/i) != null);
                    if (!isValid) {
                        inputControl.set('v.errors', [new Error('Invalid Date.')]);
                    }
                }
            }

            if (!isChanged || !isValid) {
                return;
            }

            if (Array.isArray(inputControls)) {
                for (i = 0; i < inputControls.length; i++) {
                    if (globalId === inputControls[i].getGlobalId()) {
                        equipmentId = equipmentRecords[i].Id;
                        msrp = equipmentRecords[i].genesis__Equipment__r.MSRP__c;
                        break;
                    }
                }
            } else {
                if (globalId === inputControls.getGlobalId()) {
                    equipmentId = equipmentRecords[0].Id;
					msrp = equipmentRecords[0].genesis__Equipment__r.MSRP__c;
                }
            }

            if (!equipmentId) {
                return;
            }

            equipmentUpdate.Id = equipmentId;

            switch(localId) {
                case 'serialnum':
                    equipmentUpdate.Serial_Number__c = newValue;
                    break;
                case 'price':
					if (newValue && !isNaN(newValue) && msrp && msrpWarningPct && !isNaN(msrpWarningPct)
					&& Number(newValue) > (Number(msrpWarningPct)/100.0) * msrp) {
						let toast = $A.get('e.force:showToast');
						toast.setParams({
							title: 'Warning',
							message: 'Selling price exceeds ' + msrpWarningPct + '% of MSRP',
							type: 'warning'
						});
						toast.fire();
					}
                    equipmentUpdate.genesis__Estimated_Selling_Price__c = Number(newValue);
                    break;
                case 'exempt':
                    equipmentUpdate.Tax_Exempt__c = inputControl.get('v.checked');
                    break;
                case 'location':
                    equipmentUpdate.Install_Address1__c = newValue;
                    break;
                case 'installDate':
                    equipmentUpdate.Installation_Date__c = newValue;
                    break;
                default:
                    return;
            }

            helper.updateEquipment(component, equipmentUpdate, inputControl);

            $A.util.removeClass(inputControl, 'equipment-changed');

        } catch (e) {
            console.log(e);
        }
    },

    handleRefresh: function(component, event, helper){
        
       
        var source = event.getParam('source');
        console.log('source of handlerefresh is:' + source);
        if (source === 'FMZ_ApplicationLocations') {
            helper.loadInstallAddresses(component);
            //helper.helpSaveAndValidate(component);
        } else if (source === 'FMZ_ApplicationForm') {
        	helper.refreshUpfrontTax(component);
		}
    }

})