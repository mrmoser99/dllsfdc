({
    
    handleLoad: function(cmp, event, helper) {
       
        cmp.set('v.showSpinner', false);
        var recordId = cmp.get('v.recordId');
        
        var action = cmp.get('c.getLease'); 
        action.setParams({
            "recordId": cmp.get('v.recordId')
        }); 

        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var lease = response.getReturnValue();
                
                var claim = cmp.get('v.claim');
              
                cmp.set('v.lease', lease);

                cmp.set('v.claim.Account__c',cmp.get('v.lease.cllease__Account__c'));
                cmp.set('v.claim.Lease__c',cmp.get('v.lease.Id'));
                cmp.set('v.claim.Claim_Status__c', 'New');
            }
            
        });
        
        
        $A.enqueueAction(action);
     
         
        
    },

    handleSubmit: function(cmp, event, helper) {
        console.log('in save');
        cmp.set('v.disabled', true);
        cmp.set('v.showSpinner', true);
       
        
       
       

    },
    handleCancel: function (cmp, event) {
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },

    handleChange: function (cmp, event) {
        var changeValue = event.getParam("value");
      
        console.log(cmp.get('v.value'));
    },

    handleError: function(cmp, event, helper) {
        // errors are handled by lightning:inputField and lightning:messages
        // so this just hides the spinner
        cmp.set('v.showSpinner', false);
    },

    handleSuccess: function(cmp, event, helper) {
        var params = event.getParams();
        cmp.set('v.recordId', params.response.id);
        console.log('params are:' + params);
        cmp.set('v.showSpinner', false);
        cmp.set('v.saved', true);

        var msg='Lease Claim Added!';
        cmp.find('notifLib').showToast({
                           'variant': 'success',
                           'message': msg,
                           'mode': 'sticky'
        });
        
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
                        "recordId": cmp.get('v.recordId'),
                        "slideDevName": "detail"
                    });
        navEvt.fire();

        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
              
                    
    }
})
