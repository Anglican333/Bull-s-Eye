//
//  StatisticsViewController.m
//  Bulls Eye
//
//  Created by Isaac Henby on 3/09/13.
//  Copyright (c) 2013 Isaac David Henby. All rights reserved.
//

#import "StatisticsViewController.h"
#import "BullsEyeAppDelegate.h"

@interface StatisticsViewController ()

@end

@implementation StatisticsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.statisticName.text = [self forNumber:0];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return 5;
}

- (IBAction)close
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion: nil];
}

-(NSString *)forNumber:(NSInteger) num
{
    switch(num)
    {
        case 0:
            return @"Overall Score";
            break;
        case 1:
            return @"Overall Perfects";
            break;
        case 2:
            return @"Rounds Played";
            break;
        case 3:
            return @"Highest Round Played To";
            break;
        case 4:
            return @"Highest Round Played To in Blitz";
            break;
    }
    return @"Invalid! Please report a bug!";
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    return [self forNumber:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    self.statisticName.text = [self forNumber:row];
    switch(row)
    {
        case 0:
            self.statisticData.text = [NSString stringWithFormat:@"%d", self.totalScore];
            break;
        case 1:
            self.statisticData.text = [NSString stringWithFormat:@"%d", self.totalPerfects];
            break;
        case 2:
            self.statisticData.text = [NSString stringWithFormat:@"%d", self.totalRounds];
            break;
        case 3:
            self.statisticData.text = [NSString stringWithFormat:@"%d", self.highestRound];
            break;
        case 4:
            self.statisticData.text = [NSString stringWithFormat:@"%d", self.highestRoundBlitz];
            break;
    }
}





@end
