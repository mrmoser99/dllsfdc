({
    gotoList : function (component, event, helper) {
        console.log(' entering no man zone');
        var action = component.get("c.getListViews");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var listviewId = response.getReturnValue();
                console.log('listviewId' + response.getReturnValue());
                var navEvent = $A.get("e.force:navigateToList");
                navEvent.setParams({
                    "listViewId": listviewId,
                    "listViewName": null,
                    "scope": "Account"
                });
                navEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }
})