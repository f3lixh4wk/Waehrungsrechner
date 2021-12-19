//
//  MainViewController.h
//  Waehrungsrechner
//
//  Created by Labor on 22.11.21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InitialViewController : UIViewController<NSURLSessionDelegate, NSURLSessionDataDelegate>
{
    NSString* path;
    NSURLSession* session;
    IBOutlet UILabel* lblDownloadStatus;
}

@property (strong, nonatomic) NSString* path;
@property (strong, nonatomic) NSURLSession* session;
@end

NS_ASSUME_NONNULL_END
