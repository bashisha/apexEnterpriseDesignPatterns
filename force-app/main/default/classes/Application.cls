/**
 * @Author: Bernie Shishaye
 * @Create Time: 2024-03-28 11:19:47
 * @Modified by: Bernie Shishaye
 * @Modified time: 2024-04-01 22:51:36
 * @Description:
 */

public with sharing class Application
 {
     //This creates a Unit of Work for your application. The objects in the List<SObject> need to be in order of insertion.
     //If you insert cases first put it at the top of the list, etc.
     //Exmaple initialization: fflib_ISObjectUnitOfWork unitOfWork = Application.UOW.newInstance();
     public static final fflib_Application.UnitOfWorkFactory UOW =
         new fflib_Application.UnitOfWorkFactory(
             new List<SObjectType>{
             Account.SObjectType,
             Contact.SObjectType,
             Case.SObjectType,
             Task.SObjectType}
     );
 
     //This allows us to create a factory for instantiating service classes. You send it the interface for your service class
     //and it will return the correct service layer class
     //Exmaple initialization: Object objectService = Application.service.newInstance(Task_Service_Interface.class);
     public static final fflib_Application.ServiceFactory service =
             new fflib_Application.ServiceFactory(
                     new Map<Type, Type>{Task_Service_Interface.class => Task_Service_Impl.class}
             );
 


 
     //This allows us to create a factory for instantiating selector classes. You send it an object type and it sends
     //you the corresponding selectory layer class.
     //Exmaple initialization: fflib_ISObjectSelector objectSelector = Application.selector.newInstance(objectType);
     public static final fflib_Application.SelectorFactory selector =
             new fflib_Application.SelectorFactory(
                     new Map<SObjectType, Type>{
                             Case.SObjectType => Case_Selector.class,
                             Contact.SObjectType => Contact_Selector.class,
                             Task.SObjectType => Task_Selector.class,
                             Account.SObjectType => Account_Selector.class}
             );
 
     //This allows you to create a factory for instantiating domain classes. You can send it a set of record ids and
     //you'll get the corresponding domain layer.
     //Example initialization: fflib_ISObjectDomain objectDomain = Application.domain.newInstance(recordIds);
     public static final fflib_Application.DomainFactory domain =
             new fflib_Application.DomainFactory(
                     Application.selector,
                     new Map<SObjectType, Type>{Case.SObjectType => Cases.Constructor.class,
                     Contact.SObjectType => Contacts.Constructor.class,
                     Account.SObjectType => Accounts.Constructor.class}
             );
 
 
 }