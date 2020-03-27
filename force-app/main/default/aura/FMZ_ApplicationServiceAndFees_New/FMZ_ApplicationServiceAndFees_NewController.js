({
    doInit: function(component, event, helper) {
        helper.loadApplicationFees(component);
        helper.loadPicklistOptions(component);
        var action = component.get('c.getFeeName');
        action.setParams({
            feeDefId : component.get('v.feeDefId')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                component.set('v.feeName', response.getReturnValue());
            } else if (state === 'ERROR') {
                let error = response.getError();
                if (error && error[0]) {
                    console.log(error[0].message);
                }
            }
        });
        $A.enqueueAction(action);
        var fee = {'sobjectType': 'Application_Fee__c'};
        fee.Application__c = component.get('v.applicationId');
        fee.Fee__c = component.get('v.feeDefId');
        component.set('v.fee', fee);
    },
    handleAdd: function(component, event, helper){
        var valid = helper.validate(component);
        console.log('VALID: '+valid);
        if(!valid) {
            return;
        }
        
        component.set('v.processing', true);
        var action = component.get('c.addAllFees');
        action.setParams({
            fee : component.get('v.fee'),
            equipment : component.get('v.selectedEquipment')
        });
        console.log('calling addallfees');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                 var appEvent = $A.get("e.c:FMZ_Application_Refresh");
                 appEvent.setParams({
                      source: 'FMZ_ApplicationServiceAndFees_New'
                  });
                 appEvent.fire();
                 let dismiss = $A.get('e.force:closeQuickAction');
                 dismiss.fire();
            } else if (state === 'ERROR') {
                let error = response.getError();
                if (error && error[0]) {
                    helper.renderError(component);
                    console.log(error[0].message);
                }
            }
            component.set('v.processing', false)
        });
        $A.enqueueAction(action);
    },
     handleCancel: function(component, event, helper) {
         //helper.deleteFee(component, component.get('v.feeId'));
//         var appEvent = $A.get("e.c:FMZ_Application_Refresh");
//         appEvent.fire();
         let dismiss = $A.get('e.force:closeQuickAction');
         dismiss.fire();
     },
     handleChange: function (component, event) {
         var selectedOptionValue = event.getParam("value");
         component.set('v.selectedEquipment', selectedOptionValue);
     }
})