/**
 * @Author: Bernie Shishaye
 * @Create Time: 2024-04-01 15:30:41
 * @Modified by: Bernie Shishaye
 * @Modified time: 2024-04-01 15:40:17
 * @Description:
 */

public inherited sharing class Contact_Selector extends fflib_SObjectSelector
{
	public Contact_Selector(){
		super(false, true, true, false);
	}

	public List<Schema.SObjectField> getSObjectFieldList(){
		return new List<Schema.SObjectField>{
				Contact.Id,
				Contact.Name,
				Contact.FirstName,
				Contact.LastName
		};
	}

	public Schema.SObjectType getSObjectType(){
		return Contact.SObjectType;
	}

	public List<Contact> selectById(Set<Id> contactIds){
		return (List<Contact>) selectSObjectsById(contactIds);
	}
}