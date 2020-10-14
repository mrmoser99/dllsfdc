import { LightningElement, wire, track } from "lwc";

import getJobDetails from "@salesforce/apex/BatchUtility.getJobDetails";

export default class BatchUtilityActivites extends LightningElement {
  @track jobDetails;
  _wiredJobDetails;
  @track refreshExecute = "";
  @track loading = false;
  error;
 
  

  columnConfig = [
    {
      label: "Completed Date",
      fieldName: "CompletedDate",
      type: "string"
    },
    {
      label: "Apex Class Name",
      fieldName: "ApexClassName",
      type: "text"
    },
    {
      label: "Number of Errors",
      fieldName: "NumberOfErrors",
      type: "integer"
    },
    {
      label: "Status",
      fieldName: "Status",
      type: "text"
    },
    {
      label: "Extended Status",
      fieldName: "ExtendedStatus",
      type: "text"
    }
  ];
 
  
  
  @wire(getJobDetails, { refreshExecute: "$refreshExecute"}) wired_getRunningJobs({ error, data }) {
    this._wiredJobDetails = [];
    this.jobDetails = [];
    //console.log('data is : ' + JSON.stringify (data));
   
    
    if (data) {
      data.forEach(r => {
        this.jobDetails.push({
          ApexClassName: r.ApexClassName,
          CompletedDate: r.CompletedDate,
          ExtendedStatus: r.ExtendedStatus,
          NumberOfErrors: r.NumberOfErrors,
          Status: r.Status,
          CreatedDate: r.CreatedDate
        });
      });
      
      this.loading = false;
    
    } else if (error) {
    
        this.error = error;
    }
  }

  onRefresh(){
     
    var today = new Date();
    this.loading = true;
    this.refreshExecute  = today.getSeconds() + today.getMilliseconds();
  }

  getLoading(){
    return this.loading;
  }
}