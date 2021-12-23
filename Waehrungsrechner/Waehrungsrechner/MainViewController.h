//
//  MainViewController.h
//  Waehrungsrechner
//
//  Created by Labor on 05.12.21.
//

#import <UIKit/UIKit.h>
#import "MenueViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainViewController : UIViewController <MenueViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    bool isNotFirstStartup;
    double valueToCalculate;
    NSInteger decimalPlaces;
    IBOutlet UITextField *tfValueToCalculate;
    IBOutlet UILabel *lblResult;
    IBOutlet UIButton *btnCountryRight;
    IBOutlet UIButton *btnCountryLeft;
    IBOutlet UITableView *tableViewLeft;
    IBOutlet UITableView *tableViewRight;
    NSMutableArray* tableViewCountryData;
    NSMutableArray* tableViewCountryCodeData;
    NSMutableArray* currencyEntities;
    
    CALayer* bottomBorderTfValueToCalculate;
    CALayer* bottomBorderLblResult;
}

-(void) loadControllerWithEntities:(NSMutableArray*)entities;

@end

NS_ASSUME_NONNULL_END
