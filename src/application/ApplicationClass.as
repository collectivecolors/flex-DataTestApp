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
			
			//Add focus event listeners
			txtiProtInput.addEventListener(FocusEvent.FOCUS_OUT, optionFocusHandler);
			txtiExtenInput.addEventListener(FocusEvent.FOCUS_OUT, optionFocusHandler);
			
			//Add keyboard event listeners
			txtiUrlInput.addEventListener(KeyboardEvent.KEY_DOWN, txtiUrlInputEnterHandler);
			txtiProtInput.addEventListener(KeyboardEvent.KEY_DOWN, optionEnterHandler);
			txtiExtenInput.addEventListener(KeyboardEvent.KEY_DOWN, optionEnterHandler);
			
			//Fill out text inputs with correct information
			txtiProtInput.text  = 'http, https';
			txtiExtenInput.text = '';
		}
		
		
		/**
		 * Event Handlers
		 **/
		 
		 
		 //If the user presses the enter key when focuses on the url text input, add the URL
		 public function txtiUrlInputEnterHandler(value:KeyboardEvent):void
		 {
		   if (value.charCode == Keyboard.ENTER)
		   {
		   	//Add the URL when the user presses the enter key
		    addUrl(); 
		   }
		 }
		 
		 
		 //If the user presses the add url button, add the url
		 public function btnAddHandler(value:Event):void
		 {
		 	//Add the URL when the user presses the add url button
		   	addUrl();
		 }
		 
		 
		 //If the user hits the enter key when focused on either the protocol text input or the extension text input, revalidate all URLs
		  public function optionEnterHandler(value:KeyboardEvent):void{
		  	if (value.charCode == Keyboard.ENTER){
		  		checkUrl();
		  	}
		  }
		  
		  
		  //If the user stops focusing on either the protocol text input or the extension text input, revalidate all URLs
		  public function optionFocusHandler(value:Event):void{
		  	if(value.type == FocusEvent.FOCUS_OUT){
		  		checkUrl();
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
		 
		 
		/**
		 * Methods
		 **/
		 
		 
		 //Set allowed protocols based upon user input
		 private function setProtocols(): void
		 {
		   //If there's nothing in the text input box then set allwed protocols to null
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
		
		
		//Add a new URL to the list
		private function addUrl():void{
			//Initialize URLSet filters
		 	 setProtocols();
		 	 setExtensions();
		 	
		 	 //Pass the URL from the text box "txtiUrlInput" to the URLSet instance
		 	 try {
		 		urlSet.addUrl(txtiUrlInput.text);
		 	 }
		 	 //If an error occurs, display the error to the user and immediatly return from this function
		 	 catch(error:InvalidInputError) {
		 		Alert.show(error.message);
		 		return;
		 	 }
		 	 
		 	 //Update the list
		 	 lstUrls.dataProvider = urlSet.urls;
		 		
		 	 //Clear url from input.
		 	 txtiUrlInput.text = '';
		}
		
		
		//Check all currently accepted URLs to ensure that they are still valid
		private function checkUrl():void{
			//Initialize URLSet filters ( this SHOULD filter all non-conforming URLs )
		 	setProtocols();
		 	setExtensions();
		 	 
		 	//Update the list
		 	lstUrls.dataProvider = urlSet.urls; 
		}
	}
}