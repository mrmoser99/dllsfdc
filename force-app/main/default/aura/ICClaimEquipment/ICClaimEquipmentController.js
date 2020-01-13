({
    
    handleLoad: function(cmp, event, helper) {
        console.log(cmp.get('v.recordId'));
        cmp.set('v.showSpinner', false);
        cmp.set('v.showError',false);
        //helper.getLease(cmp,event);
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

    saveAndValidate: function(component, event, helper) {
		try {
            console.log('values: ' + component.get('v.value'));
            var selected = component.get('v.value');
			if (component.get('v.value') == '') {
                console.log('error');
                component.set('v.showError',true);
                component.set('v.errorMessage','You must select at lease one piece of equipment!');
				return false;
			} else {
                console.log('clear');
                component.set('v.showError',false);
                component.set('v.errorMessage',null);
				return true;
			}
		} catch (e) {
			console.log(e);
		}
	},

    handleSuccess: function(cmp, event, helper) {
        var params = event.getParams();
        cmp.set('v.recordId', params.response.id);
        cmp.set('v.showSpinner', false);
        cmp.set('v.saved', true);
    }
})
