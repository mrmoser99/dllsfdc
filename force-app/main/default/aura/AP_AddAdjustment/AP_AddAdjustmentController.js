({
    
        doInit: function(component, event, helper) {
           var recordId = component.get('v.recordId');
           console.log('do init recid:' + recordId);
           var fee = component.get('v.fee');
           var amountDue = component.get('v.amountDue');
        
           var parentId = component.get('v.rowId');
          
           if (parentId.startsWith('a3')){
                var show = true;
                component.set("v.isCharge",show);
                component.find("chargeLookup").set("v.value", parentId);
           }
           else{
                var show = false;
                component.set("v.isCharge",show); 
                component.find("dLookup").set("v.value", parentId);
           }

           component.find("aType").set("v.value", fee);    
           component.find("credit").set("v.value", amountDue);     

            
        }, 
        
        handleSubmit: function(component,event,helper){
           
            var recordId = component.get('v.recordId');
            console.log('hasdfasd:' + recordId);
            var action = component.get('c.addAdjustment'); 
          
            var chargeId;
            var dueId;
            
            if (component.find("chargeLookup") == null){
                chargeId = null;
            }
            else{     
                chargeId = component.find("chargeLookup").get("v.value");
            }
            
            if (component.find("dLookup") == null){
                dueId = null;
            }
            else{
                dueId = component.find("dLookup").get("v.value");
            }
           
           //String recordId, String checkNumber, Decimal checkAmount Date paymentDate)
            
           action.setParams({
               recordId: component.get('v.recordId'),
               aType:  component.find("aType").get("v.value"),
               credit: component.find("credit").get("v.value"),
               chargeId: chargeId,
               dueId: dueId
           });
           console.log('hello world');
           console.log(component.get('v.recordId'));
           console.log(component.find("aType").get("v.value"));
           console.log('recid:' + recordId);
           action.setCallback(this,function(response) { 
               var state = response.getState();
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
                       var msg='Adjustment Added!';
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
           event.preventDefault();
           $A.enqueueAction(action);
            
           $A.get('e.force:refreshView').fire();

        },
       handleCancel: function(component, event, helper) {
           
            component.find("overlayLib").notifyClose();
          
       
       }
       
   
})