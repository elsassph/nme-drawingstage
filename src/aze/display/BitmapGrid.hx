package aze.display;

import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.geom.Point;


/**
 * @author Philippe / http://philippe.elsass.me
 */
class BitmapGrid extends nme.display.Sprite
{
	var size:Int;
	var shift:Int;
	var cols:Int;
	var lines:Int;
	var grid:Array<Array<Bitmap>>;
	var pos:Point;
	var contexts:Array<StyleContext>;

	public function new(width:Int, height:Int, cellSize:Int, backgroundColor:Int = 0xffffff)
	{
		super();
		size = cellSize;
		init(width, height, backgroundColor);
	}

	public function clearStyle(id:Int)
	{
		for(i in 0...contexts.length)
		{
			var ctx = contexts[i];
			if (ctx.id == id) {
				contexts.splice(i, 1);
				return ctx;
			}
		}
		return null;
	}

	public function lineStyle(id:Int, brush:BitmapBrush)
	{
		var ctx = getContext(id);
		if (ctx != null) ctx.brush = brush;
		else {
			ctx = new StyleContext(id, brush);
			contexts.push(ctx);
		}
		return ctx;
	}

	public function moveTo(id:Int, x:Int, y:Int)
	{
		var ctx = getContext(id);
		if (ctx == null) return;
		ctx.pos.x = x;
		ctx.pos.y = y;
		drawAt(ctx.brush, x, y);
	}

	public function lineTo(id:Int, x:Int, y:Int) 
	{
		var ctx = getContext(id);
		if (ctx == null) return;
		var prevX = ctx.pos.x;
		var prevY = ctx.pos.y;
		var dx = x - prevX;
		var dy = y - prevY;
		var d = Math.sqrt(dx*dx + dy*dy);
		if (d > 5) {
			var a = Math.atan2(dy, dx);
			for(i in 1...Std.int(d/5))
				drawAt(ctx.brush, Math.round(prevX + i*5*Math.cos(a)), Math.round(prevY + i*5*Math.sin(a)));
		}
		ctx.pos.x = x;
		ctx.pos.y = y;
		drawAt(ctx.brush, x, y);
	}

	function getContext(id) 
	{
		for(i in 0...contexts.length)
		{
			var ctx = contexts[i];
			if (ctx.id == id) return ctx;
		}
		return null;
	}

	function drawAt(brush:BitmapBrush, x1:Int, y1:Int)
	{
		var col = x1 >> shift;
		var line = y1 >> shift;
		var x0 = col << shift;
		var y0 = line << shift;
		
		var bw = brush.width/2.0;
		var bh = brush.height/2.0;
		pos.x = x1-x0 - bw;
		pos.y = y1-y0 - bh;

		drawLine(brush, grid[line], col, x0, x1, bw);
		if (pos.y < 0 && line > 0) {
			pos.y += size;
			drawLine(brush, grid[line-1], col, x0, x1, bw);
		}
		else if (pos.y > size - bh * 2.0 && line < lines-1) {
			pos.y -= size;
			drawLine(brush, grid[line+1], col, x0, x1, bw);
		}
	}

	inline function drawLine(brush:BitmapBrush, line:Array<Bitmap>, col:Int, x0:Int, x1:Int, bw:Float)
	{
		drawIn(brush, line[col].bitmapData);
		if (pos.x < 0 && col > 0) {
			pos.x += size;
			drawIn(brush, line[col-1].bitmapData);
			pos.x -= size;
		}
		else if (pos.x > size - bw * 2.0 && col < cols-1) {
			pos.x -= size;
			drawIn(brush, line[col+1].bitmapData);
			pos.x += size;
		}
	}

	inline function drawIn(brush:BitmapBrush, bmp:BitmapData)
	{
		bmp.copyPixels(brush.bmp, brush.rect, pos, null, null, true);
	}

	function init(width:Int, height:Int, bgColor:Int)
	{
		shift = 1;
		var tmp = size;
		while (tmp > 2) { tmp = tmp >> 1; shift++; }

		contexts = [];
		pos = new Point();

		cols = Math.ceil(width / size);
		lines = Math.ceil(height / size);
		grid = [];
		for(i in 0...lines)
		{
			var line:Array<Bitmap> = [];
			for(j in 0...cols)
			{
				var b = new Bitmap(new BitmapData(size, size, false, BitmapBrush.getColor(bgColor)));
				b.x = j * size;
				b.y = i * size;
				addChild(b);
				line.push(b);
			}
			grid.push(line);
		}
	}

}

class StyleContext implements haxe.Public
{
	var id:Int;
	var brush:BitmapBrush;
	var pos:PointI;

	function new(id, brush)
	{
		this.id = id;
		this.brush = brush;
		pos = new PointI();
	}
}

class PointI implements haxe.Public
{
	var x:Int;
	var y:Int;

	function new(x = 0, y = 0)
	{
		this.x = x;
		this.y = y;
	}
}
