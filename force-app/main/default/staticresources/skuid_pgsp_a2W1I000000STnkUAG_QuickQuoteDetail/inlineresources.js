(function(skuid){
skuid.snippet.register('SaveQuickQuote',function(args) {var qqModel = skuid.$M('QuickQuoteModel'); 
alert(1);
var qqRow = qqModel.data[0];
var $ = skuid.$
var pageTitle = $('#sk-1USljW-640');
var editor = pageTitle.data('object').editor;
var quickQuoteObjEq = new sforce.SObject("genesis__Quick_Quotes__c");
for(var key in qqRow) {
   if(key.includes('__c') || key === 'Id') {
       quickQuoteObjEq[key] = qqRow[key];
   }    
}

var queryQQ = true;
if(qqModel.originals){
   if(qqModel.originals[qqRow.Id]){
       if(qqModel.originals[qqRow.Id]['genesis__Payment_Frequency__c'] !== quickQuoteObjEq['genesis__Payment_Frequency__c']){
           queryQQ = false;
       }
       if(qqModel.originals[qqRow.Id]['genesis__Source__c'] !== quickQuoteObjEq['genesis__Source__c']){
           queryQQ = false;
       }
   } 
}

var result = sforce.apex.execute(
        'genesis.SkuidQQPricingCtrl',
        'generatePricingForQQ', { 
            quickQuote :  quickQuoteObjEq,
            queryQuickQuote : queryQQ,
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
if(!queryQQ){
       window.location.reload();
    }
});
skuid.snippet.register('CalcAmtsOnQQ',function(args) {var qqModel = skuid.$M('QuickQuoteModel'); 
// Get reference to the first row
var qqRow = qqModel.data[0];
var $ = skuid.$
var pageTitle = $('#errorPanelEquipment'); //$('#errorPanelEquipment'); // $('#sk-1USljW-640');
var editor = pageTitle.data('object').editor;
console.log('editor ',editor);
var quickQuoteObjEq = new sforce.SObject("genesis__Quick_Quotes__c");
for(var key in qqRow) {
   if(key.includes('__c') || key === 'Id') {
       quickQuoteObjEq[key] = qqRow[key];
   }    
}
var result = sforce.apex.execute(
        'genesis.SkuidQQPricingCtrl',
        'generatePricingForQQ', { 
            quickQuote :  quickQuoteObjEq,
            queryQuickQuote : true,
            isEquipmentBeingAdded : true
        }
    );

var resObj = JSON.parse(result);
console.log('resObj ',resObj);
if(resObj.status != 'ERROR') {
    editor.handleMessages(
        [
          {
              message: 'Equipment Saved!',
              severity: 'INFO'
          }
        ]
    );
} else {
    editor.handleMessages(
        [
          {
              message: resObj.errorMessage,
              severity: 'ERROR'
          }
        ]
    );
    return false;

}
window.location.reload();
});
skuid.snippet.register('GeneratePricingOnQQ',function(args) {var qqModel = skuid.$M('QuickQuoteModel'); 
// Get reference to the first row
var qqRow = qqModel.data[0];
var $ = skuid.$
var pageTitle = $('#sk-1USljW-640');
var editor = pageTitle.data('object').editor;
var quickQuoteObj = new sforce.SObject("genesis__Quick_Quotes__c");
for(var key in qqRow) {
   if(key.includes('__c') || key === 'Id') {
       quickQuoteObj[key] = qqRow[key];
   }    
}
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
              message: 'Pricing Generated Succesfully!',
              severity: 'INFO'
          }
        ]
    );
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
window.location.reload();
});
skuid.snippet.register('SelectPricing',function(args) {var $ = skuid.$
var pageTitle = $('#sk-1USljW-640');
var editor = pageTitle.data('object').editor;

var qqModel = skuid.$M('QuickQuoteModel'); 
// Get reference to the first row
var qqRow = qqModel.data[0];

var quickQuoteObj = new sforce.SObject("genesis__Quick_Quotes__c");
for(var key in qqRow) {
   if(key.includes('__c') || key === 'Id') {
       quickQuoteObj[key] = qqRow[key];
   }    
}

var records = skuid.$.map(arguments[0].list.getSelectedItems(),function(item){ 
        return item.row; 
    }); 

if (!records[0] || records.length < 1) { 
    editor.handleMessages(
        [
          {
              message: 'Please select at least one pricing option',
              severity: 'ERROR'
          }
        ]
    );
    
}else if(records  && records.length > 1){
    editor.handleMessages(
        [
          {
              message: 'Please select at only one pricing option',
              severity: 'ERROR'
          }
        ]
    );
    
} else{ 
    var result = sforce.apex.execute('genesis.SkuidQQPricingCtrl','selectPricingOptionOnQuickQuote',
    {   
            quickQuote : quickQuoteObj,
            pricingOptionId : records[0].Id
    });
    
    editor.handleMessages(
        [
          {
              message: result,
              severity: 'INFO'
          }
        ]
    );
    window.location.reload();
}
});
skuid.snippet.register('CallATS',function(args) {var $ = skuid.$
var pageTitle = $('#sk-1USljW-640');
var editor1 = pageTitle.data('object').editor;

var qqModel = skuid.$M('QuickQuoteModel'); 
// Get reference to the first row
var qqRow = qqModel.data[0];

var quickQuoteObj = new sforce.SObject("genesis__Quick_Quotes__c");
for(var key in qqRow) {
   if(key.includes('__c') || key === 'Id') {
       quickQuoteObj[key] = qqRow[key];
   }    
}
var result = sforce.apex.execute(
        'GetCreditApproval',
        'func_getcreditapproval', { 
            Cred_App_obj :  quickQuoteObj
        }
    );

if(result.indexOf('success') > -1) {
    

    editor1.handleMessages(
        [
          {
              message: result,
              severity: 'INFO'
          }
        ]
    );
} else {
    
    editor1.handleMessages(
        [
          {
              message: result,
              severity: 'ERROR'
          }
        ]
    );
    
}

window.setTimeout(function(){location.reload()},4000)
//window.location.reload();
});
// the ID prefix of the Quick_Quote custom object
// Please verify before deployment, that the sObject has the same ID prefix in the target environment.
var sObjectKeyPrefix = 'a1S';

(function() {

    initialize();
    
    EDQ.jQuery(document).on( "focus", 'div.edq-address input', function(event) {
        if('INPUT' !== event.target.nodeName) { return; }
        
        var touchpoint = window.edqAddressClient._touchpoints[0];
        var streetElementId = touchpoint._inputMappings.Street[0];
        event.target.setAttribute("id", streetElementId);

        window.edqAddressClient._initializeForTouchpoint(window.edqAddressClient._touchpoints[0], false /* isNew */); 
    });
})();

function initialize() {
    var sys = EDQ.system;
    var dq = EDQ.DataQuality;
    var sfdc = EDQ.DataQuality.Salesforce;

    if (sys.isNull(window.edqSObjectConfigurations)) { return; }
    if (sys.isNullOrEmpty(sObjectKeyPrefix)) { return; }

    var sObjectConfigurations = window.edqSObjectConfigurations[sObjectKeyPrefix];
    if (sys.isNull(sObjectConfigurations)) {
        return;
    }
    EDQ.DataQuality.Client.delimiter = window.edqGlobalSettings.AddressSettings.ConcatenationSeparator;
    
    EDQ.DataQuality.Salesforce.setElementValue = function setElementValue(elementId, value, callback) {
        value = dq.Salesforce.convertCountryValueToCountryPicklistValue(value); //Convert United States of America to United States.
        
        var skuidModel = skuid.$M('QuickQuoteModel');

        if(false === sys.isNull(skuidModel) && false !== skuidModel.getField(elementId)) {
            skuidModel.updateRow(skuidModel.getFirstRow(), elementId, value);
        }

        if (sys.isFunction(callback)) { callback(); }        
    };

    EDQ.DataQuality.Salesforce.GlobalIntuitiveAddress.Client.prototype.getElementValue = function getElementValue(elementId) {
        var skuidModel = skuid.$M('QuickQuoteModel');

        if(sys.isNull(skuidModel)) { return; }

        return skuidModel.getFieldValue(skuidModel.getFirstRow(), elementId);
    };

    window.edqAddressClient = new sfdc.GlobalIntuitiveAddress.Client(window.edqSessionToken.AV2Token);
    window.edqAddressClient.createTouchpointsFor(
        sObjectConfigurations["AddressTouchpoints"], 
        dq.GlobalIntuitiveAddress, 
        'Address', 
        sfdc.getUser().ProfileId
    );
};
skuid.snippet.register('EDQOnSaveSnippet',function(args) {var sys = EDQ.system;
if(window.edqAddressClient !== null && window.edqAddressClient !== undefined) { 
    try {
        window.edqAddressClient.fixValidationStatusIfFieldsWereEdited();
    } catch(error) {
        sys.logError(error);
    }   
}
});
skuid.snippet.register('ConvertQuickQuoteToApplication',function(args) {var params = arguments[0],
	$ = skuid.$;
var qqModel = skuid.$M('QuickQuoteModel'); 
var qqRow = qqModel.getFirstRow();

var result = sforce.apex.execute('ConvertQuickQuoteToApplication',  'createApplication', { 
            quickQuoteId :  qqRow.Id,
            mapDuplicateAccount: false
        }
    );

var resObj = JSON.parse(result);
if(resObj.Status === 'ERROR'){
    if(resObj.DuplicateId){
        var popupXMLString = '<popup title="Duplicate Account Detected" width="80%">'
                            + '<components>'
                            + '<includepanel type="skuid" uniqueid="sk-3eqAqF-193" pagename="DuplicateAccounts" module="ngUi"' + 
                                ' querystring="accountId=' + resObj.DuplicateId + '&amp;quickQuoteId=' + qqRow.Id + '"/>'
                            + '</components>'
                            + '</popup>';
        var popupXML = skuid.utils.makeXMLDoc(popupXMLString);
        context = { row: qqRow };
        var popup = skuid.utils.createPopupFromPopupXML(popupXML,context);
    } else {
        alert(resObj.Message);
    }
} else {
    alert('Application Created  Successfully!');
    window.location.reload(true);
}
});
}(window.skuid));