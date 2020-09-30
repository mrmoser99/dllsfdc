({
    doInit : function(component, event, helper) {
        
         
        console.log('in do init' + component.get("v.autoSubmitDetails"));

        let modalBody;
        
        $A.createComponent(
          "c:FMZ_CreditApproval",
          { autoSubmitDetails: component.get("v.autoSubmitDetails"),
            recordId : component.get("v.recordId")
          },
          function(content, status, errorMessage) {
            if (status === "SUCCESS") {
              modalBody = content;
              component.find("overlayLib").showCustomModal({
                body: modalBody,
                showCloseButton: true,
                cssClass: "mymodal",
                closeCallback: function() {}
              });
            } else if (status === "ERROR") {
              let toast = $A.get("e.force:showToast");
              toast.setParams({
                title: "Error",
                message: errorMessage,
                type: "error"
              });
              toast.fire();
            }
          }
        );

        console.log('in do init2');

        //let dismiss = $A.get("e.force:closeQuickAction");
        //dismiss.fire();

        console.log('in do init3');
    }     
})
