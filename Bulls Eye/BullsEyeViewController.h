//
//  BullsEyeViewController.h
//  Bulls Eye
//
//  Created by Isaac David Henby on 2/20/13.
//  Copyright (c) 2013 Isaac David Henby. All rights reserved.
//

#import <UIKit/UIKit.h>
// import social header file
#import<Social/Social.h>
#import <AudioToolbox/AudioToolbox.h>//x
#import <QuartzCore/QuartzCore.h>

@interface BullsEyeViewController : UIViewController <UIAlertViewDelegate, NSCoding>
{
    NSString *_docPath;
    SystemSoundID _pewPewSound;
}

@property (strong, nonatomic) IBOutlet UILabel *labelCurr;
@property (strong, nonatomic) IBOutlet UILabel *labelCurrent;
@property (nonatomic, strong) IBOutlet UISlider *slider;
@property (nonatomic, strong) IBOutlet UILabel *targetLabel;
@property (nonatomic, strong) IBOutlet UILabel *scoreLabel;
@property (nonatomic, strong) IBOutlet UILabel *roundLabel;
@property (nonatomic, strong) IBOutlet UILabel *day;
@property (nonatomic, strong) IBOutlet UILabel *month;
@property (nonatomic, strong) IBOutlet UILabel *year;
@property (strong, nonatomic) IBOutlet UILabel *perfectLabel;

@property (nonatomic, assign) int totalScore;
@property (nonatomic, assign) int totalPerfects;
@property (nonatomic, assign) int totalRounds;
@property (nonatomic, assign) int highestRound;
@property (nonatomic, assign) int highestRoundBlitz;

@property (copy) NSString *docPath;

- (id)init;
- (id)initWithDocPath:(NSString *)docPath;
- (void)saveData;
- (void)deleteDoc;

- (IBAction)showAlert;

//called on tap of facebook button
- (IBAction)postOnFacebookButtonTapped:(id)sender;
-(IBAction)saveCameraRoll;
//called on tap of tweet button
- (IBAction)tweetButtonTapped:(id)sender;
- (IBAction)showInfo;
- (IBAction)showSettings;

- (IBAction)sliderMoved:(UISlider *)slider;

- (IBAction)hardcoreToggled:(UISwitch*)switchs;

- (IBAction)startOver;

@end
