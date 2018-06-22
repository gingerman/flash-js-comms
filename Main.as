package
{
    import flash.display.MovieClip;
    import flash.external.ExternalInterface;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.text.TextField;

    public class Main extends MovieClip {
		
		private var containerMC:MovieClip;
		public var outputTF:TextField;
		
        public function Main() {
			
			makeUI();
			
            ExternalInterface.addCallback("receiveText", receiveText);
		
            setupExternalInterface();
        }
		
		public function receiveText(value:String):void {
            outputTF.appendText(value ) ;
        }
		
        public function setupExternalInterface():void {
            //see how we're defining a function inside another function?
            ExternalInterface.addCallback("anon", function(){
                outputTF.appendText( "Do something sexy!");
            });
             
            //same applies here
            //ExternalInterface.call("function(){ window.onresize = function(){ document['externalInterface'].anon(); }; }");
        }
		
		public function makeUI():void
		{
			containerMC = new MovieClip();
			addChild( containerMC );
			outputTF = new TextField();
			outputTF.width = 300;
			outputTF.height = 300;
			outputTF.x = 5;
			outputTF.y = 5;
			containerMC.addChild(outputTF);
			
			outputTF.text = "Start..." ;
		}
    }
}