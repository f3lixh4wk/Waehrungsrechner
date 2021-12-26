//
//  MenuViewController.m
//  Waehrungsrechner
//
//  Created by Labor on 15.12.21.
//

#import "MenueViewController.h"

@interface MenueViewController ()

@end

@implementation MenueViewController

@synthesize decimalPlaces, delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView* rootView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [rootView setBackgroundColor:[UIColor whiteColor]];
    
    UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 30, 100, 50)];
    [backButton setImage:[UIImage systemImageNamed:@"arrow.backward"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(zurueckHandler:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |
     UIViewAutoresizingFlexibleLeftMargin];
    [rootView addSubview:backButton];
    
    UILabel* settingsLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 30, 200, 50)];
    [settingsLabel setText:@"Einstellungen"];
    [settingsLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |
     UIViewAutoresizingFlexibleLeftMargin];
    [rootView addSubview:settingsLabel];
    
    UILabel* decimalLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, 200, 30)];
    [decimalLabel setText:@"Nachkommastellen"];
    [decimalLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |
     UIViewAutoresizingFlexibleLeftMargin];
    decimalLabel.textAlignment = NSTextAlignmentCenter;
    [rootView addSubview:decimalLabel];
    
    isNotFirstStartup = [[NSUserDefaults standardUserDefaults] boolForKey:@"firstStartUp"];
    if (isNotFirstStartup == true)
        decimalPlaces = [[NSUserDefaults standardUserDefaults] integerForKey:@"decimalPlacesMenue"];
    else
        decimalPlaces = 2;
    
    labelValue = [[UILabel alloc] initWithFrame:CGRectMake(200, 150, 50, 30)];
    labelValue.textAlignment = NSTextAlignmentCenter;
    [labelValue setBackgroundColor:[UIColor lightGrayColor]];
    [labelValue setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |
     UIViewAutoresizingFlexibleLeftMargin];
    labelValue.text = [NSString stringWithFormat:@"%ld", (long)decimalPlaces];
    [rootView addSubview:labelValue];
    
    UIStepper* stepper = [[UIStepper alloc] initWithFrame:CGRectMake(250, 150, 60, 30)];
    [stepper addTarget:self action:@selector(stepperChanged:) forControlEvents:UIControlEventValueChanged];
    [stepper setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |
     UIViewAutoresizingFlexibleLeftMargin];
    
    [stepper setValue:decimalPlaces];
    [stepper setMinimumValue:0];
    [stepper setMaximumValue:8];
    [rootView addSubview:stepper];
    
    self.view = rootView;
}

-(void)zurueckHandler:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setInteger:decimalPlaces forKey:@"decimalPlacesMenue"];
    [self.delegate addItemViewController:self didFinishEnteringItem:decimalPlaces];
    
    isNotFirstStartup = true;
    [[NSUserDefaults standardUserDefaults] setBool:isNotFirstStartup forKey:@"firstStartUp"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)stepperChanged:(UIStepper *)sender
{
    int value = sender.value;
    labelValue.text = [NSString stringWithFormat:@"%d",value];
    decimalPlaces = value;
}

@end
