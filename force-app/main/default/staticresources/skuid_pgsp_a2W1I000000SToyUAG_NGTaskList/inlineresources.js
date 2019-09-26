(function(skuid){
(function(skuid){
    var $ = skuid.$;
    $('.nx-page').one('pageload',function(){

        $('#submitToNxtDept').attr('title', 'Submit To Next Department');
        $('#createExceptionTsk').attr('title', 'Create Exception Task');

       var appRow = skuid.model.getModel('LDApplication').getFirstRow();
       var appId = appRow.Id;

        // document required
        var queryForDocumentException = "SELECT count() from clcommon__Document_Category__c where clcommon__Required__c = true and clcommon__Status__c = 'OPEN' AND genesis__Application__c = \'"+ appId +"\'";
        var docExceptionCount = sforce.connection.query(queryForDocumentException);
        $('.square.lochmara').attr('execVal',docExceptionCount.size);
        
        // credit dept tasks
        var queryCreditDeptTaskSetups = "SELECT count() from genesis__ProductDepartment_Task_Junction__c where genesis__Department__c = 'DEALER CHECKLIST' AND genesis__Product_Name__c = 'Finance Lease'";
        var queryCreditDeptTask = "SELECT count() from Task where genesis__Department__r.Name = 'DEALER CHECKLIST' AND IsClosed = true AND genesis__Application__c = \'" +appId + "\'";
        var creditDeptTaskSetups = sforce.connection.query(queryCreditDeptTaskSetups);
        var creditDeptTasks = sforce.connection.query(queryCreditDeptTask);
        $('.square.treeP').attr('execVal',creditDeptTaskSetups.size - creditDeptTasks.size);
        
        
        // booking dept tasks
        var queryBookingDeptTaskSetups = "SELECT count() from genesis__ProductDepartment_Task_Junction__c where genesis__Department__c = 'NEWCO CHECKLIST' AND genesis__Product_Name__c = 'Finance Lease'";
        var queryBookingDeptTasks = "SELECT count() from Task where genesis__Department__r.Name = 'NEWCO CHECKLIST' AND IsClosed = true AND genesis__Application__c = \'" +appId + "\'";
        var bookingDeptTaskSetups = sforce.connection.query(queryBookingDeptTaskSetups);
        var bookingDeptTasks = sforce.connection.query(queryBookingDeptTasks);
        $('.square.limedS').attr('execVal',bookingDeptTaskSetups.size - bookingDeptTasks.size);
        
        /*
        // example for customization
        // booking dept tasks
        queryBookingDeptTaskSetups = "SELECT count() from genesis__ProductDepartment_Task_Junction__c where genesis__Department__c = 'Booking Department' AND genesis__Product_Name__c = 'Finance Lease'";
        queryBookingDeptTasks = "SELECT count() from Task where genesis__Department__r.Name = 'Booking Department' AND IsClosed = true AND genesis__Application__c = \'" +appId + "\'";
        bookingDeptTaskSetups = sforce.connection.query(queryBookingDeptTaskSetups);
        bookingDeptTasks = sforce.connection.query(queryBookingDeptTasks);
        $('.square.limedS').attr('execVal',bookingDeptTaskSetups.size - bookingDeptTasks.size);
        */
        
        // exception tasks count
        var queryForExcpTask = "SELECT count() from Task where IsClosed != true and genesis__Application__c = \'"+ appId +"\' and genesis__Task_Setup__c = NULL";
        var exceptionTasksCount = sforce.connection.query(queryForExcpTask);
        $('.square.tskOutstanding').attr('execVal',exceptionTasksCount.size);
        
        
        var iframeHeight = window.innerHeight - 65;
        $('iframe').height(iframeHeight);

        if(appRow.genesis__Overall_Status__c){
            console.log(appRow.genesis__Overall_Status__c);
            appRow.genesis__Overall_Status__c = appRow.genesis__Overall_Status__c.replace('Being Processed By', '');
            appRow.genesis__Overall_Status__c = appRow.genesis__Overall_Status__c.replace('Waiting for', '');
        }

        var showSubmitButton = sforce.apex.execute('genesis.LoanDashBoard','showSubmitToNxtDeptBtn',
            {
                    applicationId : appRow.Id
            });

        if(showSubmitButton == 'true'){
            $('#submitToNxtDept').button('enable');
        }else{
            $('#submitToNxtDept').button('disable');
        }
    });
})(skuid);;
skuid.snippet.register('submitToNextDepartmentJs',function(args) {var appModels = skuid.model.getModel('LDApplication');
var appRow = appModels.data[0];

var showSubmitButton = sforce.apex.execute('genesis.LoanDashBoard','submitToNextDepartment',
{
        applicationId : appRow.Id
});

toTopLevelAndRefresh({iframeIds: ['task-list-popover']});

var title = 'Submit To Next Department';
var content = '<p>' + showSubmitButton + '</p>';
var type = 'alert';
openTopLevelDialog({
    type : type,
  title: title,
  prefixHtml: content
});
});
skuid.snippet.register('LaunchTaskCreationDialog',function(args) {var params = arguments[0],
  $ = skuid.$;

var appId = params.row.Id;
var title = 'Add Exception Task';
var skuidPage = 'NewTaskCreation';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + appId;

openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
}(window.skuid));