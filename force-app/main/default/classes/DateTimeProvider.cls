public virtual with sharing class DateTimeProvider {
    @TestVisible
    private static DateTimeProvider instance;

    public static DatetimeProvider getInstance(){
        if(instance==null){
            instance = new DateTimeProvider();
        }
        return instance;
    }
    protected DateTimeProvider(){

    }
    public virtual Datetime now(){
        return Datetime.now();
    }
}