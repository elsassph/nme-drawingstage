package;

import nme.display.Sprite;
import nme.events.Event;
import nme.Lib;

/**
 * A drawing canvas demo using a grid of bitmaps
 *
 * @author Philippe / http://philippe.elsass.me
 */
class Main extends Sprite 
{
	var drawingStage:DrawingStage;
	
	public function new()
	{
		super();
		
		#if iphone
		Lib.current.stage.addEventListener(Event.RESIZE, init);
		#else
		addEventListener(Event.ADDED_TO_STAGE, init);
		#end
	}
	
	private function init(e):Void 
	{
		#if iphone
		Lib.current.stage.removeEventListener(Event.RESIZE, init);
		#else
		removeEventListener(Event.ADDED_TO_STAGE, init);
		#end
		// Entry point
		
		stage.addChild(new DrawingStage(stage.stageWidth, stage.stageHeight));
		stage.addChild(new utils.FPS());
	}
	
	public static function main() 
	{
		// Static entry point
		Lib.current.stage.align = nme.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
	}
}
