({
    doInit: function(component, event, helper) {
        var isChrome = !!window.chrome && (!!window.chrome.webstore || !!window.chrome.runtime);
        alert('Chrome?' + isChrome);
        var recordId = component.get('v.recordId');
        if (recordId) {
            component.set('v.accountId', recordId);
        }
        helper.loadFields(component);
        helper.loadDealerId(component);
    },
    handleLoad: function(component, event, helper) {
        //var recordUi = event.getParam('recordUi');
        $A.util.addClass(component, 'is-loaded');
    },
    handleSubmit: function(component, event, helper) {
       ////console.log('clicked create');
        var fields = event.getParam('fields'),
            accountId = component.get('v.accountId'),
            dealerId = component.get('v.dealerId'),
            isValid = helper.isValid(component),
            recordId = component.get('v.recordId'),
            account = component.get('v.account');
        fields['genesis__Account__c'] = accountId;
        fields  ['Dealer__c'] = dealerId;
        if (!recordId) {
            fields['genesis__Business_Name__c'] = account.Name;
        }
        event.preventDefault();
        component.set('v.isInvalid', !isValid);
        if (!isValid) {
            return;
        }
        component.find('qqForm').submit(fields);
    },
    lookupChange: function(component, event, helper) {
//console.log('lookupChange');
        component.set('v.accountId', event.getParam('value'));
        var accountId = component.get('v.accountId');
        if (accountId) {
            if(Array.isArray(accountId)) {
                component.set('v.accountId', accountId[0]);
            }
            helper.prepopulateAccountInfo(component);
        }
    },
    handleSuccess: function(component, event, helper) {
        var record = event.getParam('response');
        helper.submitForApproval(component, record.id);
    },
    handleError: function(component, event, helper) {

        component.set('v.isInvalid', false);

        if (event.getName() === 'error') {

            var error = event.getParam('error');

           ////console.log(error.message);

            if(error.data) {

                // top level error messages
                error.data.output.errors.forEach(
                    function (msg) {
                       ////console.log(msg.errorCode);
                       ////console.log(msg.message);
                    }
                );

                // field specific error messages
                Object.keys(error.data.output.fieldErrors).forEach(function (field) {
                    error.data.output.fieldErrors[field].forEach(
                        function (msg) {
                           ////console.log(msg.fieldName);
                           ////console.log(msg.errorCode);
                           ////console.log(msg.message);
                        }
                    )
                });

            }
        }
    },
    handleCancel: function(component, event, helper) {
        let dismiss = $A.get('e.force:closeQuickAction');
        dismiss.fire();
    },
    handleNewCustomer: function(component, event, helper) {
       ////console.log('HANDLING NEW CUSTOMER!');
        component.set("v.accountId", event.getParams().id);
        helper.prepopulateAccountInfo(component);
    }
})