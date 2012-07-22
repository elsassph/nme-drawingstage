import aze.display.BitmapBrush;
import aze.display.BitmapGrid;
import nme.display.BitmapData;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.events.TouchEvent;
import nme.geom.Point;


/**
 * @author Philippe / http://philippe.elsass.me
 */
class DrawingStage extends nme.display.Sprite
{
	var _width:Int;
	var _height:Int;
	var canvas:BitmapGrid;
	var drawing:Bool;
	var image:BitmapData;
	var brushes:Array<BitmapBrush>;

	public function new(width:Int, height:Int)
	{
		super();
		_width = width;
		_height = height;
		addEventListener(Event.ADDED_TO_STAGE, added);
	}

	public function clear()
	{
		canvas.fillRect(canvas.rect, 0xffffff);
	}

	/* MOUSE */

	function mouseUp(e) 
	{
		stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
		drawing = false;
		releaseBrush(0);
	}

	function mouseMove(e:MouseEvent) 
	{
		if (!drawing) return;
		lineTo(0, e.localX, e.localY);
	}

	function mouseDown(e:MouseEvent)
	{
		drawing = true;
		stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
		moveTo(0, e.localX, e.localY);
	}

	/* TOUCH */

	function touchEnd(e:TouchEvent) 
	{
		releaseBrush(e.touchPointID);
	}

	function touchMove(e:TouchEvent) 
	{
		lineTo(e.touchPointID, e.localX, e.localY);
	}

	function touchBegin(e:TouchEvent) 
	{
		moveTo(e.touchPointID, e.localX, e.localY);
	}

	/* DRAWING */

	function lineTo(id, x, y) 
	{
		canvas.lineTo(id, Math.round(x), Math.round(y));
	}

	function moveTo(id, x, y) 
	{
		var brush = getBrush();
		brush.color = (Std.int(Math.random() * 256.0) << 16)
			+ (Std.int(Math.random() * 256.0) << 8)
			+ Std.int(Math.random() * 256.0);

		canvas.lineStyle(id, brush);
		canvas.moveTo(id, Math.round(x), Math.round(y));
	}

	/* BRUSH POOL */

	function releaseBrush(id)
	{
		var ctx = canvas.clearStyle(id);
		if (ctx != null) brushes.push(ctx.brush);
	}

	function getBrush()
	{
		if (brushes.length > 0) return brushes.pop();
		return new BitmapBrush(image);
	}

	/* SETUP */

	function added(e)
	{
		removeEventListener(Event.ADDED_TO_STAGE, added);

		brushes = [];
		image = nme.Assets.getBitmapData("img/brush-hard.png");

		canvas = new BitmapGrid(_width, _height, 128);
		addChild(canvas);

		mouseChildren = false;
		//#if (mobile || html5)
		#if mobile
		nme.ui.Multitouch.inputMode = nme.ui.MultitouchInputMode.TOUCH_POINT;
		addEventListener(nme.events.TouchEvent.TOUCH_BEGIN, touchBegin);
		addEventListener(nme.events.TouchEvent.TOUCH_MOVE, touchMove);
		addEventListener(nme.events.TouchEvent.TOUCH_END, touchEnd);
		#else
		addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		#end
	}
}
