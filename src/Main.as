package 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.*;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	import flash.system.fscommand;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	
	import gl.events.GestureEvent;
	import gl.events.TouchEvent;
	
	import id.component.DrawUser;
	import id.core.Application;
	import id.core.ApplicationGlobals;
	import id.core.TouchSprite;
	import id.module.GMapViewer;
	import id.module.YouTubeViewer;
	import id.template.MagnifierViewer;
	
	public class Main extends Application
	{
		protected var maps:Array = [];
		public var viewer:MagnifierViewer;
		
		protected var viewerLayer:TouchSprite = new TouchSprite();
		protected var mapSwitchButtonLayer:TouchSprite = new TouchSprite();
		protected var logoLayer:TouchSprite = new TouchSprite();
		
		protected var resetTimer:Timer;
		
		public function Main()
		{
			settingsPath = "config/"+Global.environment+"/Application.xml";
		}

		override protected function initialize():void
		{
			Player.runFullscreen = (ApplicationGlobals.dataManager.data.Template.fullscreen == "true");
			Player.runOffline = (ApplicationGlobals.dataManager.data.Template.offline == "true");
			Player.offlineHost = ApplicationGlobals.dataManager.data.Template.offlineHost;
			Player.videoHD = (ApplicationGlobals.dataManager.data.Template.videoHD == "true");
			Player.isTUIO = (ApplicationGlobals.dataManager.data.TouchCore.InputProvider == "Flosc");
			
			if ( Player.runFullscreen )	{
				stage.scaleMode = StageScaleMode.SHOW_ALL;
				stage.displayState = StageDisplayState.FULL_SCREEN;			
			} else {
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
			}
			
			if ( Player.isTUIO ) {
				Mouse.hide();
			}
			
			stage.showDefaultContextMenu = false;
			
			resetTimer = new Timer(6*60*1000,0);// reset application every 6 minutes when no touches are detected, touches are detected in main.as
			resetTimer.addEventListener(TimerEvent.TIMER, onResetTimerComplete);
			resetTimer.start();		
			
			if ( Player.useSecureDomain ) {
				Security.allowDomain("*");
				Security.allowInsecureDomain("*");	
			}
			
			addChild(viewerLayer);
			addChild(mapSwitchButtonLayer);
			
			stage.frameRate = ApplicationGlobals.dataManager.data.Template.FrameRate;
			addEventListener(TouchEvent.TOUCH_UP, onTouch);
			
			for ( var i:int=0; i<ApplicationGlobals.dataManager.data.Maps.Map.length(); i++ ) {
				var name:String = ApplicationGlobals.dataManager.data.Maps.Map[i].Name;
				var content:String = ApplicationGlobals.dataManager.data.Maps.Map[i].Content;

				maps.push( new MapData(name, content) );
				
				if ( Global.MULTIMAPMODE ) {
					var switchButton:SwitchButton = new SwitchButton(name);
					switchButton.y = (switchButton.size + 10) * i;
					switchButton.addEventListener(TouchEvent.TOUCH_UP, function(e:TouchEvent):void {
						loadMapWithName( (e.target as SwitchButton).caption );
					} );
					mapSwitchButtonLayer.addChild(switchButton);
				}
			}

			loadMapWithName( (maps[0] as MapData).name );
		}
		
		protected function loadMapWithName(name:String):void {
			if ( viewer ) {
				trace("destroy viewer");
				viewer.Dispose();
				Global.viewer = viewer = null;
			}
			
			Global.viewer = viewer = new MagnifierViewer();
			viewerLayer.addChild(viewer);
		}
		
		protected function onTouch(e:TouchEvent):void {
			resetTimer.reset();
			resetTimer.start();
		}

		protected function onResetTimerComplete(e:TimerEvent):void
		{
			if ( Player.runFullscreen ) {
				stage.displayState = StageDisplayState.FULL_SCREEN;
			}
			
			if ( viewer ) 	viewer.reset();
		}
		
		public function map(v:Number, a:Number, b:Number, x:Number = 0, y:Number = 1):Number {
    		return (v == a) ? x : (v - a) * (y - x) / (b - a) + x;
		}
	}
}