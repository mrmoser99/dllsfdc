({
    // load or reload terms associated with this application
    loadApplicationTerms: function(component) {
        try {
            console.log('loading terms');
            var action = component.get('c.getApplicationTerms');
            action.setParams({
                applicationId: component.get('v.applicationId')
            });

            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === 'SUCCESS') {
                    component.set('v.application', response.getReturnValue());
                   
                    var app = component.get('v.application');
                    console.log('seeting rate card id' + app.Rate_Card_Setup__c);
                    component.set('v.selectedRateCardId',app.Rate_Card_Setup__c);
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
    

    getDealer: function(component) {
        try {
            var action = component.get('c.getDealer');
            action.setParams({
                applicationId: component.get('v.applicationId')
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === 'SUCCESS') {
                    component.set('v.dealerId', response.getReturnValue());
                    var action = component.get('c.getRateCards');
                    action.setParams({
                        dealerId: component.get('v.dealerId')
                    });
                    action.setCallback(this, function (response) {
                         var state = response.getState();
                        if (state === 'SUCCESS') {
                            component.set('v.cards', response.getReturnValue());
                        } else if (state === 'ERROR') {
                            console.log('card error');
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
                        console.log(error[0].message);
                    }
                }
            });
            $A.enqueueAction(action);
            
        } catch (e) {
            console.log(e);
        }
    },

    loadTermOptions: function(component) {
        try {
            var action = component.get('c.getTermOptions');
            action.setParams({
                applicationId: component.get('v.applicationId')
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === 'SUCCESS') {
                    console.log('Term Options: '+response.getReturnValue());
                    component.set('v.termOpts', response.getReturnValue());
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

    loadCards: function(component) {
        try {
            console.log('in cards load');
            var action = component.get('c.getRateCards');
            action.setParams({
                dealerId: component.get('v.dealerId')
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === 'SUCCESS') {
                   
                    component.set('v.cards', response.getReturnValue());
                } else if (state === 'ERROR') {
                    console.log('card error');
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
    },
    
    helpSaveAndValidate : function(component){
        try {
            let application = component.get('v.application'),
                term = component.find('term');
//                if((Number(term.get('v.value')) % 12) > 0){
//                    term.setCustomValidity("Term must be a multiple of 12");
//                    term.reportValidity();
//                }else{
//                    term.setCustomValidity("");
//                    term.reportValidity();
//                }
            term.showHelpMessageIfInvalid();
            if(!term.get('v.validity').valid) {
                return false;
            } else {
                if ($A.util.hasClass(term, 'terms-changed')) {
                    this.updateTerms(component, application);
                }
                return true;
            }
        } catch (e) {
            console.log(e);
        }
    }

})