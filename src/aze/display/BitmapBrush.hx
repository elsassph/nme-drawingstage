package aze.display;

import nme.display.BitmapData;
import nme.geom.Rectangle;

class BitmapBrush
{
	var dirty:Bool;
	var image:BitmapData;

	public function new(image:BitmapData, color:Int = 0)
	{
		this.image = image;
		this.color = color;
	}

	public function update()
	{
		dirty = false;
		if (_bmp == null || _bmp.width != image.width || _bmp.height != image.height)
			_bmp = new BitmapData(image.width, image.height, true, getColor(0,0));
		_bmp.fillRect(_bmp.rect, getColor(0,0));
		var ct = new nme.geom.ColorTransform();
		ct.redMultiplier = (color >> 16) / 256.0;
		ct.greenMultiplier = ((color & 0xff00) >> 8) / 256.0;
		ct.blueMultiplier = (color & 0xff) / 256.0;
		_bmp.draw(image, null, ct);
		_rect = _bmp.rect.clone();
		_width = cast _rect.width;
		_height = cast _rect.height;
	}

	/* PROPERTIES */

	public var width(get_width, null):Int;
	private var _width:Int;
	
	inline function get_width():Int 
	{ 
		if (dirty) update();
		return _width; 
	}

	public var height(get_height, null):Int;
	private var _height:Int;
	
	inline function get_height():Int 
	{ 
		if (dirty) update();
		return _height; 
	}
	
	public var rect(get_rect, null):Rectangle;
	private var _rect:Rectangle;
	
	inline function get_rect():Rectangle 
	{ 
		if (dirty) update();
		return _rect; 
	}

	public var color(get_color, set_color):Int;
	private var _color:Int;
	
	inline function get_color():Int { return _color; }
	function set_color(value:Int):Int 
	{
		dirty = _color != value;
		return _color = value;
	}

	public var bmp(get_bmp, null):BitmapData;
	private var _bmp:BitmapData;
	
	function get_bmp():BitmapData 
	{ 
		if (dirty) update();
		return _bmp; 
	}

	/* HELPER */

	static public inline function getColor(rgb:Int, a:Int = 0xff)
	{
		#if neko
		return { rgb:rgb, a:a }
		#else
		return (a << 24) + rgb;
		#end
	}

}