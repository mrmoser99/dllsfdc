import { LightningElement,  track } from 'lwc';
import runJob from "@salesforce/apex/BatchUtility.runJob"; 




const VIEW_DAILY_RESULTS = 'djobview';


export default class batchUtilityManger extends LightningElement {

	@track viewMode = 'none';
	@track loading= false;
	
	handleNavItemSelected(event) {
		console.log('handle event received');
		const selectedItemName = event.detail.itemName;
		
		if (selectedItemName === 'djobview') {
			runJob()
			.then(() => {})
			.catch((error) => {
				this.message = 'Error received: code' + error.errorCode + ', ' +
					'message ' + error.body.message;
			});
			this.viewMode = VIEW_DAILY_RESULTS;
		}
		console.log('this viewMode=' + selectedItemName);
	}


	get dJobView() {
		console.log('getting job view');
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