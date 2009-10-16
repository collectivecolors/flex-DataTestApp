package application
{
	import com.collectivecolors.data.*;
	import com.collectivecolors.errors.*;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.List;
	import mx.controls.TextInput;
	import mx.core.Application;
	import mx.events.FlexEvent;
	import mx.utils.StringUtil;

	public class ApplicationClass extends Application
	{
		/**
		* MXML Components
		**/
		
		public var txtiUrlInput:TextInput;
		public var btnAdd:Button;
		public var txtiProtInput:TextInput;
		public var btnProt:Button;
		public var lstUrls:List;
		public var btnDelete:Button;
		
		/**
		 * Variables
		 **/
		 
		 public var urlSet:URLSet;
		 /*Currently accepted protocols
		 *
		 * This array is required since the URLSet protocols generally won't be changed during 
		 * runtime past the initial config and, as such, does not include a way to retrieve a 
		 * list of the protocols it is currently accepting
		 */
		 public var protCache:Array = ['http', 'https'];
		
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
			btnProt.addEventListener(MouseEvent.CLICK, BtnProtHandler);
			//Add event listeners to text inputs
			txtiProtInput.addEventListener(FocusEvent.FOCUS_IN, TxtiProtInputHandler);
			txtiProtInput.addEventListener(FocusEvent.FOCUS_OUT, TxtiProtInputHandler);
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
		 
		 //Protocol button listener
		 public function BtnProtHandler(value:Event):void{
		 	//If there's nothing in the text input box then don't do anything
		 	if(txtiProtInput.text == ""){
		 		return;
		 	}
		 	//Convert the string from the text input to an array after trimming it
		 	var protocols:Array = StringUtil.trim(txtiProtInput.text).split(" ");
		 	//Send that array to the URLSet class
		 	urlSet.allowedProtocols = protocols;
		 	//Synchronize this program's protocol cache with the protocols that the URLSet class is using
		 	protCache = protocols;
		 }
		 
		 //Delete or restore text in the protocol text area depending on user's focus
		 public function TxtiProtInputHandler(value:Event):void{
		 	//If the user's focus leaves the text box and the text box is empty, put current protocols in box
		 	if(value.type == FocusEvent.FOCUS_OUT && txtiProtInput.text == ""){
		 		txtiProtInput.text = protCache.toString().replace(',', " ");
		 	}
		 	
		 }
	}
}