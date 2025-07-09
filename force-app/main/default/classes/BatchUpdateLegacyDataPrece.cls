public class BatchUpdateLegacyDataPrece implements Database.Batchable<SObject>{
    public Database.QueryLocator start(Database.BatchableContext bc) {
        
        return Database.getQueryLocator([select id,(select id,stagename from Opportunities where stagename = 'closed won') from contact]);
    }
    public void execute(Database.BatchableContext bc, List<Contact> contactList) {
        List<Contact> contactListToUpdate = new List<Contact>();
        
        for(contact con : contactList){
            if(con.Opportunities.size() == 0){
                con.Donor_Emails__c = false;
                con.Donor_SMS__c = false;
                con.Donor_Phone_Calls__c = false;
            }else if(con.Opportunities.size() > 0){
                con.Donor_Emails__c = True;
                con.Donor_SMS__c = True;
                con.Donor_Phone_Calls__c = True;
            }
            contactListToUpdate.add(con);
            
        }
        if(!contactListToUpdate.isEMpty()){
            system.debug(contactListToUpdate);
            system.debug('-->'+contactListToUpdate.size());
            database.update(contactListToUpdate,false);
        }
    }
    public void finish(Database.BatchableContext bc) {
        
    }
    
}