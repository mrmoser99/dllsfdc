({
    onInit: function(component, event, helper) {
        console.log('on init');
        let customer = component.find('customer');
        customer.set('v.collapsed', false);
         
    },
    handleCustomerNext: function(component, event, helper) {
        let customer = component.find('customer'),
            customerForm = component.find('customerForm');
        console.log('in handle customer next');
        try { 
            if (customerForm.saveAndValidate()) {
                customer.set('v.complete', true);
                helper.checkCompletion(component);
            } else {
                customer.set('v.complete', false);
                helper.checkCompletion(component);
            }
        } catch (e) {
            console.log(e);
        }
    },
    handleEquipmentNext: function(component, event, helper) {
        let equipment = component.find('equipment'),
            equipmentForm = component.find('equipmentForm');
        try {
            if (equipmentForm.saveAndValidate()) {
                equipment.set('v.complete', true);
                helper.checkCompletion(component);
            } else {
                equipment.set('v.complete', false);
                helper.checkCompletion(component);
                equipment.set('v.collapsed', false);
            }
        } catch (e) {
            console.log(e);
        }
    },
    handleNotesNext: function(component, event, helper) {
        let notes = component.find('notes'),
            notesForm = component.find('notesForm');
        try {
            console.log('calling save and v');
            if (notesForm.saveAndValidate()) {
                console.log('save and v returned true');
                notes.set('v.complete', true);
                helper.checkCompletion(component);
            } else {
                notes.set('v.complete', false);
                helper.checkCompletion(component);
                notes.set('v.collapsed', false);
            }
        } catch (e) {
            console.log(e);
        }
        
    },
    
    navigateToRecord: function(component, event, helper) {

        component.set('v.processing', true);
        
        let customerForm = component.find('customerForm');
        let equipmentForm = component.find('equipmentForm');
        let notesForm = component.find('notesForm');
        console.log(notesForm.get('v.notearea'));
        let action = component.get('c.createClaim');
        action.setParams({
            recordId: component.get('v.recordId'),
            claim: customerForm.get('v.claim'),
            eList: equipmentForm.get('v.value'),
            notes: notesForm.get('v.notearea')
            
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            console.log(state);
            console.log(response);
            console.log(response.getReturnValue());
            if (state === 'SUCCESS') {
                var evt = $A.get("e.force:navigateToSObject");
                evt.setParams({
                    recordId: response.getReturnValue()
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
    }
})