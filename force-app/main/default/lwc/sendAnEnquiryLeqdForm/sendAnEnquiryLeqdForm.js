import { LightningElement, track } from 'lwc';
import createLead from '@salesforce/apex/LeadContactController.createLead';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import cornerImg from '@salesforce/resourceUrl/getInTouchLead';

export default class SendAnEnquiryLeadForm extends LightningElement {
    imageUrl = cornerImg;

    @track isLoading = false;
    @track firstName = '';
    @track lastName = '';
    @track company = '';
    @track phone = '';
    @track email = '';
    @track whenToBuy = '';
    @track lookingFor = '';
    @track hearAboutUs = '';
    @track isBuilder = '';
    @track consent = false;

    // Dropdown Options
    lookingtoBuyOptions = [
        { label: 'Immediate', value: 'Immediate' },
        { label: '3 Months', value: '3 Months' },
        { label: '6 Months', value: '6 Months' },
        { label: '12 Months', value: '12 Months' },
        { label: '24 Months', value: '24 Months' }
    ];

    lookingForOptions = [
        { label: 'Land only', value: 'Land only' },
        { label: 'House and land package', value: 'House and land package' },
        { label: 'Apartment / Townhouse', value: 'Apartment / Townhouse' }
    ];

    hearUsOptions = [
        { label: 'Sales Suite', value: 'Sales Suite' },
        { label: 'Social Media', value: 'Social Media' },
        { label: 'Online Advertisement', value: 'Online Advertisement' },
        { label: 'Email', value: 'Email' },
        { label: 'Word of mouth', value: 'Word of mouth' },
        { label: 'Radio', value: 'Radio' },
        { label: 'Other', value: 'Other' }
    ];

    builderOptions = [
        { label: 'Yes', value: 'Yes' },
        { label: 'No', value: 'No' }
    ];

    // handle field changes
    handleChange(event) {
        const field = event.target.dataset.id; // match data-id in HTML
        this[field] = event.target.value;
    }

    handleCheckboxChange(event) {
        this.consent = event.target.checked;
    }

    // Validation before submit
    validateFields() {
        let isValid = true;
        let requiredFields = [
            { field: 'firstName', label: 'First Name' },
            { field: 'lastName', label: 'Last Name' },
            { field: 'company', label: 'Company Name' },
            { field: 'phone', label: 'Phone' },
            { field: 'email', label: 'Email' },
            { field: 'isBuilder', label: 'Are you a builder?' }
        ];

        for (let item of requiredFields) {
            if (!this[item.field]) {
                this.showToast('Validation Error', `${item.label} is required`, 'error');
                isValid = false;
                break;
            }
        }

        return isValid;
    }

    // Submit handler
    handleSubmit() {
        if (!this.validateFields()) {
            return;
        }

        this.isLoading = true;

        const leadData = {
            FirstName: this.firstName,
            LastName: this.lastName,
            Company: this.company,
            Phone: this.phone,
            Email: this.email,
            When_to_Buy__c: this.lookingtoBuy,
            Looking_For__c: this.lookingFor,
            Hear_About_Us__c: this.hearUs,
            Is_Builder__c: this.isBuilder,
            Consent__c: this.consent
        };

        createLead({ leadData })
            .then(() => {
                this.showToast('Success', 'Lead created successfully!', 'success');
                this.resetForm();
            })
            .catch(error => {
                this.showToast('Error creating lead', error.body.message, 'error');
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    resetForm() {
        this.firstName = '';
        this.lastName = '';
        this.company = '';
        this.phone = '';
        this.email = '';
        this.lookingtoBuy = '';
        this.lookingFor = '';
        this.hearUs = '';
        this.isBuilder = '';
        this.consent = false;
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title,
                message,
                variant
            })
        );
    }
}