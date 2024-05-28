public with sharing class TodoController {
    private final TodoService todoService;
    private final ITodoValidator todoValidator;

    private TodoController() {
        this.todoService = (TodoService) Injector.getInjector().instantiate('TodoService');
        this.todoValidator = (ITodoValidator) Injector.getInjector().instantiate('TodoValidator');
    }

    private static final TodoController self = new TodoController();

    @AuraEnabled
    public static List<Todo__c> getTodos() {
       self.todoService.sdf();
        return self.todoService.getTodos();
    }

    @AuraEnabled
    public static void createTodo(Todo__c todo) {
        if(!self.todoValidator.validate(todo)){
            return new Exception('Incoming data is not valid');
        }
         self.todoService.createTodo(todo);
    }
}