public class Access_Code_Controller {

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PAGE REFERENCES  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    public static final String PAGE_WELCOME                     = URL.getSalesforceBaseUrl().toExternalForm() + '/CDOMaintenance/CDO_Maintenance_Login';
    public static final String PAGE_CREATE_ACCESS_CODE          = '/apex/User_Maintenance_CreateAccessCode';
    public static final String PAGE_CREATE_ACCESS_CODE_EXTERNAL = URL.getSalesforceBaseUrl().toExternalForm() + '/UserMaintenance/User_Maintenance_CreateAccessCode';
    public static final String PAGE_ACCESS_CODE_CREATED         = '/apex/User_Maintenance_CreateAccessCodeConfirm';
    public static final String PAGE_FORGOT_ACCESS_CODE          = '/apex/UserMaintenance/User_Maintenance_ForgotAccessCode';
    public static final String PAGE_FORGOT_ACCESS_CODE_EXTERNAL = URL.getSalesforceBaseUrl().toExternalForm() + '/UserMaintenance/User_Maintenance_ForgotAccessCode';
    public static final String PAGE_RESET_ACCESS_CODE           = '/apex/UserMaintenance/User_Maintenance_ResetAccessCode';
    public static final String PAGE_ACCESS_CODE_RESET           = '/apex/UserMaintenance/User_Maintenance_ResetAccessCodeConfirm';

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    //~~~~~~~~~~~~~~~~~~~~~~~~~~ ERROR MESSAGE STATICS  ~~~~~~~~~~~~~~~~~~~~~~~~~~//
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    public transient String ac_err_msg1 {get; set;}
    public transient String ac_err_msg2 {get; set;}
    private static final String ERR_REQUIRED_FIELD = 'This is a required field.';
    private static final String ERR_validLogin = 'Please enter a valid Login ID/Access Code.';
    private static final String ERR_orgDeactivated = 'The Organization associated with the login ID you have provided is deactivated. If you have questions, please contact us at CACQuestions@cms.hhs.gov.';
    private static final String ERR_contactInactive = 'The login ID you have provided is inactive. Please enter a valid login ID. If you have questions, please contact us at CACQuestions@cms.hhs.gov.';
    private static final String ERR_CONFIRM_ACCESS_CODE = 'Please enter and confirm the Access Code.';
    private static final String ERR_ACCESS_CODE_REQ = 'You must meet all the Access Code Requirements above.';
    private static final String ERR_ACCESS_CODE_MATCH = 'Create Access Code and Confirm Access Code must match.';
    private static final String ERR_ACCESS_CODE_MATCH_RESET = 'New Access Code and Confirm Access Code must match.';
    private static final String ERR_INVALID_CHAR = 'Field includes an invalid character.';
    private static final String ERR_INVALID_EMAIL = 'Invalid email address.';
    private static final String ERR_NOT_CEO_DES = 'The Email Address provided is not associated with a company.';
    private static final String ERR_NOT_IN_ROLE = 'You are not in a role that has permission to access this web form.';
    private static final String ERR_CONTACT_INACTIVE = 'The Email Address provided is inactive please enter a valid Email Address to access this web form. If you have questions, please contact us at CACQuestions@cms.hhs.gov.';
    private static final String ERR_NO_LONGER_CEO_DES = 'You are no longer in a role that has access to complete this web form for your company.';
    private static final String ERR_ACCESS_CODE_EXISTS = 'Our records indicate that you have already created your Access code. Please select Back to return to the Login page. If you do not remember your Login information, please reset your Access Code or contact <a href="mailto:cacquestions@cms.hhs.gov">cacquestions@cms.hhs.gov</a> for assistance.';
    private static final String ERR_NO_ACCESS_CODE_EXISTS = 'Our records indicate that an Access Code was never created. Please select <b>Back</b> and select <b>Create Access Code</b>.';
    private static final String ERR_INVALID_SEC_QUEST_ANS = 'Invalid Security Question Answer. If you forgot the answer to the security question, please contact <a href="mailto:cacquestions@cms.hhs.gov">cacquestions@cms.hhs.gov</a> for assistance.';
    private static final String ERR_EMAIL_NOTICE = 'A PIN will be sent to the email address you entered if it matches the current email address on file. If you do not receive the PIN, please verify the email entered and try again.';
    private static final String ERR_INVALID_PIN = 'Enter a valid six-digit PIN.';
    private static final String ERR_PIN_EXPIRED = 'Your PIN is expired. Please request a new PIN by selecting the <b>Send PIN</b> button.';
    //private static final String ERR_USER_LOCKED = 'NEED A VALID ERROR MESSAGE FOR THE USER LOCKED CONDITION!!!!';
    private static final String ERR_MULTIPLE_USERS = 'An error occurred while attempting to identify your account, please contact <a href="mailto:cacquestions@cms.hhs.gov">cacquestions@cms.hhs.gov</a> for assistance.';
    private static final String ERR_MULTIPLE_COMPANIES = 'An error occurred while attempting to identify your company, please contact <a href="mailto:cacquestions@cms.hhs.gov">cacquestions@cms.hhs.gov</a> for assistance.';
    private static final String ERR_PANIC_CREATE_AC = 'An error occurred while attempting to create your Access Code, please contact <a href="mailto:cacquestions@cms.hhs.gov">cacquestions@cms.hhs.gov</a> for assistance.';
    private static final String ERR_PANIC_RESET_AC = 'An error occurred while attempting to reset your Access Code, please contact <a href="mailto:cacquestions@cms.hhs.gov">cacquestions@cms.hhs.gov</a> for assistance.';
    private static final String ERR_PANIC_CREATE_PIN = 'An error occurred while attempting to create your PIN, please contact <a href="mailto:cacquestions@cms.hhs.gov">cacquestions@cms.hhs.gov</a> for assistance.';
    
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ OTHER CONSTANTS  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    private static final Integer MIN_PSWD_LEN = 8;
    private static final Integer MAX_PSWD_LEN = 12;
    private static final Integer PIN_LENGTH = 6;
    private static final Integer PIN_EXP_DAYS = 1;

    private final static String TITLE_EXIT = 'Select this button to exit the web form. All information you have entered up to this point will be lost and the session will close. Select Continue to proceed with your session. Use the original link you were provided to return to the web form. You will be required to enter the Organization Senior Official, CAC Project Director, or Secondary Contact email address and the Access Code you created.';
    //private final static String TITLE_CONTINUE = 'Select this button to exit the web form. Select OK to clear the page and end the session. Select Cancel to continue your session. Use the original link you were provided to return to the web form.';
    private final static String TITLE_CONTINUE = 'Select this button to advance to the next page of the web form.';
    private final static String TITLE_BACK = 'Select this button to return to the previous page of the web form.';

    private final static String RESET_PIN_TEMPLATE = 'Reset_Access_Code';
    //private final static String ORG_WIDE_EMAIL_ID = '0D2t0000000Kykx';

    public Contact spoofContact {get; set;}
    public Contact publicContact {get; set;}
    public transient String inputAccessCodeConfirm {get; set;}
    private Contact dbContact {get; set;}
    public Contact con {get;set;}

    public final static Set<String> cdoPrimaryRoles = new Set<String>{'CAC Project Director','Organization Senior Official','Secondary Contact'};

    public Access_Code_Controller() {
        spoofContact = new Contact();
    }
    
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    //~~~~~~~~~~~~~~~~~~~~~~~~~ START NAVIGATION METHODS ~~~~~~~~~~~~~~~~~~~~~~~~~//
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    public PageReference navigateToLoginPage() {
        spoofContact = new Contact();
        return new PageReference(PAGE_WELCOME);
    }

    public PageReference homeCreateAccessCode() {

        return new PageReference(PAGE_CREATE_ACCESS_CODE_EXTERNAL);
    }
    
    public PageReference homeForgotAccessCode() {

        return new PageReference(PAGE_FORGOT_ACCESS_CODE_EXTERNAL);
    }
    
    public PageReference createAccessCodeContinue() {
        if( !( newAccessCodeCreated() ) ) {
            return null;
        }
        return new PageReference( PAGE_ACCESS_CODE_CREATED );
    }

    public PageReference forgotAccessCodeContinue() {
        if( !( validPIN() ) ) {
            return null;
        }
        return new PageReference( PAGE_RESET_ACCESS_CODE );
    }
    
    public PageReference resetAccessCodeContinue() {
        if( !( resetAccessCodeCreated() ) ) {
            return null;
        }
        return new PageReference( PAGE_ACCESS_CODE_RESET );
    }

    public PageReference resetAccessCodeBack() {
        PageReference returnPage = new PageReference( PAGE_FORGOT_ACCESS_CODE );
        returnPage.setRedirect( true );
        return returnPage;
    }

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    //~~~~~~~~~~~~~~~~~~~~~~~~~~ END NAVIGATION METHODS ~~~~~~~~~~~~~~~~~~~~~~~~~~//
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//


    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    //~~~~~~~~~~~~~~~~~~~ START ACCESS CODE VALIDATION METHODS ~~~~~~~~~~~~~~~~~~~//
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    private Boolean newAccessCodeCreated() {
        Contact updateContact = null;
        // Confirm all fields on Create Access Code are populated.
        if( !( createAccessCodeFieldsPopulated() ) ) {
            return false;
        }

        // Confirm all fields on Create Access Code are valid.
        if( !( createAccessCodeFieldsValid() ) ) {
            return false;
        }

        List<CDO_Contact_Junction_Object__c> junctions = null;
        // Get a list of all Contact Junction Objects for given Email address.
        junctions = getJunctionsForEmail( spoofContact.Email );
        if( junctions == null || junctions.size() == 0 ) {
            PageMessages.addMessage( new PageMessages.PageMessage( PageMessages.Severity.FATAL, ERR_NOT_CEO_DES ) );
            return false;
        }
        else if(junctions.size() > 0) {
            Boolean activeOrgExists = false;
            Boolean inactiveOrgExists = false;
            Boolean appRevoked = false;
            for(CDO_Contact_Junction_Object__c j:junctions){
                if (j.Status__c == 'Active' || j.Status__c == 'Pending') {
                    activeOrgExists = true;
                    break;
                }
                else if(j.Status__c=='Inactive'){
                    inactiveOrgExists = true;
                    if(j.Organization__r.Application_Revoked__c){
                        appRevoked = true;
                    }
                }
            }

            if (!activeOrgExists && inactiveOrgExists) {
                if (appRevoked) {
                    PageMessages.clearMessages();
                    PageMessages.addMessage(new PageMessages.Pagemessage(PageMessages.Severity.FATAL, ERR_orgDeactivated));
                    return false;
                }
                PageMessages.clearMessages();
                PageMessages.addMessage(new PageMessages.Pagemessage(PageMessages.Severity.FATAL, ERR_CONTACT_INACTIVE));
                return false;
            }
        }
        // Reduce that list to only the CAC Project Director and Organization Senior Official.
        /*  junctions = getEligibleJunctionsFromList( junctions );
          if( junctions == null || junctions.size() == 0 ) {
              PageMessages.addMessage( new PageMessages.PageMessage( PageMessages.Severity.FATAL, ERR_NOT_IN_ROLE ) );
              return false;
          }

          junctions = confirmActivePeriod( junctions );
          if( junctions == null || junctions.size() == 0 ) {
              PageMessages.addMessage( new PageMessages.PageMessage( PageMessages.Severity.FATAL, ERR_NOT_IN_ROLE ) );
              return false;
          }*/
        // Get the Active CAC Project Director or Organization Senior Official - this is the contact for which we are adding access code.
        updateContact = getActiveContact( spoofContact.Email );
        if( updateContact == null ) {
            PageMessages.clearMessages();
            PageMessages.addMessage( new PageMessages.Pagemessage( PageMessages.Severity.FATAL, ERR_PANIC_CREATE_AC ) );
            return false;
        }
        // Confirm does not have access code.
        if( hasAccessCode( updateContact ) ) {
            PageMessages.addMessage( new PageMessages.PageMessage( PageMessages.Severity.FATAL, ERR_ACCESS_CODE_EXISTS ) );
            return false;
        }
        updateContact = updateContactCreateAccessCode( updateContact );

        Database.SaveResult dsr = System.Database.update( updateContact );
        if( !( dsr.isSuccess() ) ) {
            PageMessages.addMessage( new PageMessages.PageMessage( PageMessages.Severity.FATAL, ERR_PANIC_CREATE_AC));
            return false;
        }
        return true;
    }
    
    private Boolean resetAccessCodeCreated() {
        Contact updateContact = null;
        // Confirm all fields on Create Access Code are populated.
        if( !( resetAccessCodeFieldsPopulated() ) ) {
            return false;
        }

        // Confirm all fields on Create Access Code are valid.
        if( !( resetAccessCodeFieldsValid() ) ) {
            return false;
        }

        // Get the Active CEO Designate or Alternate - this is the contact for which we are adding access code.
        updateContact = getActiveContact( spoofContact.Email );
        if( updateContact == null ) {
            return false;
        }
        
        if( !( spoofContact.Security_Answer_1__c.equalsIgnoreCase( updateContact.Security_Answer_1__c ) ) || !( spoofContact.Security_Answer_2__c.equalsIgnoreCase( updateContact.Security_Answer_2__c ) ) ) {
            PageMessages.addMessage( new PageMessages.PageMessage( PageMessages.Severity.FATAL, ERR_INVALID_SEC_QUEST_ANS ));
            return false;
        }

        updateContact = updateContactAccessCode( updateContact );
        
        Database.SaveResult dsr = System.Database.update( updateContact );
        if( !( dsr.isSuccess() ) ) {
            PageMessages.addMessage( new PageMessages.PageMessage( PageMessages.Severity.FATAL, ERR_PANIC_RESET_AC));
            return false;
        }
        return true;
    }

    public Boolean validLogin() {
        // Confirm all fields on Create Access Code are populated.
        if( !( loginCodeFieldsPopulated() ) ) {
            return false;
        }

        List<CDO_Contact_Junction_Object__c> junctions = null;
        junctions = getJunctionsForEmail( spoofContact.Email );
        if( junctions.size() == 0 ) {
            PageMessages.clearMessages();
            PageMessages.addMessage( new PageMessages.Pagemessage( PageMessages.Severity.FATAL, ERR_validLogin ) );
            return false;

        }
        else if(junctions.size() > 0) {
            Boolean activeOrgExists = false;
            Boolean inactiveOrgExists = false;
            Boolean appRevoked = false;
            for(CDO_Contact_Junction_Object__c j:junctions){
                if (j.Status__c == 'Active' || j.Status__c == 'Pending') {
                    activeOrgExists = true;
                    break;
                }
                else if(j.Status__c=='Inactive'){
                    inactiveOrgExists = true;
                    if(j.Organization__r.Application_Revoked__c){
                        appRevoked = true;
                    }
                }
            }

            if (!activeOrgExists && inactiveOrgExists) {
                if (appRevoked) {
                    PageMessages.clearMessages();
                    PageMessages.addMessage(new PageMessages.Pagemessage(PageMessages.Severity.FATAL, ERR_orgDeactivated));
                    return false;
                }
                PageMessages.clearMessages();
                PageMessages.addMessage(new PageMessages.Pagemessage(PageMessages.Severity.FATAL, ERR_contactInactive));
                return false;
            }
        }
        
        dbContact = getActiveContact( spoofContact.Email );
        if( dbContact == null ) {
            PageMessages.clearMessages();
            PageMessages.addMessage( new PageMessages.Pagemessage( PageMessages.Severity.FATAL, ERR_NO_LONGER_CEO_DES ) );
            return false;
        }
        // Confirm does not have access code.
        if( !( hasAccessCode( dbContact ) ) ) {
            PageMessages.addMessage( new PageMessages.PageMessage( PageMessages.Severity.FATAL, ERR_validLogin ) );
            return false;
        }
        
        if( !( Static_Methods_Fields.validatePassword( spoofContact.Access_Code__c, dbContact.Access_Code__c, dbContact.Access_Code_Salt__c ) ) ) {
            PageMessages.addMessage( new PageMessages.PageMessage( PageMessages.Severity.FATAL, ERR_validLogin ) );
            return false;
        }
        con = dbContact;
        return true;
    }

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    //~~~~~~~~~~~~~~~~~~~~ END ACCESS CODE VALIDATION METHODS ~~~~~~~~~~~~~~~~~~~~//
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    //~~~~~~~~~~~~~~~~~~~~~~ START FORGOT PASSWORD METHODS  ~~~~~~~~~~~~~~~~~~~~~~//
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    private Boolean validPIN() {
        publicContact = null;
        // Confirm all fields on Create Access Code are populated.
        if( !( forgotCodeFieldsPopulated() ) ) {
            return false;
        }
        
        dbContact = getActiveContact( spoofContact.Email );
        if( dbContact == null ) {
            PageMessages.clearMessages();
            PageMessages.addMessage( new PageMessages.PageMessage( PageMessages.Severity.FATAL, ERR_INVALID_PIN ) );
            return false;
        }

        if( !( dbContact.Contact_Created_Access_Code__c ) ) {
            PageMessages.addMessage( new PageMessages.Pagemessage( PageMessages.Severity.FATAL, ERR_NO_ACCESS_CODE_EXISTS) );
            return false;
        }

        if( spoofContact.PIN__c != dbContact.PIN__c ) {
            PageMessages.addMessage( new PageMessages.PageMessage( PageMessages.Severity.FATAL, ERR_INVALID_PIN ) );
            return false;
        }

        // Confirm does not have access code.
        if( !( Static_Methods_Fields.notBlank( dbContact.PIN__c ) ) || dbContact.PIN_Expiration_Timestamp__c < DateTime.now() ) {
            PageMessages.addMessage( new PageMessages.PageMessage( PageMessages.Severity.FATAL, ERR_PIN_EXPIRED ) );
            return false;
        }
        publicContact = dbContact.clone(false, true, false, false);
        return true;
    }

    public PageReference pinRequest() {
        Contact updateContact = null;
        // Confirm all fields on Create Access Code are populated.
        if( !( pinRequestFieldsPopulated() ) ) {
            return null;
        }

        updateContact = getActiveContact( spoofContact.Email );
        if( updateContact == null ) {
            PageMessages.clearMessages();
            PageMessages.addMessage( new PageMessages.Pagemessage( PageMessages.Severity.FATAL, ERR_EMAIL_NOTICE ) );
            return null;
        } else if( !( hasAccessCode( updateContact ) ) ) {
            PageMessages.addMessage( new PageMessages.PageMessage( PageMessages.Severity.FATAL, ERR_NO_ACCESS_CODE_EXISTS ) );
            return null;
        }

        updateContact = updatePinCode( updateContact );
        List<Messaging.SingleEmailMessage> msg = new List<Messaging.SingleEmailMessage>();
        msg.add( getResetPINEmail( updateContact ) );
        List<Messaging.SendEmailResult> ser = Messaging.sendEmail( msg );
        if( !( ser[0].isSuccess() ) ) {
        }
        
        Database.SaveResult dsr = System.Database.update( updateContact );
        if( !( dsr.isSuccess() ) ) {
            PageMessages.addMessage( new PageMessages.PageMessage( PageMessages.Severity.FATAL, ERR_PANIC_CREATE_PIN));
            return null;
        }
       PageMessages.addMessage( new PageMessages.PageMessage( PageMessages.Severity.FATAL, ERR_EMAIL_NOTICE));
       return null;
    }

    public static Messaging.SingleEmailMessage getResetPINEmail( Contact updateContact ){
        EmailTemplate template = getEmailTemplate(RESET_PIN_TEMPLATE);
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        
        String body = template.HtmlValue.replace('<PIN>', updateContact.PIN__c);
        
        msg.setToAddresses(new List<String>{updateContact.Email});
        msg.setSaveAsActivity(true);
        msg.setSubject(template.Subject);
        msg.setTemplateId( template.Id );
        msg.setHTMLBody(body);
        msg.setTargetObjectId(updateContact.ID);
        msg.setOrgWideEmailAddressId(CDO_Static_Methods.getOrgWideEmailId());

        return msg;
    }

    private static EmailTemplate getEmailTemplate ( String templateName ){
        List<EmailTemplate> templates = [SELECT Id, Name, DeveloperName, Subject, HtmlValue, Body
                                         FROM EmailTemplate
                                         WHERE DeveloperName = :templateName];
        
        return templates[0];
    }

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    //~~~~~~~~~~~~~~~~~~~~~~~ END FORGOT PASSWORD METHODS  ~~~~~~~~~~~~~~~~~~~~~~~//
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    //~~~~~~~~~~~~~~~~~~~~~~ START FIELD VALIDATION METHODS ~~~~~~~~~~~~~~~~~~~~~~//
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    private Boolean createAccessCodeFieldsPopulated() {
        Boolean noError = true;
        noError = userIdPopulated() && noError;
        noError = accessCodesPopulated() && noError;
        noError = securityQuestionsPopulated() && noError;
        noError = securityAnswersPopulated() && noError;
        return noError;
    }

    private Boolean loginCodeFieldsPopulated() {
        Boolean noError = true;
        noError = userIdPopulated() && noError;
        noError = accessCodePopulated() && noError;
        return noError;
    }
    
    private Boolean forgotCodeFieldsPopulated() {
        Boolean noError = true;
        noError = userIdPopulated() && noError;
        noError = pinPopulated() && noError;
        return noError;
    }

    private Boolean resetAccessCodeFieldsPopulated() {
        Boolean noError = true;
        noError = userIdPopulated() && noError;
        noError = accessCodesPopulated() && noError;
        noError = securityAnswersPopulated() && noError;
        return noError;
    }

    private Boolean pinRequestFieldsPopulated() {

        return userIdPopulated(); 
    }
    
    private Boolean userIdPopulated() {
        Boolean noError = true;
        if( !( Static_Methods_Fields.notBlank( spoofContact.Email ) ) ) {
            noError = false;
            spoofContact.Email.addError( ERR_REQUIRED_FIELD );
        }
        return noError;
    }

    private Boolean pinPopulated() {
        Boolean noError = true;
        if( !( Static_Methods_Fields.notBlank( spoofContact.PIN__C ) ) ) {
            noError = false;
            spoofContact.PIN__c.addError( ERR_REQUIRED_FIELD );
        } else if( spoofContact.PIN__c.length() != PIN_LENGTH ) {
            noError = false;
            spoofContact.PIN__c.addError( ERR_INVALID_PIN );
        }
        return noError;
    }
    
    private Boolean accessCodesPopulated() {
        Boolean noError = true;
        if( !( Static_Methods_Fields.notBlank( spoofContact.Access_Code__c ) ) ) {
            noError = false;
            spoofContact.Access_Code__c.addError( ERR_CONFIRM_ACCESS_CODE );
            ac_err_msg1 = ERR_REQUIRED_FIELD;
        }
        if( !( Static_Methods_Fields.notBlank( inputAccessCodeConfirm ) ) ) {
            noError = false;
            spoofContact.Access_Code__c.addError( ERR_CONFIRM_ACCESS_CODE );
            ac_err_msg2 = ERR_REQUIRED_FIELD;
        }
        return noError;
    }

    private Boolean accessCodePopulated() {
        if( !( Static_Methods_Fields.notBlank( spoofContact.Access_Code__c ) ) ) {
            spoofContact.Access_Code__c.addError( ERR_CONFIRM_ACCESS_CODE );
            ac_err_msg1 = ERR_REQUIRED_FIELD;
            return false;
        }
        return true;
    }

    private Boolean securityQuestionsPopulated() {
        Boolean noError = true;
        if( !( Static_Methods_Fields.notBlank( spoofContact.Security_Question_1__c ) ) ) {
            noError = false;
            spoofContact.Security_Question_1__c.addError( ERR_REQUIRED_FIELD );
        }
        if( !( Static_Methods_Fields.notBlank( spoofContact.Security_Question_2__c ) ) ) {
            noError = false;
            spoofContact.Security_Question_2__c.addError( ERR_REQUIRED_FIELD );
        }
        return noError;
    }

    private Boolean securityAnswersPopulated() {
        Boolean noError = true;
        if( !( Static_Methods_Fields.notBlank( spoofContact.Security_Answer_1__c ) ) ) {
            noError = false;
            spoofContact.Security_Answer_1__c.addError( ERR_REQUIRED_FIELD );
        }
        if( !( Static_Methods_Fields.notBlank( spoofContact.Security_Answer_2__c ) ) ) {
            noError = false;
            spoofContact.Security_Answer_2__c.addError( ERR_REQUIRED_FIELD );
        }
        return noError;
    }

    private Boolean createAccessCodeFieldsValid() {
        Boolean noError = true;
        // Validate that the email address is a valid email address.
        if( !( Static_Methods_Fields.validateEmail ( spoofContact.Email ) ) ) {
            spoofContact.Email.addError( ERR_INVALID_EMAIL );
            noError = false && noError;
        }
        // Validate that password meets requirements.
        if( !( Static_Methods_Fields.validatePasswordReq( spoofContact.Access_Code__c, inputAccessCodeConfirm, MIN_PSWD_LEN, MAX_PSWD_LEN ) ) ) {
            ac_err_msg1 = ERR_ACCESS_CODE_REQ;
            ac_err_msg2 = ERR_ACCESS_CODE_REQ;
            noError = false && noError;
        }
        if( spoofContact.Access_Code__c != inputAccessCodeConfirm ) {
            ac_err_msg2 = ERR_ACCESS_CODE_MATCH;
            noError = false && noError;
        }

        if( Static_Methods_Fields.containsInvalidSpecialCharacters( spoofContact.Security_Answer_1__c ) ) {
            spoofContact.Security_Answer_1__c.addError( ERR_INVALID_CHAR  );
            noError = false && noError;
        }
        if( Static_Methods_Fields.containsInvalidSpecialCharacters( spoofContact.Security_Answer_2__c ) ) {
            spoofContact.Security_Answer_2__c.addError( ERR_INVALID_CHAR  );
            noError = false && noError;
        }
        
        return noError;
    }

    private Boolean resetAccessCodeFieldsValid() {
        Boolean noError = true;
        // Validate that the email address is a valid email address.
        if( !( Static_Methods_Fields.validateEmail ( spoofContact.Email ) ) ) {
            spoofContact.Email.addError( ERR_INVALID_EMAIL );
            noError = false && noError;
        }
        // Validate that password meets requirements.
        if( !( Static_Methods_Fields.validatePasswordReq( spoofContact.Access_Code__c, inputAccessCodeConfirm, MIN_PSWD_LEN, MAX_PSWD_LEN ) ) ) {
            ac_err_msg1 = ERR_ACCESS_CODE_REQ;
            ac_err_msg2 = ERR_ACCESS_CODE_REQ;
            noError = false && noError;
        }
        if( spoofContact.Access_Code__c != inputAccessCodeConfirm ) {
            ac_err_msg2 = ERR_ACCESS_CODE_MATCH_RESET;
            noError = false && noError;
        }
        if( Static_Methods_Fields.containsInvalidSpecialCharacters( spoofContact.Security_Answer_1__c ) ) {
            spoofContact.Security_Answer_1__c.addError( ERR_INVALID_CHAR  );
            noError = false && noError;
        }
        if( Static_Methods_Fields.containsInvalidSpecialCharacters( spoofContact.Security_Answer_2__c ) ) {
            spoofContact.Security_Answer_2__c.addError( ERR_INVALID_CHAR  );
            noError = false && noError;
        }
        
        return noError;
    }

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    //~~~~~~~~~~~~~~~~~~~~~~~ END FIELD VALIDATION METHODS ~~~~~~~~~~~~~~~~~~~~~~~//
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    //~~~~~~~~~~~~~~~~~~~~~ START CONTACT SELECTION METHODS  ~~~~~~~~~~~~~~~~~~~~~//
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

    private Contact getActiveContact( String emailAddress ) {
        List<CDO_Contact_Junction_Object__c> junctions = null;
        Id contactId = null;
        // Get a list of all Contact Junction Objects for given Email address.
        junctions = getJunctionsForEmail( emailAddress );
        // Reduce that list to only the CAC Project Director and Organization Senior Official.
        junctions = getEligibleJunctionsFromList( junctions );
        if( junctions == null || junctions.size() == 0 ) {
            PageMessages.addMessage( new PageMessages.PageMessage( PageMessages.Severity.FATAL, ERR_NOT_CEO_DES ) );
            return null;
        }
        // Reduce that list to only the Active junctions.
        junctions = confirmActivePeriod( junctions );
        if( junctions == null || junctions.size() == 0 ) {
            PageMessages.addMessage( new PageMessages.PageMessage( PageMessages.Severity.FATAL, ERR_NO_LONGER_CEO_DES ) );
            return null;
        }
        // Confirm that Active junctions all roll up to the same company!!
        if( !( confirmUniqueOrganization( junctions ) ) ) {
            PageMessages.addMessage( new PageMessages.PageMessage( PageMessages.Severity.FATAL, ERR_MULTIPLE_COMPANIES ) );
            return null;
        }
        // Get the Unique Contact ID for that remaining junctions.
        contactId = uniqueContactId( junctions );
        if(  contactId == null || String.isEmpty( contactId ) )  {
            PageMessages.addMessage( new PageMessages.PageMessage( PageMessages.Severity.FATAL, ERR_NOT_CEO_DES ) );
            return null;
        }
        // Get and return the contact for the Unique Contact ID.
        return getContactFromId( contactId );
    }
    
    /**
     * The getJunctionsForEmail method gets a List of Contact Junction Objects for a given Email Address.
     * @param emailAddress: the email address for which the junctions are desired.
     * @return the list of junctions for the given email address.
     */
    private List<CDO_Contact_Junction_Object__c> getJunctionsForEmail( String emailAddress ) {
        if( emailAddress == null || String.isBlank( emailAddress ) || String.isEmpty( emailAddress) ) {
            return null;
        }
        return [SELECT Id, Role__c, Status__c, Organization__c,Organization__r.Application_Revoked__c, Contact__c 
                FROM CDO_Contact_Junction_Object__c 
                WHERE Contact__r.Email = :emailAddress AND Role__c IN :cdoPrimaryRoles];
    }

    private List<CDO_Contact_Junction_Object__c> getActiveJunctionsForEmail( String emailAddress ) {
        if( emailAddress == null || String.isBlank( emailAddress ) || String.isEmpty( emailAddress) ) {
            return null;
        }
        return [SELECT Id, Role__c, Status__c, Organization__c,Organization__r.Application_Revoked__c, Contact__c
        FROM CDO_Contact_Junction_Object__c
        WHERE Contact__r.Email = :emailAddress AND Role__c IN :cdoPrimaryRoles AND Status__c = 'Active'];
    }

    /**
     * The confirm_ceo_designate validates that at least one Contact Junction Object is for a CEO Designate or Alternate.
     * Iterates over a list of junctions.  If the junction is for a CEO Designate or Alternate, it is added to the return list.
     * @param junctions: the List of Contact Junction Objects to be reviewed.
     * @return the list of Contact Junction Objects for a CEO Designate or Alternate.
     */ 
    private List<CDO_Contact_Junction_Object__c> getEligibleJunctionsFromList( List<CDO_Contact_Junction_Object__c> junctions ) {
        if( junctions == null || junctions.size() == 0 ) {
            return null;
        }
        
        Set<String> eligibleRoles = new Set<String>{'CAC Project Director','Organization Senior Official','Secondary Contact'};
        List<CDO_Contact_Junction_Object__c> returnJunctions = new List<CDO_Contact_Junction_Object__c>();
        
        for( CDO_Contact_Junction_Object__c junction : junctions ) {
            if( eligibleRoles.contains(junction.Role__c) ) {
                returnJunctions.add(junction);
            }
        }
        return returnJunctions;
    }

    /**
     * The confirmActivePeriod confirms that there is at least one Contact Junction Object in a provided list that is active.
     * @param junctions: the list of Contact Junction Objects to be tested.
     * @return the List of Contact_Junction_Objects with an active Period.
     */ 
    private List<CDO_Contact_Junction_Object__c> confirmActivePeriod( List<CDO_Contact_Junction_Object__c> junctions ) {
        if( junctions == null || junctions.size() == 0 ) {
            return null;
        }
        
        List<CDO_Contact_Junction_Object__c> returnJunctions = new List<CDO_Contact_Junction_Object__c>();
        
        for( CDO_Contact_Junction_Object__c junction : junctions ) {
            if( junction.Status__c == 'Active' ) {
                returnJunctions.add(junction);
            }
        }
        return returnJunctions;
    }
    
    /**
     * The uniqueContactId method confirms that only one Contact is shared between all Contact Junction Objects in a list.
     * @param junctions: the list of Contact Junction Objects to be tested.
     * @return the unique contact in the list.
     */
    private Id uniqueContactId( List<CDO_Contact_Junction_Object__c> junctions ) {
        if( junctions == null || junctions.size() == 0 ) {
            return null;
        }
        
        Id returnId = null;
        for( CDO_Contact_Junction_Object__c junction : junctions ) {
            if( returnId == null ) {
                returnId = junction.Contact__c;
            } else if ( !( returnId.equals( junction.Contact__c ) ) ){
                PageMessages.addMessage( new PageMessages.PageMessage( PageMessages.Severity.FATAL, ERR_MULTIPLE_USERS ) );
                return null;
            }
        }
        return returnId;
    }
    
    //@TODO
    private Boolean confirmUniqueOrganization( List<CDO_Contact_Junction_Object__c> junctions ) {
        return true;
    }

    /**
     * The getContactFromId method returns a Contact object queried by ID.
     * @param contactId: the sObject ID for the desired Contact Record.
     * @return the desired Contact object.
     */
    private Contact getContactFromId( Id contactId ) {
        if( contactId == null || String.isBlank( contactId ) ) {
            return null;
        }
        return [SELECT Id, FirstName, LastName, Phone, Title, Phone_Extension__c, Email, Access_Code__c, Access_Code_Salt__c, 
                    Contact_Created_Access_Code__c, PIN__c, PIN_Expiration_Timestamp__c, Prevent_Login__c, Security_Question_1__c, 
                    Security_Question_2__c, Security_Answer_1__c, Security_Answer_2__c
                FROM Contact
                WHERE Id = :contactId LIMIT 1];
    }

    private Boolean hasAccessCode( Contact cont ) {

        return cont.Contact_Created_Access_Code__c;
    }

    private Boolean isLocked( Contact cont ) {

        return cont.Prevent_Login__c;
    }

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    //~~~~~~~~~~~~~~~~~~~~~~ END CONTACT SELECTION METHODS  ~~~~~~~~~~~~~~~~~~~~~~//
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    //~~~~~~~~~~~~~~~~~~~~~~~ START CONTACT UPDATE METHODS ~~~~~~~~~~~~~~~~~~~~~~~//
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    /**
     * update_conact_create_acc_code adds Access Code field values after validation.
     * @return Contact Object with updated Access Code fields.
     */
    private Contact updateContactCreateAccessCode( Contact returnContact ) {
        returnContact = updateContactSecurityQuestions( returnContact );
        returnContact = updateContactSecurityAnswers( returnContact );
        returnContact = updateContactAccessCode( returnContact );
        return returnContact;
    }
    
    private Contact updateContactSecurityQuestions( Contact returnContact ) {
        returnContact.Security_Question_1__c = spoofContact.Security_Question_1__c;
        returnContact.Security_Question_2__c = spoofContact.Security_Question_2__c;
        return returnContact;
    }
    
    private Contact updateContactSecurityAnswers( Contact returnContact ) {
        returnContact.Security_Answer_1__c = spoofContact.Security_Answer_1__c;
        returnContact.Security_Answer_2__c = spoofContact.Security_Answer_2__c;
        return returnContact;
    }
    
    private Contact updateContactAccessCode( Contact returnContact ) {
        returnContact.Access_Code_Created_Date__c = DateTime.now();
        returnContact.Contact_Created_Access_Code__c = true;
        returnContact.Access_Code_Salt__c = Static_Methods_Fields.getSalt();
        returnContact.Access_Code__c = Static_Methods_Fields.hashWithSalt( spoofContact.Access_Code__c, returnContact.Access_Code_Salt__c );
        returnContact.PIN__C = '';
        returnContact.PIN_Expiration_Timestamp__c = DateTime.now();
        return returnContact;
    }

    private Contact updatePinCode( Contact returnContact ) {
        returnContact.PIN__c = generatePIN();
        returnContact.PIN_Expiration_Timestamp__c = DateTime.now().addDays( PIN_EXP_DAYS );
        return returnContact;
    }

    private String generatePIN() {
        String pin = '';
        
        for ( Integer i = 0; i < PIN_LENGTH; i++ ){
            pin += String.valueOf(Math.mod(Math.abs(Crypto.getRandomInteger()),10));
        }
        
        return pin;
    }

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    //~~~~~~~~~~~~~~~~~~~~~~~~ END CONTACT UPDATE METHODS ~~~~~~~~~~~~~~~~~~~~~~~~//
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

    public Id getOrganizationId( Contact con ) {
        List<CDO_Contact_Junction_Object__c> junctions = getActiveJunctionsForEmail(con.Email);
        
        if ( junctions.isEmpty() ){
            return null;
        }
        
        Organization__c org = [SELECT Id
                               FROM Organization__c 
                               WHERE Id = :junctions[0].Organization__c];
        
        return org.Id;
    }
    
    public String getTitleContinue(){
        return TITLE_CONTINUE;
    }
    
    public String getTitleBack(){
        return TITLE_BACK;
    }
    
    public String getTitleExit(){
        return TITLE_EXIT;
    }
}