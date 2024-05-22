/**
 * @Author: Bernie Shishaye
 * @Create Time: 2024-04-19 13:08:12
 * @Modified by: Bernie Shishaye
 * @Modified time: 2024-05-22 18:02:00
 * @Description:
 */


public class Batch_AutoDeactivateUsers implements Database.Batchable<SObject>, Schedulable, Database.Stateful {
    Integer usrProcessesedCount = 0;
    Integer usrDeactivatedCount = 0;        
    private static IDR_SystemLogger logger = new IDR_SystemLogger('IDR_BATCH_JOB','Batch_AutoDeactivateUsers');

    public Database.QueryLocator start(Database.BatchableContext bc) {
        integer lastLoginDays = 60; //TODO: put this in config        
        String queryString = 'SELECT Id, Name,LastLoginDate,CreatedDate FROM User WHERE IsActive=true  ';
        if(!Test.isRunningTest()){            
            queryString = queryString+' AND  (LastLoginDate < Last_N_Days:'+lastLoginDays+'  OR LastLoginDate = null) AND CreatedDate < Last_90_Days ORDER BY LastLoginDate ASC NULLS FIRST,CreatedDate ASC LIMIT 200 ';
        }
        else {
            queryString = queryString+' ORDER BY CreatedDate DESC, LastModifiedDate DESC LIMIT 20 ';
        }        
        return Database.getQueryLocator(queryString);
    }

    public void execute(SchedulableContext sc) {
        Batch_AutoDeactivateUsers b = new Batch_AutoDeactivateUsers();
        Database.ExecuteBatch(b, 20);
    }

    public void execute(Database.BatchableContext bc, List<User> userList) {        
        List<PermissionSetAssignment> psaList = new List<PermissionSetAssignment>();
        List<PermissionSetLicenseAssign> pslList = new List<PermissionSetLicenseAssign>();            
        String errorMessage;
        String errorRecordId;
        
        //get permissionset assignments for AFTR_Baseline & FinancialServicesCloudStandard to the Users passed in scope of this batch and delete assignments before deactivating them
        psaList = [SELECT Id, PermissionSet.Name from PermissionSetAssignment WHERE AssigneeId IN :userList AND  PermissionSet.Name IN ('AFTR_Baseline','FinancialServicesCloudStandard')];
        
        if(psaList.size()>0){
            Database.DeleteResult[] deletePsaResult = Database.delete(psaList, false);
            for(Database.DeleteResult dr : deletePsaResult) {
                if (dr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully deleted PermissionSetAssignment with ID: ' + dr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : dr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('PermissionSetAssignment fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }
        
        //Get all permissionset licenses assigned to the Users passed in scope of this batch and delete license assignments before deactivating them
        pslList = [SELECT Id FROM PermissionSetLicenseAssign WHERE AssigneeId in :UserList];
        
        if(pslList.size() > 0){
            Database.DeleteResult[] deletePslResult = Database.delete(pslList, false);
            for(Database.DeleteResult dr : deletePslResult) {
                if (dr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully deleted PermissionSetLicenseAssign with ID: ' + dr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : dr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('PermissionSetLicenseAssign fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }

        //Now as we have removed all assignments from the user we can deactivate them
        for(User usr : UserList) {
            usr.IsActive = false;            
        }        
        usrProcessesedCount += UserList.size(); 
        
        if(UserList.size() > 0){            
            Database.SaveResult[] saveResultUser = Database.update(UserList,false);
            Boolean isDeactivationAllSuccess = logger.isSuccess(saveResultUser, 'deactivation');
            if(!isDeactivationAllSuccess){
                logger.insertLogs();
            }
            for(Integer i = 0; i < saveResultUser.size(); i++){ 
                if(saveResultUser[i].isSuccess()){
                    usrDeactivatedCount++;
                }
            }
        }
    }

    public void finish(Database.BatchableContext bc) {
      
        AsyncApexJob apexJob = [Select Id, Status,ExtendedStatus,NumberOfErrors, JobItemsProcessed,
                          TotalJobItems, CreatedBy.Email
                          from AsyncApexJob where Id =:bc.getJobId()];
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                 
            String[] toAddresses = new List<String>{'bernie.shishaye@gdit.com'};//TODO: put in config
            mail.setToAddresses(toAddresses);
            mail.setSubject('Batch_AutoDeactivateUsers ' + apexJob.Status);
            mail.setHtmlBody('Batch_AutoDeactivateUsers apex job processed ' + apexJob.TotalJobItems +
                              ' batches with '+ apexJob.NumberOfErrors + ' failures.'  + '\n\n' +
                              'Total ' + usrDeactivatedCount +' users were deactivated successfully out of '+ 
                               usrProcessesedCount + ' users processed for deactivation.');
          if (!Test.isRunningTest()) {    
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
          }
        

    }


}