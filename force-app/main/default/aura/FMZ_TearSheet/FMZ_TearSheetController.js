({
  doInit: function(component, event, helper) {
    console.log("Made it to Tearhseet");
    helper.initColumns(component);
    helper.initFakeData(component);
    helper.fetchData(component);
  }
});