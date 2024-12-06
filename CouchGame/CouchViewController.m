//
//  CouchViewController.m
//  CouchGame
//
//  Created by JAMES K ARASIM on 10/22/13.
//  Copyright (c) 2013 JAMES K ARASIM. All rights reserved.
//

#import "CouchViewController.h"
#import "StartGameViewController.h"

@interface CouchViewController ()

@end

@implementation CouchViewController

//array of valid speeds for the images to hit
float imageToHitSpeeds[]={0.04,0.035,0.03,0.025,0.02,0.015,0.01,0.0095,0.009,0.0085,0.008,0.0075,0.007,0.0065,0.006,0.0055,0.005};

//number of speeds in the imageToHitSpeeds array, set dynamically in viewDidLoad
int numberOfSpeeds;

//how many durations to wait until increasing difficulty
int levelUp = 50;

//called everytime the view comes into play
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set welcome screen as delegate for this view controller, so high score can be updated
    NSUInteger nViewControllers = self.navigationController.viewControllers.count;
    self.delegate = (StartGameViewController*)[self.navigationController.viewControllers objectAtIndex:nViewControllers-2];
    
    //tap gesture recognizer
    //The setup code (in viewDidLoad in your view controller)
    UITapGestureRecognizer *singleFingerTap =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
    
    //initialize the score
    self.lScore = 0;
    
    //initialize the duration of the game
    self.duration = 0;
    
    //create the fire bullet image to use for all fire bullets
    self.fireBullet = [UIImage imageNamed:@"fireshot.png"];
    
    //initialize the couch lives allowed (decremented when couch is touched)
    self.lives = 3;
    
//IMAGES TO HIT
    //set the maximum number of objects in the view at once (to limit images to hit)
    self.maxObjects = 5;
    
    //set the timer interval for adding objects to hit (seconds)
    self.timerIncrement = 0.5;
    
    // Initialize hit items and audio players
    [self setupHitItems];
    [self setupAudioPlayers];
    
    //get the number of possible speeds in the speeds array
    numberOfSpeeds = sizeof(imageToHitSpeeds)/sizeof(imageToHitSpeeds[0]);
    
    //kick off the timer for objects to hit
    self.addTargetTimer = [NSTimer scheduledTimerWithTimeInterval:self.timerIncrement
                                                           target:self
                                                         selector:@selector(AddAnImageToHit)
                                                         userInfo:nil
                                                          repeats:YES];
    [self setupBackground];

//COUCH
    //put the couch on the board
    [self CreateCouch];

}

//ADJUST THE SCORE BASED ON AN EVENT THAT OCCURRED, THAT ALTERS THE SCORE
//SET THE BACKGROUND IMAGE TO WHATEVER LEVEL WE'RE AT, ACCORDINGLY
//required as an ImageToHit and ImageToShoot and ImageToDrag delegate
-(void)AdjustScore:(int)points
{
    self.lScore += points;
    self.score.text = [NSString stringWithFormat:@"%li", self.lScore];
    
    if(self.lScore < 5000) {
        [self SetBackgroundImage:@"space.jpg"];
    }
    else if(self.lScore < 10000) {
        [self SetBackgroundImage:@"back1.jpg"];
    }
    else if(self.lScore < 15000) {
        [self SetBackgroundImage:@"back2.jpg"];
    }
    else if(self.lScore < 20000) {
        [self SetBackgroundImage:@"back3.jpg"];
    }
    else if(self.lScore < 25000) {
        [self SetBackgroundImage:@"back4.jpg"];
    }
    else if(self.lScore < 30000) {
        [self SetBackgroundImage:@"back5.jpg"];
    }
    else if(self.lScore < 35000) {
        [self SetBackgroundImage:@"back6.jpg"];
    }
    else if(self.lScore < 40000) {
        [self SetBackgroundImage:@"back7.jpg"];
    }
    else if(self.lScore < 45000) {
        [self SetBackgroundImage:@"back8.jpg"];
    }
    else if(self.lScore < 50000) {
        [self SetBackgroundImage:@"back9.jpg"];
    }
    else if(self.lScore < 55000) {
        [self SetBackgroundImage:@"back10.jpg"];
    }
    else if(self.lScore < 60000) {
        [self SetBackgroundImage:@"back11.jpg"];
    }
    else if(self.lScore < 65000) {
        [self SetBackgroundImage:@"back12.jpg"];
    }
    else if(self.lScore < 70000) {
        [self SetBackgroundImage:@"back13.jpg"];
    }
    else if(self.lScore < 75000) {
        [self SetBackgroundImage:@"back14.jpg"];
    }
    else if(self.lScore < 80000) {
        [self SetBackgroundImage:@"back15.jpg"];
    }
    else if(self.lScore < 85000) {
        [self SetBackgroundImage:@"back16.jpg"];
    }
    else if(self.lScore < 90000) {
        [self SetBackgroundImage:@"back17.jpg"];
    }
    else if(self.lScore < 95000) {
        [self SetBackgroundImage:@"back18.jpg"];
    }
    else if(self.lScore < 100000) {
        [self SetBackgroundImage:@"back19.jpg"];
    }
    else if(self.lScore < 105000) {
        [self SetBackgroundImage:@"back20.jpg"];
    }
    else if(self.lScore < 110000) {
        [self SetBackgroundImage:@"back21.jpg"];
    }
    else if(self.lScore < 115000) {
        [self SetBackgroundImage:@"back22.jpg"];
    }
    else if(self.lScore < 120000) {
        [self SetBackgroundImage:@"back23.jpg"];
    }
    else if(self.lScore < 125000) {
        [self SetBackgroundImage:@"back24.jpg"];
    }
    else if(self.lScore < 130000) {
        [self SetBackgroundImage:@"back25.jpg"];
    }
    else {
        [self SetBackgroundImage:@"back26.jpg"];
    }
}

//SET THE BACKGROUND IMAGE
-(void)SetBackgroundImage:(NSString*)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    if (image) {
        [self.backgroundImage setImage:image];
    } else {
        NSLog(@"Warning: Could not load background image: %@", imageName);
    }
}

-(void)setupBackground {
    self.backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"space.jpg"]];
    [self.view addSubview:self.backgroundImage];
    [self.view sendSubviewToBack:self.backgroundImage];
    self.backgroundImage.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

//CREATE THE COUCH AND PLACE IT IN THE VIEW
-(void)CreateCouch
{
    //create the couch and place it in the view
    self.couch = [[ImageToDrag alloc] initWithImage:[UIImage imageNamed:@"v2couch3.png"]];
    
    //set this up as the couch's delegate when it wants to shoot
    self.couch.delegate = self;
    
    
    //place the couch in the view (will get removed in EndGame, like all subviews)
    self.couch.center = CGPointMake(self.view.center.x,self.view.center.y);
    
    [self.view addSubview:self.couch];
}

- (void)setupHitItems {
    // Define all hit items in one place
    self.hitItems = @[
        [[HitItemModel alloc] initWithImage:@"v2coffeetable.png" sound:@"coffee.mp3" basePoints:50],
        [[HitItemModel alloc] initWithImage:@"v2chaise.png" sound:@"relax.mp3" basePoints:50],
        [[HitItemModel alloc] initWithImage:@"v2tv.png" sound:@"zzzt.mp3" basePoints:50],
        [[HitItemModel alloc] initWithImage:@"v2lamp.png" sound:@"lamp.mp3" basePoints:200],
        [[HitItemModel alloc] initWithImage:@"v2cat.png" sound:@"meow.mp3" basePoints:100],
        [[HitItemModel alloc] initWithImage:@"v2dog.png" sound:@"woof.mp3" basePoints:100],
        [[HitItemModel alloc] initWithImage:@"v2bear.png" sound:@"roar.mp3" basePoints:100],
        [[HitItemModel alloc] initWithImage:@"v2can.png" sound:@"tap.mp3" basePoints:200],
        [[HitItemModel alloc] initWithImage:@"dino.png" sound:@"pterry.mp3" basePoints:50],
        [[HitItemModel alloc] initWithImage:@"tape.png" sound:@"bekind.mp3" basePoints:100],
        [[HitItemModel alloc] initWithImage:@"candy.png" sound:@"yum.mp3" basePoints:100]
    ];
}

- (void)setupAudioPlayers {
    self.audioPlayers = [NSMutableDictionary dictionary];
    
    // Get resource path once at the start
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    
    // Setup audio players for all sounds
    for (HitItemModel *item in self.hitItems) {
        NSString *path = [NSString stringWithFormat:@"%@/%@", resourcePath, item.soundName];
        NSURL *soundUrl = [NSURL fileURLWithPath:path];
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
        [player prepareToPlay];
        
        [self.audioPlayers setObject:player forKey:item.soundName];
    }
    
    // Add the "ow" sound
    NSString *owPath = [NSString stringWithFormat:@"%@/ow.mp3", resourcePath];
    NSURL *owUrl = [NSURL fileURLWithPath:owPath];
    AVAudioPlayer *owPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:owUrl error:nil];
    [owPlayer prepareToPlay];
    [self.audioPlayers setObject:owPlayer forKey:@"ow.mp3"];
}

//CREATE AN IMAGE TO HIT, AND ADD IT TO THE VIEW
-(void)AddAnImageToHit
{
    // Validate we have items
    if ([self.hitItems count] == 0) {
        NSLog(@"Warning: No hit items configured");
        return;
    }
    
    //increment the duration of the game
    self.duration += 1;
    
    //get the level and adjust max objects
    int currentLevel = self.duration/levelUp;
    self.maxObjects = currentLevel + 5;
    
    //don't add a target if there are already a lot
    int imagesToHitInView = [self NumberOfImagesToHit];
    if (imagesToHitInView >= self.maxObjects) {
        return;
    }
    
    //set available speeds based on duration of the game
    int randomSpeedIndex;
    if((currentLevel)>numberOfSpeeds){
        //phase out the lower speeds, so that eventually only the highest speed is chosen
        int minimumSpeed = ((self.duration/levelUp)>=(numberOfSpeeds*2))?numberOfSpeeds-1:(self.duration/levelUp)-numberOfSpeeds;
        
        randomSpeedIndex=arc4random_uniform((numberOfSpeeds-1) - minimumSpeed + 1) + minimumSpeed;
    }
    else{
        //every levelUp durations, make another speed available
        randomSpeedIndex = (int)arc4random_uniform(currentLevel);
    }
    
    //pick a random speed from the array of valid speeds for the timer increment
    float timerIncrement = imageToHitSpeeds[randomSpeedIndex];
    
    //pick a random image as the image to drop
    int randomIndex = (int)arc4random_uniform((u_int32_t)[self.hitItems count]);
    HitItemModel *selectedItem = self.hitItems[randomIndex];
    
    // Create target using the selected item
    ImageToHit *target = [[ImageToHit alloc] initWithImage:[UIImage imageNamed:selectedItem.imageName]
                                        withTimerIncrement:timerIncrement
                                               withSound:selectedItem.soundName];
    
    //pick the points value based on the speed and difficulty of the target
    target.points = (int)(selectedItem.basePoints * (randomSpeedIndex + 1));
    
    //set this up as the targets delegate for when it's hit, and the score needs to be adjusted
    target.delegate=self;
    
    //add the target to the view
    [self.view addSubview:target];
        
    //put target at the top of the view (can't do this in initWithImage because superview.bounds returns 0 for width there
    [target PlaceImageAtTop];
    
    target=nil;
}

//SOUND
//Called by ImageToHit to play the respective sound
-(void)PlaySound:(NSString*)soundFile //for playing a sound when something is hit, required by ImageToHitDelegate
{
    AVAudioPlayer *player = [self.audioPlayers objectForKey:soundFile];
    if (player && !player.playing) {
        [player play];
    }
}

//required by ImageToDrag delegate for firing bullets
-(void)Fire
{
    
    //create a fire bullets. bullets will remove themselves from the view when its position is less than 0
    ImageToShoot *fireBulletLeft = [[ImageToShoot alloc] initWithImage:self.fireBullet];
    ImageToShoot *fireBulletRight = [[ImageToShoot alloc] initWithImage:self.fireBullet];
    ImageToShoot *fireBulletCenter = [[ImageToShoot alloc] initWithImage:self.fireBullet];
    
    
    fireBulletLeft.center = CGPointMake(self.couch.center.x-(self.couch.frame.size.width/2)+fireBulletLeft.frame.size.width, self.couch.center.y);
    fireBulletRight.center = CGPointMake(self.couch.center.x+(self.couch.frame.size.width/2)-fireBulletRight.frame.size.width, self.couch.center.y);
    fireBulletCenter.center = CGPointMake(self.couch.center.x, self.couch.center.y - 50);
    
    //make this controller a delegate for the firebullets, for decreasing score when they don't hit anything
    fireBulletLeft.delegate = self;
    fireBulletRight.delegate = self;
    fireBulletCenter.delegate = self;
    
    [self.view addSubview:fireBulletLeft];
    [self.view addSubview:fireBulletRight];
    [self.view addSubview:fireBulletCenter];
    
    
    fireBulletLeft=nil;
    fireBulletRight=nil;
    fireBulletCenter=nil;
    
}

//required by ImageToDrag delegate for losing lives (can be called to add lives too)
-(void)AdjustLives:(int)lives
{
    //adjust the lives count
    self.lives += lives;
    
    //play a sound of getting hit
    [self PlaySound:@"ow.mp3"];
    
    //end the game if there are no more
    if(self.lives<=0)
    {
        [self EndGame];
    }
    
}

-(void)EndGame
{
    //remove all the views
    NSArray *subviews = [self.view subviews];
    for (UIView *subview in subviews)
    {
        
        //stop timers
        if([subview isKindOfClass:[ImageToHit class]])
        {
            [((ImageToHit*)subview).checkPositionTimer invalidate];
            ((ImageToHit*)subview).checkPositionTimer=nil;
        }
        
        if([subview isKindOfClass:[ImageToShoot class]])
        {
            [((ImageToShoot*)subview).checkPositionTimer invalidate];
            ((ImageToShoot*)subview).checkPositionTimer=nil;
        }

        if([subview isKindOfClass:[ImageToDrag class]])
        {
            ((ImageToDrag*)subview).animationArray=nil;
        }
        
        //remove view
        [subview removeFromSuperview];
        
    }
    
    //stop the game timer
    [self.addTargetTimer invalidate];
    self.addTargetTimer=nil;
    
    //free allocated resources
    self.fireBullet = nil;
    self.couch = nil;
    self.score = nil;
    subviews = nil;
    
    [self.delegate setScore:self.lScore];
    
    //go back to start game controller
    [self.navigationController popViewControllerAnimated:YES];
    
}

//count the number of images to hit currently in the view
-(int)NumberOfImagesToHit
{
    int numberOfImagesToHit=0;
    
    //get images to hit count
    NSArray *subviews = [self.view subviews];
    for (UIView *subview in subviews){
        if([subview isKindOfClass:[ImageToHit class]]){
            numberOfImagesToHit+=1;
        }
    }
    
    return numberOfImagesToHit;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [self EndGame];
}

//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:[recognizer.view superview]];

    self.couch.center = location;

    [self Fire];
}


@end
