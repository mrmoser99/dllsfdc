({
  doInit: function(component, event, helper) {
     
    helper.initColumns(component);
    helper.initFakeData(component);

    console.log('from newco is: ' + component.get('v.fromNewco'));
    helper.fetchData(component);
    
  }
});