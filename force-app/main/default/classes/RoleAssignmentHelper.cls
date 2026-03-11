/**
* @Description : This is a helper class for RoleAssignment LWC  
* @Author : Girikon
* Test Class : RoleAssignmentHelperTest
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 19-Aug-25 | Girikon | getFromUserList was returning more then 50000 records,used group by
*==============================================================================
* 1.0 | August 01, 2025 |   | Initial Version
**/
public class RoleAssignmentHelper {
    @AuraEnabled(cacheable=true)
    public static List<User> getActiveStandardUsers() {
        return [SELECT Id, Name FROM User WHERE isActive = TRUE AND UserType = 'Standard' ORDER BY Name];
    }
   
    @AuraEnabled(cacheable=true)
    public static List<User> getFromUserList(String objName, String fieldName) {
        try {
            // Validate input
            if (String.isBlank(objName) || String.isBlank(fieldName)) {
                return new List<User>();
            }
            system.debug('objName->'+objName);
            system.debug('fieldName->'+fieldName);
            
            String query = 'SELECT Id, Name, Email FROM User ' + 'WHERE Id IN (SELECT ' + fieldName + ' FROM ' + objName + ' WHERE ' + fieldName + ' != null) ' + 'AND IsActive = false';
            system.debug('query->'+query);
            
            List<User> fromUserListToReturn = Database.query(query);
            system.debug('fromUserListToReturn->'+fromUserListToReturn);
            
            return fromUserListToReturn;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static void transferRecords(string objName, String fieldName, String fromUserId, String toUserid, string mailingState){
        system.debug('objName->'+objName);
        system.debug('fieldName->'+fieldName);
        system.debug('fromUserId->'+fromUserId);
        system.debug('toUserid->'+toUserid);
        system.debug('mailingState->'+mailingState);

        Database.executeBatch(new RoleAssignmentTransferBatch(objName, fieldName, fromUserId, toUserId,mailingState), 200);        
    }
}