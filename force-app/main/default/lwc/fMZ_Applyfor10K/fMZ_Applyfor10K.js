import { LightningElement } from 'lwc';

import { NavigationMixin } from 'lightning/navigation';

export default class FMZ_Applyfor10K extends LightningElement {


    handleNavigate() {
        this[NavigationMixin.Navigate]({
            type: "standard__component",
            attributes: {
                componentName: "c__FMZ_CreditApproval"
            },
            state: {
                c__propertyValue: '500'
            }
        });
    }
}