//
//  MainViewController.m
//  Waehrungsrechner
//
//  Created by Labor on 05.12.21.
//

#import "MainViewController.h"
#import "MenueViewController.h"
#import "CurrencyEntity.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Idee für Animation: Wenn der SwitchCountryButton gedrückt wird, dann wird das Switchen animiert.
    
    [self prepareTableViewData];
    
    tableViewLeft.delegate = self;
    tableViewLeft.dataSource = self;
    tableViewLeft.hidden = YES;
    tableViewLeft.scrollEnabled = YES;
    
    tableViewRight.delegate = self;
    tableViewRight.dataSource = self;
    tableViewRight.hidden = YES;
    tableViewRight.scrollEnabled = YES;
}

-(void) loadControllerWithEntities:(NSMutableArray *)entities
{
    currencyEntities = entities;
}

-(void)prepareTableViewData
{
    tableViewCountryData = [[NSMutableArray alloc] init];
    tableViewCountryCodeData = [[NSMutableArray alloc] init];
    
    [tableViewCountryData addObject:@"Euro"];
    [tableViewCountryCodeData addObject:@"EU"];
    
    for (CurrencyEntity *entity in currencyEntities)
    {
        [tableViewCountryData addObject:entity.land];
        [tableViewCountryCodeData addObject:entity.laenderCode];
    }
}

-(IBAction)btnCountryLeftHandler:(id)sender
{
    tableViewLeft.hidden = tableViewLeft.hidden ? NO : YES;
    tableViewRight.hidden = YES;
}

-(IBAction)btnCountryRightHandler:(id)sender
{
    tableViewRight.hidden = tableViewRight.hidden ? NO : YES;
    tableViewLeft.hidden = YES;
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableViewCountryData count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView == tableViewLeft
    ? [self setCellForRowAtIndexPath:indexPath withTableView:tableView andWithIdentifier:@"tableLeft"]
    : [self setCellForRowAtIndexPath:indexPath withTableView:tableView andWithIdentifier:@"tableRight"];
}

-(UITableViewCell*)setCellForRowAtIndexPath:(NSIndexPath *) indexPath withTableView:(UITableView *) tableView andWithIdentifier:(NSString *)identifier
{
    UITableViewCell* cell = [[UITableViewCell alloc] init];
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSString* countryName = [tableViewCountryData objectAtIndex:indexPath.row];
    NSString* countryCode = [tableViewCountryCodeData objectAtIndex:indexPath.row];
    UIImageView *countryImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:countryCode]];
    UIFont *labelFont = [ UIFont fontWithName: @"Arial" size: 14.0 ];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", countryName, countryCode];
    cell.textLabel.font  = labelFont;
    cell.accessoryView = countryImage;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == tableViewLeft)
    {
        [self setButtonContentWithIndexPath:indexPath andButton:_btnCountryLeft];
        tableViewLeft.hidden = YES;
    }
    else if (tableView == tableViewRight)
    {
        [self setButtonContentWithIndexPath:indexPath andButton:_btnCountryRight];
        tableViewRight.hidden = YES;
    }
}

-(void)setButtonContentWithIndexPath:(NSIndexPath *)indexPath andButton:(UIButton *)button
{
    NSString* countryName = [tableViewCountryData objectAtIndex:indexPath.row];
    NSString* countryCode = [tableViewCountryCodeData objectAtIndex:indexPath.row];
    UIImage *countryImage = [UIImage imageNamed:countryCode];
    UIFont *labelFont = [ UIFont fontWithName: @"Arial" size: 14.0 ];
    
    [button setTitle:[NSString stringWithFormat:@"   %@ (%@)", countryName, countryCode] forState:UIControlStateNormal];
    [button.titleLabel setFont:labelFont];
    [button setImage:countryImage forState:UIControlStateNormal];
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
