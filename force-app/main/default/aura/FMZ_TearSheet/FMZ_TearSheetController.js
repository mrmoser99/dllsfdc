({
  doInit: function(component, event, helper) {
     
    helper.initColumns(component);
    helper.initFakeData(component);
    helper.fetchData(component);
    
  }
});