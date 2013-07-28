//
//  GameScene.m
//  TowerDenfese
//
//  Created by NOMIS on 6/18/13.
//  Copyright 2013 nomis. All rights reserved.
//

#import "GameScene.h"
#import "GameUILayer.h"
#import "GameDefine.h"
#import "Hole.h"
#import "Tower.h"
@implementation GameScene
@synthesize gameData;
@synthesize globalData;
-(void)dealloc{
    [GameData releaseInstance];
    [super dealloc];
}
+(CCScene*) scene{
    CCScene *scene = [CCScene node];
    
    GameScene *layer = [GameScene node];
    [scene addChild:layer z:GAME_LAYER_MAP tag:GAME_TAG_LAYER_MAP];
    
    GameUILayer *uiLayer = [GameUILayer node];
    [scene addChild:uiLayer z:GAME_LAYER_UI tag:GAME_TAG_LAYER_UI];
    return scene;
}
- (id)init
{
    self = [super init];
    if (self) {
        [self setTouchEnabled:YES];
        globalData = [GlobalData sharedInstance];
        gameData = [GameData sharedInstance];
        
        CCSprite *background = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"map%d.png", globalData.selectMap ]];
        background.position = [globalData ccp:[globalData winSize].width/2 :[globalData winSize].height/2 ];
        [self addChild:background z:GAME_LAYER_MAP];
        [self addChild:gameData.baseLayer z:GAME_LAYER_BASE tag:GAME_TAG_LAYER_BASE];

        
        CCSprite *countDownSprite = [CCSprite spriteWithSpriteFrameName:@"Game_CountDown/0000"];
        countDownSprite.position = [globalData ccpCenter];
        [self addChild:countDownSprite];
        CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        
        NSMutableArray *frames = [NSMutableArray array];
        for(int i = 0; i<83;i++){
            NSString *fileName;
            if(i<10)
                fileName= [NSString stringWithFormat:@"Game_CountDown/000%d" , i];
            else{
                fileName = [NSString stringWithFormat:@"Game_CountDown/00%d" , i ];
            }
            [frames addObject:[frameCache spriteFrameByName:fileName]];
        }
        
        CCAnimation* anim = [CCAnimation animationWithSpriteFrames:frames delay:0.042];
        CCAnimate* animate = [CCAnimate actionWithAnimation:anim];
        id action = [CCSequence actions:animate , [CCCallFunc actionWithTarget:self selector:@selector(gameStart:)], nil];
        [countDownSprite runAction:action];
    }
    return self;
}

-(void)update:(ccTime)delta{

}


- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch  *touch=[touches anyObject];
	CGPoint  touchLocation= [touch locationInView:[touch view]];
    
    CGPoint  glLocation=[[CCDirector sharedDirector] convertToGL:touchLocation];
    glLocation = [gameData.baseLayer convertToNodeSpace:glLocation];
    CCLOG(@"click %f,%f",glLocation.x,glLocation.y);
    
}

@end
