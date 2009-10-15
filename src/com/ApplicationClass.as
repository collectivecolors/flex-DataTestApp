package com
{
	import com.collectivecolors.data.*;
	import com.collectivecolors.errors.*;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.List;
	import mx.controls.TextInput;
	import mx.core.Application;
	import mx.events.FlexEvent;

	public class ApplicationClass extends Application
	{
		/**
		* MXML Components
		**/
		
		public var txtiUrlInput:TextInput;
		public var btnAdd:Button;
		public var lstUrls:List;
		public var btnDelete:Button;
		
		/**
		 * Variables
		 **/
		 
		 public var urlSet:URLSet;
		
		/**
		 * Constructor And Creation Complete Handler
		 **/
		public function ApplicationClass()
		{
			addEventListener(FlexEvent.CREATION_COMPLETE, CreationCompleteHandler);
		}
		
		public function CreationCompleteHandler(value:Event):void{
			//Create an instance of the URL set
			urlSet = new URLSet;
			//Add event listeners to buttons
			btnAdd.addEventListener(MouseEvent.CLICK, BtnAddHandler);
			btnDelete.addEventListener(MouseEvent.CLICK, BtnDeleteHandler);
		}
		
		/**
		 * Event Handlers
		 **/
		 
		 //Add URL button listener
		 public function BtnAddHandler(value:Event):void{
		 	//Pass the URL from the text box "txtiUrlInput" to the URLSet instance
		 	try{
		 		urlSet.addUrl(txtiUrlInput.text);
		 	}
		 	//If an error occurs, display the error to the user
		 	catch(error:InvalidInputError){
		 		Alert.show(error.message);
		 	}
		 	//If no error occurs, update the list
		 		lstUrls.dataProvider = urlSet.urls;
		 }
		 
		 //Delete URL button listener
		 public function BtnDeleteHandler(value:Event):void{
		 	//Iterate through all selected items and remove them from the url set
		 	var selectedUrls:Array = lstUrls.selectedItems;
		 	for(var i:int = 0 ; i < selectedUrls.length ; i++){
		 		urlSet.removeUrl(selectedUrls[i]);
		 	}
		 	//Update the list with the new data
		 		lstUrls.dataProvider = urlSet.urls;
		 }
	}
}