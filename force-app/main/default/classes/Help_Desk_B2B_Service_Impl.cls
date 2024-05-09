/**
 * @Author: Bernie Shishaye
 * @Create Time: 2024-04-01 16:04:58
 * @Modified by: Bernie Shishaye
 * @Modified time: 2024-04-01 16:05:14
 * @Description:
 */


public with sharing class Help_Desk_B2B_Service_Impl implements Help_Desk_Interface
{
	public List<Case> setupMilestones(){
		System.debug('Ran the B2B Milestone setup');
		return new List<Case>();
	}

	public List<Case> stopMilestones(){
		System.debug('Ran the B2B Milestone stopper');
		return new List<Case>();
	}
}