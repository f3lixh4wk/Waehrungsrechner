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
    
    bottomBorderLblValueToCalculate = [self createBottomBorderForLabel:lblValueToCalculate];
    [lblValueToCalculate.layer addSublayer:bottomBorderLblValueToCalculate];
    
    bottomBorderLblResult = [self createBottomBorderForLabel:lblResult];
    [lblResult.layer addSublayer:bottomBorderLblResult];
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
    NSString* btnTitleLeft = btnCountryLeft.currentTitle;
    UIImage* countryImageLeft = btnCountryLeft.currentImage;
    NSString* btnTitleRight = btnCountryRight.currentTitle;
    UIImage* countryImageRight = btnCountryRight.currentImage;
    
    [btnCountryLeft setTitle:btnTitleRight forState:UIControlStateNormal];
    [btnCountryLeft setImage:countryImageRight forState:UIControlStateNormal];
    [btnCountryRight setTitle:btnTitleLeft forState:UIControlStateNormal];
    [btnCountryRight setImage:countryImageLeft forState:UIControlStateNormal];
}

- (void)addItemViewController:(MenueViewController*)controller didFinishEnteringItem:(NSInteger)_decimalPlaces
{
    decimalPlaces = _decimalPlaces;
}

-(IBAction)menuHandler:(id)sender
{
    MenueViewController* menue = [[MenueViewController alloc] init];
    menue.delegate = self;
    menue.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:menue animated:YES completion:nil];
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id  _Nonnull context)
    {
        // will execute during rotation
    }
    completion:^(id  _Nonnull context)
    {
        // will execute after rotation
        [self->bottomBorderLblValueToCalculate removeFromSuperlayer];
        self->bottomBorderLblValueToCalculate = [self createBottomBorderForLabel:self->lblValueToCalculate];
        [self->lblValueToCalculate.layer addSublayer:self->bottomBorderLblValueToCalculate];
        
        [self->bottomBorderLblResult removeFromSuperlayer];
        self->bottomBorderLblResult = [self createBottomBorderForLabel:self->lblResult];
        [self->lblResult.layer addSublayer:self->bottomBorderLblResult];
    }];
}

-(CALayer*)createBottomBorderForLabel:(UILabel*)label
{
    CALayer* bottomBorder = [CALayer layer];
    bottomBorder.borderColor = [UIColor blackColor].CGColor;
    bottomBorder.borderWidth = 1;
    bottomBorder.frame = CGRectMake(0, CGRectGetHeight(label.frame)-1, CGRectGetWidth(label.frame), 1);
    return bottomBorder;
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
    UIFont *labelFont = [ UIFont fontWithName: @"Arial" size: 16.0 ];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", countryName, countryCode];
    cell.textLabel.font  = labelFont;
    cell.accessoryView = countryImage;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == tableViewLeft)
    {
        [self setButtonContentWithIndexPath:indexPath andButton:btnCountryLeft];
        tableViewLeft.hidden = YES;
    }
    else if (tableView == tableViewRight)
    {
        [self setButtonContentWithIndexPath:indexPath andButton:btnCountryRight];
        tableViewRight.hidden = YES;
    }
}

-(void)setButtonContentWithIndexPath:(NSIndexPath *)indexPath andButton:(UIButton *)button
{
    NSString* countryName = [tableViewCountryData objectAtIndex:indexPath.row];
    NSString* countryCode = [tableViewCountryCodeData objectAtIndex:indexPath.row];
    UIImage *countryImage = [UIImage imageNamed:countryCode];
    UIFont *labelFont = [ UIFont fontWithName: @"Arial" size: 16.0 ];
    
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
