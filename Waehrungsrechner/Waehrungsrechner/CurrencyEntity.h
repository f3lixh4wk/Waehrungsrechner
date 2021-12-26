//
//  CurrencyEntity.h
//  Waehrungsrechner
//
//  Created by Labor on 22.11.21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CurrencyEntity : NSObject<NSCoding, NSSecureCoding>
{
    NSInteger kursID;
    NSString* land;
    double kurswert;
    NSString* laenderCode;
    NSString* laenderIsoCode;
    NSDate* startDatum;
    NSDate* endDatum;
}

@property (nonatomic) NSInteger kursID;
@property (nonatomic, strong) NSString* land;
@property (nonatomic) double kurswert;
@property (nonatomic, strong) NSString* laenderCode;
@property (nonatomic, strong) NSString* laenderIsoCode;
@property (nonatomic) NSDate* startDatum;
@property (nonatomic) NSDate* endDatum;

@end

NS_ASSUME_NONNULL_END
