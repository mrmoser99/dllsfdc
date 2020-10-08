({
	init : function(component, event, helper) {
        
        var recordId = component.get("v.recordId");
         
        var action = component.get('c.getRates');
        
        action.setParams({
            accountId: recordId
        });
        action.setCallback(this,function(response) {
        	var state = response.getState();
            if (state == 'SUCCESS'){
                var rateError = JSON.parse(response.getReturnValue());
                
                if (rateError.Message){
                	component.find('notifLib').showToast({
                           'variant': 'error',
                           'message': rateError.Message,
                           'mode': 'pester'
                    });
                }
                else{

                    var msg='Get Rates Submitted!';
                    component.find('notifLib').showToast({
                           'variant': 'success',
                           'message': msg,
                           'mode': 'sticky'
                    });
                    $A.get('e.force:refreshView').fire();
                    
                }
            }
            else if (state == 'ERROR'){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                 errors[0].message);
                    	component.find('notifLib').showToast({
                           'variant': 'error',
                           'message':  errors[0].message,
                           'mode': 'pester'
                    });
                    }
                } else {
                    console.log("Unknown error");
                }

            }
            component.set('v.processing', false);
            let dismiss = $A.get('e.force:closeQuickAction');
            dismiss.fire();
        });
        component.set('v.processing', true);
        $A.enqueueAction(action);
	}
})