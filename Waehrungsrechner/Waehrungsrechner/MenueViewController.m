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
    rootView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [rootView setBackgroundColor:[UIColor whiteColor]];
    
    backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 30, 100, 50)];
    [backButton setImage:[UIImage systemImageNamed:@"arrow.backward"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(zurueckHandler:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |
     UIViewAutoresizingFlexibleLeftMargin];
    [rootView addSubview:backButton];
    
    settingsLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 30, 200, 50)];
    [settingsLabel setText:@"Einstellungen"];
    [settingsLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |
     UIViewAutoresizingFlexibleLeftMargin];
    [rootView addSubview:settingsLabel];
    
    decimalLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, 200, 30)];
    [decimalLabel setText:@"Nachkommastellen"];
    [decimalLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |
     UIViewAutoresizingFlexibleLeftMargin];
    decimalLabel.textAlignment = NSTextAlignmentCenter;
    [rootView addSubview:decimalLabel];
    
    backgroundLabel = [[UILabel alloc] initWithFrame:CGRectMake(-23, 220, 200, 30)];
    [backgroundLabel setText:@"Darkmode"];
    [backgroundLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |
     UIViewAutoresizingFlexibleLeftMargin];
    backgroundLabel.textAlignment = NSTextAlignmentCenter;
    [rootView addSubview:backgroundLabel];
    
    isNotFirstStartup = [[NSUserDefaults standardUserDefaults] boolForKey:@"firstStartUp"];
    if (isNotFirstStartup == true)
        decimalPlaces = [[NSUserDefaults standardUserDefaults] integerForKey:@"decimalPlacesMenue"];
    else
        decimalPlaces = 2;
    
    darkmode = [[NSUserDefaults standardUserDefaults] boolForKey:@"darkmode"];
    [self setDarkMode];
    
    labelValue = [[UILabel alloc] initWithFrame:CGRectMake(200, 151.5, 50, 30)];
    labelValue.textAlignment = NSTextAlignmentCenter;
    [labelValue setBackgroundColor:[UIColor lightGrayColor]];
    [labelValue setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |
     UIViewAutoresizingFlexibleLeftMargin];
    labelValue.text = [NSString stringWithFormat:@"%ld", (long)decimalPlaces];
    [rootView addSubview:labelValue];
    
    stepper = [[UIStepper alloc] initWithFrame:CGRectMake(250, 150, 60, 30)];
    [stepper addTarget:self action:@selector(stepperChanged:) forControlEvents:UIControlEventValueChanged];
    [stepper setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |
     UIViewAutoresizingFlexibleLeftMargin];
    
    [stepper setValue:decimalPlaces];
    [stepper setMinimumValue:0];
    [stepper setMaximumValue:8];
    [rootView addSubview:stepper];
    
    modeswitch = [[UISwitch alloc] initWithFrame:CGRectMake(300, 220, 60, 30)];
    [modeswitch addTarget:self action:@selector(switchDidChange:) forControlEvents:UIControlEventTouchUpInside];
    [modeswitch setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |
     UIViewAutoresizingFlexibleLeftMargin];
    
    [modeswitch setOn:darkmode];
    [rootView addSubview:modeswitch];
    
    
    self.view = rootView;
}

-(void)zurueckHandler:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setInteger:decimalPlaces forKey:@"decimalPlacesMenue"];
    [self.delegate addItemViewController:self didFinishEnteringItem:decimalPlaces];
    
    [[NSUserDefaults standardUserDefaults] setBool:darkmode forKey:@"darkmode"];
    [self.delegate addItemViewController:self didFinishEnteringDarkmode:darkmode];
    
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
- (IBAction)switchDidChange:(UISwitch *)sender
{
    UISwitch *mySwitch = (UISwitch *)sender;
    darkmode = [mySwitch isOn];
    [self setDarkMode];
}

-(void)setDarkMode
{
    if (darkmode == true)
    {
        [rootView setBackgroundColor:[UIColor darkGrayColor]];
        [labelValue setTextColor:[UIColor whiteColor]];
        [settingsLabel setTextColor:[UIColor whiteColor]];
        [decimalLabel setTextColor:[UIColor whiteColor]];
        [backgroundLabel setTextColor:[UIColor whiteColor]];
        [stepper setBackgroundColor:[UIColor whiteColor]];
    }
    else
    {
        [rootView setBackgroundColor:[UIColor whiteColor]];
        [labelValue setTextColor:[UIColor blackColor]];
        [settingsLabel setTextColor:[UIColor blackColor]];
        [decimalLabel setTextColor:[UIColor blackColor]];
        [backgroundLabel setTextColor:[UIColor blackColor]];
        [stepper setBackgroundColor:[UIColor grayColor]];
    }
}
@end
