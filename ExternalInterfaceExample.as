package  {
    
    import flash.display.Sprite;
    import flash.events.*;
    import flash.external.ExternalInterface;
    import flash.text.TextField;
    import flash.utils.Timer;
    import flash.text.TextFieldType;
    import flash.text.TextFieldAutoSize;
    import flash.system.Security;
    
    public class ExternalInterfaceExample extends Sprite 
    {
        
    private var input:TextField;
        private var output:TextField;
        private var sendBtn:Sprite;
        
        public function ExternalInterfaceExample() 
        {
            // constructor code
            Security.allowDomain("*");
			
            output = new TextField();
            output.y = 25;
            output.width = 350;
            output.height = 25;
            output.multiline = true;
            output.wordWrap = true;
            output.border = true;
            output.text = "Initializing...\n";
            addChild(output);

            if (ExternalInterface.available) {
                try {
                    output.text ="Adding callback...\n";
                    ExternalInterface.addCallback("sendToActionScript", receivedFromJavaScript);
                    if (checkJavaScriptReady()) {
                        output.text ="JavaScript is ready.\n";
                    } else {
                        output.text ="JavaScript is not ready, creating timer.\n";
                        var readyTimer:Timer = new Timer(750, 0);
                        readyTimer.addEventListener(TimerEvent.TIMER, timerHandler);
                        readyTimer.start();
                    }
                } catch (error:SecurityError) {
                    output.text ="A SecurityError occurred: " + error.message + "\n";
                } catch (error:Error) {
                    output.text ="An Error occurred: " + error.message + "\n";
                }
            } else {
                output.text ="External interface is not available for this container.";
            }
        }
		
		
        private function receivedFromJavaScript(value:String):void {
            output.text ="JavaScript says: " + value + "\n";
        }
		
		
        private function checkJavaScriptReady():Boolean {
            var isReady:Boolean = ExternalInterface.call("isReady");
            return isReady;
        }
        private function timerHandler(event:TimerEvent):void {
            output.text ="Checking JavaScript status...\n";
            var isReady:Boolean = checkJavaScriptReady();
            if (isReady) {
                output.text ="JavaScript is ready.\n";
                output.text ="ExternalInterface.objectID = " + ExternalInterface.objectID + "\n";
                Timer(event.target).stop();
            }
        }
		/*
			private function clickHandler(event:MouseEvent):void {
			
			output.text ="click";
            if (ExternalInterface.available) {
                ExternalInterface.call("sendToJavaScript", input.text);
            }
        }*/
    }
}
