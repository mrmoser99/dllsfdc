(function(skuid){
skuid.snippet.register('saveQuickQuote',function(args) {var qqModel = skuid.$M('QuickQuoteModel'); 
// Get reference to the first row
var qqRow = qqModel.data[0];
var quickQuoteObj = new sforce.SObject("genesis__Quick_Quotes__c");
for(var key in qqRow) {
   if(key.includes('genesis__Company__c') || key.includes('Legal_Entity__c') || key.includes('CL_Product__c') || key.includes('Dealer__c') || key.includes('Dealer_Name__c')) {
       quickQuoteObj[key] = qqRow[key];
   }    
   
}
//window.alert(quickQuoteObj.Dealer__c);
var $ = skuid.$
var pageTitle = $('#sk-1USljW-640');
var editor = pageTitle.data('object').editor;
var result = sforce.apex.execute(
        'genesis.SkuidQQPricingCtrl',
        'generatePricingForQQ', { 
            quickQuote :  quickQuoteObj,
            queryQuickQuote : false,
            isEquipmentBeingAdded : false
        }
    );
    
 
var resObj = JSON.parse(result);
if(resObj.status != 'ERROR') {
    editor.handleMessages(
        [
          {
              message: 'Quick Quote Saved!',
              severity: 'INFO'
          }
        ]
    );
    var v = resObj['content'];
    var id = v["0"].Id;
    qqRow.UpdatePricing = true;
    qqRow.Id = id;
    
    // create pricing option
    var pricingModel = skuid.model.getModel('QuickQuotePricingOptions');
    pricingModel.createRow({
        additionalConditions: [
            { field: 'genesis__Converted__c', value: true },
            { field: 'genesis__Quick_Quote__c', value: id },
        ]
    });
    
    skuid.model.save([pricingModel], {callback: function(result){
        if (result.totalsuccess) {
            console.log('Success');
            window.location = '/' + id;
        } else {
          // There was a problem. Let's see what went wrong.
          console.log(result.insertResults[0]);
        }
    }});
} else {
    editor.handleMessages(
        [
          {
              message: resObj.errorMessage,
              severity: 'ERROR'
          }
        ]
    );

}
});
}(window.skuid));