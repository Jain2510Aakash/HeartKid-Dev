public class UpdateRelationshipManager {
    
    @InvocableMethod(label='Update Primary Relationship Manager')
    public static void updateManager(List<Request> requests) {
        if (requests.isEmpty()) return;
        
        Request req = requests[0];
        if (req.contactIds == null || req.newManagerId == null) return;
        
        system.debug('req.contactIds->'+req.contactIds);
        system.debug('req.newManagerId->'+req.newManagerId);
        // Queue the job to process asynchronously
        List<Contact> contactListToUpdate = new List<Contact>();
        
        // Safety check
        if (req.contactIds == null || req.contactIds.isEmpty() || req.newManagerId == null) {
            return;
        }
        
        for (string conId : req.contactIds) {
            Contact conToUpdate = new Contact();
            conToUpdate.Id = conId;
            conToUpdate.Primary_Relationship_Manager__c = req.newManagerId;
            contactListToUpdate.add(conToUpdate);
        }
        
        // Bulk update (no DML inside loop)
        if (!contactListToUpdate.isEmpty()) {
            // update contactListToUpdate;
        }
    }
    
    public class Request {
        @InvocableVariable
        public List<string> contactIds;
        
        @InvocableVariable
        public string newManagerId;
    }    
}