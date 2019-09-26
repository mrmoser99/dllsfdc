(function(skuid){
(function(skuid){
var $ = skuid.$;
	$(document.body).one('pageload',function(){
		// set height of window
        var windowHeight = window.innerHeight - 50;
        $('#deal-dashboard-iframe').height(windowHeight);
        // trigger click of first item in queue
        $($('#package-deal-queue .nx-item.nx-queue-item')[0]).trigger('click');
        var applicationFirstRow = skuid.model.getModel('ParentAndIncludedApplication').getFirstRow();
        sessionStorage.selectApplicationId = applicationFirstRow.Id;
        if(applicationFirstRow.RecordType && applicationFirstRow.RecordType.Name != 'Package'){
            $('#AppQueue').attr("style","display:none;");
            $('#deal-dashboard-container').attr("style","left:10px;");
        }
	});
})(skuid);;
skuid.snippet.register('LaunchAddDealsDialog',function(args) {var params = arguments[0],
	$ = skuid.$;

var appRow = skuid.model.getModel('ParentAndIncludedApplication').getFirstRow();
var title = 'Add Credit Facility To Deal - ' + appRow.Name;
var skuidPage = 'AddDealsToPackage';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + appRow.Id + '&name=' + appRow.Name;
openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
skuid.snippet.register('UpdateIFrameIds',function(args) {var params = arguments[0],
	$ = skuid.$;

var url = $('#deal-dashboard-iframe').attr('src');
if (url.lastIndexOf('&id=') >= 0) {
    url = url.substring(0, url.lastIndexOf('&id=')) + '&id=' + params.row.Id;
} else {
    url += '&id=' + params.row.Id;
}
$('#deal-dashboard-iframe').attr('src', url);
$('#deal-dashboard-iframe').hide();
$('#deal-dashboard-iframe').on('load', function() {
    $("#deal-dashboard-iframe").show();
});
sessionStorage.setItem('selectApplicationId',params.row.Id);
});
skuid.snippet.register('CreditFacilityOFF',function(args) {var params = arguments[0],
	$ = skuid.$;
return false;
});
}(window.skuid));