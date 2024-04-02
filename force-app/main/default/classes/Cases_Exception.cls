public with sharing class Cases_Exception extends Exception
{
	public override String getMessage(){
		return 'All cases must have contacts associated with them';
	}
}