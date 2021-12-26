//
//  MainViewController.m
//  Waehrungsrechner
//
//  Created by Labor on 22.11.21.
//

#import "InitialViewController.h"
#import "MainViewController.h"
#import "XMLParser.h"

@interface InitialViewController ()
{
    //https://www.zoll.de/DE/Fachthemen/Zoelle/Zollwert/Aktuelle-Wechselkurse/Datenbankanwendung/abruf_wechselkurse.html?nn=298574&faqCalledDoc=298574
}

@end

@implementation InitialViewController

@synthesize path, session;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self downloadXML];
}

-(NSString*) getURLWithCurrentDate
{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *year = [formatter stringFromDate:now];
    [formatter setDateFormat:@"MM"];
    NSString *month = [formatter stringFromDate:now];
    [formatter setDateFormat:@"dd"];
    NSString *day = [formatter stringFromDate:now];
    
    // Wenn man Start und Enddatum gleich wählt in der URL, wird die Gültigkeit der Kurse für den ganzen Monat geliefert.
    NSString *urlStr = [NSString stringWithFormat:@"http://www.zoll.de/SiteGlobals/Functions/Kurse/KursExport.xml?view=xmlexportkursesearchresultZOLLWeb&kursart=1&startdatum_tag2=%@&startdatum_monat2=%@&startdatum_jahr2=%@&enddatum_tag2=%@&enddatum_monat2=%@&enddatum_jahr2=%@&sort=asc&spalte=gueltigkeit",
                        day,
                        month,
                        year,
                        day,
                        month,
                        year];
    return urlStr;
}

-(void)downloadXML
{
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSString* downloadURL = [self getURLWithCurrentDate];
    NSURLSessionDownloadTask* task = [session downloadTaskWithURL:[NSURL URLWithString:downloadURL]];
    [activityIndicator startAnimating];
    
    [task resume];
}

-(void) URLSession:(NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(nonnull NSURL *)location
{
    lblDownloadStatus.text = @"Download Completed!";
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString* directoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    path = [NSString stringWithFormat:@"%@/KursExport.xml", directoryPath];
    [fileManager moveItemAtURL:location toURL:[NSURL fileURLWithPath:path] error:nil];
    [activityIndicator stopAnimating];
    
    [self readXML];
}

-(void)URLSession:(NSURLSession*)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    float totalSize = totalBytesExpectedToWrite/1024; // KByte
    float writtenSize = totalBytesWritten/1024; // KByte
    
    lblDownloadStatus.text = [NSString stringWithFormat:@"Downloading KursExport.xml...\n%.2f KB of %.2f KB", writtenSize, totalSize]; // UI activity indicator
    // documents ordner abspeichern nice to have
}

-(void)readXML
{
    XMLParser* parser = [[XMLParser alloc]initXMLParserWithPath:path];
    entities = parser.currencyEntities;
    [self loadMainViewControllerWithEntities:entities];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"loadMainViewController"])
    {
        MainViewController* controller = (MainViewController*)segue.destinationViewController;
        [controller loadControllerWithEntities:entities];
    }
}

-(void)loadMainViewControllerWithEntities:(NSMutableArray*)entities
{
    [self performSegueWithIdentifier:@"loadMainViewController" sender:self]; // calls prepareForSegue
}

- (BOOL) shouldAutorotate
{
    return YES;
}

@end
