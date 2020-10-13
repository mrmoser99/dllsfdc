({
    // load fields from the field set
    loadFields: function(component) {
//console.log('loadFields');
        var action = component.get('c.getQQFields');
        action.setParams({
            fieldsetName: 'FMZ_NewQuickQuote'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                component.set('v.fields', response.getReturnValue());
                if (component.get('v.accountId')) {
                    this.prepopulateAccountInfo(component);
                } else {
                    component.set('v.processing', false);
                }
            } else {
                component.set('v.processing', false);
            }
        });

        component.set('v.processing', true);

        $A.enqueueAction(action);
    },

    // load accountid for the dealer user
    loadDealerId: function(component) {
        var action = component.get('c.getDealerAccount');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                component.set('v.dealerId', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    // submit for credit approval
    submitForApproval: function(component, qqId) {
        var action = component.get('c.submitForApproval');
        action.setParams({
            qqId: qqId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var result = response.getReturnValue();
               ////console.log(result);
                if (Boolean(result) && result.indexOf('success') != -1) {
                    this.showToast (
                        component,
                        'success',
                        'Your credit approval was submitted.  {0} to view the credit approval record.',
                        'Click here',
                        qqId
                    );
                } else {
                    this.showToast(
                        component,
                        'error',
                        'An error occurred. ' + (result||'') + ' {0} to view the credit approval record.',
                        'Click here',
                        qqId
                    );
                    let dismiss = $A.get('e.force:closeQuickAction');
                    dismiss.fire();
                    component.set('v.processing', false);
                }
            } else if (state === 'ERROR') {
               ////console.log(response.getError());
                this.showToast(
                    component,
                    'error',
                    'An error occurred. ' + (response.getError()||'') + ' {0} to view the credit approval record.',
                    'Click here',
                    qqId
                );
                let dismiss = $A.get('e.force:closeQuickAction');
                dismiss.fire();
                component.set('v.processing', false);
            }
        });
        component.set('v.processing', true);
        $A.enqueueAction(action);
    },

    // get account info to prepopulate the quick quote
    prepopulateAccountInfo: function(component) {
//console.log('prepop');
        var action = component.get('c.getAccountInfo');
        action.setParams({
            accountId : component.get('v.accountId')
        });
//console.log(component.get('v.accountId'));
        action.setCallback(this, function(response) {
           ////console.log('Callback!');
            var state = response.getState(),
                recordId = component.get('v.recordId');
            component.set('v.processing', false);
//console.log(state);
            if (state === 'SUCCESS') {
               ////console.log('Success!!!');
                var account = response.getReturnValue();
                component.set('v.account', account);
                if (recordId) {
                    this.prepopulateField(component, 'genesis__Business_Name__c', account.Name);
                }
                this.prepopulateField(component, 'Primary_Phone_number__c', account.Phone);
                if (account.Primary_Address__r) {
                   ////console.log('Populatng Address Fields');
                    this.prepopulateField(component, 'genesis__Address_Line_1__c', account.Primary_Address__r.Address_Line_1__c);
                    this.prepopulateField(component, 'genesis__City__c', account.Primary_Address__r.City__c);
                    this.prepopulateField(component, 'genesis__State__c', account.Primary_Address__r.State__c);
                    this.prepopulateField(component, 'County__c', account.Primary_Address__r.County__c);
                    this.prepopulateField(component, 'genesis__Postal_Code__c', account.Primary_Address__r.Zip_Code__c);
                }
                component.set('v.accountId', account.Id);
                this.prepopulateField(component, 'genesis__Account__c', account.Id);
            }
        });
        $A.enqueueAction(action);
    },

    // set the value of inputField based on field set position
    prepopulateField: function(component, fieldName, value) {
        var fields = component.get('v.fields');
        var inputField = component.find('inputField');
        for (var i = 0; i < fields.length; i++) {
            if (fields[i].fieldPath == fieldName) {
                inputField[i].set('v.value', value);
                break;
            }
        }
    },

    // check for required fields
    isValid: function(component) {
        var result = true,
            fields = component.get('v.fields'),
            inputField = component.find('inputField');
        for (var i = 0; i < fields.length; i++) {
            if (fields[i].required && !Boolean(inputField[i].get('v.value'))) {
                $A.util.addClass(inputField[i], 'slds-has-error');
                result = false;
            }
        }
        component.set('v.isInvalid', !result);
        return result;
    },

    // show toast message
    showToast: function(component, variant, message, linkLabel, qqId) {
        component.find('notifLib').showToast({
            'variant': variant,
            'message': message,
            'messageData': [
                {
                    url: '/detail/' + qqId,
                    label: linkLabel
                }
            ],
            'mode': 'sticky'
        });
    }

})