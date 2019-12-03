({
    doInit: function(component, event, helper) {
        helper.loadApplicationTerms(component);
        helper.loadTermOptions(component);
    },

    // mark components with equipment-changed css class
    handleChange: function(component, event, helper) {
        console.log('handle change');
        console.log(component.find('term').get('v.value'));
        try {
            let inputControl = event.getSource();
            $A.util.addClass(inputControl, 'terms-changed');
            return helper.helpSaveAndValidate(component);
        } catch (e) {
            console.log(e);
        }
    },

    // validate required fields and at least one piece of equipment
    saveAndValidate: function(component, event, helper) {
        return helper.helpSaveAndValidate(component);
    }

})