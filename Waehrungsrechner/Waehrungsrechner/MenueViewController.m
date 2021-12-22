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
    
    _isNotFirstStartup = [[NSUserDefaults standardUserDefaults] boolForKey:@"firstStartUp"];
    if (_isNotFirstStartup == true)
        _decimalPlaces = [[NSUserDefaults standardUserDefaults] integerForKey:@"decimalPlaces"];
    else
        _decimalPlaces = 2;
    
    _labelValue = [[UILabel alloc] initWithFrame:CGRectMake(200, 150, 50, 30)];
    _labelValue.textAlignment = NSTextAlignmentCenter;
    [_labelValue setBackgroundColor:[UIColor lightGrayColor]];
    [_labelValue setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |
     UIViewAutoresizingFlexibleLeftMargin];
    _labelValue.text = [NSString stringWithFormat:@"%ld", (long)_decimalPlaces];
    [rootView addSubview:_labelValue];
    
    UIStepper* stepper = [[UIStepper alloc] initWithFrame:CGRectMake(250, 150, 60, 30)];
    [stepper addTarget:self action:@selector(stepperChanged:) forControlEvents:UIControlEventValueChanged];
    [stepper setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |
     UIViewAutoresizingFlexibleLeftMargin];
    
    [stepper setValue:_decimalPlaces];
    [stepper setMinimumValue:0];
    [stepper setMaximumValue:8];
    [rootView addSubview:stepper];
    
    self.view = rootView;
}

-(void)zurueckHandler:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setInteger:_decimalPlaces forKey:@"decimalPlaces"];
    [self.delegate addItemViewController:self didFinishEnteringItem:_decimalPlaces];
    
    _isNotFirstStartup = true;
    [[NSUserDefaults standardUserDefaults] setBool:_isNotFirstStartup forKey:@"firstStartUp"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)stepperChanged:(UIStepper *)sender
{
    int value = sender.value;
    _labelValue.text = [NSString stringWithFormat:@"%d",value];
    _decimalPlaces = value;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
