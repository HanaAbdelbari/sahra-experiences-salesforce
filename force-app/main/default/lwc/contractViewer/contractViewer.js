import { LightningElement, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getContractFiles from '@salesforce/apex/ContractViewerController.getContractFiles';

export default class ContractViewer extends NavigationMixin(LightningElement) {
    @api recordId;
    files = [];

    @wire(getContractFiles, { recordId: '$recordId' })
    wiredFiles({ error, data }) {
        if (data) {
            this.files = data.map(file => ({
                ...file,
                downloadUrl: '/sfc/servlet.shepherd/document/download/' 
                             + file.ContentDocumentId
            }));
        }
    }

    get hasFiles() {
        return this.files && this.files.length > 0;
    }

    handlePreview(event) {
        const contentDocumentId = event.target.dataset.id;
        this[NavigationMixin.Navigate]({
            type: 'standard__namedPage',
            attributes: {
                pageName: 'filePreview'
            },
            state: {
                selectedRecordId: contentDocumentId
            }
        });
    }
}