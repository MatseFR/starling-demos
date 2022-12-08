package;

import openfl.display.Sprite;
import openfl.Lib;
import openfl.display.StageScaleMode;
import openfl.display3D.Context3DRenderMode;
import openfl.errors.Error;
import openfl.geom.Rectangle;
import openfl.system.Capabilities;
import openfl.utils.Assets;
import starling.assets.AssetManager;
import starling.core.Starling;
import starling.events.Event;
import starling.utils.Max;

/**
 * ...
 * @author Matse
 */
class Main extends Sprite 
{
	private var _starling:Starling;
	private var _assets:AssetManager;

	/**

	**/
	public function new() 
	{
		super();
		
		if (stage != null) start();
		else addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}

	private function onAddedToStage(event:Dynamic):Void
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

		stage.scaleMode = StageScaleMode.NO_BORDER;

		start();
	}

	private function start():Void
	{
		Starling.multitouchEnabled = true; // for Multitouch Scene

		_starling = new Starling(ShockwaveDemo, stage, null, null, Context3DRenderMode.AUTO, "auto");
		//_starling.stage.stageWidth = Constants.GameWidth;
		//_starling.stage.stageHeight = Constants.GameHeight;
		_starling.enableErrorChecking = Capabilities.isDebugger;
		_starling.showStats = true;
		_starling.skipUnchangedFrames = true;
		_starling.supportBrowserZoom = true;
		_starling.supportHighResolutions = true;
		_starling.simulateMultitouch = true;
		_starling.addEventListener(Event.ROOT_CREATED, function():Void
		{
			loadAssets(startGame);
		});

		this.stage.addEventListener(Event.RESIZE, onResize, false, Max.INT_MAX_VALUE, true);

		_starling.start();
	}

	private function loadAssets(onComplete:Void->Void):Void
	{
		_assets = new AssetManager();

		_assets.verbose = Capabilities.isDebugger;
		_assets.enqueue([
			Assets.getPath ("assets/img/background.jpg"),
			Assets.getPath ("assets/img/shockwave_displace.png"),
		]);
		_assets.loadQueue(onComplete);
	}
	
	private function startGame():Void
    {
        var demo:ShockwaveDemo = cast(_starling.root, ShockwaveDemo);
        demo.start(_assets);
    }
	
	private function onResize(e:openfl.events.Event):Void
    {
        //var viewPort:Rectangle = RectangleUtil.fit(new Rectangle(0, 0, Constants.GameWidth, Constants.GameHeight), new Rectangle(0, 0, stage.stageWidth, stage.stageHeight));
        //try
        //{
            //this._starling.viewPort = viewPort;
        //}
        //catch(error:Error) {}
    }

}
