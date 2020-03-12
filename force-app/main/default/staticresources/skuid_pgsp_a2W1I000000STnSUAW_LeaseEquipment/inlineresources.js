(function(skuid){
skuid.snippet.register('calcFinAmt',function(args) {// Get reference to our Application model
var appModel = skuid.$M('AppEquipmentModel'); 
// Get reference to the first row
var appRow = appModel.getFirstRow();
try {
    var result = sforce.apex.execute(
        'genesis.SkuidPricingCtrl',
        'generatePricing', { 
            applicationId : appRow.genesis__Application__c 
        }
    );
    console.log(result); 
} catch (err) {
    console.log('Error getting pricing: ' + err.description);
} 


// reload applicationform
closeTopLevelDialogAndRefresh({iframeIds: ['deal-dashboard-iframe,loan-details-iframe']});
});
(function(skuid){
	var $ = skuid.$;
	$(document.body).one('pageload',function(){
		openLinksInNewTab();
	});
})(skuid);;
skuid.snippet.register('DefaultDateOnFees',function(args) {var params = arguments[0],
	$ = skuid.$;
var dueDate;
if(params.row.Fee__r &&  (params.row.Fee__r.Name == 'Origination Fees' || params.row.Fee__r.Name == 'Interim Rent')){
    var applicationRecord = skuid.model.getModel('EQAppModel').data[0];
    dueDate = applicationRecord.genesis__Expected_First_Payment_Date__c;    
} 
params.model.updateRow(params.row, {'Start_Date__c': dueDate});
});
(function(skuid){
	var $ = skuid.$;
	$(document.body).one('pageload',function(){
	
	
	$(document).ready(function(){
	    
	    skuid.snippet.getSnippet('TACalculation')();
	    
// 		var AppEqFundingDetails = skuid.model.getModel('AppEqFundingDetails');
// 		if(AppEqFundingDetails && AppEqFundingDetails.data && AppEqFundingDetails.data.length>0)
// 		{
// 		    var lists = AppEqFundingDetails.data;
		    
// 		    $.each(lists,function(i,val)
// 		    {
		     
// 		      //alert(val.Equipment__c+ '----'+ val.Trade_Amount__c);
		      
// 		      $('.TA_'+val.Equipment__c).html(val.Trade_Amount__c);
		        
// 		    });
// 		}
	});
		
	});
})(skuid);;
skuid.snippet.register('TACalculation',function(args) {var params = arguments[0],
$ = skuid.$;
	
var AppEqFundingDetails = skuid.model.getModel('AppEqFundingDetails');
		
		if(AppEqFundingDetails && AppEqFundingDetails.data && AppEqFundingDetails.data.length>0)
		{
		    var lists = AppEqFundingDetails.data;
		    
		    $.each(lists,function(i,val)
		    {
		      $('.TA_'+val.Equipment__c).html(val.Trade_Amount__c);
		    });
		}
});
skuid.snippet.register('UpdateAmountOnApplicationFee',function(args) {/*var params = arguments[0],
    $ = skuid.$;
var Amount;
alert(params);
if(params.row.Fee__r && (params.row.Fee__r.Name === 'Service Fees' && params.row.Escalate_Service_On__c === 'Total Payment' && params.row.Parent_id__c === Null)){

    var ApplicationFeeSRecords = skuid.model.getModel('FeesServices').data[0];
	alert(ApplicationFeeSRecords);
	Amount = ApplicationFeeSRecords.Equipment_Total_Payment__c;
}
alert(Amount);
params.model.updateRow(params.row,param.id,Amount);*/
var ApplicationFeeSRecords = skuid.model.getModel('FeesServices').data[0];
if(ApplicationFeeSRecords.Amount__c === null)
alert(suhas);
});
skuid.snippet.register('PageRefresh',function(args) {var params = arguments[0],
	$ = skuid.$;
window.location.reload();
});
skuid.snippet.register('EquipmentSelection',function(args) {var field = arguments[0],    
$ = skuid.$;
var value = skuid.utils.decodeHTML(arguments[1]);

console.log(field);
console.log(value);

if (field.mode === 'edit') {
    // create list of earlier selected details
    //$.each( field.model.getRows(), function(i,row) {
        //var selectedEqpList = '';
        /*console.log(row.Selected_Equipment__c);
        if(row.Selected_Equipment__c !== null && row.Selected_Equipment__c !== undefined) {
            selectedEqpList = row.Selected_Equipment__c;
            console.log('inside if statement');
        }
        */
    	//console.log(selectedEqpList);
    	var eqpList = [];
    	skuid.$.each(skuid.model.getModel('AppEquipmentModel').getRows(), function(i,row) {
    	    console.log(row.Name);
    	    //var previousSelected = selectedEqpList.includes(row.Name);
    	    //console.log(previousSelected);
    	    
    		eqpList.push({
    			active: true, 
    			defaultValue: true,
    			label : row.Name,
    			value : row.Name
    		});
    	});
    	
    	var customMultiselect = skuid.ui.renderers.MULTIPICKLIST.edit({
    			entries 	: eqpList,
    			required 	: false,
    			value 		: value
    		}).change(function(newValue) {
    			var selectedOptions = '';
    			for(i = 0; i < newValue.target.selectedOptions.length; i++) {
    			    if(i === (newValue.target.selectedOptions.length-1)) {
    			        selectedOptions += newValue.target.selectedOptions[i].value;
    			    } else {
    			        selectedOptions += newValue.target.selectedOptions[i].value + ', ';
    			    }
    			}
    
    			//Update the row in the target object
    			field.model.updateRow(field.row, 'Selected_Equipment__c', selectedOptions);
    		});
    	//Append the MULTIPICKLIST to the DOM element
    	field.element.append(customMultiselect);
    //});
	
} else if(field.mode === 'read') {
	//If the mode is anything other than edit, display the field as Text
	$.each( field.model.getRows(), function(i,row){
        var formattedValue = '';
        var fieldValue = row.Selected_Equipment__c;
    	/*if(fieldValue !== null) {
    		formattedValue = fieldValue.split(';').sort().join(', ');
    	}*/
    	skuid.ui.fieldRenderers.TEXT.read(field, fieldValue);
    });
}
});
skuid.snippet.register('UpdateEquipment',function(args) {var params = arguments[0],
	$ = skuid.$;
var appEqpModel = skuid.model.getModel('AppEquipmentModel');

alert('Please (Re)Generate Pricing as Equipment Details Modified...');

// Save updates
appEqpModel.save({
    callback: function (result) {
        if (result.totalsuccess) {
            //alert('New Quote Id: ' + appRow.Id); 
        } else {
            alert('Error: ' + result.insertResults[0]); 
            console.log(result.insertResults[0]);          
        }
    }
});

window.location.reload();
});
}(window.skuid));