(function(skuid){
(function(skuid){
  var $ = skuid.$;
  $('head').append(
      $('<base target="_blank">')
  );

  $(document.body).one('pageload',function(){
      var paramId = skuid.page.params.id;
      var orgParamRow = skuid.model.getModel('OrgParameter').getFirstRow();
      var applicationModel = skuid.model.getModel('CommonApplicationModel');
      applicationModel.emptyData();
      var productModel = skuid.model.getModel('SelectedProduct');
      // application record type model
      var applicationRTModel = skuid.model.getModel('ApplicationRecordType');
      var rtIdCondition = applicationRTModel.getConditionByName('Id');
      
      if(paramId){
            var appIdCondition = applicationModel.getConditionByName('AppId');
            applicationModel.setCondition(appIdCondition,paramId);
           
            
            skuid.model.updateData([applicationModel],function(){
                // record type
                var appRecType = applicationModel.data[0].RecordTypeId;
                applicationRTModel.setCondition(rtIdCondition,appRecType);
                
              
                var prodIdCondition = productModel.getConditionByName('Id');
                productModel.setCondition(prodIdCondition, applicationModel.data[0].genesis__CL_Product__c);
                skuid.model.updateData([productModel,applicationRTModel],function(){
                    skuid.snippet.getSnippet('fetchAccountData')();
                    skuid.snippet.getSnippet('fetchContactData')();
                });
            });
      }else{
          // fetch record type info
        var appRecType = skuid.page.params.RecordType;
        if(!appRecType){
            var recordTypeQueryData = sforce.connection.query("Select Id from RecordType where DeveloperName = 'Lease' and SobjectType = 'genesis__Applications__c'");
            appRecType = recordTypeQueryData.records.Id;  
        }
        
        applicationRTModel.setCondition(rtIdCondition,appRecType);
        
        var company = sforce.connection.query('Select Id,Name from genesis__Company__c LIMIT 1');
        
        
        skuid.model.updateData([applicationRTModel],function(){
          var newRow = applicationModel.createRow({
                additionalConditions: [
                    { field: 'NewBorrower', value:false },
                    { field: 'RecordType', value:applicationRTModel.getFirstRow() },
                    { field: 'RecordTypeId', value:applicationRTModel.getFirstRow().Id },
                    { field: 'genesis__CL_Product__c', value:productModel.getFirstRow().Id },
                    { field: 'genesis__CL_Product__r.Name', value:productModel.getFirstRow().Name },
                    { field: 'genesis__Company__c', value:company.records.Id },
                    { field: 'genesis__Company__r.Name', value:company.records.Name },
                ]
            });
        }); 
      }  
  });
})(skuid);;
skuid.snippet.register('fieldRenderMode',function(args) {var field = arguments[0],
    value = arguments[1];
var renderMode = skuid.page.params.mode;
fieldModeToRender(field,value,renderMode);
});
skuid.snippet.register('fetchAccountData',function(args) {var params = arguments[0],
  $ = skuid.$;
  
var applicationRowData = skuid.model.getModel('CommonApplicationModel').data[0];
var commonAccountModel = skuid.model.getModel('CommonAccountModel');
var biModel = skuid.model.getModel('CommonBusinessInforModel');

commonAccountModel.emptyData();
biModel.emptyData();

if(applicationRowData && applicationRowData.genesis__Account__c){
    var accountIdCondition = commonAccountModel.getConditionByName('CommonAccId');
    commonAccountModel.setCondition(accountIdCondition,applicationRowData.genesis__Account__c);
    skuid.model.updateData([commonAccountModel],function(){
        if(!(commonAccountModel.data && commonAccountModel.data.length > 0)){
            var newPSRow = commonAccountModel.createRow({ });
        }else{
            if(commonAccountModel.data[0].genesis__Business_Information__c){
                // fetch business info
                var bIdCondition = biModel.getConditionByName('BusinessInfoId');
                biModel.setCondition(bIdCondition,commonAccountModel.data[0].genesis__Business_Information__c);
                skuid.model.updateData([biModel],function(){});
            }else{
                var newBIRow = biModel.createRow({ });
            }
        }
    });    
}else{
    if(!(commonAccountModel.data && commonAccountModel.data.length > 0)){
        var newPSRow = commonAccountModel.createRow({ });
        var newBIRow = biModel.createRow({ });
    } 
}
});
skuid.snippet.register('fetchContactData',function(args) {var params = arguments[0],
  $ = skuid.$;

var applicationRowData = skuid.model.getModel('CommonApplicationModel').data[0];
var commonContactModel = skuid.model.getModel('CommonContactModel');
commonContactModel.emptyData();
if(applicationRowData && applicationRowData.Name){
    if(applicationRowData.genesis__Contact__c){
        var contactIdCondition = commonContactModel.getConditionByName('CommonContactId');
        commonContactModel.setCondition(contactIdCondition,applicationRowData.genesis__Contact__c);
        skuid.model.updateData([commonContactModel],function(){
            if(!(commonContactModel.data && commonContactModel.data.length > 0)){
                var newPSRow = commonContactModel.createRow({ });
            }
        });    
    }
    
    if(applicationRowData.genesis__Account__c && applicationRowData.genesis__Account__r && 
        applicationRowData.genesis__Account__r.clcommon__Legal_Entity_Type__c && 
        (applicationRowData.genesis__Account__r.clcommon__Legal_Entity_Type__r.Name.toUpperCase() == 'INDIVIDUAL' ||
            applicationRowData.genesis__Account__r.clcommon__Legal_Entity_Type__r.Name.toUpperCase() == 'SOLE PROPRIETORSHIP')){
        var accountIdCondition = commonContactModel.getConditionByName('AccountId');
        commonContactModel.setCondition(accountIdCondition,applicationRowData.genesis__Account__c);
        skuid.model.updateData([commonContactModel],function(){
            if(!(commonContactModel.data && commonContactModel.data.length > 0)){
                var newPSRow = commonContactModel.createRow({ });
            }
        });
    }
}else{
    if(applicationRowData && applicationRowData.genesis__Contact__c){
        var contactIdCondition = commonContactModel.getConditionByName('CommonContactId');
        commonContactModel.setCondition(contactIdCondition,applicationRowData.genesis__Contact__c);
        skuid.model.updateData([commonContactModel],function(){
            if(!(commonContactModel.data && commonContactModel.data.length > 0)){
                var newPSRow = commonContactModel.createRow({ });
            }
        });    
    }else{
        if(!(commonContactModel.data && commonContactModel.data.length > 0)){
            var newPSRow = commonContactModel.createRow({ });
        }
    }
}
});
skuid.snippet.register('saveApplication',function(args) {var params = arguments[0],
  $ = skuid.$;
  
var newAppParams = {};
var editorWrapper = $('#AppTitleHeader'); 
if(skuid.page.params.id){
    editorWrapper = $('#AppDetailTitleHeader'); 
}
var editor = editorWrapper.data('object').editor;
var fetchIncludedPageData = skuid.snippet.getSnippet('getIncludedPageData');
var result = fetchIncludedPageData();
if(!result){
    editor.handleMessages(
        [
          {
              message: 'Unable to save Application data.',
              severity: 'ERROR'
          },
        ]
    );
    return;
}


var applicationModel = result['genesis__Applications__c'];
var billingAddressModel = result['Address__c'];

var appRow = applicationModel.data[0];
if(skuid.page.params.RecordType){
    appRow.RecordTypeId = skuid.page.params.RecordType;    
}
if(skuid.page.params.parentId){
    appRow.genesis__Parent_Application__c = skuid.page.params.parentId;    
}

var selectedProductModel = skuid.model.getModel('SelectedProduct');
var selectedProductRow = selectedProductModel.data[0];
if(selectedProductRow.Id && selectedProductRow.Id.length > 14){
    appRow.genesis__CL_Product__c = selectedProductRow.Id;
}
var contactModel = skuid.model.getModel('CommonContactModel');
var contactRow = contactModel.data[0];

var accountModel = skuid.model.getModel('CommonAccountModel');
var accRow = accountModel.data[0];

var businessModel = skuid.model.getModel('CommonBusinessInforModel');
var businessRow = businessModel.data[0];

// added by Manohar
var profilename=skuid.utils.userInfo.profileName;
var newApp= appRow.Id.startsWith("sk");
if(newApp == true){
    if((appRow.genesis__Status__c!= 'EXCEPTION' && appRow.genesis__Status__c != 'CREDIT APPROVED' && appRow.genesis__Status__c!= 'APPROVED - DOCUMENT CHECK' && profilename=='Newco Admin') || (appRow.genesis__Status__c!= 'APPROVED - DOCUMENT CHECK'  && profilename=='Newco Dealer')){
        editor.handleMessages(
            [
              {
                  message: 'You do not have access to update '+ appRow.genesis__Status__c + ' status',
                  severity: 'ERROR'
              },
            ]
        );
        return;
    }
} else {
      
    var soql = "select Id,genesis__Status__c from genesis__Applications__c where Id = '" + appRow.Id + "'";
    var resultapp = sforce.connection.query(soql);
    var apprecord = resultapp.getArray("records");
    if(apprecord[0].genesis__Status__c != appRow.genesis__Status__c && ((appRow.genesis__Status__c!= 'EXCEPTION' && appRow.genesis__Status__c != 'CREDIT APPROVED' && appRow.genesis__Status__c!= 'APPROVED - DOCUMENT CHECK' && profilename=='Newco Admin') || (appRow.genesis__Status__c!= 'APPROVED - DOCUMENT CHECK'  && profilename=='Newco Dealer'))){
        editor.handleMessages(
            [
              {
                  message: 'You do not have access to update '+ appRow.genesis__Status__c + ' status',
                  severity: 'ERROR'
              },
            ]
        );
        return;
    }
}

if(!appRow.Dealer_Invoice_Date__c || !appRow.Dealer_Invoice_Number__c){
    editor.handleMessages(
        [
          {
              message: 'You must enter a value for required fields',
              severity: 'ERROR'
          },
        ]
    );
    return;
}
// end manohar changes
if(!appRow.genesis__Term__c){
    appRow.genesis__Term__c = 0;
}

if(!appRow.genesis__Interest_Rate__c){
    appRow.genesis__Interest_Rate__c = 0;
}
if(!appRow.genesis__Loan_Amount__c){
    appRow.genesis__Loan_Amount__c = 0;
}
if(!appRow.genesis__Credit_Limit__c){
    appRow.genesis__Credit_Limit__c = 0;
}
if(!appRow.genesis__Financed_Amount__c){
    appRow.genesis__Financed_Amount__c = 0;
}
if(!appRow.genesis__Draw_Term__c){
    appRow.genesis__Draw_Term__c = 0;
}
newAppParams.applicationM = applicationModel;
newAppParams.pmtstreamM = null;
newAppParams.businessM = businessModel;
if(accRow.Name){
    if(!accountModel.data[0]['clcommon__Legal_Entity_Type__c']){
        editor.handleMessages(
            [
              {
                  message: 'Legal Entity Type is missing',
                  severity: 'ERROR'
              },
            ]
        );
        return;
    }
    if(!accountModel.data[0]['EIN__c']){
        editor.handleMessages(
            [
              {
                  message: 'EIN is missing',
                  severity: 'ERROR'
              },
            ]
        );
        return;
    }
    newAppParams.accountM = accountModel;
}else{
    newAppParams.accountM = null;
}

if(contactRow && contactRow.LastName){
    if(!contactModel.data[0].clcommon__Legal_Entity_Type__c){
        editor.handleMessages(
            [
              {
                  message: 'Legal Entity Type is missing',
                  severity: 'ERROR'
              },
            ]
        );
        return;
    }
    newAppParams.contactM = contactModel;
}else{
    newAppParams.contactM = null;
}
var skuidApplicationId = appRow.Id;
// create new address
if(billingAddressModel.data.length > 0){
    skuid.model.save([billingAddressModel], {callback: function(result){
        appRow.Billing_Address1__c = billingAddressModel.data[0].Id;
        processSaveApplication(newAppParams, editor);
    }});
} else {
    processSaveApplication(newAppParams, editor);
}

function processSaveApplication(newAppParams, editor){
    console.log('got invoked');
    var result = saveNGApplication(newAppParams);
    var resultJSON = $.parseJSON(result[0]);
    if (resultJSON.status === 'ERROR') {
        editor.handleMessages(
            [
              {
                  message: resultJSON.errorMessage,
                  severity: 'ERROR'
              },
            ]
        );
    } else {
        if(skuidApplicationId == resultJSON.content[0].Id){
            closeTopLevelDialogAndRefresh({iframeIds: ['deal-dashboard-iframe,loan-details-iframe','loan-details-iframe','deal-dashboard-iframe,document-iframe']});
        }else{
            // create dealer party
            // var dealerAccount = sforce.connection.query("SELECT id from Account where id = '" + skuid.utils.userInfo.userId + "'");
            // var dealerType = sforce.connection.query("SELECT id from clcommon__Party_Type__c where Name = 'DEALER'");
            // console.log(dealerAccount.id);
            // console.log(dealerType.id);
            window.location = '/' + resultJSON.content[0].Id;   
        }
    }
}
});
skuid.snippet.register('CloseDialog',function(args) {var params = arguments[0],
    $ = skuid.$;

//closeTopLevelDialogAndRefresh({iframeIds: ['loan-details-iframe']});
closeTopLevelDialogAndRefresh({iframeIds: ['deal-dashboard-iframe,loan-details-iframe','loan-details-iframe']});
});
skuid.snippet.register('IsReadModeDisabled',function(args) {var params = arguments[0],
  $ = skuid.$;

var readMode = false;
if(skuid.page.params.mode && skuid.page.params.mode == 'read'){
    readMode = true;
}
console.log('Mode ' + readMode);
return !readMode;
});
}(window.skuid));