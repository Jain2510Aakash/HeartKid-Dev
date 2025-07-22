public class OpportunityTriggerHandler {
    public static void beforeInsertUpdate(Map<Id, opportunity> oldMap, map<Id, opportunity> newMap){
        system.debug('beforeInsertUpdate');
        for(Opportunity opp : newMap.values()){
            if(opp.Name != NULL && (opp.Name).contains('!@#$')){
                List<String> parts = (opp.Name).split('!@#\\$');
                opp.Name = parts[parts.size() - 1].trim();
            }
        }
    }
    public static void afterInsertUpdate(Map<Id, opportunity> oldMap, map<Id, opportunity> newMap){
        system.debug('afterInsertUpdate');
        set<Id> insertedOppIds = new set<id>();
        set<Id> updatedOppIds = new set<id>();
        
        for(Opportunity opp : newMap.values()){
            opportunity oldOppRec = oldMap.get(opp.Id);
            if (Trigger.isInsert && opp.npsp__Primary_Contact__c != null && opp.Amount > 0 && opp.StageName == 'Closed Won') {
                insertedOppIds.add(opp.Id);
            }else if(!Trigger.isInsert && ((opp.npsp__Primary_Contact__c != null && opp.npsp__Primary_Contact__c != oldOppRec.npsp__Primary_Contact__c) || 
                                           (opp.StageName != oldOppRec.StageName &&  opp.StageName == 'Closed Won') || (opp.Amount != oldOppRec.Amount && oldOppRec.Amount == 0 && opp.Amount > 0)) ){
                                               updatedOppIds.add(opp.Id);  
                                               
                                           }
        }
        system.debug('insertedOppIds->'+insertedOppIds);
        system.debug('updatedOppIds->'+updatedOppIds);
        
        if(!insertedOppIds.isEmpty() || !updatedOppIds.isEmpty()){
            system.debug('Calling populatePRMonContact from opportunity');
            OpportunityTriggerHelper.populatePRMonContact(insertedOppIds, updatedOppIds);
        }
    }
}