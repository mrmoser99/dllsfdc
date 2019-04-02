({
    // load or reload terms associated with this application
    loadApplicationTerms: function(component) {
        try {
            var action = component.get('c.getApplicationTerms');
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

    updateTerms: function (component, application) {
        try {
            console.log('update terms');
            let action = component.get('c.updateApplicationTerms'),
                applicationUpdate = {
                    Id: application.Id,
                    genesis__Term__c: Number(application.genesis__Term__c)
                };
            action.setParams({
                applicationString: JSON.stringify(applicationUpdate)
            });
            action.setCallback(this, function (response) {
                let state = response.getState(),
                    terms = component.find('terms'),
                    onChangeAction = component.get('v.onchange');
                if (state === 'SUCCESS') {
                    $A.util.removeClass(terms, 'terms-changed');
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
            $A.enqueueAction(action);
        } catch (e) {
            console.log(e);
        }
    }

})