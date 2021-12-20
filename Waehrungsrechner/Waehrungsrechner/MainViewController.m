//
//  MainViewController.m
//  Waehrungsrechner
//
//  Created by Labor on 05.12.21.
//

#import "MainViewController.h"
#import "MenueViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

-(void) loadControllerWithEntities:(NSMutableArray *)entities
{
    currencyEntities = entities;
    
}

-(IBAction)btnCountryLeftHandler:(id)sender
{
    
}

-(IBAction)btnCountryRightHandler:(id)sender
{
    
}

-(IBAction)btnSwitchCountriesHandler:(id)sender
{
    
}

- (void)addItemViewController:(MenueViewController*)controller didFinishEnteringItem:(NSInteger)decimalPlaces
{
    _decimalPlaces = decimalPlaces;
}

-(IBAction)menuHandler:(id)sender
{
    MenueViewController* menue = [[MenueViewController alloc] init];
    menue.delegate = self;
    menue.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:menue animated:YES completion:nil];
}

- (BOOL) shouldAutorotate
{
    return YES;
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
