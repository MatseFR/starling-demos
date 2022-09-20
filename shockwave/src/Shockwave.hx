package;
import openfl.display.BitmapDataChannel;
import openfl.errors.TypeError;
import starling.animation.Juggler;
import starling.animation.Transitions;
import starling.display.DisplayObject;
import starling.events.Event;
import starling.events.EventDispatcher;
import starling.filters.DisplacementMapFilter;
import starling.filters.FilterChain;
import starling.textures.Texture;

/**
 * ...
 * @author Matse
 */
class Shockwave extends EventDispatcher
{
	private var _distortion:Float = 0;
	private var _distortionEnd:Float = 0;
	private var _distortionStart:Float = 64;
	private var _duration:Float = 1;
	private var _juggler:Juggler;
	private var _radius:Float = 0;
	private var _radiusEnd:Float = 600;
	private var _radiusStart:Float = 20;
	private var _reverse:Bool = false;
	private var _target:Dynamic;
	private var _texture:Texture;
	private var _transition:String = Transitions.EASE_OUT;
	private var _x:Float = 0;
	private var _y:Float = 0;
	
	private var _displayObject:DisplayObject;
	private var _filter:DisplacementMapFilter;
	private var _filterChain:FilterChain;
	private var _isStarted:Bool = false;
	private var _tweenID:UInt;
	
	/**
	   
	**/
	public function new() 
	{
		super();
		
		_filter = new DisplacementMapFilter(null, BitmapDataChannel.RED, BitmapDataChannel.GREEN);
	}
	
	/**
	   Clears target, texture and juggler + stops and remove the effect if needed
	**/
	public function clear():Void
	{
		__stop();
		this.removeEventListeners();
		this.target = null;
		this.texture = null;
		this.juggler = null;
	}
	
	/**
	   Disposes this effect
	**/
	public function dispose():Void
	{
		clear();
		_filter.dispose();
	}
	
	/**
	   Pools this effect
	**/
	public function pool():Void
	{
		toPool(this);
	}
	
	/**
	   Helper function : target, texture and juggler are mandatory
	   
	   @param	target	a DisplayObject or FilterChain instance
	   @param	texture
	   @param	juggler
	**/
	public function setup(target:Dynamic, texture:Texture, juggler:Juggler)
	{
		this.target = target;
		this.texture = texture;
		this.juggler = juggler;
	}
	
	/**
	   Starts the effect and its animation
	**/
	public function start():Void
	{
		__stop();
		
		if (_displayObject != null)
		{
			_displayObject.filter = _filter;
		}
		else
		{
			_filterChain.addFilter(_filter);
		}
		
		this.distortion = _distortionStart;
		this.radius = _radiusStart;
		
		if (_reverse)
		{
			_tweenID = _juggler.tween(this, _duration, {radius:_radiusEnd, distortion:_distortionEnd, transition:_transition, onComplete:complete, reverse:true, repeatCount:2});
		}
		else
		{
			_tweenID = _juggler.tween(this, _duration, {radius:_radiusEnd, distortion:_distortionEnd, transition:_transition, onComplete:complete});
		}
		_isStarted = true;
	}
	
	private function complete():Void
	{
		__stop();
		dispatchEventWith(Event.COMPLETE);
	}
	
	/**
	   Stops the effect and its animation
	**/
	public function stop():Void
	{
		if (_isStarted)
		{
			__stop();
			dispatchEventWith(Event.CANCEL);
		}
	}
	
	private function __stop():Void
	{
		if (_isStarted)
		{
			_juggler.removeByID(_tweenID);
			
			if (_displayObject != null && _displayObject.filter == _filter)
			{
				_displayObject.filter = null;
			}
			else
			{
				_filterChain.removeFilter(_filter);
			}
			
			_isStarted = false;
		}
	}
	
	/**
	   Tells which color channel to use in the texture to displace the x result
	   @default BitmapDataChannel.RED
	**/
	public var componentX(get, set):UInt;
	private function get_componentX():UInt { return _filter.componentX; }
	private function set_componentX(value:UInt):UInt
	{
		return _filter.componentX = value;
	}
	
	/**
	   Tells which color channel to use in the texture to displace the y result
	   @default BitmapDataChannel.GREEN
	**/
	public var componentY(get, set):UInt;
	private function get_componentY():UInt { return _filter.componentY; }
	private function set_componentY(value:UInt):UInt
	{
		return _filter.componentY = value;
	}
	
	/**
	   Strength of the displacement
	**/
	public var distortion(get, set):Float;
	private function get_distortion():Float { return _distortion; }
	private function set_distortion(value:Float):Float
	{
		_distortion = value;
		_filter.scaleX = _filter.scaleY = _distortion;
		return value;
	}
	
	/**
	   Strength of the displacement at the end of animation
	   @default 0.0
	**/
	public var distortionEnd(get, set):Float;
	private function get_distortionEnd():Float { return _distortionEnd; }
	private function set_distortionEnd(value:Float):Float
	{
		return _distortionEnd = value;
	}
	
	/**
	   Strength of the displacement at the start of animation
	   @default 64.0
	**/
	public var distortionStart(get, set):Float;
	private function get_distortionStart():Float { return _distortionStart; }
	private function set_distortionStart(value:Float):Float
	{
		return _distortionStart = value;
	}
	
	/**
	   Animation duration in seconds
	   @default 1.0
	**/
	public var duration(get, set):Float;
	private function get_duration():Float { return _duration; }
	private function set_duration(value:Float):Float
	{
		return _duration = value;
	}
	
	/**
	   The Juggler instance to use to animate
	**/
	public var juggler(get, set):Juggler;
	private function get_juggler():Juggler { return _juggler; }
	private function set_juggler(value:Juggler):Juggler
	{
		return _juggler = value;
	}
	
	/**
	   Effect's radius
	**/
	public var radius(get, set):Float;
	private function get_radius():Float { return _radius; }
	private function set_radius(value:Float):Float
	{
		_filter.mapX = _x - value;
		_filter.mapY = _y - value;
		_filter.mapScaleX = _filter.mapScaleY = value / (_texture.width / 2);
		return _radius = value;
	}
	
	/**
	   Effect's radius at the end of animation
	   @default 600.0
	**/
	public var radiusEnd(get, set):Float;
	private function get_radiusEnd():Float { return _radiusEnd; }
	private function set_radiusEnd(value:Float):Float
	{
		return _radiusEnd = value;
	}
	
	/**
	   Effect's radius at the start of animation
	   @default 20.0
	**/
	public var radiusStart(get, set):Float;
	private function get_radiusStart():Float { return _radiusStart; }
	private function set_radiusStart(value:Float):Float
	{
		return _radiusStart = value;
	}
	
	/**
	   Tells wether the animation should reverse (true) or not (false)
	   @default false
	**/
	public var reverse(get, set):Bool;
	private function get_reverse():Bool { return _reverse; }
	private function set_reverse(value:Bool):Bool
	{
		return _reverse = value;
	}
	
	/**
	   The target to which the filter will be applied. It can either be a DisplayObject or a FilterChain instance.
	   If target is a DisplayObject it will set `displayObject.filter` and the effect can only be applied one at a time.
	   If target is a FilterChain it will use `filterChain.addFilter` and `filterChain.removeFilter`, and several effects can be applied at the same time
	**/
	public var target(get, set):Dynamic;
	private function get_target():Dynamic { return _target; }
	private function set_target(value:Dynamic):Dynamic
	{
		if (value == null)
		{
			_displayObject = null;
			_filterChain = null;
		}
		else if (Std.isOfType(value, DisplayObject))
		{
			_displayObject = cast value;
			_filterChain = null;
		}
		else if (Std.isOfType(value, FilterChain))
		{
			_displayObject = null;
			_filterChain = cast value;
		}
		else
		{
			throw new TypeError("target should be a DisplayObject or FilterChain instance");
		}
		return _target = value;
	}
	
	/**
	   The texture to use for displacement (typically a normal map)
	**/
	public var texture(get, set):Texture;
	private function get_texture():Texture { return _texture; }
	private function set_texture(value:Texture):Texture
	{
		_filter.mapTexture = value;
		return _texture = value;
	}
	
	/**
	   The animation's transition
	   @default Transitions.EASE_OUT
	**/
	public var transition(get, set):String;
	private function get_transition():String { return _transition; }
	private function set_transition(value:String):String
	{
		return _transition = value;
	}
	
	/**
	   The effect's position on x axis
	**/
	public var x(get, set):Float;
	private function get_x():Float { return _x; }
	private function set_x(value:Float):Float
	{
		_filter.mapX = value - _radius;
		return _x = value;
	}
	
	/**
	   The effect's position on y axis
	**/
	public var y(get, set):Float;
	private function get_y():Float { return _y; }
	private function set_y(value:Float):Float
	{
		_filter.mapY = value - _radius;
		return _y = value;
	}
	
	static private var POOL:Array<Shockwave> = new Array<Shockwave>();
	
	static public function fromPool():Shockwave
	{
		if (POOL.length != 0) return POOL.pop();
		return new Shockwave();
	}
	
	static public function toPool(shockwave:Shockwave):Void
	{
		shockwave.clear();
		POOL.push(shockwave);
	}
	
}