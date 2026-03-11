/**
* @File Name : LeadContactController.cls
* @Description :
* @Author :
* @Last Modified By :
* @Last Modified On : August 14, 2025
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | August 14, 2025 |   | Initial Version
**/

public class LeadContactController {
	@AuraEnabled
    public static Id createLead(Lead lead) {
        try {
            insert lead;
            return lead.Id;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}