public with sharing class TodoService {
    public virtual void createTodo(Todo__c todo){
        insert as user todo;
    }
    public virtual List<Todo__c> getTodos() {
        return [SELECT Id, Name, Priority__c, DueDate__c FROM Todo__c USER_MODE];
    }
    public virtual void updateTodo(Todo__c todo){
        upsert as user todo;
    }
}