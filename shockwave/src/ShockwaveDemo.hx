package;

import starling.animation.Transitions;
import starling.assets.AssetManager;
import starling.core.Starling;
import starling.display.Button;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.filters.DropShadowFilter;
import starling.filters.FilterChain;
import starling.text.TextField;
import starling.text.TextFieldAutoSize;
import starling.textures.RenderTexture;
import starling.textures.Texture;

/**
 * ...
 * @author Matse
 */
class ShockwaveDemo extends Sprite 
{
	private var _assets:AssetManager;
	
	private var _reverseButton:Button;
	private var _textField:TextField;
	
	private var _filterChain:FilterChain;
	private var _background:Image;
	private var _shockwaveTexture:Texture;
	
	private var _isReverse:Bool;
	
	public function new() 
	{
		super();
		
	}
	
	public function start(assets:AssetManager):Void
	{
		_assets = assets;
		
		_background = new Image(_assets.getTexture("background"));
		addChild(_background);
		
		_shockwaveTexture = _assets.getTexture("shockwave_displace");
		
		_filterChain = new FilterChain([]);
		this.filter = _filterChain;
		
		var quad:Quad = new Quad(100, 20);
		var render:RenderTexture = new RenderTexture(Std.int(quad.width), Std.int(quad.height));
		render.draw(quad);
		
		_reverseButton = new Button(render, "reverse OFF");
		_reverseButton.x = stage.stageWidth - _reverseButton.width;
		_reverseButton.addEventListener(Event.TRIGGERED, onReverseButtonClick);
		addChild(_reverseButton);
		
		_textField = new TextField(0, 0, "Click or touch to create shockwave");
		_textField.format.size = 20;
		_textField.format.bold = true;
		_textField.format.color = 0xffffff;
		_textField.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
		center(_textField);
		addChild(_textField);
		_textField.filter = new DropShadowFilter();
		Starling.current.juggler.tween(_textField, 2, {alpha:0, transition:Transitions.EASE_IN_OUT, repeatCount:0, reverse:true});
		
		this.addEventListener(TouchEvent.TOUCH, onTouch);
	}
	
	private function onTouch(evt:TouchEvent):Void
	{
		var touch:Touch = evt.getTouch(_reverseButton);
		if (touch != null) return;
		
		touch = evt.getTouch(stage);
		if (touch != null && touch.phase == TouchPhase.ENDED)
		{
			var shock:Shockwave = Shockwave.fromPool();
			shock.setup(_filterChain, _shockwaveTexture, Starling.current.juggler);
			shock.reverse = _isReverse;
			shock.x = touch.globalX;
			shock.y = touch.globalY;
			shock.addEventListener(Event.COMPLETE, onShockwaveComplete);
			shock.start();
		}
	}
	
	private function onShockwaveComplete(evt:Event):Void
	{
		var shock:Shockwave = cast evt.target;
		shock.pool();
	}
	
	private function onReverseButtonClick(evt:Event):Void
	{
		_isReverse = !_isReverse;
		if (_isReverse)
		{
			_reverseButton.text = "reverse ON";
		}
		else
		{
			_reverseButton.text = "reverse OFF";
		}
	}
	
	/**
	   
	   @param	object
	**/
	private function center(object:DisplayObject):Void
	{
		object.x = (stage.stageWidth - object.width) / 2;
		object.y = (stage.stageHeight - object.height) / 2;
	}
	
}