//
//  XMLReader.m
//  Waehrungsrechner
//
//  Created by Labor on 22.11.21.
//

#import "XMLParser.h"
#import "CurrencyEntity.h"

@implementation XMLParser

@synthesize currencyEntities;

- (id)initXMLParserWithPath:(NSString*)_path
{
    if(self == [super init])
    {
        numberFormatter = [NSNumberFormatter new];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [numberFormatter setDecimalSeparator:@","];
        
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
        
        parser = [[NSXMLParser alloc]initWithContentsOfURL:[NSURL fileURLWithPath:_path]];
        [parser setDelegate:self];
        [parser parse];
    }
    return self;
}

// Diese Methode wird aufgerufen, sobald in der XML Datei ein Element vom parser gefunden wird, das mit "<" startet und kein "/" enthält.
- (void)parser:(NSXMLParser*)parser didStartElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary*)attributeDict
{
    // The element variable is meant to hold the value of only one XML element. So, when a new element is started, we make sure to clear it out.
    currentElement = [NSMutableString string];
    
    if([elementName isEqualToString:@"kurse"])
    {
       currencyEntities = [[NSMutableArray alloc] init]; //Initialisiere Währungs-Array
    }
    else if([elementName isEqualToString:@"kurs"])
    {
        currency = [[CurrencyEntity alloc] init]; //Initialisiere eine Währung
        currency.kursID = [[attributeDict objectForKey:@"id"] integerValue]; //Extrahiere die Attribute der Währung
    }
}

// Diese Methode wird aufgerufen, sobald ein Character zwischen "><" gefunden wird
- (void)parser:(NSXMLParser*)parser foundCharacters:(NSString *)string
{
     if(currentElement == nil)
         currentElement = [[NSMutableString alloc] init];

     [currentElement appendString:string];
}

// Wird aufgerufen, sobald ein Ende Tag eines Elements erreicht wurde "</>"
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"kurse"])
        return;

    else if([elementName isEqualToString:@"kurs"])
    {
        [currencyEntities addObject:currency];
        currency = nil;
    }
    else if([elementName isEqualToString:@"land"])
        currency.land = [currentElement stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    else if([elementName isEqualToString:@"kurswert"])
    {
        NSNumber* number = [numberFormatter numberFromString:currentElement];
        currency.kurswert = [number doubleValue];
    }
    else if([elementName isEqualToString:@"iso2"])
        currency.laenderCode = [currentElement stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    else if([elementName isEqualToString:@"startdatum"])
        currency.startDatum = [dateFormatter dateFromString:currentElement];
    else if([elementName isEqualToString:@"enddatum"])
        currency.endDatum = [dateFormatter dateFromString:currentElement];
    
}

@end
