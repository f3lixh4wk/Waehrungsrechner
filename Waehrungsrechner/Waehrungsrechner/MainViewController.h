//
//  MainViewController.h
//  Waehrungsrechner
//
//  Created by Labor on 05.12.21.
//

#import <UIKit/UIKit.h>
#import "MenueViewController.h"
#import "CurrencyEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainViewController : UIViewController <MenueViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    UIView* rootView;
    bool isNotFirstStartup;
    double valueToCalculate;
    NSInteger decimalPlaces;
    bool darkmode;
    IBOutlet UITextField *tfValueToCalculate;
    IBOutlet UILabel *lblResult;
    IBOutlet UILabel *lblCurrenciesComparison;
    IBOutlet UILabel *lblTitle;
    IBOutlet UIButton *btnCountryRight;
    IBOutlet UIButton *btnCountryLeft;
    IBOutlet UIButton *btnSwitchCountries;
    IBOutlet UIButton *btnSettings;
    IBOutlet UITableView *tableViewLeft;
    IBOutlet UITableView *tableViewRight;
    NSMutableArray* tableViewCountryData;
    NSMutableArray* tableViewCountryCodeData;
    NSMutableArray* currencyEntities;

    
    CALayer* bottomBorderTfValueToCalculate;
    CALayer* bottomBorderLblResult;
    
    CurrencyEntity* euroEntity;
}

-(void) loadControllerWithEntities:(NSMutableArray*)entities;

@end

NS_ASSUME_NONNULL_END
