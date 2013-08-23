package EngineCopter
{
	import cocos2d.CCNode;
	import cocos2d.CCSprite;
	import cocos2d.CCRect;

  /**
   * CCNode for generating and scrolling random terrain.
   */
	public class Terrain extends CCNode 
	{	
		private static const HEIGHT_FACTOR = 75;
		private static const STEP_FACTOR = 40;
		
		private var _width = 0;
		private var _height = 0
		private var _tempRect:CCRect;
		private var _counter = 0;
		private var _positionCounter = 1;
		private var blocks1:Vector.<CCSprite>;
		private var blocks2:Vector.<CCSprite>;
		private var middleBlocks1:Vector.<CCSprite>;
		private var middleBlocks2:Vector.<CCSprite>;
	
		public function Terrain(w:Number, h:Number)
		{
			_width = w;
			_height = h;
			
			blocks1 = allocateBlocks(20);
			blocks2 = allocateBlocks(20);
			middleBlocks1 = allocateBlocks(2);
			middleBlocks2 = allocateBlocks(2);
			buildTerrain();
		}
		
		public function reset()
		{
			x = 0;
			_counter = 0;
			_positionCounter = 1;
			buildTerrain();
		}
		
		public function scroll(value:Number)
		{
			x -= value;
			_counter += value;

			if(_counter >= _width) 
			{
				// destroy the first 20 blocks and build them back
				_counter = 0;
				_positionCounter++;
				
				var temp = blocks1;
				blocks1 = blocks2;
				blocks2 = temp;
				
				temp = middleBlocks1;
				middleBlocks1 = middleBlocks2;
				middleBlocks2 = temp;
				
				positionBlocks(_positionCounter*_width, blocks2);
				positionMiddleBlocks(_positionCounter*_width, middleBlocks2);
			}
		}
		
		public function hitTest(x:Number, y:Number):Boolean
		{
			for(var i=0; i<blocks1.length; i++)
			{
				var block = blocks1[i];
				if(block.hitTest_loomscript(x,y))
					return true;
					
				block = blocks2[i];
				if(block.hitTest_loomscript(x,y))
					return true;
			}
			
			for(var j=0; j<middleBlocks1.length; j++)
			{
				var middleBlock = middleBlocks1[j];
				if(middleBlock.hitTest_loomscript(x,y))
					return true;
					
				middleBlock = middleBlocks2[j];
				if(middleBlock.hitTest_loomscript(x,y))
					return true;
			}
			
			return false;
		}
		
		protected function allocateBlocks(num:Number):Vector.<CCSprite>
		{
			var source = new Vector.<CCSprite>();
			
			for(var i=0; i<num; i++)
			{
				var block = CCSprite.createFromFile("assets/bg.png");
				this.addChild(block);
				source.push(block);
			}
			
			return source;
		}
		
		protected function buildTerrain()
		{
			positionBlocks(0, blocks1);
			positionBlocks(_width, blocks2);
			positionMiddleBlocks(0, middleBlocks1);
			positionMiddleBlocks(_width, middleBlocks2);
		}
		
		protected function positionBlocks(startLocation:Number, container:Vector.<CCSprite>)
		{
			var lastHeight = HEIGHT_FACTOR/2;
		
			for(var i=0; i<container.length; i++)
			{
				var block = container[i];
			
				var w = _width/10;
				var h = lastHeight - STEP_FACTOR/2 + (STEP_FACTOR*Math.random());
				h = Math.clamp(h, 0, HEIGHT_FACTOR);
			
				block.x = startLocation +  w*(i%10) + (w/2);
				
				if(i >= 10)
					block.y = _height - (h/2);
				else
					block.y = h/2;
				
				_tempRect.setRect(0, 0, w, h);
				block.setTextureRect(_tempRect);
			}
		}
		
		protected function positionMiddleBlocks(startLocation:Number, container:Vector.<CCSprite>)
		{
			for(var i=0; i<container.length; i++)
			{
				var block = container[i];
				block.x = startLocation + _width * Math.random();
				block.y = _height * Math.random();
				
				_tempRect.setRect(0, 0, 40, 75 + (Math.random()*75));
				block.setTextureRect(_tempRect);
			}
		}
		
	}

}
