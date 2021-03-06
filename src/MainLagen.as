﻿package 
{
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import id.core.Application;
	import id.core.ApplicationGlobals;
	import id.module.GMapViewer;
	import id.module.YouTubeViewer;
	import id.core.TouchSprite;
	import id.component.DrawUser;

	import flash.ui.Mouse;
	import id.core.ApplicationGlobals;
	import id.template.MagnifierViewer;
	import gl.events.TouchEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import gl.events.GestureEvent;
	import id.core.TouchSprite;
	import flash.system.fscommand;

		import flash.geom.*;
		import flash.display.Sprite;
		import flash.events.Event;
		 import flash.system.Security;
 import flash.system.SecurityPanel;
	
	public class Main extends Application
	{
		private var gMapViewer:GMapViewer;
		private var youTubeViewer:YouTubeViewer;
		private var objects:Array = new Array();
		private var square:TouchSprite = new TouchSprite();

		private var squareB:TouchSprite = new TouchSprite();
		private var squareC:TouchSprite = new TouchSprite();
		private var squareD:TouchSprite = new TouchSprite();
		private var squareE:TouchSprite = new TouchSprite();
		private var squareF:TouchSprite = new TouchSprite();
		private var squareG:TouchSprite = new TouchSprite();
		private var nextLayer:TouchSprite = new TouchSprite();
		private var lineLayer:TouchSprite = new TouchSprite();
		private var userContent:DrawUser;
		private var container:MagnifierViewer;
		private var alles:TouchSprite = new TouchSprite();
		
  		private var inDrag:Boolean = false;
		private var offsetX:int;
		private var offsetY:int;
		private var dragStart:Point;
		private var currentXrotation:Number = 0;
		//private var tray:TouchSprite = new TouchSprite;


		public function Main()
		{
			settingsPath = "config/Application.xml";

			stage.scaleMode = StageScaleMode.NO_SCALE;
			//stage.displayState = StageDisplayState.FULL_SCREEN;
			stage.align = StageAlign.TOP_LEFT;
			var timer = new Timer(50000,0);// reset application every 5 minutes when no touches are detected, touches are detected in main.as
			timer.addEventListener(TimerEvent.TIMER, reset);
			timer.start();		
			
			addChild(square);
			Security.allowDomain("*");
			trace("hallo");
			//Security.allowInsecureDomain("*");
			Security.allowInsecureDomain("*");
			Security.loadPolicyFile("http://193.190.58.10/~dleen/Z33/gmapViewer/crossdomain.xml");			
		}

		override protected function initialize():void
		{
			stage.frameRate = ApplicationGlobals.dataManager.data.Template.FrameRate;
			container = new MagnifierViewer();
			//addChild(container);
			addEventListener(TouchEvent.TOUCH_UP, update);
			
			square.graphics.beginFill(0x000000 , 1);
			square.graphics.drawRect(0,0,stage.width,stage.height);
			square.graphics.endFill();
			
			
			
			squareB.graphics.beginFill(0x23E0FF , 0.01);
			squareB.graphics.drawRect(0,0,stage.width,stage.height);
			squareB.graphics.endFill();
			squareB.z= -300;
			
			squareC.graphics.beginFill(0xFFFFFF , 1);
			squareC.graphics.drawRect(0,0,300,80);
			squareC.graphics.endFill();
			
			squareC.y = stage.height;
			squareC.rotationX = 90;
			
			
			squareD.graphics.beginFill(0xFFFFFF , 1);
			squareD.graphics.drawRect(0,0,300,80);
			squareD.graphics.endFill();
			
			squareD.y = stage.height;
			//squareD.rotationX = 20;
			
			squareE.graphics.beginFill(0xFFFFFF , 1);
			squareE.graphics.drawRect(0,0,stage.width,10);
			squareE.graphics.endFill();
			squareC.addChild(squareE);
			
			
			squareF.graphics.beginFill(0xFFFFFF , 1);
			squareF.graphics.drawRect(0,0,stage.width,10);
			squareF.graphics.endFill();
			squareD.addChild(squareF);
			
			squareG.graphics.beginFill(0x36A9E1 , 1);
			squareG.graphics.drawEllipse(0,0,40,40);
			squareG.x= 200;
			squareG.y= 100;
			squareG.graphics.endFill();
			squareG.z = -100;
			
			
			squareG.addEventListener(TouchEvent.TOUCH_MOVE, driedee);
			
			nextLayer.graphics.beginFill(0x36A9E1 , 1);
			nextLayer.graphics.drawEllipse(0,0,40,40);
			nextLayer.x= 300;
			nextLayer.y= 100;
			nextLayer.graphics.endFill();
			nextLayer.z = -100;
			
			lineLayer.graphics.beginFill(0x000000 , 1);
			lineLayer.graphics.drawRect(0,0,10,800);
			lineLayer.x= 215;
			lineLayer.y= 100;
			lineLayer.graphics.endFill();
			lineLayer.z = -100;
			
			
			addChild(alles);
			alles.addChild(container);
			
			fscommand("exec", "Start.bat");
			userContent = new DrawUser(stage.width,stage.height);
			
			//alles.addChild(squareA);
			alles.addChild(squareB);

			//squareA.addChild(squareD);
			squareB.addChild(squareC);
			alles.addChild(userContent);
			addChild(lineLayer);
			addChild(squareG);
			addChild(nextLayer);
			
			//stage.addEventListener(MouseEvent.MOUSE_DOWN, startMoveObject);
			//stage.addEventListener(MouseEvent.MOUSE_UP, stopMoveObject);
			//stage.addEventListener( MouseEvent.MOUSE_MOVE, doMoveObject);
			nextLayer.addEventListener(TouchEvent.TOUCH_DOWN, touchHandler);
			squareG.addEventListener(TouchEvent.TOUCH_UP, touchUp);
			//addEventListener(GestureEvent.GESTURE_TILT, gestureTiltHandler);
			
			
		}
		private function touchHandler(e:TouchEvent){
			addEventListener(Event.ENTER_FRAME, onFrame);
			}
		private function touchUp(e:TouchEvent){
			removeEventListener(Event.ENTER_FRAME,onFrame );
			//trace("remove");
			}
			
		private function onFrame(e:Event){
						
			if(alles.rotationX > -50){
				//trace(alles.rotationX);
			alles.rotationX -=3;
			//alles.scaleX *=0.99;
			//alles.scaleY *=0.99;
			userContent.touchLayer();
			alles.z +=80;
			squareG.y +=10;
			
			}			
			}
		
		private function driedee(e:TouchEvent){
			//trace("maak 3d", e.localY);
			if(e.stageY-20 < 80){
				alles.rotationX =0;
				alles.z = 0;
				alles.y = 0 ;
				}
			if(e.stageY-20 > 80 && e.stageY-20 < 800){
			squareG.y = e.stageY-20; 
			alles.rotationX = map(-e.stageY, 70,800, 0,90);
			alles.z = map(e.stageY, 130, 800, 0, 2400);
			alles.y = map(e.stageY, 70, 800, 0, 900);
			//container.z = 2400;
			//container.x =-500;
			}
			
			}
		

		
		/*public function startMoveObject(e:MouseEvent):void
		{
			dragStart = new Point(e.stageX,e.stageY);
			inDrag = true;
		}
		
		public function stopMoveObject(e:MouseEvent):void
		{
			inDrag = false;
		}
			
		public function doMoveObject(e:MouseEvent):void
		{
			if (inDrag)
			{
				//Convert to integer to avoid rounding errors that could accumulate
				var posX:int=e.stageX;
				var posY:int=e.stageY;
				orbitObjects(posX - dragStart.x, posY - dragStart.y);
				dragStart=new Point(posX,posY);
			}
		}
		public function orbitObjects(offsetX:int, offsetY:int):void
		{
			//Don't bother if no rotate
			if (offsetX==0 && offsetY==0)
			{
				return;
			}

				//Since most of the time the rotation will involve both
				//x and y rotation, and given that 3D rotations are not commutative,
				//meaning that the order of operation is important, this code will always
				//undo the previous X axis rotation, then perform the Y and X rotations.
				//This preserves the not tilted attribute (no Z rotation). If the two rotations
				//were performed without the "undo", then soon the object gets tilted even when
				//trying to rotate back to the original position. Use the transform.matrix3D API
				//as it is more efficient when performing multiple transformations
	
				//"Undo" the X rotation from previous rotation
				tray.transform.matrix3D.prependRotation(-currentXrotation, Vector3D.X_AXIS);
	
				//Apply the new Y rotation
				//tray.transform.matrix3D.prependRotation(-offsetX /2, Vector3D.Y_AXIS);
	
				//Add the new X rotation to previous X rotation and "re"apply it
				currentXrotation += offsetY / 2;
				tray.transform.matrix3D.prependRotation(currentXrotation, Vector3D.X_AXIS);
				//trace("rotation= " + tray.rotationX + "," + tray.rotationY + "," + tray.rotationZ);
			*/
		//}
	//}

		private function reset(e:Event)
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			//stage.displayState = StageDisplayState.FULL_SCREEN;
			stage.align = StageAlign.TOP_LEFT;

		}
		private function update(e:Event)
		{
			//trace('Down', '--> reset');
			container.updater();
		}
		function map(v:Number, a:Number, b:Number, x:Number = 0, y:Number = 1):Number {
    return (v == a) ? x : (v - a) * (y - x) / (b - a) + x;
}
	}
}