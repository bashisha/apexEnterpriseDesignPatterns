@isTest
public with sharing class SingletonTest {
    @isTest
    public static void testLeapYear(){
        SingletonController.printDateTime();
    }

    @isTest
    public static void testNonLeapYear(){
       Datetime newNow = Datetime.newInstance(2020,9,8);
       DateTimeProvider.instance  = new DateTimeStub(newNow);
       SingletonController.printDateTime();
    }

    private with sharing class DateTimeStub extends DateTimeProvider {
        private Datetime dt;
        public DateTimeStub(DateTime dtt){
            this.dt = dtt;
        }

        public override Datetime now(){
            return dt;
        }
    }
}