//
//  ProductGridViewController.m
//  Ecommerce
//
//  Created by Pengyu Lan on 09/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ProductGridViewController.h"
#import "ProductGridViewCell.h"
#import "UILabelStrikethrough.h"
#import "Product.h"
#import "EcommerceAppDelegate.h"
#import "Category.h"
#import "ProductXMLParser.h"
#import "ProductVariant.h"
#import "Picture.h"
#import "ProductSingleVariantViewController.h"
#import "HJManagedImageV.h"
#import "BagAndSavedCommonMethods.h"
#import "ActionSheetPicker.h"
#import "GetProductsWithGXMLParser.h"

@implementation ProductGridViewController

@synthesize gridView;
@synthesize zoomInButton;
@synthesize zoomOutButton;
@synthesize numberOfItemsPerRow;
@synthesize sortTextfield;
@synthesize pickerData;
@synthesize products;
@synthesize imageHeightOfTwoItemsPerRow;
@synthesize imageHeightOfThreeItemsPerRow;
@synthesize imageHeightOfFourItemsPerRow;
@synthesize productDetailViewController;
//@synthesize actionSheetPicker;
@synthesize selectedIndexNumber;
@synthesize previousSelectedIndexNumber;
@synthesize navBartitle;
@synthesize searchTerm;

@synthesize spinner;
@synthesize portrait;
@synthesize landscape;

#define TwoImagesPerRow 0
#define ThreeImagesPerRow 1
#define FourImagesPerRow 2

//@"Price - Low to High", @"Price - High to Low", @"Newest First", @"Sale Items First", @"Normal Items First
#define kLowToHigh 0
#define kHighToLow 1
#define kNewestFirst 2
#define kSalesItemsFirst 3
#define kNormalItemsFirst 4


#define TagForLogoInNavigationController 10001
#define TagForSearchInNavigationController 10002

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        products = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void) dealloc
{
    [searchTerm release];
    [productDetailViewController release];
    [products release];
    [zoomInButton release];
    [zoomOutButton release];
    [sortTextfield release];
    [gridView release];
    [pickerData release];
    [pickerShowInTextFieldData release];
    //[actionSheetPicker release];
    [navBartitle release];
    [self.spinner release];
    [self.portrait release];
    [self.landscape release];
    [super dealloc]; 
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.previousSelectedIndexNumber = -1;
    self.selectedIndexNumber = 2;
    
    // pickerView init
    self.pickerData = [[NSArray alloc] initWithObjects:@"Price - Low to High", @"Price - High to Low", @"Newest First", @"Sale Items First", @"Normal Items First" ,nil];
    pickerShowInTextFieldData = [[NSArray alloc] initWithObjects:@"Low to High", @"High to Low", @"Newest", @"Sale Items", @"Normal Items" ,nil];
    
    // customize the UINavigationBar.titleView
    // Replace titleView
    CGRect headerTitleSubtitleFrame = CGRectMake(0.f, 0.f, 200.f, 44.f);    
    UIView* headerTitleSubtitleView = [[[UILabel alloc] initWithFrame:headerTitleSubtitleFrame] autorelease];
    headerTitleSubtitleView.backgroundColor = [UIColor clearColor];
    headerTitleSubtitleView.autoresizesSubviews = YES;
    
    CGRect titleFrame = CGRectMake(0.f, 5.f, 200.f, 22.f);  
    titleView = [[[UILabel alloc] initWithFrame:titleFrame] autorelease];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
    titleView.textAlignment = UITextAlignmentCenter;
    titleView.textColor = [UIColor whiteColor];
    titleView.shadowColor = [UIColor darkGrayColor];
    titleView.shadowOffset = CGSizeMake(0, -1);
    titleView.adjustsFontSizeToFitWidth = YES;
    [headerTitleSubtitleView addSubview:titleView];
    
    CGRect subtitleFrame = CGRectMake(0.f, 20.f, 200.f, 22.f);   
    subtitleView = [[[UILabel alloc] initWithFrame:subtitleFrame] autorelease];
    subtitleView.backgroundColor = [UIColor clearColor];
    subtitleView.font = [UIFont fontWithName:@"Arial" size:13]; 
    subtitleView.textAlignment = UITextAlignmentCenter;
    subtitleView.textColor = [UIColor grayColor];
    subtitleView.text = @"";
    subtitleView.adjustsFontSizeToFitWidth = YES;
    [headerTitleSubtitleView addSubview:subtitleView];
    self.navigationItem.titleView = headerTitleSubtitleView;
    
    // zoomOutButton
    self.zoomOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *zoomOutButtonBkgroundImage = [UIImage imageNamed:@"Zoomout.png"];
    [self.zoomOutButton setBackgroundImage:zoomOutButtonBkgroundImage forState:UIControlStateNormal];
    self.zoomOutButton.frame = CGRectMake(6.f, 7.f, 28.f, 28.f);
    [self.zoomOutButton addTarget:self action:@selector(zoomOut:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.zoomOutButton];
    
    // zoomInButton
    self.zoomInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *zoomInButtonBkgroundImage = [UIImage imageNamed:@"ZoominStop.png"];
    [self.zoomInButton setBackgroundImage:zoomInButtonBkgroundImage forState:UIControlStateNormal];
    self.zoomInButton.frame = CGRectMake(40.f, 7.f, 28.f, 28.f);
    [self.zoomInButton addTarget:self action:@selector(zoomIn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.zoomInButton];
    
    // sortTextfield
    self.sortTextfield = [[UITextField alloc] init];
    sortTextfield.delegate = self;
    sortTextfield.background = [UIImage imageNamed:@"categoryPagedropdownfield.png"];
    sortTextfield.borderStyle = UITextBorderStyleNone;
    sortTextfield.text = [pickerShowInTextFieldData objectAtIndex:self.selectedIndexNumber];
    sortTextfield.font = [UIFont fontWithName:@"Arial" size:13];
    sortTextfield.clearButtonMode = UITextFieldViewModeNever;
    [self.sortTextfield addTarget:self action:@selector(chooseSortMethod:) forControlEvents:UIControlEventTouchDown];
    sortTextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    sortTextfield.frame = CGRectMake(219.f, 7.f, 96.f, 26.f);
    UIView *leftPaddingView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)] autorelease];
    sortTextfield.leftView = leftPaddingView;
    sortTextfield.leftViewMode = UITextFieldViewModeAlways;
    UIView *rightPaddingView = [[[UIView alloc] initWithFrame:CGRectMake(68, 0, 28, 20)] autorelease];
    sortTextfield.rightView = rightPaddingView;
    sortTextfield.rightViewMode = UITextFieldViewModeAlways;
    [self.sortTextfield setEnabled:NO];
    [self.view addSubview:self.sortTextfield];
    
    // banner
    UIImageView *headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MiddleBkground.png"]];
    headerImageView.frame = CGRectMake(0.f, 36.f, 320.f, 5.f);
    [self.view addSubview:headerImageView];
    [headerImageView release];
    
    // initialise gridView
    self.numberOfItemsPerRow = TwoImagesPerRow;
    self.gridView = [[AQGridView alloc] initWithFrame:CGRectMake(0.f, 41.f, 320.f, 326.f)];
    self.gridView.resizesCellWidthToFit = NO;
    [self.view addSubview:gridView];
    
    // spinner
    self.spinner.hidesWhenStopped = YES;
    
    
    
    // set AQGridViewController delegate and data source
    self.gridView.dataSource = self;
    self.gridView.delegate = self;
    
    // spinner starts to animate
    [self.spinner startAnimating];
    
    // gridView invisible
    self.gridView.alpha = 0;
    
    
    // put products loading into another thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (searchTerm.length == 0 ) {
            [self loadingProducts];
        }
        else
        {
            self.products = [BagAndSavedCommonMethods handleSearchTerm:self.searchTerm]; 
        }
        
        // after loading products make gridView visible and stop and hide spinner
        dispatch_async(dispatch_get_main_queue(), ^{
            Product *p = [products objectAtIndex:0];
            Picture *pic = [p.productPictures objectAtIndex:0];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:pic.PictureURL]];
            
            imageHeightOfTwoItemsPerRow = ceilf(155.0f * image.size.height / image.size.width);
            imageHeightOfThreeItemsPerRow = ceilf(104.0f * image.size.height / image.size.width);
            imageHeightOfFourItemsPerRow = ceilf(77.0f * image.size.height / image.size.width);
            
            UIApplication *app = [UIApplication sharedApplication];
            app.networkActivityIndicatorVisible = NO;
            [self.gridView reloadData];
            self.gridView.alpha = 1;
            [self.sortTextfield setEnabled:YES];
            subtitleView.text = [NSString stringWithFormat:@"%i styles", [products count]];
            [self.spinner stopAnimating];
        });
    });

}

- (void)viewWillAppear:(BOOL)animated
{
    // restore the original looking of NavigationBar
    CGRect frame = CGRectMake(0, 20, 320, 44);
    [self.navigationController.navigationBar setFrame:frame];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    // remove previously added views
    for (UIView *view in self.navigationController.navigationBar.subviews) {
        if  (view.tag == TagForLogoInNavigationController || view.tag == TagForSearchInNavigationController)
        {
            [view removeFromSuperview];
        }
    }
    
    titleView.text = self.navBartitle;
        
    switch (numberOfItemsPerRow) {
        case TwoImagesPerRow:
            [self.zoomOutButton setBackgroundImage:[UIImage imageNamed:@"Zoomout.png"] forState:UIControlStateNormal];
            [self.zoomOutButton setEnabled:YES];
            [self.zoomInButton setEnabled:NO];
            break;
        case ThreeImagesPerRow:
            [self.zoomOutButton setBackgroundImage:[UIImage imageNamed:@"Zoomout.png"] forState:UIControlStateNormal];
            [self.zoomInButton setBackgroundImage:[UIImage imageNamed:@"Zoomin.png"] forState:UIControlStateNormal];
            [self.zoomOutButton setEnabled:YES];
            [self.zoomInButton setEnabled:YES];
            break;
        case FourImagesPerRow:
            [self.zoomInButton setBackgroundImage:[UIImage imageNamed:@"Zoomin.png"] forState:UIControlStateNormal];
            [self.zoomOutButton setEnabled:NO];
            [self.zoomInButton setEnabled:YES];
            break;
        default:
            break;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.portrait = nil;
    self.landscape = nil;
}

- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationPortrait == toInterfaceOrientation)
    {
        
    }
    else if (UIInterfaceOrientationLandscapeLeft == toInterfaceOrientation)
    {
        
    }
    else if (UIInterfaceOrientationLandscapeRight == toInterfaceOrientation)
    {
        
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark Grid View Data Source
- (NSUInteger) numberOfItemsInGridView:(AQGridView *)gridView
{
    //NSLog(@"PRODUCTS HAS %i products", [products count]);
    return [products count];
}

- (CGSize) portraitGridCellSizeForGridView:(AQGridView *)gridView
{
    if (numberOfItemsPerRow == TwoImagesPerRow)
    {
        return CGSizeMake(155, imageHeightOfTwoItemsPerRow + 60);
    }
    else if (numberOfItemsPerRow == ThreeImagesPerRow)
    {
        return CGSizeMake(104, imageHeightOfThreeItemsPerRow + 60);
    }
    else 
    {
        return CGSizeMake(77, imageHeightOfFourItemsPerRow + 60);
    }
}


- (AQGridViewCell *) gridView:(AQGridView *)gridView cellForItemAtIndex:(NSUInteger)index
{
    static NSString * ProductCellIdentifier = @"ProductCellIdentifier";
    HJManagedImageV *mi;
    Product *p = [products objectAtIndex:index];
    ProductVariant *pv = [p.productVariants objectAtIndex:0];
    Picture *pic = [p.productPictures objectAtIndex:0];
    
    ProductGridViewCell *cell = (ProductGridViewCell *)[self.gridView 
                                                dequeueReusableCellWithIdentifier:ProductCellIdentifier];
    if (cell == nil) {
        cell = [[ProductGridViewCell alloc] initWithFrame:CGRectMake(0, 0, 155, imageHeightOfTwoItemsPerRow + 60) reuseIdentifier:ProductCellIdentifier];
        mi = [[[HJManagedImageV alloc] init] autorelease];
        mi.tag = 999;
        [cell addSubview:mi];
    }else{
        mi = (HJManagedImageV*)[cell viewWithTag:999];
        [mi clear];
    }
    
    [mi showLoadingWheel];
    
    switch (numberOfItemsPerRow) {
        case TwoImagesPerRow:
            mi.frame = CGRectMake(0,0,155,imageHeightOfTwoItemsPerRow);
            cell.frame = CGRectMake(0,0,155,imageHeightOfTwoItemsPerRow + 60);
            cell.imageWidth = 155;
            cell.imageHeight = imageHeightOfTwoItemsPerRow;
            break;
        case ThreeImagesPerRow:
            mi.frame = CGRectMake(0,0,104,imageHeightOfThreeItemsPerRow);
            cell.frame = CGRectMake(0,0,104,imageHeightOfThreeItemsPerRow + 60);
            cell.imageWidth = 104;
            cell.imageHeight = imageHeightOfThreeItemsPerRow;
            break;
        case FourImagesPerRow:
            mi.frame = CGRectMake(0,0,77,imageHeightOfFourItemsPerRow);
            cell.frame = CGRectMake(0,0,77,imageHeightOfFourItemsPerRow + 60);
            cell.imageWidth = 77;
            cell.imageHeight = imageHeightOfFourItemsPerRow;
            break;
        default:
            break;
    }
    
    mi.url = pic.PictureURL;
    EcommerceAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate.objMan manage:mi];
    
    cell.product = p;
    
    // product description
    cell.productDescription.text = p.Name;
    if (numberOfItemsPerRow == FourImagesPerRow) 
    {
        cell.productDescription.hidden = YES;
    }
    else
    {
        cell.productDescription.hidden = NO;
    }
    
    // product price
    NSNumberFormatter *formatter = [[[NSNumberFormatter alloc] init] autorelease];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString *formatterOutput = [formatter stringFromNumber:[NSNumber numberWithFloat:pv.Price]];
    cell.productPrice.text = formatterOutput;
    
    // product old price
    formatterOutput = [formatter stringFromNumber:[NSNumber numberWithFloat:pv.OldPrice]];
    cell.productOldPrice.text = formatterOutput;
    
    if  (pv.OldPrice == 0)
    {
        cell.productOldPrice.hidden = YES;
    }
    else
    {
        cell.productOldPrice.hidden = NO;
    }

    return cell;
}


#pragma mark Grid View Delegate
- (void) gridView: (AQGridView *) gridView didSelectItemAtIndex: (NSUInteger) index
{
    if (self.productDetailViewController == nil)
    {
        ProductSingleVariantViewController* controller = [[ProductSingleVariantViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil];
        self.productDetailViewController = controller;
        [controller release];
    }
    self.navigationItem.title = self.title;
    Product *p = [self.products objectAtIndex:index];
    //self.productDetailViewController.title = p.Name;
    self.productDetailViewController.product = p;
    [self.navigationController pushViewController:self.productDetailViewController animated:YES];
}

#pragma mark - 
#pragma mark methods
- (void) adjustZoomInZoomOutButtonImage
{
    switch (numberOfItemsPerRow) {
        case TwoImagesPerRow:
            [self.zoomOutButton setBackgroundImage:[UIImage imageNamed:@"Zoomout.png"] forState:UIControlStateNormal];
            [self.zoomOutButton setEnabled:YES];
            [self.zoomInButton setEnabled:NO];
            break;
        case ThreeImagesPerRow:
            [self.zoomOutButton setBackgroundImage:[UIImage imageNamed:@"Zoomout.png"] forState:UIControlStateNormal];
            [self.zoomInButton setBackgroundImage:[UIImage imageNamed:@"Zoomin.png"] forState:UIControlStateNormal];
            [self.zoomOutButton setEnabled:YES];
            [self.zoomInButton setEnabled:YES];
            break;
        case FourImagesPerRow:
            [self.zoomInButton setBackgroundImage:[UIImage imageNamed:@"Zoomin.png"] forState:UIControlStateNormal];
            [self.zoomOutButton setEnabled:NO];
            [self.zoomInButton setEnabled:YES];
            break;
        default:
            break;
    }
}

- (void) zoomIn:(id)sender
{
    numberOfItemsPerRow --;
    if (numberOfItemsPerRow < TwoImagesPerRow) {
        numberOfItemsPerRow = TwoImagesPerRow;
    }

    [self adjustZoomInZoomOutButtonImage];
    [self.gridView reloadData];
}

- (void) zoomOut:(id)sender
{
    numberOfItemsPerRow ++;
    if (numberOfItemsPerRow > FourImagesPerRow) {
        numberOfItemsPerRow = FourImagesPerRow;
    }
    
    [self adjustZoomInZoomOutButtonImage];
    [self.gridView reloadData];
}

- (void) chooseSortMethod :(id)sender
{
    [[ActionSheetStringPicker showPickerWithTitle:@"Sort Products" 
                                      rows:self.pickerData 
                          initialSelection:self.selectedIndexNumber 
                                    target:self 
                                    sucessAction:@selector(itemWasSelected: element:) 
                                    cancelAction:@selector(actionPickerCancelled:)
                                    origin:sender] retain];
}

- (void)itemWasSelected:(NSNumber *)selectedIndex element:(id)element {
    self.previousSelectedIndexNumber = self.selectedIndexNumber;
    self.selectedIndexNumber = [selectedIndex intValue];
    if ([element respondsToSelector:@selector(setText:)]) {
        [element setText:[pickerShowInTextFieldData objectAtIndex:self.selectedIndexNumber]];
    }
    
    if (self.selectedIndexNumber == self.previousSelectedIndexNumber) {
        return;
    } 
    else
    {
        // going to sort products
        // @"Price - Low to High", @"Price - High to Low", @"Newest First", @"Sale Items First", @"Normal Items First
        switch (self.selectedIndexNumber) {
            case kLowToHigh:
                [self.gridView reloadData];
                break;
            case kHighToLow:
                [self.gridView reloadData];
                break;
            case kNewestFirst:
                [self.gridView reloadData];
                break;
            case kSalesItemsFirst:
                [self.gridView reloadData];
                break;
            case kNormalItemsFirst:
                [self.gridView reloadData];
                break;     
            default:
                break;
        }
        return;
    }
}


#pragma mark - 
#pragma mark LoadingProducts
- (void) loadingProducts
{
    products = [GetProductsWithGXMLParser loadProducts];
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;    
}

#pragma mark - 
#pragma mark - ActionSheetPickerDelegate
- (void)actionPickerCancelled: (id)sender {
    NSLog(@"Delegate has been informed that ActionSheetPicker was cancelled");
}

- (void)actionPickerDoneWithValue:(id)value {
    NSLog(@"Delegate has been informed that ActionSheetPicker completed with value: %@", value);
}

#pragma mark - 
#pragma mark - UITextfield delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

@end
