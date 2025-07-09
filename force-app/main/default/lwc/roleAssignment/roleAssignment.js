import { LightningElement } from 'lwc';
import getActiveStandardUsers from '@salesforce/apex/RoleAssignmentHelper.getActiveStandardUsers';
import getFromUserList from '@salesforce/apex/RoleAssignmentHelper.getFromUserList';
import transferRecords from '@salesforce/apex/RoleAssignmentHelper.transferRecords';

export default class RoleAssignment extends LightningElement {
    objName = '';
    fieldName = '';
    fromUsersList = [];
    fromUser = '';
    parentField = '';
    toUserList = [];
    toUser = '';

    connectedCallback() {
        getActiveStandardUsers()
            .then(result => {
                this.toUserList = result.map(user => ({
                    label: user.Name,
                    value: user.Id
                }));
            })
            .catch(error => {
                console.error('Error fetching users:', error);
            });
    }

    get objectVal() {
        return [
            { label: 'Account', value: 'Account' },
            { label: 'Contact', value: 'Contact' },
        ];
    }

    get fieldVal() {
        return [
            { label: 'PRM', value: 'Primary_Relationship_Manager__c' },
            { label: 'Owner', value: 'OwnerId' },
        ];
    }

   get isTransferDisabled() {
        return !(this.objName && this.fieldName && this.fromUser && this.toUser);
   }

    handleChange(event) {
        debugger;
        const name = event.target.name;
        const value = event.detail.value;

        if (name === 'object') {
            this.objName = value;
        } else if (name === 'field') {
            this.fieldName = value;
        } else if (name === 'fromUser') {
            this.fromUser = value;
        } else if (name === 'toUser') {
            this.toUser = value;
        }

        if (this.objName && this.fieldName && this.fromUsersList.length === 0) {
            this.parentField = this.fieldName.includes('__c')
                ? this.fieldName.replace('__c', '__r')
                : this.fieldName.replace('Id', '');

            getFromUserList({ objName: this.objName, fieldName: this.fieldName })
                .then(result => {
                    this.fromUsersList = result.map(record => {
                        const related = record[this.parentField];
                        return {
                            label: related?.Name || 'Unknown',
                            value: related?.Id || ''
                        };
                    });
                    console.log('fromUsersList:', this.fromUsersList);
                })
                .catch(error => {
                    console.error('Error fetching from user list:', error);
                });
        }
    }
    handleTransferClick() {
        if (!this.objName || !this.fieldName || !this.fromUser || !this.toUser) {
            alert('Please select all values');
            return;
        }
        transferRecords({
            objName: this.objName,
            fieldName: this.fieldName,
            fromUserId: this.fromUser,
            toUserid: this.toUser
        })
            .then(result => {
                this.parentField = this.fieldName.includes('__c') ? this.fieldName.replace('__c', '__r') : this.fieldName.replace('Id', '');
                this.fromUsersList = result.map(record => {
                    const related = record[this.parentField];
                    return {
                        label: related?.Name || 'Unknown',
                        value: related?.Id || ''
                    };
                });
                console.log('Updated fromUsersList:', this.fromUsersList);
            })
            .catch(error => {
                console.error('Error transferring records:', error);
            });
    }
}