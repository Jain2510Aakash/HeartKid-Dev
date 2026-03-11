import { LightningElement, track } from 'lwc';
import createLead from '@salesforce/apex/LeadContactController.createLead';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import cornerImg from '@salesforce/resourceUrl/getInTouchLead';

export default class getInTouchleadForm extends LightningElement {
    imageUrl = cornerImg;

    @track firstName = '';
    @track lastName = '';
    @track whenToBuy = '';
    @track phone = '';
    @track email = '';
    @track heardFrom = '';
    @track consent = false;
    @track isLoading = false;

    buyOptions = [
        { label: 'Immediate', value: 'Immediate' },
        { label: '3 Months', value: '3 Months' },
        { label: '6 Months', value: '6 Months' },
        { label: '12 Months', value: '12 Months' },
        { label: '24 Months', value: '24 Months' }
    ];

    heardFromOptions = [
        { label: 'Sales Suite', value: 'Sales Suite' },
        { label: 'Social Media', value: 'Social Media' },
        { label: 'Online Advertisement', value: 'Online Advertisement' },
        { label: 'Email', value: 'Email' },
        { label: 'Word of mouth', value: 'Word of mouth' },
        { label: 'Radio', value: 'Radio' },
        { label: 'Other', value: 'Other' }
    ];

    handleChange(event) {
        const field = event.target.dataset.id;
        this[field] = event.detail ? event.detail.value : event.target.value;
    }

    handleCheckboxChange(event) {
        const field = event.target.dataset.id;
        this[field] = event.target.checked;
    }

    async handleSubmit() {
        debugger;
        this.isLoading = true;
        if (!this.lastName || !this.email || !this.firstName || !this.phone) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Missing required fields',
                    message: 'Please fill out required fields.',
                    variant: 'error'
                })
            );
            this.isLoading = false; // Hide spinner

            return;
        }

        const leadRecord = {
            FirstName: this.firstName,
            LastName: this.lastName,
            Company: 'Individual',
            Phone: this.phone,
            Email: this.email,
            Description: 'When to buy: ' + this.whenToBuy + '\nHeard From: ' + this.heardFrom + '\nConsent: ' + this.consent,
            Status: 'Open - Not Contacted'
        };

        try {
            const result = await createLead({ lead: leadRecord });
            this.isLoading = false; // Hide spinner

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Lead created (Id: ' + result + ')',
                    variant: 'success'
                })
            );
            this.resetForm();
        } catch (error) {
            this.isLoading = false; // Hide spinner

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error creating lead',
                    message: error.body ? error.body.message : error.message,
                    variant: 'error'
                })
            );
        }
    }

    resetForm() {
        this.firstName = '';
        this.lastName = '';
        this.whenToBuy = '';
        this.phone = '';
        this.email = '';
        this.heardFrom = '';
        this.consent = false;

        const inputs = this.template.querySelectorAll('lightning-input, lightning-combobox');
        if (inputs) {
            inputs.forEach((el) => {
                if (el.type === 'checkbox') el.checked = false;
                else el.value = '';
            });
        }
    }
}