import { LightningElement,  track } from 'lwc';
import runJob from "@salesforce/apex/BatchUtility.runJob"; 
import { ShowToastEvent } from 'lightning/platformShowToastEvent';




const VIEW_DAILY_RESULTS = 'djobview';


export default class batchUtilityManger extends LightningElement {

	@track viewMode = 'none';
	@track loading= false;
	_title = 'Notice';
    message = 'The daily job has been submitted!';
	variant = 'Success';
	
	handleNavItemSelected(event) {
		
		const selectedItemName = event.detail.itemName;
		
		if (selectedItemName === 'djobview') {
			runJob()
			.then(() => {})
			.catch((error) => {
				this.message = 'Error received: code' + error.errorCode + ', ' +
					'message ' + error.body.message;
			});

			this.viewMode = VIEW_DAILY_RESULTS;
			const evt = new ShowToastEvent({
				title: this._title,
				message: this.message,
				variant: this.variant
            });
            this.dispatchEvent(evt);
         
		}
	
	}


	get dJobView() {
	
		return (this.viewMode === VIEW_DAILY_RESULTS);
	}

	getLoading(){
		return this.loading;
	}
	handleLoading() {
		this.loading = true;
	}
	handleDoneLoading() {
		this.loading = false;
	}
}