({
	doInit: function(component, event, helper) {
		//helper.loadAccount(component);
	},
	saveAndValidate: function(component, event, helper) {
		try {
			if (!helper.isInputValid(component)) {
				return false;
			} else {
				return true;
			}
		} catch (e) {
			console.log(e);
		}
	},
    navToAccount: function(component, event, helper){
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": '/detail/'+component.get('v.customer').Id,
          "isredirect": true
        });
        urlEvent.fire();
    },
    fixFormatting: function(component, event, helper){
        var phoneInput = component.find('contactphone');
        phoneInput.set('v.value', phoneInput.get('v.value').replace(/(\(|\)| |-)/g, ""));
    }
})