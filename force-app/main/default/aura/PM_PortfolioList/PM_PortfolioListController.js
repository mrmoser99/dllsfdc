({
    init: function (component, event, helper) {
        component.set('v.page',0);

        var actions = [
            { label: 'Get Lease Details', name: 'leaseDetails' },
            { label: 'Get Quote', name: 'quote' },
            { label: 'Equipment Detail', name: 'equipment' }
        ];

        component.set('v.columns', [
            {label: 'Account', fieldName: 'customerName', type: 'text', initialWidth: 220},
            {label: 'Lease', fieldName: 'contractNumber', type: 'text'},
            {label: 'Postal Code', fieldName: 'customerZipCode', type: 'text'},
            {label: 'Start', fieldName: 'contractStartDate', type: 'text'},
            {label: 'Term', fieldName: 'contractTerm', type: 'text'},
            {label: 'Remaining Payments', fieldName: 'numberOfRemainingPayments', type: 'text'},
            {label: 'Equipment', fieldName: 'equipmentDescription', type: 'text',  initialWidth: 225},
            {label: 'Cost', fieldName: 'contractOriginalCost', type: 'currency', typeAttributes: { currencyCode: 'USD'}},
            {label: 'Payment', fieldName: 'contractPayment', type: 'currency', typeAttributes: { currencyCode: 'USD'}},
            {label: 'Type', fieldName: 'contractType', type: 'text'},
            {label: 'Account Link', fieldName: 'customerName', type: 'url', typeAttributes: {label: { fieldName: 'customerName' }, target: '_asaablank'}},
            {label: 'Newco Ready?', fieldName: 'newcoReady', type: 'boolean'},
            {type: 'action', typeAttributes: { rowActions: actions } }
           

        ]);

        var actions2 = [
            { label: 'Quote Detail', name: 'quoteDetail' } 
        ];
        component.set('v.quoteColumns', [
            {label: 'Type', fieldName: 'quoteCalculationDescription', type: 'text', initialWidth: 250},
            {label: 'Quote Amount', fieldName: 'amount',  initialWidth: 150, type: 'currency', typeAttributes: { currencyCode: 'USD'}},
            {label: 'Quote Number', fieldName: 'quoteNumber', type: 'text', initialWidth: 150},
            {type: 'action', typeAttributes: { rowActions: actions2 } }
           

        ]);

        component.set('v.equipmentColumns', [
            {label: 'Seq Nbr', fieldName: 'assetSequenceNumber', type: 'number'},
            {label: 'Make', fieldName: 'assetMake', type: 'text'},
            {label: 'Model', fieldName: 'assetModel', type: 'text'},
            {label: 'Desc', fieldName: 'assetDescription', type: 'text'},
            {label: 'Mfg', fieldName: 'assetManufacturer', type: 'text'},
            {label: 'Addr Line 1', fieldName: 'assetAddressLine1', type: 'text'},
            {label: 'Addr Line 2', fieldName: 'assetAddressLine2', type: 'text'},
            {label: 'City', fieldName: 'assetCity', type: 'text'},
            {label: 'State', fieldName: 'assetState', type: 'text'},
            {label: 'Zip Code', fieldName: 'assetZipCode', type: 'text'},
            {label: 'Payment', fieldName: 'assetPayment', type: 'currency'}
        ]);

    },
    
    loadMoreData: function (component, event, helper) {
        
        event.getSource().set("v.isLoading", true);        
        component.set('v.loadMoreStatus', 'Loading');

        var page = component.get('v.page');
        page = page + 1;
        component.set('v.page',page);
       
        helper.fetchRecords(component, event, page);
    },
    
    handleSearch: function (component, event, helper) {

        component.set('v.data',[]);
        helper.fetchRecords(component, event, 0);
        
    },
   

    handleRowAction: function (component, event, helper) {
        
        var rowAction = event.getParam('action');
        var row = event.getParam('row');
       
        component.set('v.quoteData',[]);
        component.set('v.equipmentData',[]);
       
        switch (rowAction.name) {
            case 'quote':
                var action = component.get("c.generateQuotes");
                
                action.setParams({
                  "leaseNumber": row.contractNumber
                });
                
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    console.log('State is: ' + state);
                    if (state === "SUCCESS") {
                        var records = response.getReturnValue();
                        console.log(records.quotes);
                        component.set('v.records',records);
                        component.set('v.recordList',records.quotes);

                        component.set('v.quoteData', records.quotes);

                        var msg='Quotes Generated!';
                        component.find('notifLib').showToast({
                                      'variant': 'success',
                                      'message': msg,
                                      'mode': 'sticky'
                        });
                        //$A.get('e.force:refreshView').fire();  
                    }
                    else if (state === 'ERROR') {
                        let toast = $A.get('e.force:showToast');
                        toast.setParams({
                            title: 'Error',
                            message: 'Exception in callout!',
                            type: 'error'
                        });
                        toast.fire();
                    }
                    
                    //$A.get('e.force:refreshView').fire();
                });
                
                $A.enqueueAction(action);
                break;

            case 'quoteDetail':
                let modalBody;
                var quoteDataToPass = component.get('v.quoteData');
                var recordsToPass = component.get('v.records');
                $A.createComponent('c:PM_QuoteDetail', {records :recordsToPass, recordList: component.get('v.quoteData'), selectedQuoteNumber : row.quoteNumber},
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
                    } else if (state === 'ERROR') {
                        let toast = $A.get('e.force:showToast');
                        toast.setParams({
                            title: 'Error',
                            message: 'Exception in callout!',
                            type: 'error'
                        });
                        toast.fire();
                    }
                }
                );
                break;
            case 'equipment':
                console.log('************************ start');
                
                component.set('v.equipmentData', []);
                component.set('v.equipmentData', row.assetDetail);

                
                for (var i in row.assetDetail){
                    console.log('in loop');
                   
                    console.log(row.assetDetail[i].assetSequenceNumber);
                    console.log(row.assetDetail[i].assetDescription);
                }
                console.log('end1');
                 

                break;

            case 'leaseDetails':

                console.log(JSON.stringify(row));
                var action = component.get("c.getLeaseDetails");
                
                action.setParams({
                  "leaseInfo": JSON.stringify(row)
                });
                
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        var records = response.getReturnValue();
                        console.log(records);
                        
                        var msg='Details Gathered!';
                        component.find('notifLib').showToast({
                                      'variant': 'success',
                                      'message': msg,
                                      'mode': 'sticky'
                        });
                        //$A.get('e.force:refreshView').fire();  
                    }
                    
                    //$A.get('e.force:refreshView').fire();
                });
                
                $A.enqueueAction(action);
                break; 
                
                
                
        }
    }     
    
})