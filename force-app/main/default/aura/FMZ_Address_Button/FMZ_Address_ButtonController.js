({
    handleShowModal: function(component, evt, helper) {
        let modalBody;
        $A.createComponent('c:FMZ_Address_New',{
            accountId: component.get('v.accountId')
        }, function(content, status, errorMessage) {
                if (status === 'SUCCESS') {
                    modalBody = content;
                    component.find('overlayLib').showCustomModal({
                        body: modalBody,
                        showCloseButton: true,
                        cssClass: 'mymodal',
                        closeCallback: function() {
                            //alert('You closed the alert!');
                        }
                    })
                } else if (status === 'ERROR') {
                    let toast = $A.get('e.force:showToast');
                    toast.setParams({
                        title: 'Error',
                        message: errorMessage,
                        type: 'error'
                    });
                    toast.fire();
                }
            }
        );
    }
})