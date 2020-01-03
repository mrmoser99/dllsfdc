({
    
    handleLoad: function(cmp, event, helper) {
       
        cmp.set('v.showSpinner', false);
       
        helper.getLease(cmp,event);
        helper.getEquipment(cmp,event);
    },

    handleSubmit: function(cmp, event, helper) {
        console.log('in save');
        event.preventDefault();
        cmp.set('v.disabled', true);
        cmp.set('v.showSpinner', true);
        helper.save(cmp,event);
      


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
        cmp.set('v.showSpinner', false);
        cmp.set('v.saved', true);
    }
})
