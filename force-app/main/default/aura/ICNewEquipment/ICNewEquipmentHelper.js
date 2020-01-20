({
    getLease : function (component, event){ 
        console.log('in get lease');
        var action = component.get("c.getLease");
        action.setParams({
            "recordId": component.get('v.recordId')
        }); 

        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {
                var lease = response.getReturnValue();
                component.set('v.lease', lease);
            }

            console.log('lease is: ' + component.get('v.lease'));
           
            
        });
        
        $A.enqueueAction(action);
    },
    save : function (component, event){ 
        
        var action = component.get("c.save");
        action.setParams({
            "recordId": component.get('v.recordId'),
            "eList" : component.get('v.value')

        }); 

        action.setCallback(this, function(response) {
            
            var state = response.getState();
            var validationError = JSON.parse(response.getReturnValue());
            if (state === "SUCCESS") {
                 
                if (validationError.Message){
                    component.find('notifLib').showToast({
                           'variant': 'error',
                           'message': validationError.Message,
                           'mode': 'pester'
                    });
                }
                else{
                    var msg='Lease Claim Equipment Added!';
                    component.find('notifLib').showToast({
                           'variant': 'success',
                           'message': msg,
                           'mode': 'sticky'
                    });
                    

                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": component.get('v.recordId'),
                        "slideDevName": "detail"
                    });
                    navEvt.fire();

                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire();
                    
                    $A.get('e.force:refreshView').fire();

                     
                }
                
            }    
            
        });
        
        $A.enqueueAction(action);
    },
    getEquipment : function (component, event){ 
        console.log('in get eq');
        var action = component.get("c.getEquipment");
        action.setParams({
            "recordId": component.get('v.recordId')
        }); 

        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {
                var choiceList = response.getReturnValue();
                var choices = [];
                component.set('v.EquipList',choiceList);  
                
                for (var i=0; i<component.get('v.EquipList').length; i++){
                    choices.push({label:  component.get('v.EquipList')[i].Equipment_Description1__c + '  Location: ' + 
                    component.get('v.EquipList')[i].Install_Address_Line_1__c + ' ' +
                    component.get('v.EquipList')[i].City__c + ', ' +
                    component.get('v.EquipList')[i].State__c + ' ' + 
                    component.get('v.EquipList')[i].Zip_Code__c + ' S/N:' + 
                    component.get('v.EquipList')[i].Serial_Number__c
                    
                    , value: component.get('v.EquipList')[i].Id});
                }
                
                component.set('v.options', choices);
                
                console.log(component.get('v.EquipList'));
                for (var i=0; i<component.get('v.EquipList').length; i++){
                    console.log('i: ' + component.get('v.EquipList')[i].cllease__Make__c );
                }
               
            }
           
            
        });
        
        $A.enqueueAction(action);
    }
})