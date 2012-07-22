package aze.display;

import nme.display.BitmapData;
import nme.geom.Rectangle;

class BitmapBrush
{
	var dirty:Bool;
	var image:BitmapData;

	public function new(image:BitmapData, color:Int = 0, scale:Float = 1.0)
	{
		this.image = image;
		this.color = color;
		this.scale = scale;
	}

	public function update()
	{
		dirty = false;
		var bw = Math.ceil(image.width * scale / 2) * 2;
		var bh = Math.ceil(image.height * scale / 2) * 2;

		if (_bmp == null || _bmp.width != bw || _bmp.height != bh)
			_bmp = new BitmapData(bw, bh, true, getColor(0,0));
		else _bmp.fillRect(_bmp.rect, getColor(0,0));
		
		var ct = new nme.geom.ColorTransform();
		ct.redMultiplier = (color >> 16) / 256.0;
		ct.greenMultiplier = ((color & 0xff00) >> 8) / 256.0;
		ct.blueMultiplier = (color & 0xff) / 256.0;

		var mat = new nme.geom.Matrix();
		mat.scale(scale, scale);

		_bmp.draw(image, mat, null, null, null, true);
		_bmp.colorTransform(_bmp.rect, ct);
		
		_rect = _bmp.rect.clone();
		_width = cast _rect.width;
		_height = cast _rect.height;
	}

	/* PROPERTIES */

	public var step(get_step, null):Float;
	private var _step:Float;
	
	function get_step():Float 
	{ 
		if (dirty) update();
		return _step; 
	}

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

	public var scale(get_scale, set_scale):Float;
	private var _scale:Float;
	
	inline function get_scale():Float { return _scale; }
	function set_scale(value:Float):Float 
	{
		dirty = _scale != value;
		return _scale = value;
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

	static public function closestPow2(v:Float)
	{
		var s:Int = 1;
		while (s < v) s = s << 1;
		return s;
	}

}