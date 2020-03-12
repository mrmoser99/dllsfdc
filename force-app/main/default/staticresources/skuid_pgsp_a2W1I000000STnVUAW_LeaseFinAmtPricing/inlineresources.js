(function(skuid){
skuid.snippet.register('calculateFinancedAmount',function(args) {var pricingAppModel = skuid.model.getModel('PricingAppModel');
var pricingAppRow = pricingAppModel.data[0]; 

var result = sforce.apex.execute('genesis.SkuidPricingCtrl','generatePricing',
{   
        applicationId : pricingAppRow.Id
});
alert(result);
window.location.reload();
});
skuid.snippet.register('selectPricingOption',function(args) {var records = skuid.$.map(arguments[0].list.getSelectedItems(),function(item){ 
        return item.row; 
    }); 
if ( !records[0]  || records.length < 1) { 
    alert("Please select at least one pricing option"); 
}else if(records  && records.length > 1){
    alert("Please select at only one pricing option"); 
} else{ 
    var result = sforce.apex.execute('genesis.SelectPricingOnApplication','selectPricingOption',
    {   
            pricingId : records[0].Id
    });
    
    
    var selectedPricingModel = skuid.model.getModel('SelectedPricingDetail');
    var applicationModel = skuid.model.getModel('PricingAppModel');
    var applicationEquipmentModel = skuid.model.getModel('PricingEquipModel');
    
    skuid.model.updateData([selectedPricingModel, applicationEquipmentModel, applicationModel], function(){
        //update residual value on each equipment
        $.each(applicationEquipmentModel.data,function(i,row) {
            applicationEquipmentModel.updateRow(row,{ genesis__Residual_Value__c : selectedPricingModel.data[0].genesis__Residual_Percent__c});
        });
        
        // update rate factor on application
        applicationModel.updateRow(applicationModel.data[0], { Rate_Factor__c : selectedPricingModel.data[0].genesis__Rate_Factor__c});
        
        // save changes
        skuid.model.save([applicationEquipmentModel, applicationModel]);
        closeTopLevelDialogAndRefresh({iframeIds: ['deal-dashboard-iframe']});
        

    });
}
});
skuid.snippet.register('calculateFinancedAmount1',function(args) {var pricingAppModel = skuid.model.getModel('PricingAppModel');
var pricingAppRow = pricingAppModel.data[0]; 


// 1. Copying formula fields in Equipment for trade up amount before pricing generation
var result = sforce.apex.execute('UpdateEquipmentDetails','updateEquipmentDetail',
{   
        applicationId : pricingAppRow.Id
});


alert('Initiated Upfront Tax Calculation for Application Equipments...');
result = sforce.apex.execute('VertexUpfrontTaxCalculation','VertexGetUpfrontTax',
{   
        applicationName : pricingAppRow.Name
});
alert(result);

alert('Initiated Pricing Generation...');
result = sforce.apex.execute('genesis.SkuidPricingCtrl','generatePricing',
{   
        applicationId : pricingAppRow.Id
});

// Update pricing status
pricingAppModel.updateRow({
    Id: pricingAppRow.Id
}, {
    genesis__Status__c: "NEW - PRICING GENERATED"
});

// Save updates
pricingAppModel.save({
    callback: function (result) {
        if (result.totalsuccess) {
             //alert('New Quote Id: ' + appRow.Id); 
        } else {
            alert('Error: ' + result.insertResults[0]); 
            console.log(result.insertResults[0]);          
        }
    }
});

alert(result);

//        alert(pricingAppRow['Purchase_Option__c']);

if(pricingAppRow['Purchase_Option__c'] != 'One Dollar Buyout')        
var result1 = sforce.apex.execute('calculateEstPropertyTax','func_calcEPT',
{   
        applicationId : pricingAppRow.Id
});

var result2 = sforce.apex.execute('CalculateInsurance','GetInsuranceAmount',
{   
        applicationid : pricingAppRow.Id
});

if(pricingAppRow['Purchase_Option__c'] != 'One Dollar Buyout') 
alert('Insurance generation '+result2+ ' and EPT generation '+result1);
else
alert('Insurance generation '+result2);

console.log('trying to reload');

closeTopLevelDialogAndRefresh({iframeIds: ['deal-dashboard-iframe']});
//window.location.reload();
});
skuid.snippet.register('CalcPaymentsOrYield',function(args) {var $ = skuid.$
var pageTitle = $('#sk-228Y53-385');
var editor = pageTitle.data('object').editor;

var pricingAppModel = skuid.model.getModel('PricingAppModel');
var pricingAppRow = pricingAppModel.data[0];

/*
* Added IsYieldEnabled Model to check for which choiceNo to send based on selected checkbox genesis__Is_Get_Yield_Enabled__c 
*/
var isYieldEnabledModel = skuid.model.getModel('IsYieldEnabled'); 
var isYieldEnabledRow = isYieldEnabledModel.data[0];

var pAppObj = new sforce.SObject("genesis__Applications__c");
for(var key in pricingAppRow) {
   if(key.includes('__c') || key === 'Id'|| key === 'Name') {
       pAppObj[key] = pricingAppRow[key];
   }    
}

var choiceNo = 1;
if( ! isYieldEnabledRow['genesis__Is_Get_Yield_Enabled__c'] ){
    choiceNo = 2;
}

var result = sforce.apex.execute('genesis.SkuidPricingCtrl','calculatePricingFactors',
{   
        application : pAppObj,
        choice : choiceNo
});

if(result == 'Successfully computed...'){
    
    /* 
    Added extra if else to check against choiceNo to display whether yield/payment is 
    succesfully computed. Earlier in both cases only "yield calculated succesfully" was getting displayed
    */
    
    if(choiceNo == 1){
        editor.handleMessages( 
       [{
          
           message: 'Yield Calculated Successfully', 
           severity: 'INFO'
       }]
    )} else {
        editor.handleMessages( 
       [{
          
           message: 'Payment Calculated Successfully', 
           severity: 'INFO'
       }]
    )}
} else {
    editor.handleMessages(
        [{
              message: result,
              severity: 'ERROR'
        }]
    );
}
window.location.reload();
});
skuid.snippet.register('copyIsYieldEnabledValue',function(args) {/*
*  Purpose: Used to save rendering field in application object using different model name
*  Where  : Calculating Financial Amount / yield button
*
* @name   : editSaveForCalcFinanceAmt.js
* @author : Ashish Kumar Singh
* @version: 1.0
* @since  : 15-03-2017
*/
var isYieldEnabledModel = skuid.model.getModel('IsYieldEnabled'); 
var isYieldEnabledRow = isYieldEnabledModel.data[0];

console.log('isYieldEnabledRow ',isYieldEnabledRow);
isYieldEnabledModel.save();
});
skuid.snippet.register('GenerateInsuranceAndEPT',function(args) {var PriAppModel = skuid.model.getModel('PricingAppModel');

var PriAppRow = PriAppModel.data[0];

console.log(PriAppRow.id);

// 1. Copying formula fields in Equipment for trade up amount before pricing generation
var result = sforce.apex.execute('UpdateEquipmentDetails','updateEquipmentDetail',
{   
        applicationId : PriAppRow.Id
});

var result = sforce.apex.execute('CalculateInsurance','GetInsuranceAmount',
{   
        applicationid : PriAppRow.Id
});
//alert('Insurance generation '+result);

var result1 = sforce.apex.execute('calculateEstPropertyTax','func_calcEPT',
{   
        applicationId : PriAppRow.Id
});
alert('Insurance and EPT generation '+result1);

window.location.reload();
});
skuid.snippet.register('Capitalize Tax',function(args) {var PriAppModel = skuid.model.getModel('PricingAppModel');
var PriAppRow = PriAppModel.data[0];

//console.log(PriAppRow.id);
//commenting out the apex call as requested by Sophie (DLL) 
/*
var result = sforce.apex.execute('CapitalizeTax','CapitalizeTax',
{   
        applicationid : PriAppRow.Id, response :'YES'
});
alert('Please recalculate lease pricing as upfront tax amount added to financed amount')
window.location.reload();

*/
});
skuid.snippet.register('Uncapitalize Tax',function(args) {var PriAppModel = skuid.model.getModel('PricingAppModel');
var PriAppRow = PriAppModel.data[0];

//console.log(PriAppRow.id);
//commenting out the apex call as requested by Sophie (DLL)
/*
var result = sforce.apex.execute('CapitalizeTax','CapitalizeTax',
{   
        applicationid : PriAppRow.Id, response :'NO'
});
alert('New Application Fees created')
window.location.reload();
*/
});
skuid.snippet.register('Get Upfront Tax',function(args) {var PriAppModel = skuid.model.getModel('PricingAppModel');
var PriAppRow = PriAppModel.data[0];

//console.log(PriAppRow.id);
//commenting out the apex call as requested by Sophie (DLL)

var result = sforce.apex.execute('VertexUpfrontTaxCalculation','VertexGetUpfrontTax',
{   
        applicationName : PriAppRow.Name
});

//alert('please click "Finance Upfront Tax" or "One Time Upfront Tax"');
alert('Initiated Upfront Tax Calculation for Application Equipments...');

window.location.reload();
});
}(window.skuid));