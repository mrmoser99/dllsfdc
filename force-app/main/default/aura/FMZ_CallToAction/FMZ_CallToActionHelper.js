/**
 * Created by samuelmeyers on 11/15/18.
 */
({
    showRowDetails: function(component, row){

    },
    fundApp: function(component, row){
        let modalBody;
        $A.createComponent('c:FMZ_ApplicationConvertToLease',{
        recordId: row.id
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
        });
    },
    openEditApp: function(component, row){
        console.log('open edit app');
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/application-edit?id='+row.id
        });
        urlEvent.fire();
    },
    convertToApp: function(component, row){
        let modalBody;
        $A.createComponent('c:FMZ_QQ_ConvertToApplication',{
            recordId: row.id
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