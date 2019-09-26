(function(skuid){
skuid.snippet.register('SelectFirstEntryInQueue',function(args) {var params = arguments[0],
	$ = skuid.$;

$(function() {
    var pageInclude = skuid.$('#relationship-dashboard').data('object');
    pageInclude.load(function() {
        clickQueueEntry(true, sessionStorage.selectedPartyId);
    });
});

function clickQueueEntry(force, partyId) {
    sessionStorage.removeItem('selectedPartyId');
    if (partyId) {
        var clickIndex = 0;
        $.each(skuid.model.getModel('DashboardParty').data, function(index, party) {
            if (party.Id === partyId) {
                clickIndex = index;
                return false;
            }
        });
        $($('#relationship-queue .nx-item.nx-queue-item')[clickIndex]).trigger('click');
    } else {
        if (force) {
            $($('#relationship-queue .nx-item.nx-queue-item')[0]).trigger('click');
        }
    }
}
});
skuid.snippet.register('AdjustLayoutRelationshipDashboard',function(args) {var params = arguments[0],
	$ = skuid.$;

if (sessionStorage.refreshParty) {
    sessionStorage.removeItem('refreshParty');
    var pageInclude = skuid.$('#relationship-dashboard').data('object');
    pageInclude.load(function() {
        clickQueueEntry(true, sessionStorage.selectedPartyId);
    });
} else {
    clickQueueEntry(false, sessionStorage.selectedPartyId);
}

function clickQueueEntry(force, partyId) {
    skuid.model.updateData([skuid.model.getModel('DashboardParty')],function(){
        if (partyId) {
            var clickIndex = 0;
            $.each(skuid.model.getModel('DashboardParty').data, function(index, party) {
                if (party.Id === partyId) {
                    clickIndex = index;
                    return false;
                }
            });
            $($('#relationship-queue .nx-item.nx-queue-item')[clickIndex]).trigger('click');
        } else {
            if (force) {
                $($('#relationship-queue .nx-item.nx-queue-item')[0]).trigger('click');
            }
        }
    });
}
});
skuid.snippet.register('LaunchEditLoanDialog',function(args) {var params = arguments[0],
	$ = skuid.$;

var appRowData = skuid.model.getModel('NGLDApplication').data[0];
var appId = appRowData.Id;
var title = 'Edit Loan Opportunity ' + appRowData.Name;
var skuidPage = 'ApplicationForm';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + appId;

openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
skuid.snippet.register('LaunchCreditMemoDialog',function(args) {var params = arguments[0],
	$ = skuid.$;

var appId = skuid.model.getModel('NGLDApplication').data[0].Id;
var title = 'Manage Credit Memo';
var skuidPage = 'CreditMemo';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + appId;

openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
skuid.snippet.register('LaunchChangeMemoDialog',function(args) {var params = arguments[0],
	$ = skuid.$;

var title = 'Manage Change Memo';

var appId = skuid.model.getModel('NGLDApplication').data[0].Id;
var skuidPage = 'ChangeMemos';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + appId;

openTopLevelDialog({
	title: title,
	iframeUrl: iframeUrl
});
});
skuid.snippet.register('LaunchFeeDialog',function(args) {var params = arguments[0],
	$ = skuid.$;

var appId = skuid.model.getModel('NGLDApplication').data[0].Id;
var title = 'Manage Fees';
var skuidPage = 'Fees';

// launchSimplePopupDialog(appId, title, skuidPage);

var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + appId;

openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
skuid.snippet.register('LaunchPolicyExceptionDialog',function(args) {var params = arguments[0],
	$ = skuid.$;

var appId = skuid.model.getModel('NGLDApplication').data[0].Id;
var title = 'Manage Policy Exceptions';
var skuidPage = 'PolicyExceptions';

// launchSimplePopupDialog(appId, title, skuidPage);

var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + appId;

openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
skuid.snippet.register('AddTooltipCollateralTab',function(args) {var params = arguments[0],
	$ = skuid.$;

$(function() {
    var pageInclude = skuid.$('#collateral-tab').data('object');
    pageInclude.load(function() {
        openLinksInNewTab();
	    showIconicBtnLabelAsTooltip();
    });
});
});
skuid.snippet.register('LaunchLoanHistoryDialog',function(args) {var params = arguments[0],
	$ = skuid.$;

var appId = skuid.model.getModel('NGLDApplication').data[0].Id;
var title = 'View Renewal History';
var skuidPage = 'RenewalHistory';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + appId;

openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
skuid.snippet.register('LaunchCovenantsDialog',function(args) {var params = arguments[0],
	$ = skuid.$;
var appId = skuid.model.getModel('NGLDApplication').data[0].Id;
var title = 'View Covenants';
var skuidPage = 'ApplicationCovenant';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + appId;

openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
skuid.snippet.register('refreshDocument',function(args) {var params = arguments[0],
	$ = skuid.$;

if(sessionStorage.refreshDocument) {
    sessionStorage.removeItem('refreshDocument');
    $('#document-iframe')[0].contentWindow.postMessage({type: 'action-refresh-tree-details'}, '*');
}
});
(function(skuid){
	var $ = skuid.$;
	$(document.body).one('pageload',function(){
	    var applicationData = skuid.model.getModel('NGLDApplication').getFirstRow();
	    if(applicationData && applicationData.genesis__Product_Type__c && applicationData.genesis__Product_Type__c == 'PACKAGE'){
    	    $('#loan-dashboard-parties-section').css('top','0');
    	    $('#loan-dashboard-parties-section').css('bottom','0');
	    }
	});
})(skuid);;
skuid.snippet.register('ConvertToContract',function(args) {var $ = skuid.$;

// To start showing the message
$.blockUI({
    message: 'Converting Application...',
    onBlock:function(){
        var appModel = skuid.model.getModel('NGLDApplication');
        var appRow = appModel.data[0];
        try {
            if(appRow.Selected_Pricing_Count__c != 1) {
                $.unblockUI();
                alert("Please Select Pricing before Converting to Contract..."); 
            } else {
                var result = sforce.apex.execute('genesis.ConvertApplicationCtrl','convertApplicationToContract',{appId : appRow.Id});
                $.unblockUI();
                if(result[0] === 'Application is converted to contract successfully'){
                    alert(result[0]);  
                    window.location.reload();
                } else {
                    alert(result[0]);
                }
            }
        } catch(err) {
            $.unblockUI();
            alert(err);
        }
    }
});
});
skuid.snippet.register('GenerateDandA',function(args) {// This Snippet is used to call CongaImpl class to generate D&A templet

var NGLDModel = skuid.model.getModel('NGLDApplication');
var NGLDRow = NGLDModel.data[0];

//var type="DandA";
  $ = skuid.$;
$.blockUI({
  message: 'Please Wait...'
});

var r = confirm("Are you sure you want to generate D and A Document!");
if (r === true) {
setTimeout(function(){
   var congaUrl = sforce.apex.execute('CongaImpl','generateDandADocument',
    {   
       recordId : NGLDRow.Id
   });
         $.unblockUI();
        alert(congaUrl);
        window.location.reload();
    },2000);
 
 }
else{
      $.unblockUI();
    return null;
}
});
skuid.snippet.register('GenerateLease',function(args) {// This Snippet is used to call CongaImpl class to generate Lease Agreement templet

var NGLDModel = skuid.model.getModel('NGLDApplication');
var NGLDRow = NGLDModel.data[0];
//var type="Lease";
$ = skuid.$;
$.blockUI({
  message: 'Please Wait...'
});

var r = confirm("Are you sure you want to generate Lease Document!");
if (r === true) {
setTimeout(function(){  
   var congaUrl = sforce.apex.execute('CongaImpl','generateLeaseDocument',
    {   
       recordId : NGLDRow.Id
   });
           $.unblockUI();
        alert(congaUrl);
        window.location.reload();
   },2000);
}
else{
      $.unblockUI();
    return null;
}
});
skuid.snippet.register('GenerateCreditApproval',function(args) {// This Snippet is used to call CongaImpl class to generate credit approval templet

var NGLDModel = skuid.model.getModel('NGLDApplication');
var NGLDRow = NGLDModel.data[0];
$ = skuid.$;

$.blockUI({
  message: 'Please Wait...'
});

var r = confirm("Are you sure you want to generate CreditApproval Document!");
if (r === true) {
setTimeout(function(){
   var congaUrl = sforce.apex.execute('CongaImpl','generateCreditApprovalDocument',
    {   
        
       recordId : NGLDRow.Id
   });
  
         $.unblockUI();
        alert(congaUrl);
        window.location.reload();
     },2000);
 }
else {
     $.unblockUI();
    return null;
    
}
});
}(window.skuid));