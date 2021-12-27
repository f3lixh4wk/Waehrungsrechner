//
//  MainViewController.m
//  Waehrungsrechner
//
//  Created by Labor on 05.12.21.
//

#import "MainViewController.h"
#import "MenueViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Idee für Animation: Wenn der SwitchCountryButton gedrückt wird, dann wird das Switchen animiert.
    // TODO ein kleines HelperInterface schreiben, damit der Code hier übersichtlicher wird
    // Nice to have: wenn man auf einen der beiden Button klickt, wäre es cool wenn dann ein suchfeld erscheint,
    // in dem man nach der gewünschten Währung suchen könnte, diese wird anhand des Suchbegriffes herausgefiltert.
    
    [self initEuroEntity];
    [self prepareTableViewData];
    
    tableViewLeft.delegate = self;
    tableViewLeft.dataSource = self;
    tableViewLeft.hidden = YES;
    tableViewLeft.scrollEnabled = YES;
    
    tableViewRight.delegate = self;
    tableViewRight.dataSource = self;
    tableViewRight.hidden = YES;
    tableViewRight.scrollEnabled = YES;
    
    tfValueToCalculate.delegate = self;
    tfValueToCalculate.keyboardType = UIKeyboardTypeDecimalPad;
    bottomBorderTfValueToCalculate = [self createBottomBorderForView:tfValueToCalculate];
    [tfValueToCalculate.layer addSublayer:bottomBorderTfValueToCalculate];
    tfValueToCalculate.textAlignment = NSTextAlignmentCenter;
    
    bottomBorderLblResult = [self createBottomBorderForView:lblResult];
    [lblResult.layer addSublayer:bottomBorderLblResult];
    lblResult.textAlignment = NSTextAlignmentCenter;
    
    isNotFirstStartup = [[NSUserDefaults standardUserDefaults] boolForKey:@"firstStartUpMain"];
    if (isNotFirstStartup == true)
        decimalPlaces = [[NSUserDefaults standardUserDefaults] integerForKey:@"decimalPlacesMain"];
    else
        decimalPlaces = 2;
    
    [self setButtonContentWithButton:btnCountryLeft andLoadForKey:@"leftCurrency"];
    [self setButtonContentWithButton:btnCountryRight andLoadForKey:@"rightCurrency"];
    
    NSArray* currentCurrencies = [self leftAndRightCurrencyArray];
    [self updateComparisonForLeftCurrency:[currentCurrencies objectAtIndex:0] andRightCurrency:[currentCurrencies objectAtIndex:1]];
    [self updateCurrencyCourseResultFromString:tfValueToCalculate.text];
}

-(void)initEuroEntity
{
    euroEntity = [[CurrencyEntity alloc] init];
    euroEntity.land = @"Euro";
    euroEntity.kurswert = 1.0;
    euroEntity.laenderCode = @"EU";
    euroEntity.laenderIsoCode = @"EUR";
    
    NSMutableArray* dateRange = [self dateRange];
    if ([dateRange count] != 0)
    {
        euroEntity.startDatum = [dateRange objectAtIndex:0];
        euroEntity.endDatum = [dateRange objectAtIndex:1];
    }
    
    [currencyEntities addObject:euroEntity];
}

-(void) loadControllerWithEntities:(NSMutableArray *)entities
{
    currencyEntities = entities;
}

-(void)prepareTableViewData
{
    tableViewCountryData = [[NSMutableArray alloc] init];
    tableViewCountryCodeData = [[NSMutableArray alloc] init];
    
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
    [tfValueToCalculate resignFirstResponder];
}

-(IBAction)btnCountryRightHandler:(id)sender
{
    tableViewRight.hidden = tableViewRight.hidden ? NO : YES;
    tableViewLeft.hidden = YES;
    [tfValueToCalculate resignFirstResponder];
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
    
    [tfValueToCalculate resignFirstResponder];
    NSArray* currentCurrencies = [self leftAndRightCurrencyArray];
    [self updateComparisonForLeftCurrency:[currentCurrencies objectAtIndex:0] andRightCurrency:[currentCurrencies objectAtIndex:1]];
    [self updateCurrencyCourseResultFromString:tfValueToCalculate.text];
}

-(CurrencyEntity*)getCurrencyByCountryName:(NSString*)countryName
{
    CurrencyEntity* entity = [[CurrencyEntity alloc] init];
    for (CurrencyEntity *currentEntity in currencyEntities)
    {
        if([currentEntity.land isEqualToString:countryName])
        {
            entity = currentEntity;
            break;
        }
    }
    return entity;
}

-(void)storeCurrency:(CurrencyEntity*)currency forKey:(NSString*)key
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:currency requiringSecureCoding:YES error:nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
}

-(CurrencyEntity*)loadCurrencyForKey:(NSString*)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *storedEncodedObject = [defaults objectForKey:key];
    CurrencyEntity* entity = [NSKeyedUnarchiver unarchivedObjectOfClass:[CurrencyEntity class] fromData:storedEncodedObject error:nil];
    return entity;
}

- (void)addItemViewController:(MenueViewController*)controller didFinishEnteringItem:(NSInteger)_decimalPlaces
{
    decimalPlaces = _decimalPlaces;
    [[NSUserDefaults standardUserDefaults] setInteger:decimalPlaces forKey:@"decimalPlacesMain"];
    
    NSString* textFieldText = tfValueToCalculate.text;
    if([textFieldText containsString:@","])
    {
        // Only allow the decimal places entered in the settings menu
        NSArray *components = [textFieldText componentsSeparatedByString:@","];
        NSString* decimalPlacesStr = [components objectAtIndex:1];
        while (decimalPlacesStr.length > decimalPlaces)
        {
            if (decimalPlacesStr.length > 0)
            {
                decimalPlacesStr = [decimalPlacesStr substringToIndex:[decimalPlacesStr length] - 1];
                textFieldText = [textFieldText substringToIndex:[textFieldText length] - 1];
            }
        }
        [tfValueToCalculate setText:textFieldText];
    }
    
    isNotFirstStartup = true;
    [[NSUserDefaults standardUserDefaults] setBool:isNotFirstStartup forKey:@"firstStartUpMain"];
    NSArray* currentCurrencies = [self leftAndRightCurrencyArray];
    [self updateComparisonForLeftCurrency:[currentCurrencies objectAtIndex:0] andRightCurrency:[currentCurrencies objectAtIndex:1]];
    [self updateCurrencyCourseResultFromString:tfValueToCalculate.text];
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
        [self->bottomBorderTfValueToCalculate removeFromSuperlayer];
        self->bottomBorderTfValueToCalculate = [self createBottomBorderForView:self->tfValueToCalculate];
        [self->tfValueToCalculate.layer addSublayer:self->bottomBorderTfValueToCalculate];
        
        [self->bottomBorderLblResult removeFromSuperlayer];
        self->bottomBorderLblResult = [self createBottomBorderForView:self->lblResult];
        [self->lblResult.layer addSublayer:self->bottomBorderLblResult];
    }];
}

-(CALayer*)createBottomBorderForView:(UIView*)view
{
    CALayer* bottomBorder = [CALayer layer];
    bottomBorder.borderColor = [UIColor blackColor].CGColor;
    bottomBorder.borderWidth = 1;
    bottomBorder.frame = CGRectMake(0, CGRectGetHeight(view.frame)-1, CGRectGetWidth(view.frame), 1);
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
    cell.accessoryView = countryImage; // Sorgt dafür, dass die Flagge auf der rechten Seite angezeigt wird
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
    
    NSString* leftCountryName = [self getCountryNameFromTitle:btnCountryLeft.currentTitle];
    NSString* rightCountryName = [self getCountryNameFromTitle:btnCountryRight.currentTitle];
    CurrencyEntity* leftEntity = [self getCurrencyByCountryName:leftCountryName];
    CurrencyEntity* rightEntity = [self getCurrencyByCountryName:rightCountryName];
    
    // Store selected entities in user defaults
    [self storeCurrency:leftEntity forKey:@"leftCurrency"];
    [self storeCurrency:rightEntity forKey:@"rightCurrency"];
    [self updateComparisonForLeftCurrency:leftEntity andRightCurrency:rightEntity];
    [self updateCurrencyCourseResultFromString:tfValueToCalculate.text];
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Bereite Animation vor
    CATransform3D rotate;
    rotate = CATransform3DMakeRotation((45*M_PI)/180, 0.0, 2.0, 0.0);
    cell.alpha = 0;
    cell.layer.transform = rotate;
    cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
    if(cell.layer.position.x != 0)
    {
        cell.layer.position = CGPointMake(0, cell.layer.position.y);
    }

    // Starte Animation
    [UIView animateWithDuration:1.0 animations:^(void)
    {
        cell.layer.transform = CATransform3DIdentity;
        cell.alpha = 1;
    }];
}

-(NSString*)getCountryNameFromTitle:(NSString*)title
{
    NSString* countryName = [[NSString alloc] initWithString:title];
    NSArray *components = [countryName componentsSeparatedByString:@" ("];
    NSString* countryNameObject = [components objectAtIndex:0];
    countryName = [countryNameObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return countryName;
}

-(void)setButtonContentWithIndexPath:(NSIndexPath *)indexPath andButton:(UIButton *)button
{
    NSString* countryName = [tableViewCountryData objectAtIndex:indexPath.row];
    NSString* countryCode = [tableViewCountryCodeData objectAtIndex:indexPath.row];
    UIImage *countryImage = [UIImage imageNamed:countryCode];
    UIFont *labelFont = [ UIFont fontWithName: @"System" size: 16.0 ];
    
    [button setTitle:[NSString stringWithFormat:@"   %@ (%@)", countryName, countryCode] forState:UIControlStateNormal];
    [button.titleLabel setFont:labelFont];
    [button setImage:countryImage forState:UIControlStateNormal];
}

-(void)setButtonContentWithButton:(UIButton*)button andLoadForKey:(NSString*)key
{
    CurrencyEntity* entity = [self loadCurrencyForKey:key];
    NSString* countryName = entity.land;
    NSString* countryCode = entity.laenderCode;
    UIImage *countryImage = [UIImage imageNamed:countryCode];
    UIFont *labelFont = [UIFont fontWithName: @"System" size: 16.0];
    
    [button setTitle:[NSString stringWithFormat:@"   %@ (%@)", countryName, countryCode] forState:UIControlStateNormal];
    [button.titleLabel setFont:labelFont];
    [button setImage:countryImage forState:UIControlStateNormal];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* textFieldText = textField.text;
    NSString* valueToCalculateStr = [[NSString alloc] init];
    
    // For allowing backspace
    if (!string.length)
    {
        valueToCalculateStr = [textFieldText substringToIndex:[textFieldText length]-1];
        [self updateCurrencyCourseResultFromString:valueToCalculateStr];
        return YES;
    }
    
    else if ([string containsString:@"."] || [string containsString:@","])
    {
        // Only allow one decimal comma to be entered
        if([textFieldText containsString:@","] || range.location == 0)
            return NO;
        
        NSMutableString *newTextFieldText = [NSMutableString stringWithString:textFieldText];
        [newTextFieldText insertString:@"," atIndex:range.location];
        
        [textField setText:newTextFieldText];
        return NO;
    }
    else if ([textFieldText containsString:@","])
    {
        // Only allow the decimal places entered in the settings menu
        NSArray *components = [textFieldText componentsSeparatedByString:@","];
        NSString* decimalPlacesStr = [components objectAtIndex:1];
        if(decimalPlacesStr.length >= decimalPlaces)
            return NO;
    }
    else if (textField.keyboardType == UIKeyboardTypeNumberPad)
    {
        // Only allows numbers to be entered
        if ([string rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location != NSNotFound)
            return NO;
    }
    
    if([textFieldText isEqualToString:@""])
    {
        [self updateCurrencyCourseResultFromString:string];
    }
    else
    {
        valueToCalculateStr = [NSString stringWithFormat:@"%@%@", textFieldText, string];
        [self updateCurrencyCourseResultFromString:valueToCalculateStr];
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *) event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ([tfValueToCalculate isFirstResponder] && (tfValueToCalculate != touch.view))
    {
        [tfValueToCalculate resignFirstResponder];
    }
}

-(double)calculateCurrencyCourseResult:(double)valueToCalculate
{
    // Währungskurs auf der rechten Seite durch Währungskurs auf der linken Seite teilen
    // Das Ergebnis mit dem valueToCalculate multiplizieren
    NSArray* currentCurrencies = [self leftAndRightCurrencyArray];
    CurrencyEntity* leftEntity = [currentCurrencies objectAtIndex:0];
    CurrencyEntity* rightEntity = [currentCurrencies objectAtIndex:1];
    
    double leftCurrencyCourseValue = leftEntity.kurswert;
    double rightCurrencyCourseValue = rightEntity.kurswert;
    
    return (rightCurrencyCourseValue / leftCurrencyCourseValue) * valueToCalculate;
}

-(void)updateComparisonForLeftCurrency:(CurrencyEntity*)leftCurrency andRightCurrency:(CurrencyEntity*)rightCurrency
{
    double leftCurrencyCourseValue = leftCurrency.kurswert;
    double rightCurrencyCourseValue = rightCurrency.kurswert;
    
    double lhsValue = leftCurrencyCourseValue / leftCurrencyCourseValue;
    double rhsValue = rightCurrencyCourseValue / leftCurrencyCourseValue;

    NSString *lhsValueStr = [self formatValue:lhsValue ToDecimalPlaces:decimalPlaces];
    NSString *rhsValueStr = [self formatValue:rhsValue ToDecimalPlaces:decimalPlaces];
    
    [lblCurrenciesComparison setText:[NSString stringWithFormat:@"%@ %@ = %@ %@", lhsValueStr, leftCurrency.laenderIsoCode, rhsValueStr, rightCurrency.laenderIsoCode]];
}

// Helper
// Index 0: NSDate for the First day of the month
// Index 1: NSDate for the Last day of the month
// TODO in den einstellungen die möglichkeit einer date range einstellung bieten -> dann muss es eine updateDateRange Methode geben, die bei jeder entity die date range updated.
-(NSMutableArray*)dateRange
{
    NSMutableArray* range = [[NSMutableArray alloc] init];
    if ([currencyEntities count] != 0)
    {
        CurrencyEntity* entity = [currencyEntities objectAtIndex:0];
        [range addObject:entity.startDatum];
        [range addObject:entity.endDatum];
    }
    return range;
}

// Helper
-(NSString*)formatValue:(double)value ToDecimalPlaces:(NSInteger)_decimalPlaces
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    if(_decimalPlaces < 3)
    {
        // Der Grund hier für das if statement ist, dass setMinimumFractionDigit minimal 3 Nachkommastellen anzeigt,
        // auch wenn in den Einstellungen z.B. maximal 2 Nachkommastellen eingestellt sind.
        // Allerdings wird bei Aufrundung die 0 hinten weggeschnitten :(
        [formatter setMaximumFractionDigits:decimalPlaces];
    }
    else
    {
        [formatter setMinimumFractionDigits:decimalPlaces];
    }
    [formatter setRoundingMode: NSNumberFormatterRoundHalfUp];

    NSString *valueStr = [formatter stringFromNumber:[NSNumber numberWithFloat:value]];
    return valueStr;
}

-(NSArray*)leftAndRightCurrencyArray
{
    NSString* leftCountryName = [self getCountryNameFromTitle:btnCountryLeft.currentTitle];
    CurrencyEntity* leftEntity = [self getCurrencyByCountryName:leftCountryName];
    NSString* rightCountryName = [self getCountryNameFromTitle:btnCountryRight.currentTitle];
    CurrencyEntity* rightEntity = [self getCurrencyByCountryName:rightCountryName];
    return @[leftEntity, rightEntity];
}

-(void)updateResultLabelWithValue:(double)value
{
    if(value == 0)
    {
        [lblResult setText:@""];
        return;
    }
    
    double currencyCourseResult = [self calculateCurrencyCourseResult:value];
    NSString* currencyCourseResultStr = [self formatValue:currencyCourseResult ToDecimalPlaces:decimalPlaces];
    [lblResult setText:[NSString stringWithFormat:@"%@", currencyCourseResultStr]];
}

-(void)updateCurrencyCourseResultFromString:(NSString*)string
{
    NSString* valueToCalculateStr = [[NSString alloc] init];
    double valueToCalculate;
    
    valueToCalculateStr = [NSString stringWithFormat:@"%@", string];
    valueToCalculateStr = [valueToCalculateStr stringByReplacingOccurrencesOfString:@"," withString:@"."]; // doubleValue benötigt die Punktnotation
    valueToCalculate = [valueToCalculateStr doubleValue];
    [self updateResultLabelWithValue:valueToCalculate];
}

@end
