public without sharing class CodeCoverageHelper {

    
    @future(callout=true)
    public static void emailCoverageSummary(){
        String htmlBody = '';

        //get the body and attachment for 2 scenarios 
        htmlBody    = htmlBody + generateCoverageAggregateReport();
        htmlBody    = htmlBody + generateTestMethodSummary();
        
        //get the sandbox name from the username
        list<string> userAttributes = userinfo.getUserName().split('\\.');        
        String sandboxName = 'Dev';

        //get the email address
        List<String> emailAddresses =  getEmailAddresses();

        //send the email with body and attachments
        if(emailAddresses!=null && emailAddresses.size()>0){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(emailAddresses);
            mail.setSubject('Test Class Execution Summary on: '+sandboxName.toUpperCase());
            mail.setHtmlBody(htmlBody );
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }        
    }

   
    public static string generateTestMethodSummary(){
        String htmlBody = '';
        List<ApexTestResult> apexTestResults= [SELECT Id, 
                                                      ApexClass.Name, 
                                                      MethodName, 
                                                      Message, 
                                                      StackTrace, 
                                                      ApexLogId, 
                                                      RunTime, 
                                                      Outcome, 
                                                      SystemModstamp, 
                                                      TestTimestamp, 
                                                      AsyncApexJobId, 
                                                      QueueItemId, 
                                                      ApexTestRunResultId 
                                               FROM ApexTestResult 
                                               WHERE SystemModstamp = today 
                                               ORDER BY ApexClass.Name ASC];
        
        List<ApexTestResult> passedApexTestResults = new List<ApexTestResult>();
        List<ApexTestResult> failedApexTestResults = new List<ApexTestResult>();        
        for(ApexTestResult atr:apexTestResults){
            if(atr!=null && String.isnotBlank(atr.Outcome) && atr.outcome.equalsIgnoreCase('Pass')){
                passedApexTestResults.add(atr);
            }else{
                failedApexTestResults.add(atr);                
            }
        }
        htmlBody += '<br/><br/>';
        htmlBody += 'Below is status on the Test Methods Execution. <br/><br/>';
        htmlBody += 'Total Passed Test Methods : <b>'+ passedApexTestResults.size() +'</b> <br/>';
        htmlBody += 'Total Failed Test Methods : <b style="color:red">'+ failedApexTestResults.size() +'</b>. <br/><br/>';
        
        String docBody = '';
        if(failedApexTestResults.size()>0){
            htmlBody += '<br/><br/>';
            htmlBody += '<table border="1"><tr><th>Apex Class</th><th>Method Name</th><th>Message</th><th>StackTrace</th><th>Outcome</th></tr>';
        }
        for(ApexTestResult atr:failedApexTestResults){
            htmlBody += '<tr><td>'+atr.ApexClass.Name+'</td><td>'+atr.MethodName+'</td><td>'+atr.Message+'</td><td>'+atr.StackTrace+'</td><td>'+atr.Outcome+'</td></tr>';
        }
        
        htmlBody += '</table>';
        htmlBody += '<br/><br/>';
        htmlBody += 'Automation'; 
        return htmlBody;       
    }

   
    public static string generateCoverageAggregateReport(){
        String htmlBody = '';
        HttpRequest req = new HttpRequest();
       // String baseUrl = 'callout:ToolingAPI/services/data/v50.0/tooling/';
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint('https://mats-cms-ccrms--idrdev.sandbox.my.salesforce.com/services/data/v58.0/tooling/'+'query/?q=SELECT+ApexClassOrTrigger.Name,+NumLinesCovered,+NumLinesUncovered+FROM+ApexCodeCoverageAggregate+Order+By+SystemModStamp+Desc+LIMIT+200');
        req.setMethod('GET');
        
        Http h = new Http();
        HttpResponse res = h.send(req);
        system.debug('res '+res);
        string response ='didnt set yet';
        if (res.getStatusCode() != 201) {
            response  = res.getBody();
            System.debug('response '+response);
        }        
        
        Decimal baseCoverage = 90;        
        Integer totalOrgCovered = 0;
        Integer totalOrgLines = 0;

        htmlBody += 'Hello Team,<br/><br/>';
        htmlBody += 'Below is summary of the Test Classes which have less than recommended <b>'+baseCoverage+'%</b> coverage. You would also see the methods failing as you scroll down this list.<br/><br/>';
        
        CodeCoverageAggregate myObject = (CodeCoverageAggregate) JSON.deserialize(response, CodeCoverageAggregate.class);
        if(myObject !=null){
            
            List<CodeCoverageAggregate.Records> recordList = myObject.records;
            recordList.sort();
            
            for(CodeCoverageAggregate.Records record: recordList){
                totalOrgCovered += record.numLinesCovered;
                totalOrgLines += record.totalLines;
            }
            Double orgCoverage = (totalOrgCovered * 100)/totalOrgLines;
            htmlBody += 'Your sandbox Code Coverage is at <b style="color:red">'+orgCoverage+'%.</b> <br/><br/>';
            htmlBody += 'Please take appropriate action.<br/><br/>';
            htmlBody += '<table border="1"><tr><th>Class Name</th><th># Of Lines Covered</th><th># of Lines Uncovered</th><th>Total Lines</th><th>% Covered</th></tr>';
            
            for(CodeCoverageAggregate.Records record: recordList){
                system.debug(record.ApexClassOrTrigger.Name+' - '+record.numLinesCovered);
                totalOrgCovered += record.numLinesCovered;
                totalOrgLines += record.totalLines;
                Integer totalLines = record.totalLines;
                if(totalLines==0 || record.percCovered >= baseCoverage){
                    continue;
                }
                Double percCovered = record.percCovered;//((record.NumLinesCovered*100)/totalLines);
                htmlBody += '<tr><td>'+record.ApexClassOrTrigger.Name+'</td><td>'+record.NumLinesCovered+'</td><td>'+record.NumLinesUncovered+'</td><td>'+totalLines+'</td><td>'+percCovered+'%</td></tr>';
            }
            
            htmlBody += '</table>';
        }
        return htmlBody;  
    } 

    
    public static void runLocalTests(){
        String jobId;
        ApexClass[] testClasses = [SELECT Id, NamespacePrefix, Name, Status, IsValid 
                                   FROM ApexClass 
                                   WHERE Name LIKE '%Test%' and Name like '%IDR%' and NamespacePrefix = null];
        
        if (testClasses.size() > 0) {
            ApexTestQueueItem[] queueItems = new List<ApexTestQueueItem>();
            for (ApexClass cls : testClasses) {
                queueItems.add(new ApexTestQueueItem(ApexClassId=cls.Id));
            }
            if(!Test.isRunningTest() && queueItems!=null && queueItems.size()>0){
                insert queueItems;            
                // Get the job ID of the first queue item returned.
                ApexTestQueueItem item = [SELECT ParentJobId FROM ApexTestQueueItem 
                                        WHERE Id=:queueItems[0].Id LIMIT 1];
                jobId =  item.parentjobid;                  
            }   
        }
    }
 
    private static List<String> getEmailAddresses() {       
        List<String> mailToAddresses = new List<String>{'bernie.shishaye@gdit.com'};   
             
        return mailToAddresses;        
    }
        

}