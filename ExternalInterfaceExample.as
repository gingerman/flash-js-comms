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
			            
            input = new TextField();
            input.type = TextFieldType.INPUT;
            input.background = true;
            input.border = true;
            input.width = 350;
            input.height = 18;
            addChild(input);
			
            output = new TextField();
            output.y = 25;
            output.width = 500;
            output.height = 800;
            output.multiline = true;
            output.wordWrap = true;
            output.border = true;
            output.text = "Initializing...\n";
            addChild(output);
			
			sendBtn = new Sprite();
            sendBtn.mouseEnabled = true;
            sendBtn.x = input.width + 10;
            sendBtn.graphics.beginFill(0xccccff);
            sendBtn.graphics.drawRoundRect(0, 0, 80, 18, 10, 10);
            sendBtn.graphics.endFill();
            sendBtn.addEventListener(MouseEvent.CLICK, clickHandler);
            addChild(sendBtn);
            
            
            if (ExternalInterface.available) {
                try {
                    output.appendText("Adding callback...\n");
                    ExternalInterface.addCallback("sendToActionScript", receivedFromJavaScript);
                    if (checkJavaScriptReady()) {
                        output.appendText("JavaScript is ready.\n");
                    } else {
                        output.appendText("JavaScript is not ready, creating timer.\n");
                        var readyTimer:Timer = new Timer(750, 0);
                        readyTimer.addEventListener(TimerEvent.TIMER, timerHandler);
                        readyTimer.start();
                    }
                } catch (error:SecurityError) {
                    output.appendText("A SecurityError occurred: " + error.message + "\n");
                } catch (error:Error) {
                    output.appendText("An Error occurred: " + error.message + "\n");
                }
            } else {
                output.appendText("External interface is not available for this container.");
            }
        }
		
		
        private function receivedFromJavaScript(value:String):void {
            output.appendText("JavaScript says: " + value + "\n");
        }
		
		
        private function checkJavaScriptReady():Boolean {
            var isReady:Boolean = ExternalInterface.call("isReady");
            return isReady;
        }
        private function timerHandler(event:TimerEvent):void {
            output.appendText("Checking JavaScript status...\n");
            var isReady:Boolean = checkJavaScriptReady();
            if (isReady) {
                output.appendText("JavaScript is ready.\n");
                output.appendText("ExternalInterface.objectID = " + ExternalInterface.objectID + "\n");
                Timer(event.target).stop();
            }
        }
        private function clickHandler(event:MouseEvent):void {
			
			output.appendText("click");
            if (ExternalInterface.available) {
                ExternalInterface.call("sendToJavaScript", input.text);
            }
        }
    }
}
