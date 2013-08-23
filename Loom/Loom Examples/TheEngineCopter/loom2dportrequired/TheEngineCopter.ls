package
{
    import cocos2d.Cocos2DGame;
    import cocos2d.CCSprite;
    import cocos2d.ScaleMode;
    import cocos2d.ccColor3B;

    import loom.animation.LoomTween;
    import loom.animation.LoomEaseType;

    import EngineCopter.Terrain;

    import UI.Label;

    /**
    * Helicopter Game example where you fly a Poly through
    * a wondrous and magical cave. Can you unconver the hidden
    * secrets of the wondrous and magical cave?!?
    */
    public class TheEngineCopter extends Cocos2DGame
    {
        public static const ASCENT_FACTOR = 1.5;
        public static const DESCENT_FACTOR = 2.25;
        public static const SCROLL_SPEED_NORMAL = 2.5;
        public static const SCROLL_SPEED_FORWARD = 3;
        public static var scrollSpeed = SCROLL_SPEED_NORMAL;

        public var isPlaying:Boolean = false;
        public var hero:CCSprite;
        public var label:SimpleLabel;
        public var scoreLabel:SimpleLabel;
        public var terrain:Terrain;
        public var score = 0;

        public var isTouching:Boolean;

        override public function run():void
        {
            // Comment out this line to turn off automatic scaling.
            layer.scaleMode = ScaleMode.LETTERBOX;

            super.run();

            terrain = new Terrain(layer.designWidth, layer.designHeight);
            layer.addChild(terrain);

            hero = CCSprite.createFromFile("assets/polycopter.png");
            hero.x = 80;
            hero.y = 120;
            hero.scale = 0.5;
            hero.setVisible(false);
            layer.addChild(hero);

            label = new SimpleLabel("assets/Curse-hd.fnt");
            label.text = "Tap to play";
            label.x = 240;
            label.y = 180;
            layer.addChild(label);

            var redColor:ccColor3B;
            redColor.r = 255;
            redColor.g = 0;

            scoreLabel = new SimpleLabel("assets/Curse-hd.fnt");
            scoreLabel.text = "0";
            scoreLabel.x = 240;
            scoreLabel.y = 32;
            scoreLabel.scale = 0.5
            scoreLabel.setColor(redColor);
            layer.addChild(scoreLabel);

            layer.onTouchBegan += function() {
                if(!isPlaying)
                    startGame();

                isTouching=true;
                LoomTween.to(hero, 0.4, {"rotation":20, "ease": LoomEaseType.EASE_OUT_BACK});
                scrollSpeed = SCROLL_SPEED_FORWARD;
            }

            layer.onTouchEnded += function() {
                isTouching=false;
                LoomTween.to(hero, 0.4, {"rotation":0, "ease": LoomEaseType.EASE_OUT_BACK});
                scrollSpeed = SCROLL_SPEED_NORMAL;
            }
        }

        override protected function onTick()
        {
            if(isPlaying)
            {
                moveHero();
                scrollTerrain();
                hitDetection();
            }

            scoreLabel.text = score.toString();
        }

        protected function scrollTerrain()
        {
            score += scrollSpeed;
            score = Math.round(score);
            terrain.scroll(scrollSpeed);
        }

        protected function moveHero()
        {
            if(isTouching)
                hero.y += ASCENT_FACTOR;
            else
                hero.y -= DESCENT_FACTOR;

            hero.y = Math.clamp(hero.y, 0, 320);
        }

        protected function hitDetection()
        {
            if(terrain.hitTest(hero.x, hero.y))
            {
                endGame();
            }
        }

        protected function startGame()
        {
            score = 0;
            terrain.reset();
            isPlaying = true;
            label.setVisible(false);
            hero.setVisible(true);
            hero.x = 80;
            hero.y = 120;
        }

        protected function endGame()
        {
            isPlaying = false;

            LoomTween.to(hero, 0.5, {"rotation": 180, "y": hero.y+100, "ease": LoomEaseType.EASE_OUT}).onComplete += function(tween:LoomTween) {
                LoomTween.to(hero, 0.5, {"y": -hero.getContentSize().height});
            };

            label.setVisible(true);
            label.text = "Game Over."
        }
    }
}
