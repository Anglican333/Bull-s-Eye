//
//  BullsEyeViewController.m
//  Bulls Eye
//
//  Created by Isaac David Henby on 2/20/13.
//  Copyright (c) 2013 Isaac David Henby. All rights reserved.
//

#import "BullsEyeViewController.h"
#import "AboutViewController.h"
#import "StatisticsViewController.h"
#import "StatisticsViewController5.h"
#import "GameKitHelper.h"
#import <GameKit/GameKit.h>

@interface BullsEyeViewController ()

@end

@implementation BullsEyeViewController
{
    int currentValue;
    int targetValue;
    int score;
    int round;
    int difference;
    int multiplier;
    int perfects;
    Boolean hardcore;
    
}

@synthesize docPath = _docPath;

-(UIImage*)captureImage
{
    UIGraphicsBeginImageContext(CGSizeMake([[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width));
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

- (IBAction)saveCameraRoll
{
    UIImage *image = [self captureImage];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    NSString *message = [NSString stringWithFormat:
                         @"Saved to camera roll!"];
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Saved!"
                              message:message
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
}

- (IBAction)postOnFacebookButtonTapped:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *fbComposer = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeFacebook];
        //set the initial text message
        NSString *message = [NSString stringWithFormat:@"I scored %d in Bulls Eye in %d rounds! Download the app here: https://itunes.apple.com/us/app/bulls-eye/id618049804?ls=1&mt=8", score, round - 1];
        [fbComposer setInitialText:message];
        
        
        // you can remove all added URLs as follows
        //[fbComposer removeAllURLs];
        
        //add image to post
        UIImage *image = [self captureImage];
        if ([fbComposer addImage:image]) {
            NSLog(@"strong binary added to the post");
        }
        //if ([fbComposer addImage:[UIImage imageNamed: @"scan.jpg"]]) {
        //    NSLog(@"scan is added to the post");
        //}
        
        //remove all added images
        //[fbComposer removeAllImages];
        
        //present the composer to the user
        [self presentViewController:fbComposer animated:YES completion:nil];
        
    }else {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Facebook Error"
                                  message:@"You may not have set up facebook service on your device or\n                                  You may not connected to Internet.\nPlease check ..."
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles: nil];
        [alertView show];
    }
}

- (IBAction)tweetButtonTapped:(id)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:[NSString stringWithFormat:@"I scored %d in Bulls Eye in %d rounds! Download the app here: https://itunes.apple.com/us/app/bulls-eye/id618049804?ls=1&mt=8", score, round--]];
        [tweetSheet addImage:[self captureImage]];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

@synthesize slider;
@synthesize targetLabel;
@synthesize scoreLabel;
@synthesize roundLabel;

- (void)startNewRound
{
    self.totalRounds += 1;
    round++;
    targetValue = 1 + (arc4random() % 100);
    [self updateLabels];
}



- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(hardcore != YES)
        [self startNewRound];
    else if(difference > 13)
        [self startOver];
    else
        [self startNewRound];
}

-(IBAction)startOver
{
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionReveal;
    transition.duration = 1;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:
                                 kCAMediaTimingFunctionEaseOut];
    targetValue = 0;
    currentValue = slider.value;
    score = 0;
    round = 0;
    perfects = 0;
    multiplier = 1;
    [self startNewRound];
    [self.view.layer addAnimation:transition forKey:nil];
}

- (IBAction)showInfo
{
    AboutViewController *controller = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:controller animated:YES completion:nil]; }

- (IBAction)showStat
{
    StatisticsViewController5 *controller = [[StatisticsViewController5 alloc] initWithNibName:@"StatisticsViewController5" bundle:nil];
    controller.totalRounds = self.totalRounds;
    controller.totalPerfects = self.totalPerfects;
    controller.totalScore = self.totalScore;
    controller.highestRound = self.highestRound;
    controller.highestRoundBlitz = self.highestRoundBlitz;
    controller.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [self presentViewController:controller animated:YES completion:nil]; }

- (void)viewDidLoad
{
    NSString *pewPewPath = [[NSBundle mainBundle] pathForResource:@"arrow" ofType:@"wav"];
	NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
	AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(pewPewURL), &_pewPewSound);
    [self setHolidays];
    UIImage *trackLeftImage = [[UIImage imageNamed:@"SliderTrackLeft"] stretchableImageWithLeftCapWidth:14 topCapHeight:0];
    [self.slider setMinimumTrackImage:trackLeftImage forState:UIControlStateNormal];
    UIImage *trackRightImage = [[UIImage imageNamed:@"SliderTrackRight"] stretchableImageWithLeftCapWidth:14 topCapHeight:0];
    [self.slider setMaximumTrackImage:trackRightImage forState: UIControlStateNormal];
    currentValue = lroundf(slider.value);
    [self startNewRound];
}

@synthesize day, month, year;

- (void) setHolidays
{
    NSCalendar *usersCalendar = [[NSLocale currentLocale] objectForKey:NSLocaleCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    NSDateComponents *textComponents = [usersCalendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[NSDate date]];
    [components setDay:25];
    [components setMonth:12];
    [components setYear:[textComponents year]];
    NSDate *christmas = [usersCalendar dateFromComponents:components];
    UIImage *thumbImageNormal = [UIImage imageNamed:@"SliderThumb-Normal"];
    UIImage *thumbImageHighlighted = [UIImage imageNamed:@"SliderThumb-Highlighted"];
    if([self compare:[NSDate date] :[self getEasterDay]])
    {
        //thumbImageNormal = [UIImage imageNamed:@"Easter"];
        //thumbImageHighlighted = [UIImage imageNamed:@"Easter"];
    }
    else if([self compare:[NSDate date] :christmas])
    {
        //thumbImageNormal = [UIImage imageNamed:@"Present"];
        //thumbImageHighlighted = [UIImage imageNamed:@"Present"];
    }
    [components setDay:31];
    [components setMonth:10];
    christmas = [usersCalendar dateFromComponents:components];
    if([self compare:[NSDate date] :christmas])
    {
        //thumbImageNormal = [UIImage imageNamed:@"Pumpkin"];
        //thumbImageHighlighted = [UIImage imageNamed:@"Pumpkin"];
    }
    [components setDay:11];
    [components setMonth:2];
    christmas = [usersCalendar dateFromComponents:components];
    if([self compare:[NSDate date] :christmas])
    {
        //thumbImageNormal = [UIImage imageNamed:@"Valentines"];
        //thumbImageHighlighted = [UIImage imageNamed:@"Valentines"];
    }
    day.text = [NSString stringWithFormat:@"%d", [textComponents day]];
    month.text = [NSString stringWithFormat:@"%d", [textComponents month]];
    year.text = [NSString stringWithFormat:@"%d", [textComponents year]];
    [self.slider setThumbImage:thumbImageNormal forState:UIControlStateNormal];
    [self.slider setThumbImage:thumbImageHighlighted forState:UIControlStateHighlighted];

}

- (Boolean) compare: (NSDate *)date1 :(NSDate *)date2
{
    Boolean comp = NO;
    NSCalendar *usersCalendar = [[NSLocale currentLocale] objectForKey:NSLocaleCalendar];
    
    NSDateComponents *comp1 = [usersCalendar components:(NSDayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:date1];
    NSDateComponents *comp2 = [usersCalendar components:(NSDayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:date2];

    if([comp1 year] == [comp2 year])
            if([comp1 month] == [comp2 month])
                if([comp1 day] == [comp2 day])
                    comp = YES;
    return comp;
}


- (void)updateLabels
{
    self.targetLabel.text = [NSString stringWithFormat:@"%d", targetValue];
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", score];
    self.roundLabel.text = [NSString stringWithFormat:@"%d", round];
    self.perfectLabel.text = [NSString stringWithFormat:@"%d", perfects];
}

#define highScore20 @"org.abimon.bull.highScore20"
- (IBAction)addRound:(UIStepper *)sender
{
    GKLocalPlayer* localPlayer =
    [GKLocalPlayer localPlayer];

    if(localPlayer.authenticated && [localPlayer.displayName isEqual: @"Anglican"])
    {
        round += sender.value;
        self.labelCurrent.text = @"Success";
    }
    
    self.labelCurrent.text = localPlayer.displayName;
    sender.value = 0;
    [self updateLabels];
}
- (IBAction)addScore:(UIStepper *)sender
{
    GKLocalPlayer* localPlayer =
    [GKLocalPlayer localPlayer];
    
    if(localPlayer.authenticated && [localPlayer.displayName  isEqual: @"Anglican"])
        score += sender.value;
    sender.value = 0;
    [self updateLabels];
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeFloat:self.totalScore forKey:@"Score"];
    [encoder encodeFloat:self.totalPerfects forKey:@"Perfects"];
    [encoder encodeFloat:self.totalRounds forKey:@"Rounds"];
    [encoder encodeFloat:self.highestRound forKey:@"HighestR"];
    [encoder encodeFloat:self.highestRoundBlitz forKey:@"HighestBlitz"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self.totalRounds = [decoder decodeFloatForKey:@"Rounds"];
    self.totalScore = [decoder decodeFloatForKey:@"Score"];
    self.totalPerfects = [decoder decodeFloatForKey:@"Perfects"];
    self.highestRound = [decoder decodeFloatForKey:@"HighestR"];
    self.highestRoundBlitz = [decoder decodeFloatForKey:@"HighestBLitz"];
    return nil;
}

- (IBAction)showAlert
{
     AudioServicesPlaySystemSound(_pewPewSound);
    [self setHolidays];
    if(currentValue < targetValue)
    {
        difference = targetValue - currentValue;
    }
    else if(currentValue > targetValue)
    {
        difference = currentValue - targetValue;
    }
    else
    {
        difference = 0;
    }
    int scoreAdd = 100 - difference;
    int number = 100;
    Boolean diff = NO;
    if(difference > 13)
        diff = YES;
    NSString *title; //org.abimon.bull.highScore20
    if(hardcore != YES)
    {
        if (difference == 0) {
            title = @"Perfect!";
            NSLog(@"The multiplier: %d, The Additional points: %d", multiplier, number);
            number *= multiplier;
            multiplier += 1;
            perfects += 1;
            self.totalPerfects += 1;
        } else if (difference <= 2){
            title = @"Soooooo close!";
            multiplier = 1;
            scoreAdd += 50;
        } else if (difference < 5) {
            title = @"You almost had it!";
            multiplier = 1;
        } else if (difference < 10) {
            title = @"Pretty good!";
                        multiplier = 1;
        } else if (difference < 25) {
            title = @"Could be better.";
            multiplier = 1;
        }else {
            title = @"Not even close...";
            multiplier = 1;
        }
        NSLog(@"The multiplier: %d, The Additional points: %d", multiplier, number);
        
        NSString *message;
        if(difference == 0)
        {
            scoreAdd += number;

        message = [NSString stringWithFormat:
                             @"The value of the slider is: %d\nThe target value is: %d\nThe difference is: %d\nYour score for this round is: %d", currentValue, targetValue, difference, scoreAdd + number];
        }
        else
        {
            message = [NSString stringWithFormat:
                                 @"The value of the slider is: %d\nThe target value is: %d\nThe difference is: %d\nYour score for this round is: %d", currentValue, targetValue, difference, scoreAdd];
        }
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:title
                                  message:message
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        score += scoreAdd;
        self.totalScore += scoreAdd;
        if(round == 101 && round % 20 == 0)
        {
            [[GameKitHelper sharedGameKitHelper]
             submitScore:(int64_t)score
             category:[NSString stringWithFormat:@"org.abimon.bull.highScore%d", round]];
            [[GameKitHelper sharedGameKitHelper]
             submitScore:(int64_t)perfects
             category:[NSString stringWithFormat:@"org.abimon.bull.perfect%d", round]];
        }
    }
    else{
        if (difference == 0) {
        title = @"Perfect!";
        NSLog(@"The multiplier: %d, The Additional points: %d", multiplier, number);
        number *= multiplier;
        multiplier += 1;
        perfects += 1;
        self.totalPerfects += 1;
    } else if (difference <= 2){
        title = @"Soooooo close!";
        multiplier = 1;
        scoreAdd += 10;
    } else if (difference < 5) {
        title = @"You almost had it!";
        multiplier = 1;
    } else if (difference < 10) {
        title = @"Pretty good!";
        multiplier = 1;
    } else if (difference < 25) {
        title = @"Could be better.";
        multiplier = 1;
    }else {
        title = @"Not even close...";
        multiplier = 1;
    }
    NSLog(@"The multiplier: %d, The Additional points: %d", multiplier, number);

    NSString *message;
    if(difference == 0)
    {
        scoreAdd += number;
        
        message = [NSString stringWithFormat:
                   @"The value of the slider is: %d\nThe target value is: %d\nThe difference is: %d\nYour score for this round is: %d\n The total score was: %d", currentValue, targetValue, difference, scoreAdd + number, score];
    }
    else if(diff == NO)
    {
        message = [NSString stringWithFormat:
                   @"The value of the slider is: %d\nThe target value is: %d\nThe difference is: %d\nYour score for this round is: %d\n The total score was: %d", currentValue, targetValue, difference, scoreAdd, score];
    }
    else
    {
        message = [NSString stringWithFormat:
                   @"Oh no! You lost! The value of the slider that round was: %d\nThe target value is: %d\nThe difference is: %d\nYour score for this round is: %d\n The total score was: %d", currentValue, targetValue, difference, scoreAdd, score];
    }
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:title
                              message:message
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    score += scoreAdd;
    self.totalScore += scoreAdd;
    [alertView show];
    }
}

- (IBAction)sliderMoved:(UISlider *)sender {
    currentValue = lroundf(sender.value);
    self.labelCurrent.text = [NSString stringWithFormat:@"%d", currentValue];
}

- (IBAction)hardcoreToggled:(UISwitch *)switchs{
    hardcore = switchs.on;
    if(hardcore == YES)
        NSLog(@"The switch is on");
    else
        NSLog(@"The switch is off");
    [self startOver];
}

- (NSDate *) getEasterDay
{
    NSDate *today = [NSDate date];
    
    NSCalendar *usersCalendar = [[NSLocale currentLocale] objectForKey:NSLocaleCalendar];
    
    NSDateComponents *weekdayComponents = [usersCalendar components:(NSDayCalendarUnit | NSYearCalendarUnit) fromDate:today];

    NSInteger year = [weekdayComponents year];
    NSInteger goldenNumber = year;
    
    goldenNumber -= 1994;

    while(goldenNumber >= 20)
    {
        goldenNumber -= 19;
    }
    NSLog(@"Golden Number is: %d, year is %d", goldenNumber, year);
    NSDateComponents *components = [[NSDateComponents alloc] init];
    switch (goldenNumber)
    {
        case 1:
            [components setDay:14];
            [components setMonth:4];
            break;
        case 2:
            [components setDay:3];
            [components setMonth:4];
            break;
        case 3:
            [components setDay:23];
            [components setMonth:3];
            break;
        case 5:
            [components setDay:31];
            [components setMonth:3];
            break;
        case 19:
            [components setDay:27];
            [components setMonth:3];
            break;
    }
    [components setYear:year];
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *date = [gregorian dateFromComponents:components];
    NSDateComponents *weekdayComponent = [usersCalendar components:(NSWeekdayCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:date];
    
    NSLog(@"The weekday is:%d. The year is %d. The month is %d, and the day is %d", [weekdayComponent weekday], [weekdayComponent year], [weekdayComponent month], [weekdayComponent day]);
    while([weekdayComponent weekday] > 1)
    {
        if([weekdayComponent day] == 31)
        {
            [components setDay:1];
            [components setMonth:4];
        }
        else
            [components setDay:([weekdayComponent day]) + 1];
        NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        
       date = [gregorian dateFromComponents:components];
        weekdayComponent = [usersCalendar components:(NSWeekdayCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:date];
    }
    NSLog(@"The final weekday is:%d. The year is %d. The month is %d, and the day is %d", [weekdayComponent weekday], [weekdayComponent year], [weekdayComponent month], [weekdayComponent day]);
    return date;
}

- (id)init {
    if ((self = [super init])) {
    }
    return self;
}

- (id)initWithDocPath:(NSString *)docPath {
    if ((self = [super init])) {
        _docPath = [docPath copy];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
