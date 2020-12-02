({
  doInit: function(component, event, helper) {
    
   
    helper.initColumns(component);
    console.log('before fetch');
  
    helper.fetchData(component);
   
    
  }
});