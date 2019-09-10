({
    // load or reload equipment associated with this application
    loadApplicationEquipment: function(component) {
        var action = component.get('c.getEquipment');
        action.setParams({
            applicationId: component.get('v.applicationId')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var equipment = response.getReturnValue();
                component.set('v.equipment', response.getReturnValue());
                this.checkTotalCost(equipment);
                this.equipmentHasChanged(response.getReturnValue());
            } else if (state === 'ERROR') {
                let error = response.getError();
                if (error && error[0]) {
                    console.log(error[0].message);
                }
            }
        });
        $A.enqueueAction(action);
    },
    checkTotalCost: function(equipment){
        var totalCost = 0;
        for(var x in equipment){
            totalCost += Number(equipment[x].genesis__Estimated_Selling_Price__c);
        }
        if(totalCost > 50000){
            let toast = $A.get('e.force:showToast');
            toast.setParams({
                title: 'Warning',
                message: 'Total of Equipment Selling Prices is more than $50,000 and may cause a Pricing Error.',
                type: 'warning'
            });
            toast.fire();
        }
    },
    // load or reload installation addresses for the application account
    loadInstallAddresses: function(component) {
        var action = component.get('c.getInstallationAddresses');
        action.setParams({
            applicationId: component.get('v.applicationId')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                component.set('v.installAddresses', response.getReturnValue());
                this.setBlankLocation(component);
                window.setTimeout($A.getCallback(function(){
                    var evt = $A.get('e.c:FMZ_Application_Refresh');
                    evt.setParams({
                        source: 'FMZ_ApplicationEquipment:InstallAddressChange'
                    });
                    evt.fire();
                }), 1000);
            } else if (state === 'ERROR') {
                let error = response.getError();
                if (error && error[0]) {
                    console.log(error[0].message);
                }
            }
        });
        $A.enqueueAction(action);
    },
    setBlankLocation: function(component){
        var locations = component.find('location');
        var addresses = component.get('v.installAddresses');
        var equipment = component.get('v.equipment');
        var addressIds = [];
        for(var x in addresses){
            addressIds.push(addresses[x].Id);
        }
        console.log('addressIds: '+addressIds);
        if(locations){
            if(!Array.isArray(locations)){
                locations = [locations];
            }
            console.log('locations: '+locations);
            for(var y in locations){
                console.log('LOCATION VALUE: '+locations[y].get('v.value'));
                console.log('EQUIPMENT VALUE: '+equipment[y].Install_Address1__c);
                //console.log('CHECK: '+!addressIds.includes(equipment[y].Install_Address1__c));
                if(addressIds.includes(equipment[y].Install_Address1__c)){
                    locations[y].set('v.value', equipment[y].Install_Address1__c);
                }else if(addressIds.includes(locations[y].get('v.value'))){
                    equipment[y].Install_Address1__c = locations[y].get('v.value');
                }else{
                    locations[y].set('v.value', '');
                    equipment[y].Install_Address1__c = null;
                }
            }
            component.set('v.equipment', equipment);
        }
    },
    addEquipment: function(component, equipmentId) {
        let applicationId = component.get('v.applicationId'),
            action = component.get('c.addEquipment');
        action.setParams({
            applicationId: applicationId,
            equipmentId: equipmentId
        });
        action.setCallback(this, function(response) {
            let state = response.getState(),
                onChangeAction = component.get('v.onchange');
            component.set('v.processing', false);
            if (state === 'SUCCESS') {
                let lookup = component.find('lookup');
                lookup.set('v.selection', []);
                this.loadApplicationEquipment(component);
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
    deleteEquipment: function(component, appEquipmentId) {
        let action = component.get('c.deleteEquipment');
        action.setParams({
            appEquipmentId: appEquipmentId
        });
        action.setCallback(this, function(response) {
            let state = response.getState(),
                onChangeAction = component.get('v.onchange');
            component.set('v.processing', false);
            if (state === 'SUCCESS') {
                this.loadApplicationEquipment(component);
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
    helpSaveAndValidate: function (component){
        console.log('HELP SAVE AND VALIDATE');
        let equipment = component.get('v.equipment'),
            lookup = component.find('lookup');
        try {
            if (!Boolean(equipment) || equipment.length == 0) {
                $A.util.addClass(lookup, 'slds-has-error');
                component.set('v.error', 'Please add equipment to the application.')
                return false;
            } else if (!this.isEquipmentValid(component)) {
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

    updateEquipment: function (component, equipment, inputControl) {
    	try {
			console.log('update equipment');
			let action = component.get('c.updateEquipment');
			action.setParams({
				equipmentString: JSON.stringify(equipment)
			});
			action.setCallback(this, function (response) {
				try {
					let state = response.getState(),
						onChangeAction = component.get('v.onchange');
					if (state === 'SUCCESS') {
						this.equipmentHasChanged(component.get('v.equipment'));
						if (onChangeAction) {
							$A.enqueueAction(onChangeAction);
						}
            var action = component.get('c.getEquipment');
            action.setParams({
                applicationId: component.get('v.applicationId')
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === 'SUCCESS') {
                    var equipment = response.getReturnValue();
                    component.set('v.equipment', response.getReturnValue());
                } else if (state === 'ERROR') {
                    let error = response.getError();
                    if (error && error[0]) {
                        console.log(error[0].message);
                    }
                }
            });
            $A.enqueueAction(action);
					} else if (state === 'ERROR') {
						let error = response.getError();
						if (error && error[0]) {
							if (error[0].message) {
								console.log(error[0].message);
							} else if (error[0].pageErrors && error[0].pageErrors[0]) {
								console.log(error[0].pageErrors[0].message);
								if (error[0].pageErrors[0].statusCode === 'DUPLICATE_VALUE'
								&& inputControl.getLocalId() === 'serialnum') {
									inputControl.setCustomValidity('Duplicate Serial Number');
									inputControl.reportValidity();
								}
							}
						}
					}
					var equipment = component.get('v.equipment');
                    this.checkTotalCost(equipment);
				} catch (e) {
					console.log(e);
				}
			});
			console.log('enqueue');
			$A.enqueueAction(action);
		} catch (e) {
    		console.log(e);
		}
    },

    isEquipmentValid: function(component) {
        let locations = component.find('location'),
			serialNums = component.find('serialnum'),
			prices = component.find('price'),
			installDates = component.find('installDate'),
			locationsValid,
			serialNumsValid,
			pricesValid,
			installDatesValid;

        if(!Array.isArray(locations)){
             locations = [locations];
        }
        locationsValid = locations.reduce(function (validFields, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validFields && inputCmp.get('v.validity').valid && inputCmp.get('v.value') != '';
        }, true);

        if(!Array.isArray(serialNums)){
			serialNums = [serialNums];
        }
        serialNumsValid = serialNums.reduce(function (validFields, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validFields && inputCmp.get('v.validity').valid;
        }, true);

        if(!Array.isArray(prices)){
             prices = [prices];
        }
        pricesValid = prices.reduce(function (validFields, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validFields && inputCmp.get('v.validity').valid;
        }, true);

        if(!Array.isArray(installDates)){
             installDates = [installDates];
        }
       installDatesValid = installDates.reduce(function (validFields, inputCmp) {
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

//	refreshUpfrontTax: function(component) {
//    	try {
//			let action = component.get('c.getEquipment');
//			action.setParams({
//				applicationId: component.get('v.applicationId')
//			});
//			action.setCallback(this, function (response) {
//				let state = response.getState(),
//					equipment = component.get('v.equipment'),
//					equipmentUpdates = response.getReturnValue();
//				if (state === 'SUCCESS') {
//					if (equipment && equipmentUpdates) {
//						let equipmentUpdateMap = equipmentUpdates.reduce(function (map, item) {
//							map[item.Id] = item;
//							return map;
//						}, {});
//						equipment.forEach(function(item) {
//							let update = equipmentUpdateMap[item.Id];
//							item.Upfront_Tax_Amount__c = update.Upfront_Tax_Amount__c;
//						});
//						component.set('v.equipment', equipment);
//					}
//				} else if (state === 'ERROR') {
//					let error = response.getError();
//					if (error && error[0]) {
//						console.log(error[0].message);
//					}
//				}
//			});
//			$A.enqueueAction(action);
//		} catch (e) {
//    		console.log(e);
//		}
//	},

    equipmentHasChanged: function(data) {
        var evt = $A.get('e.c:FMZ_Application_Refresh');
        evt.setParams({
            source: 'FMZ_ApplicationEquipment',
            data: data
        });
        evt.fire();
    }

})