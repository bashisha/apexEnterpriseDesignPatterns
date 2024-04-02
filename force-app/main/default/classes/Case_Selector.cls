/**
 * @Author: Bernie Shishaye
 * @Create Time: 2024-04-01 15:18:08
 * @Modified by: Bernie Shishaye
 * @Modified time: 2024-04-01 15:47:46
 * @Description:
 */

public inherited sharing class Case_Selector extends fflib_SObjectSelector implements Task_Selector_Interface
{
	//This sets the base fields that you will ALWAYS have in your queries when calling this selector class
	public List<Schema.SObjectField> getSObjectFieldList(){
		return new List<Schema.SObjectField>{
			Case.Id,
			Case.Subject,
			Case.Status,
			Case.ContactId
		};
	}

	//This will return your object type for this selector, useful in abstractions
	public Schema.SObjectType getSObjectType(){
		return Case.SObjectType;
	}

	//This method calls the fflib_SObjectSelector classes selectSObjectsById method and returns a list
	//of cases from the caseIds you sent in with the default fields declared in the getSObjectFieldList method above
	public List<Case> selectById(Set<Id> caseIds){
		return (List<Case>) selectSObjectsById(caseIds);
	}

	//This uses the fflib_SObjectSelector class's QueryFactory inner class to create a custom query with
	//extra fields selected and conditions set
	public List<Case> selectCaseByAccount(Set<Id> acctIds){
		return (List<Case>) Database.query(
			newQueryFactory().
					selectField(Case.AccountId).
					setCondition('AccountId IN :acctIds').
					toSOQL()
		);
	}

	//This allows us to select all new cases in the system using the QueryFactory in fflib_SObjectSelector
	public List<Case> selectNewCases(){
		return (List<Case>) Database.query(newQueryFactory().
				setCondition('Status = \'New\'').setLimit(1000).subselectQuery(Contact.SObjectType).
				toSOQL());
	}

	//This method HAS TO BE IMPLEMENTED since we are implementing the Task_Selector_Interface in this class
	//It queries for records and adds fields specific for this query
	public List<Case> selectRecordsForTasks()
	{
		return (List<SObject>) Database.query(
				newQueryFactory().
						selectField(Case.Origin).
						toSOQL()
		);
	}

	public List<Case> innerQueryExample(){
		fflib_QueryFactory caseQueryFactory = newQueryFactory();
		fflib_QueryFactory taskSubSelectQuery = new Task_Selector().addQueryFactorySubselect(caseQueryFactory);
		System.debug('This is the query ::: ' + caseQueryFactory.toSOQL());
		return (List<Case>) Database.query(caseQueryFactory.toSOQL());
	}
}