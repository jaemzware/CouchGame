//
//  CouchViewController.h
//  CouchGame
//
//  Created by JAMES K ARASIM on 10/22/13.
//  Copyright (c) 2013 JAMES K ARASIM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "ImageToDrag.h"
#import "ImageToHit.h"
#import "ImageToShoot.h"
#import "HitItemModel.h"

//delegate method implemented by viewcontroller when image is hit; to update the score
@protocol ReportScoreDelegate <NSObject>
@required
-(void)setScore:(long)score;
@end

//note, this is a delegate for ImageToHit (see ImageToHit.h for delegate definition)
@interface CouchViewController : UIViewController <ImageToHitDelegate,ImageToShootDelegate,ImageToDragDelegate>
{
    //INSTANCE VARIABLES
 
}

@property (nonatomic, strong) NSArray<HitItemModel *> *hitItems;

//access to delegate
@property (weak, nonatomic) id <ReportScoreDelegate> delegate;

//SOUND
//instance variable player for playing sounds
// In CouchViewController.h
@property (nonatomic, strong) AVAudioPlayer *owAudioPlayer; // Keep this one for the "ow" sound when losing lives
@property (nonatomic, strong) NSMutableDictionary *audioPlayers; // For all other sounds

//weak means this will not hold a reference to the object
@property (weak, nonatomic) IBOutlet UILabel *score; //label for showing score

@property long lScore; //model object for keeping track of score

@property ImageToDrag * couch;

@property NSTimer * addTargetTimer; //timer for dropping objects to hit

@property  UIImage * fireBullet; //image to use for fire bullets

@property UIImageView * backgroundImage; //image to use for the background

@property float timerIncrement; //how long to wait between dropping objects to hit

@property int maxObjects; //for keeping track of total objects in the view at one time

@property int duration; //for keeping track of how long the game has gone

@property int lives; //for keeping track of couch lives

//array of filenames of images to hit
@property  NSArray * imagesToHitFileNameArray;

//array of sounds the images to hit make
@property NSArray * imageSoundsArray;

//array of images to hit
@property  NSArray * imagesToHitArray;

-(void)AddAnImageToHit; //for adding objects to hit to the main view

-(void)AdjustScore:(int)points; //for adding/removing points to the overall score, required by delegates

-(void)PlaySound:(NSString*)soundFile; //for playing a sound when something is hit, required by ImageToHitDelegate

-(void)Fire;

-(void)EndGame; //for ending the game for whatever reason

@end
