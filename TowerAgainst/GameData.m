//
//  GameData.m
//  TowerDenfese
//
//  Created by NOMIS on 6/23/13.
//  Copyright (c) 2013 nomis. All rights reserved.
//

#import "GameData.h"
#import "GlobalData.h"
#import "GameDefine.h"
#import "GameUILayer.h"
#import "MoneySprite.h"
#import "GameWinLayer.h"
#import "GameFailedLayer.h"
#import "Hole.h"


@implementation GameData
@synthesize life;
@synthesize fullLife;
@synthesize money;
@synthesize waveCount;
@synthesize projectiles;

@synthesize towers;
@synthesize creeps;
@synthesize wayPoints;
@synthesize wave;
@synthesize waves;
@synthesize nowCreepInWaveIndex;
@synthesize holes;
@synthesize initPoint;
@synthesize targetPoint;
@synthesize mapItems;
@synthesize baseLayer;
@synthesize isTowerCreateComponentSelect;

static dispatch_once_t  onceToken;
static GameData * sSharedInstance;
- (void)dealloc
{
    [projectiles release] , projectiles = nil;
    [wayPoints release] , wayPoints = nil;
    [creeps release] , creeps = nil;
    [towers release] , towers = nil;
    [waves release] , waves = nil;
    [mapItems release] , mapItems = nil;
    [holes release] , holes = nil;
    [super dealloc];
}
+ (GameData *)sharedInstance{
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[GameData alloc] init];
    });
    return sSharedInstance;
}
+ (void)releaseInstance{
    onceToken = nil;
    [sSharedInstance release] , sSharedInstance = nil;
}

- (id)init
{
    self = [super init];
    if (self) {

        GlobalData *globalData = [GlobalData sharedInstance];
        baseLayer = [CCNode node];
        baseLayer.anchorPoint = ccp(0.5 , 0.5);
        baseLayer.contentSize = CGSizeMake(480*globalData.winScale, 320*globalData.winScale);
        baseLayer.position = [globalData ccpCenter];
        
        
        money = 0;
        fullLife = GAME_LIFE;
        life = fullLife;
        wave = 1;
        waveCount = 0;
        nowCreepInWaveIndex = 0;
        isTowerCreateComponentSelect = false;
        
        projectiles = [[CCArray alloc]init];
        wayPoints = [[CCArray alloc]init];
        creeps = [[CCArray alloc]init];
        towers = [[CCArray alloc]init];
        waves = [[CCArray alloc]init];
        holes = [[CCArray alloc]init];
        mapItems = [[CCArray alloc]init];

    }
    return self;
}
- (void)loseLife:(int)index{
    life = life - index;
    if(life <= 0){
        GameFailedLayer *scene = [GameFailedLayer node];
        [[[CCDirector sharedDirector]runningScene] addChild:scene z:GAME_LAYER_ALERT tag:GAME_TAG_LAYER_FAILED];
        
    }
}
- (void)addMoney:(int)index{
    money = index+money;
    GameUILayer *scene = (GameUILayer*)[[[CCDirector sharedDirector]runningScene] getChildByTag:GAME_TAG_LAYER_UI];
    MoneySprite *moneySprite = (MoneySprite*)[scene getChildByTag:GAME_TAG_SPRITE_MONEY];
    [moneySprite changeMoney:money];
}
- (bool)loseMoney:(int)index{
    if(money >index){
        money = money-index;
        GameUILayer *scene = (GameUILayer*)[[[CCDirector sharedDirector]runningScene] getChildByTag:GAME_TAG_LAYER_UI];
        MoneySprite *moneySprite = (MoneySprite*)[scene getChildByTag:GAME_TAG_SPRITE_MONEY];
        [moneySprite changeMoney:money];
        return true;
    }
    else return false;
}
- (bool)isMoneyEnough :(int)index{
    if(money>=index) return true;
    else return false;
}

@end
