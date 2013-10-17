package dragonBones.display
{
	/**
	* Copyright 2012-2013. DragonBones. All Rights Reserved.
	* @playerversion Flash 10.0
	* @langversion 3.0
	* @version 2.0
	*/


	import com.sig.starling.StarlingUtils;

	import dragonBones.objects.DBTransform;
	
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.textures.Texture;
	
	/**
	 * The StarlingDisplayBridge class is an implementation of the IDisplayBridge interface for starling.display.DisplayObject.
	 *
	 */
	public class StarlingDisplayBridge implements IDisplayBridge
	{
		private var _imageBackup:Image;
		private var _textureBackup:Texture;
		private var _pivotXBackup:Number;
		private var _pivotYBackup:Number;
		
		private var _display:Object;
		/**
		 * @inheritDoc
		 */
		public function get display():Object
		{
			return _display;
		}
		public function set display(value:Object):void
		{
			if (_display is Image && value is Image)
			{
				var from:Image = _display as Image;
				var to:Image = value as Image;
				if (from.texture == to.texture)
				{
					if(from == _imageBackup)
					{
						from.texture = _textureBackup;
						from.pivotX = _pivotXBackup;
						from.pivotY = _pivotYBackup;
						from.readjustSize();
					}
					return;
				}
			
				from.texture = to.texture;
				//update pivot
				from.pivotX = to.pivotX;
				from.pivotY = to.pivotY;
				from.readjustSize();
				return;
			}
			
			if (_display == value)
			{
				return;
			}
			// SIG: faster display switching
			if (_display)
			{
				replaceDisplay( value )
			}
			else if(value is Image && !_imageBackup)
			{
				_imageBackup = value as Image;
				_textureBackup = _imageBackup.texture;
				_pivotXBackup = _imageBackup.pivotX;
				_pivotYBackup = _imageBackup.pivotY;
			}
			_display = value;
		}
		
		public function get visible():Boolean
		{
			return _display?_display.visible:false;
		}
		public function set visible(value:Boolean):void
		{
			if(_display)
			{
				_display.visible = value;
			}
		}
		
		/**
		 * Creates a new StarlingDisplayBridge instance.
		 */
		public function StarlingDisplayBridge()
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function dispose():void
		{
			_display = null;
			_imageBackup = null;
			_textureBackup = null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function updateTransform(matrix:Matrix, transform:DBTransform):void
		{
			var pivotX:Number = _display.pivotX;
			var pivotY:Number = _display.pivotY;
			matrix.tx -= matrix.a * pivotX + matrix.c * pivotY;
			matrix.ty -= matrix.b * pivotX + matrix.d * pivotY;
			//if(updateStarlingDisplay)
			//{
			//	_display.transformationMatrix = matrix;
			//}
			//else
			//{
				_display.transformationMatrix.copyFrom(matrix);
			//}
		}
		
		/**
		 * @inheritDoc
		 */
		public function updateColor(
			aOffset:Number, 
			rOffset:Number, 
			gOffset:Number, 
			bOffset:Number, 
			aMultiplier:Number, 
			rMultiplier:Number, 
			gMultiplier:Number, 
			bMultiplier:Number
		):void
		{
			_display.alpha = aMultiplier;
			if (_display is Quad)
			{
				(_display as Quad).color = (uint(rMultiplier * 0xff) << 16) + (uint(gMultiplier * 0xff) << 8) + uint(bMultiplier * 0xff);
			}
		}
        
        /**
         * @inheritDoc
         */
        public function updateBlendMode(blendMode:String):void
        {
            if (_display is DisplayObject)
            {
                _display.blendMode = blendMode;
            }
        }

		// SIG: use faster methods
		/**
		 * @inheritDoc
		 */
		public function addDisplay(container:Object, index:int = -1):void
		{
			var parent : DisplayObjectContainer = container as DisplayObjectContainer;
			var display : DisplayObject = _display as DisplayObject;
			if (container && _display)
			{
				if (index < 0)
				{
					StarlingUtils.addChildSilent( parent, display );
				}
				else
				{
					StarlingUtils.addChildSilentAt( parent, display, Math.min( index, container.numChildren ) );
				}
			}
		}

		// SIG: use faster methods
		/**
		 * @inheritDoc
		 */
		public function removeDisplay():void
		{
			var display : DisplayObject = _display as DisplayObject;
			if (display && display.parent)
			{
				StarlingUtils.removeChildSilent( display.parent, display );
			}
		}

		// SIG: faster display switching
		public function replaceDisplay( newDisplay : Object ) : void {
			var display : DisplayObject = _display as DisplayObject;
			var parent : DisplayObjectContainer = _display.parent as DisplayObjectContainer;
			var newStarlingDisplay : DisplayObject = newDisplay as DisplayObject;
			if ( display && parent ) {
				if ( newStarlingDisplay ) {
					StarlingUtils.changeChildSilent( parent, display, newStarlingDisplay );
				} else {
					StarlingUtils.removeChildSilent( display.parent, display );
				}
			}
		}
	}
}