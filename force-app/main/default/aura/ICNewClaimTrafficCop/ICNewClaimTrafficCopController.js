({
    onInit: function(component, event, helper) {
         
        this.navigateToMyComponent(component, event, helper);
       
         
    },
    navigateToMyComponent : function(component, event, helper) {
        console.log('navigating....');
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:ICSubmitNewClaim",
            componentAttributes: {
                recordId : component.get("v.recordId")
            }
        });
        evt.fire();
    }
})