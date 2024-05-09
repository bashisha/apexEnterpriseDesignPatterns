public with sharing class SingletonController {
    @AuraEnabled    
    public static void printDateTime() {
        DateTimeProvider dtProvider = DateTimeProvider.getInstance();
        System.debug('Hey,is it a leap year?');
        Boolean isLeapYear = Date.isLeapYear(dtProvider.now().year());
        if(isLeapYear) {
            System.debug('Yes');
        }
        else{
            System.debug('No');
        }

    }
}