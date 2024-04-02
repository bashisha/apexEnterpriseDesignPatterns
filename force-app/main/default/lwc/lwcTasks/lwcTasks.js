import { LightningElement, api, wire } from 'lwc';
import createTasksController from '@salesforce/apex/Task_Controller.createTasks';
import getTasks from '@salesforce/apex/Task_Controller.getTasks';

export default class LwcTasks extends LightningElement {
    @api recordId;
	displayMessage;
	taskColumns =
		[
			{label: 'Id', fieldName: 'Id', editable: false},
			{label: 'Subject', fieldName: 'Subject', editable: false},
			{label: 'Related Contact', fieldName: 'WhoId', editable: false}
		];
	taskRows;

	createTasks(){
		createTasksController({"recordId": this.recordId}).then(result=>{			
            this.displayMessage = 'Success, Created Tasks!';
		}).catch(error=>{
			this.displayMessage = JSON.stringify(error);
		});
	}

    @wire(getTasks)
    getTodayTasks({error, data}){
        if(data){
            this.taskRows=data;
        }
        else if(error){
            this.displayMessage = JSON.stringify(error);
        }
    }
   

}