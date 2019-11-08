({
    doInit: function(component, event, helper) {
       var recordId = component.get('v.recordId');
      
        var action = component.get('c.getInvoice');  
        action.setParams({
            recordId: recordId
        });

      
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                 
                if (results == 'Approved'){
                    component.set('v.isDisabled',true);
                    console.log('is: ' + component.get('v.isDisabled'));
                    
                }
                else{
                    component.set('v.isDisabled',false);
                    
                }
                console.log('ugh' + component.get('v.isDisabled'));
                var actions2 = [
                    { label: 'Adjust', name: 'adjust', disabled : component.get('v.isDisabled')}
                    
                ];
                var actions = [
                    { label: 'Delete', name: 'delete',  disabled : component.get('v.isDisabled')}
                ];
                component.set('v.columns', [
                    {label: 'Equipment', fieldName: 'equipmentName', type: 'text', initialWidth : 200},
                    {label: 'Charge/Bill Id', fieldName: 'chargeId',  initialWidth : 200, type: 'url',sortable: true,typeAttributes: {label:{ fieldName: 'name'}}},
                    {label: 'Description', fieldName: 'fee', type: 'text', initialWidth : 200},
                    {label: 'Amount Due', fieldName: 'feeAmount', type: 'currency', typeAttributes: { currencyCode: 'USD'}},
                    {label: 'Tax Due', fieldName: 'taxAmount', type: 'currency', typeAttributes: { currencyCode: 'USD'}},
                    { type: 'action', typeAttributes: { rowActions: actions2 } }
                    ]);
            
            
                component.set('v.columnsA', [
                        {label: 'Equipment', fieldName: 'Equipment__c', type: 'text', initialWidth : 200},
                        {label: 'Charge/Bill Id', fieldName: 'Charge_Bill_Name__c', type: 'text'}, 
                        {label: 'Description', fieldName: 'Adjustment_Type__c', type: 'text'}, 
                        {label: 'Credit', initialWidth:120, fieldName: 'Credit__c', type: 'currency', typeAttributes: { currencyCode: 'USD'}},
                        {label: 'Tax Amount', fieldName: 'Tax_Amount__c', type: 'currency', typeAttributes: { currencyCode: 'USD'}},
                        { type: 'action', typeAttributes: { rowActions: actions } }
                        ]);
                
        
            }
        });
        $A.enqueueAction(action);

        helper.fetchAccounts(component,event, 0);
        
        helper.fetchAdjustments(component,event, 0);
   }, 
    handleApprove: function(component,event,helper){
       component.set('v.isDisabled', true);  
       var recordId = component.get('v.recordId'); 
       var action = component.get('c.approve');  
      
       action.setParams({
           recordId: recordId
       });
      
       action.setCallback(this,function(response) {
           var state = response.getState();
           console.log(state);
           var validationError = JSON.parse(response.getReturnValue());
           console.log(validationError);
           console.log('hello');
           if (state == 'SUCCESS'){
               
               if (validationError.Message){
                   component.find('notifLib').showToast({
                          'variant': 'error',
                          'message': validationError.Message,
                          'mode': 'pester'
                   });
               }
               else{
                   var msg='Invoice Adjustment Has Been Approved And Will Be Processed!';
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
               $A.get('e.force:refreshView').fire();  
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
   
    loadMoreData: function (component, event, helper) {
        console.log('loading more' + component.get('v.data').length);
        helper.fetchAccounts(component, event, component.get('v.data').length);
    },

    handleShowModal: function(component, evt, helper) {
        
        let modalBody;
        var recordId = component.get('v.recordId');
        $A.createComponent('c:AP_AddAdjustment', {invoiceId :recordId, chargeId : chargeId},
            function(content, status, errorMessage) {
                if (status === 'SUCCESS') {
                    modalBody = content;
                    component.find('overlayLib').showCustomModal({
                        body: modalBody,
                        showCloseButton: true,
                        cssClass: 'mymodal',
                        closeCallback: function() {
                            
                        }
                    })
                } else if (status === 'ERROR') {
                    let toast = $A.get('e.force:showToast');
                    toast.setParams({
                        title: 'Error',
                        message: errorMessage,
                        type: 'error'
                    });
                    toast.fire();
                }
            }
        );
    },
    handleRowActionAdd: function (component, event, helper) {
        
        let modalBody;
        var recordId = component.get('v.recordId');
        var row = event.getParam('row');
           
       
        $A.createComponent('c:AP_AddAdjustment', {recordId :recordId, rowId :row.id, fee: row.fee, amountDue: row.feeAmount, taxAmount: row.taxAmount},
            function(content, status, errorMessage) {
                if (status === 'SUCCESS') {
                    modalBody = content;
                    component.find('overlayLib').showCustomModal({
                        body: modalBody,
                        showCloseButton: true,
                        cssClass: 'mymodal',
                        closeCallback: function() {
                            //alert('You closed the alert!');
                        }
                    })
                } else if (status === 'ERROR') {
                    let toast = $A.get('e.force:showToast');
                    toast.setParams({
                        title: 'Error',
                        message: errorMessage,
                        type: 'error'
                    });
                    toast.fire();
                }
            }
        );
    },
    handleRowAction: function (component, event, helper) {
      
        var rows = component.get('v.adjList');
        var action = component.get("c.deleteAdj");
        var row = event.getParam('row');
        
        var rowIndex = rows.indexOf(row);
        rows.splice(rowIndex, 1);
        component.set('v.adjList', rows);
        
        action.setParams({
          "toDelete": row
        });

        action.setCallback(this, function(response) {
           
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                var msg='Adjustment Deleted!';
                component.find('notifLib').showToast({
                              'variant': 'success',
                              'message': msg,
                              'mode': 'sticky'
                });
                $A.get('e.force:refreshView').fire();  
            }
            
            $A.get('e.force:refreshView').fire();
        });
        
        
        $A.enqueueAction(action);
         
       

    }     
   
})