({
    steps: ['customer', 'equipment', 'notes'],

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

    checkCompletion: function(component) {
        console.log('in check completion');
        let steps = this.steps, //steps = ['customer', 'equipment', 'notes'],
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
                console.log('in complete and complete flat is: ' +  stepCmp.get('v.complete') );
                if (!stepCmp.get('v.complete')) {
                    stepCmp.set('v.collapsed', false);
                    console.log('set to false');
                    break;
                }
            }
        } catch (e) {
            console.log(e);
        }
    }
})