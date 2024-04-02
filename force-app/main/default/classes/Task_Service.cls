global with sharing class Task_Service
{
	//This literally just calls the Task_Service_Impl class's createTasks method
	global static void createTasks(Set<Id> recordIds, Schema.SObjectType objectType){
		service().createTasks(recordIds, objectType);
	}

	//This gets an instance of the Task_Service_Impl class from our Application class
	private static Task_Service_Interface service(){
		return (Task_Service_Interface) Application.service.newInstance(Task_Service_Interface.class);
	}
}