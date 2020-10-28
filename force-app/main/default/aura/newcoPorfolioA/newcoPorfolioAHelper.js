({
    getLeaseDetails : function(component) {

        var action = component.get("c.getLeaseDetailsNewco");
        action.setParams({
          leaseNumber: component.get("v.leaseNumber")
        });
        action.setCallback(this, function (response) {
          let state = response.getState();
          if (state === 'SUCCESS') {
              component.set('v.leaseDetails', response.getReturnValue());
              //console.log('lease details' + JSON.stringify(response.getReturnValue()));
              
          } else if (state === 'ERROR') {
              component.find("notifLib").showToast({
                title: "Something went wrong!",
                variant: "error",
                showCloseButton: true
              });
          }
      });
      $A.enqueueAction(action);
    }   
    
})
