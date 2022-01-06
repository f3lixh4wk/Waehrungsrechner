//
//  MenuViewController.h
//  Waehrungsrechner
//
//  Created by Labor on 15.12.21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MenueViewController;

@protocol MenueViewControllerDelegate <NSObject>

- (void)addItemViewController:(MenueViewController*)controller didFinishEnteringItem:(NSInteger)_decimalPlaces;
- (void)addItemViewController:(MenueViewController*)controller didFinishEnteringDarkmode:(bool)_darkmode;

@end

@interface MenueViewController : UIViewController
{
    UILabel* labelValue;
    bool isNotFirstStartup;
    bool darkmode;
    UILabel* decimalLabel;
    UILabel* settingsLabel;
    UILabel* backgroundLabel;
    UIButton* backButton;
    UIView* rootView;
    UIStepper* stepper;
    UISwitch* modeswitch;
}

@property (nonatomic) NSInteger decimalPlaces;
@property (nonatomic, weak) id <MenueViewControllerDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
