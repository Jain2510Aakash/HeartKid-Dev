/*****
* Created by Girikon 11-July-2025 
* Test Class : 
* Purpose: to fill PSRM on the related contact
*     Change log
 
*     Author            Date            Description
* ==============================================================================================================================================================
*
*/
public class CaseTriggerHelper {
    public static void afterInsert(Map<Id,Case> oldMap, Map<Id,Case> newMap){
        List<Contact> ContactListToUpdatePSRM = new List<Contact>();
        for(Case caseRec : newMap.values()){
            if(caseRec.ContactId != null){
                contact conRec = new Contact();
                conRec.Id = caseRec.ContactId;
                conRec.Primary_Support_Relationship_Manager__c = caseRec.ownerId;
                ContactListToUpdatePSRM.add(conRec);
            }
        }
        if(!ContactListToUpdatePSRM.isEmpty()){
            database.update(ContactListToUpdatePSRM, false);
        }
    }
    public static void afterUpdate(Map<Id,Case> oldMap, Map<Id,Case> newMap){
        Map<Id,Contact> ContactMapToUpdatePSRM = new Map<Id, Contact>();
        Set<Id> removedContactIds = new Set<Id>();
        for(Case caseRec : newMap.values()){
            if(caseRec.ContactId != null && caseRec.ContactId != oldMap.get(caseRec.Id).ContactId){
                contact conRecToUpdate = new Contact();
                conRecToUpdate.Id = caseRec.ContactId;
                conRecToUpdate.Primary_Support_Relationship_Manager__c = caseRec.ownerId;
                ContactMapToUpdatePSRM.put(conRecToUpdate.Id, conRecToUpdate);
                if(oldMap.get(caseRec.Id).ContactId != null)
                    removedContactIds.add(oldMap.get(caseRec.Id).ContactId);
            }else if(caseRec.ContactId == null){
                removedContactIds.add(oldMap.get(caseRec.Id).ContactId);
            }
        }
        if(!removedContactIds.isEmpty()){
            List<Contact> removedContactList = [Select Id,Primary_Support_Relationship_Manager__c,(Select Id,OwnerId From Cases order by CreatedDate Desc limit 1) From Contact where Id in: removedContactIds];
            if(!removedContactList.isEmpty()){
                for(Contact con : removedContactList){
                    system.debug('removedContactList->'+removedContactList);
                    system.debug('con.Cases->'+con.Cases);
                    if(con.Cases != null && !con.Cases.isEmpty()){
                        contact conRecToUpdate = new Contact();
                        conRecToUpdate.Id = con.Id;
                        conRecToUpdate.Primary_Support_Relationship_Manager__c =  con.Cases[0].ownerId;
                        ContactMapToUpdatePSRM.put(conRecToUpdate.Id, conRecToUpdate);
                    }else if(con.Cases.isEmpty() || con.cases == null){
                        contact conRecToUpdate = new Contact();
                        conRecToUpdate.Id = con.Id;
                        conRecToUpdate.Primary_Support_Relationship_Manager__c =  null;
                        ContactMapToUpdatePSRM.put(conRecToUpdate.Id, conRecToUpdate);
                    }
                }
            }
        }
        if(!ContactMapToUpdatePSRM.isEmpty()){
            database.update(ContactMapToUpdatePSRM.values(), false);
        }
    }
}