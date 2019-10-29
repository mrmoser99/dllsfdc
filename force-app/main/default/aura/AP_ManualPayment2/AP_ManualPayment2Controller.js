({
	doInit: function(component, event, helper) {
        var recordId = component.get('v.recordId');
         
    }, 
    handleSubmit: function(component,event,helper){
        component.set('v.isHide', true);  
        var recordId = component.get('v.recordId');
        var action = component.get('c.addPayment'); 
        console.log('record id ' + recordId);
        var checkNumber = component.find("checkNumber").get("v.value");
        var checkAmount= component.find("checkAmount").get("v.value");
        var paymentDate = component.find("paymentDate").get("v.value"); 
        var voidPNC = component.find("voidGroup").get("v.value"); 
        var notes = component.find("notes").get("v.value"); 
        console.log(checkNumber);
        console.log(checkAmount);
        console.log(paymentDate);
        
        //String recordId, String checkNumber, Decimal checkAmount Date paymentDate)
        action.setParams({
            recordId: recordId,
            checkNumber: checkNumber,
            checkAmount: checkAmount, 
            paymentDate: paymentDate,
            voidPNC:voidPNC,
            notes:notes
        });
       
        action.setCallback(this,function(response) {
            var state = response.getState();
            console.log(state);
            var validationError = JSON.parse(response.getReturnValue());
            if (state == 'SUCCESS'){
                if (validationError.Message){
                	component.find('notifLib').showToast({
                           'variant': 'error',
                           'message': validationError.Message,
                           'mode': 'pester'
                    });
                }
                else{
                    var msg='Payment Submittted!';
                    component.find('notifLib').showToast({
                           'variant': 'success',
                           'message': msg,
                           'mode': 'sticky'
                    });
                    
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": recordId,
                        "slideDevName": "detail"
                    });
                    navEvt.fire();
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

        });
        component.set('v.processing', true);
        $A.enqueueAction(action);
     },
    handleCancel: function(component, event, helper) {
        let dismiss = $A.get('e.force:closeQuickAction');
        dismiss.fire();
    },
    handleChange: function (component, event) {
        var changeValue = event.getParam("value");
        component.set('v.voidPNC',changeValue);
        
    }
    
})