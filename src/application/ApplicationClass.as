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
		public var txtiExtenInput:TextInput;
		public var btnExten:Button;
		public var txtiProtInput:TextInput;
		public var btnProt:Button;
		public var lstUrls:List;
		public var btnDelete:Button;
		
		/**
		 * Variables
		 **/
		 
		 public var urlSet:URLSet;
		 //Currently accepted protocols
		 public var protCache:Array = ['http', 'https'];
		 //Currently accepted extensions, empty = accept all
		 public var extenCache:Array = [];
		
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
			btnExten.addEventListener(MouseEvent.CLICK, BtnExtenHandler);
			//Add event listeners to text inputs
			txtiProtInput.addEventListener(FocusEvent.FOCUS_IN, TxtiProtInputHandler);
			txtiProtInput.addEventListener(FocusEvent.FOCUS_OUT, TxtiProtInputHandler);
			txtiExtenInput.addEventListener(FocusEvent.FOCUS_IN, TxtiExtenInputHandler);
			txtiExtenInput.addEventListener(FocusEvent.FOCUS_OUT, TxtiExtenInputHandler);
			//Fill out text inputs with correct information
			txtiProtInput.text = protCache.toString().replace(',', ' ');
			txtiExtenInput.text = extenCache.toString().replace(',', ' ');
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
		 	//Synchronize this program's protocol cache and text input with the protocols that the URLSet class is using
		 	protCache = protocols;
		 	txtiProtInput.text = protCache.toString().replace(/,/g, ' ');
		 }
		 
		 //Extension button listener
		 public function BtnExtenHandler(value:Event):void{
		 	//If there's nothing in the text input box then set allowed extensions to null
		 	if(txtiExtenInput.text == ""){
		 		urlSet.allowedFileExtensions = null;
		 		extenCache = [];
		 		return;
		 	}
		 	//Convert the string from the text input to an array after trimming it
		 	var extensions:Array = StringUtil.trim(txtiExtenInput.text).split(" ");
		 	//Send that array to the URLSet class
		 	urlSet.allowedFileExtensions = extensions;
		 	//Synchronize this program's protocol cache and text input with the protocols that the URLSet class is using
		 	extenCache = extensions;
		 	txtiExtenInput.text = extenCache.toString().replace(/,/g, ' ');
		 }
		 
		 //Restore text in the protocol text area if the user leaves it blank without committing the data
		 public function TxtiProtInputHandler(value:Event):void{
		 	//If the user's focus leaves the text box and don't commit the data, put current protocols in box
		 	if(value.type == FocusEvent.FOCUS_OUT && getFocus() != btnProt){
		 		txtiProtInput.text = protCache.toString().replace(/,/g, ' ');
		 	}
		 }
		 	
		 //Restore text in the extension text area if the user leaves it blank without committing the data
		 public function TxtiExtenInputHandler(value:Event):void{
		 	//If the user's focus leaves the text box and don't commit the data, put current extensions in box
		 	if(value.type == FocusEvent.FOCUS_OUT && getFocus() != btnExten){
		 		txtiExtenInput.text = extenCache.toString().replace(/,/g, ' ');
		 	}
		 }
	}
}