//
//  CurrencyEntity.m
//  Waehrungsrechner
//
//  Created by Labor on 22.11.21.
//

#import "CurrencyEntity.h"

/*
 <kurs id="242505">
 <land>Australien</land>
 <iso2>AU</iso2>
 <kurswert>1,5528</kurswert>
 <iso3>AUD</iso3>
 <startdatum>01.11.2021</startdatum>
 <enddatum>30.11.2021</enddatum>
 </kurs>
 */

@implementation CurrencyEntity

@synthesize kursID, land, kurswert, laenderCode, laenderIsoCode, startDatum, endDatum;

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInteger:kursID forKey:@"kursID"];
    [encoder encodeObject:land forKey:@"land"];
    [encoder encodeDouble:kurswert forKey:@"kurswert"];
    [encoder encodeObject:laenderCode forKey:@"laenderCode"];
    [encoder encodeObject:laenderIsoCode forKey:@"laenderIsoCode"];
    [encoder encodeObject:startDatum forKey:@"startDatum"];
    [encoder encodeObject:endDatum forKey:@"endDatum"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init]))
    {
        kursID = [decoder decodeIntegerForKey:@"kursID"];
        land = [decoder decodeObjectOfClass:[NSString class] forKey:@"land"];
        kurswert = [decoder decodeDoubleForKey:@"kurswert"];
        laenderCode = [decoder decodeObjectOfClass:[NSString class] forKey:@"laenderCode"];
        laenderIsoCode = [decoder decodeObjectOfClass:[NSString class] forKey:@"laenderIsoCode"];
        startDatum = [decoder decodeObjectOfClass:[NSDate class] forKey:@"startDatum"];
        endDatum = [decoder decodeObjectOfClass:[NSDate class] forKey:@"endDatum"];
    }
    return self;
}

+(BOOL)supportsSecureCoding
{
    return YES;
}

@end
