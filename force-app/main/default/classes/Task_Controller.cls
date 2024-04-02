/**
 * @Author: Bernie Shishaye
 * @Create Time: 2024-04-01 15:17:23
 * @Modified by: Bernie Shishaye
 * @Modified time: 2024-04-01 23:16:51
 * @Description:
 */


public with sharing class Task_Controller
{
	@AuraEnabled
	public static void createTasks(Id recordId){
		Set<Id> recordIds = new Set<Id>{recordId};
		Schema.SObjectType objectType = recordId.getSobjectType();
		try{
			Task_Service.createTasks(recordIds, objectType);
		}
		catch(Exception e){
			throw new AuraHandledException(e.getMessage());
		}
	}

    @AuraEnabled(Cacheable=true)
	public static List<Task> getTasks(){		
		try{

			Task_Selector taskSelector = (Task_Selector)Application.selector.newInstance(Task.SObjectType);
			return taskSelector.selectTodaysTasks();
		}
		catch(Exception e){
			throw new AuraHandledException(e.getMessage());
		}
	}
}