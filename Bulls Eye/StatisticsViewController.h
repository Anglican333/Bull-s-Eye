//
//  StatisticsViewController.h
//  Bulls Eye
//
//  Created by Isaac Henby on 3/09/13.
//  Copyright (c) 2013 Isaac David Henby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatisticsViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, assign) int totalScore;
@property (nonatomic, assign) int totalPerfects;
@property (nonatomic, assign) int totalRounds;
@property (nonatomic, assign) int highestRound;
@property (nonatomic, assign) int highestRoundBlitz;

@property (strong, nonatomic) IBOutlet UILabel *statisticData;
@property (strong, nonatomic) IBOutlet UILabel *statisticName;
@property (strong, nonatomic) IBOutlet UIPickerView *statisticPicker;
@property (strong, nonatomic) IBOutlet UIButton *returnButton;

-(IBAction)close;
@end
