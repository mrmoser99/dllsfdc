({
    fetchRecords : function(component, event, page) {
         
        var searchCustomerName = component.find('customerName').get('v.value');
        var searchCustomerNumber = component.find('customerNumber').get('v.value');
        var searchSerial = component.find('assetSerialNumber').get('v.value');
         
         
        if (searchCustomerName != '' || searchCustomerNumber != '' || searchSerial != ''){
            component.set('v.enableInfiniteLoading',false);
        }
        else{
            component.set('v.enableInfiniteLoading',true);
        }
        console.log('*******************************' + searchCustomerNumber);

        var action = component.get("c.searchPortfolio");
        action.setParams({
            "customerName": searchCustomerName ,
            "contractNumber" : searchCustomerNumber,
            "assetSerialNumber": searchSerial,
            "size" : 20,
            "sortOrder" : " ",
            "assetDetail" : true,
            "page" : page,
            "disableLogging" : false
        }); 
       
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                var records = response.getReturnValue();
                console.log(records);
                var currentData = component.get('v.data');  
                if (records.data != null){     
                    component.set('v.data', currentData.concat(records.data));
                }        
                event.getSource().set("v.isLoading", false);

                /* here are samples of accessing the response message */
                
                //console.log(records.data[0]);
                //console.log(records.common);
                //console.log(records.data[0].assetDetail);
                //console.log(records.common);
                //console.log(records.data[0].contractNumber);
                
                /* display the equipment list in the log */
                
                
                for (var i in records.data){
                    console.log(records.data[i]);
                    console.log(records.data[i].contractNumber);
                    console.log(records.data[i].assetDetail);
                    
                }
                
                 

                //var equipMap = component.get('v.contractEquipmentMap');
                //equipMap.set(records.data[0].contractNumber,records.data[0].assetDetail);
            }
        });
        $A.enqueueAction(action);
 },
 toggleProgress: function (cmp) {
    if (cmp.get('v.isProgressing')) {
        // stop
        cmp.set('v.isProgressing', false);
        clearInterval(cmp._interval);
    } else {
        // start
        cmp.set('v.isProgressing', true);
        cmp._interval = setInterval($A.getCallback(function () {
            var progress = cmp.get('v.progress');
            cmp.set('v.progress', progress === 100 ? 0 : progress + 1);
        }), 200);
    }
}

})