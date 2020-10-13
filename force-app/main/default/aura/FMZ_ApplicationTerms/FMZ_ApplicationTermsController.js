({
    doInit: function(component, event, helper) {
        console.log('doInit');
        helper.loadApplicationTerms(component);
        helper.loadTermOptions(component);
        console.log('getting dealer');
        helper.getDealer(component);
        
    },
    
    updateRateCard: function (component) {
        try {
           
            let action = component.get('c.updateApplicationRateCard'),
                application = component.get('v.application'),
           
                applicationUpdate = {
                    Id: application.Id
            };
            console.log('update rate card ' + application);
            console.log('Select rate card is: ' + component.get('v.selectedRateCardId'));
            
            action.setParams({
                applicationString: JSON.stringify(applicationUpdate),
                rateCardId: component.get('v.selectedRateCardId')
                
            });
            action.setCallback(this, function (response) {
                let state = response.getState();
                if (state === 'SUCCESS') {
                    var onChangeAction = component.get('v.onchange');
                    $A.enqueueAction(onChangeAction);
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


    // mark components with equipment-changed css class
    handleChange: function(component, event, helper) {
        console.log('handle change ****');
        console.log(component.find('term').get('v.value'));
        component.set('v.nbrofpayments',component.find('term').get('v.value'));
        try {
            let inputControl = event.getSource();
            $A.util.addClass(inputControl, 'terms-changed');
            return helper.helpSaveAndValidate(component);
        } catch (e) {
            console.log(e);
        }
    },

    // validate required fields and at least one piece of equipment
    saveAndValidate: function(component, event, helper) {
        return helper.helpSaveAndValidate(component);
    }

})