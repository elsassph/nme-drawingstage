import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.geom.Point;


/**
 * @author Philippe / http://philippe.elsass.me
 */
class DrawingStage extends nme.display.Sprite
{
	var size:Int;
	var bgColor:Int;
	var shift:Int;
	var cols:Int;
	var lines:Int;
	var grid:Array<Array<Bitmap>>;
	var drawing:Bool;
	var pos:Point;
	var prevX:Float;
	var prevY:Float;
	var brushDirty:Bool;
	var curBrush:BitmapData;

	public function new(size:Int, backgroundColor:Int = 0xffffff)
	{
		super();
		this.size = size;
		this.bgColor = backgroundColor;

		shift = 1;
		while (size > 2) { size = size >> 1; shift++; }
		pos = new Point();

		addEventListener(Event.ADDED_TO_STAGE, added);
	}

	function mouseUp(e) 
	{
		drawing = false;
	}

	function mouseMove(e:MouseEvent) 
	{
		if (!drawing) return;
		var mx = e.localX;
		var my = e.localY;
		var dx = mx - prevX;
		var dy = my - prevY;
		var d = Math.sqrt(dx*dx + dy*dy);
		if (d >= 5) {
			var a = Math.atan2(dy, dx);
			for(i in 1...Std.int(d/5))
				drawAt(Math.round(prevX + i*5*Math.cos(a)), Math.round(prevY + i*5*Math.sin(a)));
		}
		prevX = mx;
		prevY = my;
		drawAt(cast mx, cast my);
	}

	function drawAt(x1:Int, y1:Int)
	{
		var col = x1 >> shift;
		var line = y1 >> shift;
		var x0 = col << shift;
		var y0 = line << shift;
		
		var bw = brush.width/2.0;
		var bh = brush.height/2.0;
		pos.x = x1-x0 - bw;
		pos.y = y1-y0 - bh;

		drawLine(grid[line], col, x0, x1, bw);
		if (pos.y < 0 && line > 0) {
			pos.y += size;
			drawLine(grid[line-1], col, x0, x1, bw);
		}
		else if (pos.y > size - bh * 2.0 && line < lines-1) {
			pos.y -= size;
			drawLine(grid[line+1], col, x0, x1, bw);
		}
	}

	function drawLine(line:Array<Bitmap>, col:Int, x0:Int, x1:Int, bw:Float)
	{
		drawIn(line[col].bitmapData);
		if (pos.x < 0 && col > 0) {
			pos.x += size;
			drawIn(line[col-1].bitmapData);
			pos.x -= size;
		}
		else if (pos.x > size - bw * 2.0 && col < cols-1) {
			pos.x -= size;
			drawIn(line[col+1].bitmapData);
			pos.x += size;
		}
	}

	inline function drawIn(bmp:BitmapData)
	{
		bmp.copyPixels(curBrush, curBrush.rect, pos, null, null, true);
	}

	function mouseDown(e:MouseEvent)
	{
		color = (Std.int(Math.random() * 256.0) << 16)
			+ (Std.int(Math.random() * 256.0) << 8)
			+ Std.int(Math.random() * 256.0);

		updateBrush();
		drawing = true;
		prevX = e.localX;
		prevY = e.localY;
		mouseMove(e);
	}

	function updateBrush()
	{
		if (!brushDirty) return;
		brushDirty = false;
		if (curBrush == null || curBrush.width != brush.width || curBrush.height != brush.height)
			curBrush = new BitmapData(brush.width, brush.height, true, 0);
		curBrush.fillRect(curBrush.rect, 0);
		var ct = new nme.geom.ColorTransform();
		ct.redMultiplier = (color >> 16) / 256.0;
		ct.greenMultiplier = ((color & 0xff00) >> 8) / 256.0;
		ct.blueMultiplier = (color & 0xff) / 256.0;
		curBrush.draw(brush, null, ct);
	}

	function added(e)
	{
		removeEventListener(Event.ADDED_TO_STAGE, added);

		cols = Math.ceil(stage.stageWidth / size);
		lines = Math.ceil(stage.stageHeight / size);
		grid = [];
		for(i in 0...lines)
		{
			var line:Array<Bitmap> = [];
			for(j in 0...cols)
			{
				var b = new Bitmap(new BitmapData(size, size, false, bgColor));
				b.x = j * size;
				b.y = i * size;
				addChild(b);
				line.push(b);
			}
			grid.push(line);
		}

		addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		addEventListener(MouseEvent.MOUSE_UP, mouseUp);
	}


	/* PROPERTIES */

	public var brush(get_brush, set_brush):BitmapData;
	private var _brush:BitmapData;
	
	function get_brush():BitmapData { return _brush; }
	function set_brush(value:BitmapData):BitmapData 
	{
		brushDirty = true;
		return _brush = value;
	}

	public var color(get_color, set_color):Int;
	private var _color:Int;
	
	function get_color():Int { return _color; }
	function set_color(value:Int):Int 
	{
		brushDirty = true;
		return _color = value;
	}

}
