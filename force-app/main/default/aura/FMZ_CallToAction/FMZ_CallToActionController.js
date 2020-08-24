/**
 * Created by samuelmeyers on 11/9/18.
 */
({
    doInit : function(component, event, helper){
        console.log('do init');
        var action = component.get('c.getSections');
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
            if (state === 'SUCCESS') {
                var sections = response.getReturnValue();
                console.log(sections);
                component.set('v.sections', sections);

                for(var y in sections){
                    sections[y].columns = [
                        {label: sections[y].linkColTitle, fieldName: 'link', type: 'url', typeAttributes: {label: { fieldName: 'name'}},sortable:false},
                        {label: sections[y].infoColTitle, fieldName: 'info', type: 'text',sortable:false},
                        {label: 'Action', type: 'button', initialWidth: 150, typeAttributes: { variant: 'brand', label: sections[y].actionLabel, name: sections[y].name}}
                    ];
                }
                component.set('v.processing', false);
            } else {
                component.set('v.processing', false);
            }
        });

        component.set('v.processing', true);

        $A.enqueueAction(action);
    },
    handleRowAction : function(component, event, helper){
        var action = event.getParam('action');
        var row = event.getParam('row');
        console.log('action name' + action.name);
        switch (action.name) {
            case 'Fund_Applications':
                helper.fundApp(component, row);
                break;
            case 'Complete_Applications':
                helper.openEditApp(component, row);
                break;
            case 'Convert_Credit_Checks':
                helper.convertToApp(component, row);
                break;
            default:
                helper.showRowDetails(component, row);
                break;
        }
    },
    selectSection : function(component, event, helper){
        console.log('set selection');
        var selected = component.get('v.selectedSection');
        var ctarget = event.currentTarget;
        var data = ctarget.dataset.value;

        if(data == selected){
            component.set('v.selectedSection', '');
        }else{
            component.set('v.selectedSection', data);
        }
    }
})