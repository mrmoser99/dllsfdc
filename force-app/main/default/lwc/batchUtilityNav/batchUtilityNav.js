import { LightningElement } from 'lwc';

export default class BatchUtilityNav extends LightningElement {

    onselect(event) {
        console.log('dispatching event to parent');
        const selectedItemName = event.detail.name;
        console.log('dispatching event to parent selectged was: ' + selectedItemName);
        const evt = new CustomEvent('navitemselected', {
            detail: { itemName: selectedItemName }
        });
        this.dispatchEvent(evt);
    }



}