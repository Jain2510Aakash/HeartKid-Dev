trigger CaseTrigger on Case (After insert, after update) {
    if(trigger.isAfter && trigger.isInsert){
        CaseTriggerHelper.afterInsert(trigger.oldMap, trigger.newMap);
    }
     if(trigger.isAfter && trigger.isUpdate){
        CaseTriggerHelper.afterUpdate(trigger.oldMap, trigger.newMap);
    }
}