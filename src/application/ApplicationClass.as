package application
{
	import com.collectivecolors.data.*;
	import com.collectivecolors.errors.*;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
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
		
		public var lstUrls:List;
		
		public var btnAdd:Button;
		public var btnDelete:Button;
		public var btnCheck:Button;
		
		public var txtiExtenInput:TextInput;
		public var txtiProtInput:TextInput;
		
		
		
		/**
		 * Variables
		 **/
		 
		 public var urlSet:URLSet;
		 
		/**
		 * Constructor And Creation Complete Handler
		 **/
		public function ApplicationClass()
		{
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
		}
		
		public function creationCompleteHandler(value:Event):void 
		{
			//Create an instance of the URL set
			urlSet = new URLSet();
			
			//Add event listeners to buttons
			btnAdd.addEventListener(MouseEvent.CLICK, btnAddHandler);
			btnDelete.addEventListener(MouseEvent.CLICK, btnDeleteHandler);
			btnCheck.addEventListener(MouseEvent.CLICK, btnCheckHandler);
			
			//Add event listener to add text field
			txtiUrlInput.addEventListener(KeyboardEvent.KEY_DOWN, txtiUrlInputEnterHandler);
			
			//Fill out text inputs with correct information
			txtiProtInput.text  = 'http, https';
			txtiExtenInput.text = '';
			
			//Set focus
			txtiUrlInput.setFocus();
		}
		
		/**
		 * Event Handlers
		 **/
		 
		 // Respond to enter key press when on add url text input
		 public function txtiUrlInputEnterHandler(value:KeyboardEvent):void
		 {
		   if (value.charCode == Keyboard.ENTER)
		   {
		     btnAddHandler(null); 
		   }
		 }
		 
		 //Add URL button listener
		 public function btnAddHandler(value:Event):void
		 {
		   var isError : Boolean = false;
		   
		   //Initialize URLSet filters
		 	 setProtocols();
		 	 setExtensions();
		 	
		 	 //Pass the URL from the text box "txtiUrlInput" to the URLSet instance
		 	 try {
		 		urlSet.addUrl(txtiUrlInput.text);
		 	 }
		 	 //If an error occurs, display the error to the user
		 	 catch(error:InvalidInputError) {
		 	   isError = true;
		 		 Alert.show(error.message);
		 	 }
		 	 //If no error occurs, update the list
		 	 lstUrls.dataProvider = urlSet.urls;
		 		
		 	 // Clear url from input.
		 	 if (!isError) {
		 	   txtiUrlInput.text = '';
		 	 }
		 }
		 
		 //Delete URL button listener
		 public function btnDeleteHandler(value:Event):void
		 {
		 	//Iterate through all selected items and remove them from the url set
		 	var selectedUrls:Array = lstUrls.selectedItems;
		 	for(var i:int = 0 ; i < selectedUrls.length ; i++){
		 		urlSet.removeUrl(selectedUrls[i]);
		 	}
		 	//Update the list with the new data
		 		lstUrls.dataProvider = urlSet.urls;
		 }
		 
		 //Check all existing URLs
		 public function btnCheckHandler(value:Event):void
		 {
		   //Initialize URLSet filters ( this SHOULD filter all non-conforming URLs )
		 	 setProtocols();
		 	 setExtensions();
		 	 
		 	 //Update the list
		   lstUrls.dataProvider = urlSet.urls; 
		 }
		 
		 //Set allowed protocols based upon user input
		 private function setProtocols(): void
		 {
		   //If there's nothing in the text input box then don't do anything
		   if (txtiProtInput.text == "") {
		     urlSet.allowedProtocols = null;
		     return;
		   }
		   
		   //Convert the string from the text input to an array and set allowed protocols
		   urlSet.allowedProtocols = txtiProtInput.text.split(",");
		 }
		 
		//Set allowed extensions based upon user input
		private function setExtensions():void
		{
		  //If there's nothing in the text input box then set allowed extensions to null
		 	if(txtiExtenInput.text == "") {
		 		urlSet.allowedFileExtensions = null;
		 		return;
		 	}
		 	
		 	//Convert the string from the text input to an array and set allowed extensions
		 	urlSet.allowedFileExtensions = txtiExtenInput.text.split(",");
		}
	}
}