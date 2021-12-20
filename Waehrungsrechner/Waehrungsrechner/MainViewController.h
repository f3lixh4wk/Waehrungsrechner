//
//  MainViewController.h
//  Waehrungsrechner
//
//  Created by Labor on 05.12.21.
//

#import <UIKit/UIKit.h>
#import "MenueViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainViewController : UIViewController <MenueViewControllerDelegate>
{
    double _valueToCalculate;
    NSInteger _decimalPlaces;
    IBOutlet UILabel *_lblValueToCalculate;
    IBOutlet UILabel *_lblResult;
    IBOutlet UIButton *_btnCountryRight;
    IBOutlet UIButton *_btnCountryLeft;
    NSMutableArray* currencyEntities;
}

-(void) loadControllerWithEntities:(NSMutableArray*)entities;

@end

NS_ASSUME_NONNULL_END
