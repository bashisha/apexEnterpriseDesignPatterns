public with sharing class Help_Desk_Marketing_Service_Impl implements Help_Desk_Interface
{
	public List<Case> setupMilestones(){
		System.debug('Ran the Marketing Milestone setup');
		return new List<Case>();
	}

	public List<Case> stopMilestones(){
		System.debug('Ran the Marketing Milestone stopper');
		return new List<Case>();
	}
}