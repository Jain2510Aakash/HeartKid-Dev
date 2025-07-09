public class BatchMergeDuplicateContactSch implements Schedulable {
    public void execute(SchedulableContext sc) {
        BatchMergeDuplicateContact batch = new BatchMergeDuplicateContact('scheduler');
        Database.executeBatch(batch, 1);
    }
}