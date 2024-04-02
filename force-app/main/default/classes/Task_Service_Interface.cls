/**
 * @Author: Bernie Shishaye
 * @Create Time: 2024-03-28 10:28:36
 * @Modified by: Bernie Shishaye
 * @Modified time: 2024-04-01 23:55:58
 * @Description:
 */

public interface Task_Service_Interface
{
	void createTasks(Set<Id> recordIds, Schema.SObjectType objectType);
}