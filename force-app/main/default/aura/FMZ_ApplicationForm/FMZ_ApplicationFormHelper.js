({
    steps: ['parties', 'terms', 'locations', 'equipment', 'services', 'documents'],

    // check the status of the application up front
    loadCompletion: function(component) {
        try {
            let action = component.get('c.checkCompletion'),
                applicationId = component.get('v.applicationId');
            action.setParams({
                applicationId: applicationId,
                sections: this.steps
            });
            action.setCallback(this, function (response) {
                let state = response.getState();
                if (state === 'SUCCESS') {
                    let result = response.getReturnValue();
                    for (let i = 0; i < this.steps.length; i++) {
                        let stepCmp = component.find(this.steps[i]);
                        stepCmp.set('v.complete', result[i]);
                    }
                    this.checkCompletion(component);
                } else if (state === 'ERROR') {
                    let error = response.getError();
                    if (error && error[0].message) {
                        console.log(error[0].message);
                    }
                }
            });
            $A.enqueueAction(action);
        } catch(e) {
            console.log(e);
        }

    },

    getApp: function(component) {
        try {
            let action = component.get('c.getApplication'),
                applicationId = component.get('v.applicationId');
            action.setParams({
                applicationId: applicationId
            });
            action.setCallback(this, function (response) {
                let state = response.getState();
                if (state === 'SUCCESS') {
                    component.set('v.application',response.getReturnValue());
                } else if (state === 'ERROR') {
                    let error = response.getError();
                    if (error && error[0].message) {
                        console.log(error[0].message);
                    }
                }
            });
            $A.enqueueAction(action);
        } catch(e) {
            console.log(e);
        }

    },

    checkCompletion: function(component) {
        let steps = this.steps, //steps = ['parties', 'terms', 'locations', 'equipment', 'services'],
            progress = component.find('progress'),
            finishCount = 0;
        try {

            for (let x in steps) {
                let stepCmp = component.find(steps[x]);
                if (stepCmp.get('v.complete')) {
                    finishCount++;
                }
                stepCmp.set('v.collapsed', true);
            }
			var progressValue = Math.round(( 100  * finishCount ) / steps.length );
            progress.set('v.progressValue', progressValue);
            component.set('v.applicationComplete', progressValue == 100);

            for (let y in steps) {
                let stepCmp = component.find(steps[y]);
                if (!stepCmp.get('v.complete')) {
                    stepCmp.set('v.collapsed', false);
                    break;
                }
            }
        } catch (e) {
            console.log(e);
        }
    },

	clearPricing: function(component) {
    	try {
			let p = new Promise($A.getCallback(function(resolve, reject) {
				let action = component.get('c.clearPricing'),
					applicationId = component.get('v.applicationId');
				action.setParams({
					applicationId: applicationId
				});
				action.setCallback(this, function (response) {
					let state = response.getState();
					if (state === 'SUCCESS') {
						let result = response.getReturnValue();
						resolve(result);
					} else if (state === 'ERROR') {
						let error = response.getError();
						if (error && error[0].message) {
							console.log(error[0].message);
						}
						reject(error);
					}
				});
				$A.enqueueAction(action);
			}));
			return p;
		} catch(e) {
			console.log(e);
		}
	},

    updatePricing: function(component) {
        try {
            
            console.log('updatePricing background');

            let action = component.get('c.generatePricing'),
                applicationId = component.get('v.applicationId'),
                appSummary = component.find('appSummary');
            action.setParams({
                applicationId: applicationId
            });

            action.setBackground();
            action.setCallback(this, function (response) {
                let state = response.getState();
                appSummary.updateView();
                if (state === 'SUCCESS') {
                    let result = response.getReturnValue();
                    console.log(result);
                    if (result != 'Successfully Selected Pricing Option.') {
                        appSummary.set('v.pricingMessage', response.getReturnValue());
                    }
                    var appEvent = $A.get("e.c:FMZ_Application_Refresh");
                    appEvent.setParams({
						source: 'FMZ_ApplicationForm'
					});
					appEvent.fire();
                } else if (state === 'ERROR') {
                    let error = response.getError();
                    if (error && error[0].message) {
                        //appSummary.set('v.pricingMessage', 'An Error Occurred Updating Pricing.')
                        console.log(error[0].message);
                    }
                }
            });
            appSummary.set('v.recalculating', true);
            appSummary.set('v.pricingMessage',null);
            $A.enqueueAction(action);
        } catch(e) {
            console.log(e);
        }
    }
})