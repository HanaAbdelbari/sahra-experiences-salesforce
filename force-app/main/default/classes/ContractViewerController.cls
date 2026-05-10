public with sharing class ContractViewerController {
    
    @AuraEnabled(cacheable=true)
    public static List<ContentVersion> getContractFiles(Id recordId) {
        
        // Get all ContentDocumentLinks for this record
        List<ContentDocumentLink> links = [
            SELECT ContentDocumentId 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :recordId
        ];
        
        // Extract document IDs
        Set<Id> documentIds = new Set<Id>();
        for (ContentDocumentLink link : links) {
            documentIds.add(link.ContentDocumentId);
        }
        
        if (documentIds.isEmpty()) {
            return new List<ContentVersion>();
        }
        
        // Get the latest version of each document
        return [
            SELECT Id, Title, ContentDocumentId, 
                   FileExtension, ContentSize, CreatedDate
            FROM ContentVersion
            WHERE ContentDocumentId IN :documentIds
            AND IsLatest = true
            ORDER BY CreatedDate DESC
        ];
    }
}