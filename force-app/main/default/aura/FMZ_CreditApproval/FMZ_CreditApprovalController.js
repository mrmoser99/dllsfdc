({
    doInit: function(component, event, helper) {
        var recordId = component.get('v.recordId');
        if (recordId) {
            var action = component.get('c.getAccountId');
            action.setParams({
                'recordId': recordId
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === 'SUCCESS') {
                    var accId = response.getReturnValue();
                    component.set('v.accountId', accId);
                    component.set('v.newAccount', false);
                    helper.loadFields(component, helper);
        			helper.loadDealerId(component);
                }
            });
            $A.enqueueAction(action);
        }else{
            helper.loadFields(component, helper);
        	helper.loadDealerId(component);
        }
    },
    findMatchingAddresses : function(component, event, helper){
        var action = component.get('c.getMatches');
        var addressSearchString = component.find('addressLine1').get('v.value');
        action.setParams({
            'addressString': addressSearchString
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var matches = response.getReturnValue();
                component.set('v.matches', matches);
                var cmpTarget = component.find('matchesOverlay');
                $A.util.removeClass(cmpTarget, 'no-display');
            }
        });
        $A.enqueueAction(action);
    },
    selectMatch : function(component, event, helper) {
        component.set('v.processing', true);
        var cmpTarget = component.find('matchesOverlay');
        $A.util.addClass(cmpTarget, 'no-display');
        var ctarget = event.currentTarget;
        var formatUrl = ctarget.dataset.value;

        var action = component.get('c.getFormat');
        action.setParams({
            'formatUrl': formatUrl
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
            if (state === 'SUCCESS') {
                var formattedAddress = response.getReturnValue();
                helper.populateAddressFields(component, formattedAddress);
            }
            component.set('v.processing', false);
        });
        $A.enqueueAction(action);
    },
    doneLoading: function(component, event, helper){
        var accountId = component.get('v.accountId');
        console.log('AccountId: '+accountId);
        if (accountId) {
            if(Array.isArray(accountId)) {
                component.set('v.accountId', accountId[0]);
            }
            helper.prepopulateAccountInfo(component, helper);
        }
        component.set("v.processing", false);
    },
    handleLoad: function(component, event, helper) {
        $A.util.addClass(component, 'is-loaded');
    },
    handleSubmit: function(component, event, helper) {
        var fields =  event.getParam('fields');
        var accountId = component.get('v.accountId');
        var dealerId = component.get('v.dealerId');

        var isValid = helper.isValid(component);
        var recordId = component.get('v.recordId');
        var account = component.get('v.account');

        fields['Primary_Phone_number__c'] = fields['Primary_Phone_number__c'].replace(/(\(|\)| |-)/g, "");
        fields['genesis__Address_Line_1__c'] = component.find('addressLine1').get('v.value');
        fields['genesis__City__c'] = component.find('city').get('v.value');
        fields['County__c'] = component.find('county').get('v.value');
        fields['genesis__State__c'] = component.find('state').get('v.value');
        fields['genesis__Postal_Code__c'] = component.find('postalCode').get('v.value');
        fields['genesis__Country__c'] = 'USA';
        fields['Validation_Status__c'] = component.find('validStatus').get('v.value');
        fields['Validation_Time_Stamp__c'] = component.find('validTime').get('v.value');
        fields['genesis__Account__c'] = accountId;
        fields['Dealer__c'] = dealerId;

        if(account && account.Name){
            fields['genesis__Business_Name__c'] = account.Name;
        }
        component.set('v.isInvalid', !isValid);
        if (!isValid) {
            return;
        }

        var action = component.get('c.createRecords');
        action.setParams({
            qq: fields,
            ignoreDuplicates: false
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log("STATE: "+state);
            if (state === 'SUCCESS') {
                console.log(state);
                var createResponse = response.getReturnValue();
                if(createResponse.status == 'SUCCESS'){
                    console.log('Created QQ!!!');
                    helper.submitForApproval(component, createResponse.message);
                }else{
                    let modalBody;
                    $A.createComponent('c:FMZ_SelectDuplicate',{
                            selectedId : component.getReference('v.accountId'),
                            message : createResponse.message,
                            duplicates : createResponse.duplicates
                        },
                        function(content, status, errorMessage) {
                            if (status === 'SUCCESS') {
                                modalBody = content;
                                component.find('overlayLib').showCustomModal({
                                    body: modalBody,
                                    showCloseButton: true,
                                    cssClass: 'mymodal',
                                    closeCallback: function() {
                                        accountId = component.get('v.accountId');
                                        fields['genesis__Account__c'] = accountId;
                                        if(accountId){
                                            var resubmitAction = component.get('c.createRecords');
                                            resubmitAction.setParams({
                                                qq: fields,
                                                ignoreDuplicates: true
                                            });
                                            resubmitAction.setCallback(this, function(response) {
                                                var state = response.getState();
                                                console.log("STATE: "+state);
                                                if (state === 'SUCCESS') {
                                                    console.log(state);
                                                    var createResponse = response.getReturnValue();
                                                    if(createResponse.status == 'SUCCESS'){
                                                        console.log('Created QQ!!!');
                                                        helper.submitForApproval(component, createResponse.message);
                                                    }
                                                }else if(state == 'ERROR'){
                                                    component.find('notifLib').showToast({
                                                        'variant': 'error',
                                                        'message': 'ERROR: An error has occurred processing your request. Try again later, or report this issue to a System Administrator.',
                                                        'mode': 'dismissible',
                                                        'duration': '5000'
                                                    });
                                                    let dismiss = $A.get('e.force:closeQuickAction');
                                                    dismiss.fire();
                                                    component.set('v.processing', false);
                                                }
                                            });
                                            $A.enqueueAction(resubmitAction);
                                        }else{
                                            component.find('notifLib').showToast({
                                                'variant': 'error',
                                                'message': 'Please use the existing Account to create this Credit Approval',
                                                'mode': 'dismissible',
                                                'duration': '5000'
                                            });
                                            let dismiss = $A.get('e.force:closeQuickAction');
                                            dismiss.fire();
                                            component.set('v.processing', false);
                                        }
                                    }
                                });
                            } else if (status === 'ERROR') {
                                let toast = $A.get('e.force:showToast');
                                toast.setParams({
                                    title: 'Error',
                                    message: errorMessage,
                                    type: 'error',
                                    mode: 'dismissible',
                                    duration: '5000'
                                });
                                toast.fire();
                            }
                        }
                    );
                }
            }else if (state === 'ERROR'){
                component.find('notifLib').showToast({
                    'variant': 'error',
                    'message': 'ERROR: An error has occurred processing your request. Try again later, or report this issue to a System Administrator.',
                    'mode': 'dismissible',
                    'duration': '5000'
                });
                let dismiss = $A.get('e.force:closeQuickAction');
                dismiss.fire();
                component.set('v.processing', false);
            }
        });
        component.set("v.processing", true);
        $A.enqueueAction(action);
        event.preventDefault();
    },
    lookupChange: function(component, event, helper) {
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

            console.log(error.message);

            // top level error messages
            error.data.output.errors.forEach(
                function(msg) { console.log(msg.errorCode);
                    console.log(msg.message); }
            );

            // field specific error messages
            Object.keys(error.data.output.fieldErrors).forEach(function(field) {
                error.data.output.fieldErrors[field].forEach(
                    function(msg) { console.log(msg.fieldName);
                        console.log(msg.errorCode);
                        console.log(msg.message); }
                )
            });
        }
    },
    handleCancel: function(component, event, helper) {
        let dismiss = $A.get('e.force:closeQuickAction');
        dismiss.fire();
    },
    toggleNewAccount: function(component, event, helper){
        component.set("v.processing", true);
        component.set("v.newAccount", ! component.get("v.newAccount"));
        var inputField = component.find('inputField');
        for (var i = 0; i < inputField.length; i++) {
            inputField[i].set('v.value', '');
            component.set('v.accountId', null);
            component.set('v.account', null);
        }

        helper.clearAddressData(component);
        component.set("v.processing", false);
    }
})