//
//  ProductDetailViewController.m
//  Ecommerce
//
//  Created by Pengyu Lan on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ProductSingleVariantViewController.h"
#import "DDPageControl.h"
#import "Product.h"
#import "Picture.h"
#import "ProductVariant.h"
#import "NSString+HTML.h"
#import "BagAndSavedCommonMethods.h"
#import "ProductVariantAttribute.h"
#import "ActionSheetPicker.h"

#define kRecommendImageWidth 215
#define kControlSeparationHeight 15

#define kRecipientNameTag 100
#define kRecipientEmailTag 101
#define kSenderNameTag 102
#define kSenderEmailTag 103

@implementation ProductSingleVariantViewController

@synthesize product;
@synthesize scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [pageControl release];
    [recipientName release];
    [recipientEmail release];
    [senderName release];
    [senderEmail release];
    [product release];
    [scrollView release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //scrollView.delegate = self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGFloat contentScrollViewHeight = 0.f;
    
    // customise the UINavigationBar.titleView
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480.f, 44.f)] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Arial" size:13];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = UITextAlignmentCenter;
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.text = self.product.Name;
    self.navigationItem.titleView = label;
    
    UIBarButtonItem *saveBagButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction 
                                                                                   target:self 
                                                                                   action:@selector(shareProducts)];
    self.navigationItem.rightBarButtonItem = saveBagButton;
    
    // get how many pictures this product have and the size of image
    // maybe later i will create a thread to get hold of the images
    NSArray *pictures = self.product.productPictures;
    NSInteger numberOfPictures = [pictures count];
    Picture *picture = [pictures objectAtIndex:0];
    UIImage *pictureImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:picture.PictureURL]];
    CGSize pictureSize = pictureImage.size;
    CGFloat ratio = pictureSize.width / kRecommendImageWidth;;
    CGSize newSize = CGSizeMake(pictureSize.width / ratio, pictureSize.height / ratio);
    
    UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
    
    // define the scroll view content size, frame and enable paging
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 10, newSize.width, newSize.height)];
    scrollView.center = CGPointMake(160, (newSize.height + 10) / 2);
    scrollView.delegate = self;
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setPagingEnabled:YES];
    [scrollView setContentSize:CGSizeMake(newSize.width * numberOfPictures, newSize.height)];
    contentScrollViewHeight += scrollView.frame.size.height + kControlSeparationHeight;
    [contentScrollView addSubview:scrollView];
    
    // programmatically add the page control
    pageControl = [[DDPageControl alloc] init];
    [pageControl setCenter:CGPointMake(self.view.center.x, newSize.height + 20.0f)];
    [pageControl setNumberOfPages:numberOfPictures];
    [pageControl setCurrentPage:0];
    [pageControl addTarget:self action:@selector(pageControlClicked:) forControlEvents:UIControlEventValueChanged];
    [pageControl setDefersCurrentPageDisplay:YES];
    [pageControl setType:DDPageControlTypeOnFullOffFull];
    [pageControl setOffColor: [UIColor colorWithWhite: 0.9f alpha: 1.0f]] ;
	[pageControl setOnColor: [UIColor colorWithWhite: 0.7f alpha: 1.0f]] ;
	[pageControl setIndicatorDiameter: 8.0f] ;
	[pageControl setIndicatorSpace: 8.0f] ;
    [pageControl setHidesForSinglePage:YES];
    if (!pageControl.hidden) {
        contentScrollViewHeight += 44.f + kControlSeparationHeight;
    }
	[contentScrollView addSubview: pageControl] ;

    UIImageView *productImageView;
    CGRect pageFrame;
    for (int i = 0; i < numberOfPictures; i ++) {
        pageFrame = CGRectMake(i * kRecommendImageWidth, 0.0f, kRecommendImageWidth, scrollView.bounds.size.height);
        
        productImageView = [[UIImageView alloc] initWithFrame:pageFrame];
        Picture *p = [pictures objectAtIndex:i];
        productImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:p.PictureURL]];
        [scrollView addSubview:productImageView];
        [productImageView release];
    }
    
    UILabel *productPriceLabel = [[[UILabel alloc] initWithFrame:CGRectMake(30, contentScrollViewHeight, 320, 20)] autorelease];
    contentScrollViewHeight += 20.f + kControlSeparationHeight;
    productPriceLabel.backgroundColor = [UIColor clearColor];
    productPriceLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:20];
    productPriceLabel.textAlignment = UITextAlignmentLeft;
    NSNumberFormatter *formatter = [[[NSNumberFormatter alloc] init] autorelease];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    ProductVariant *pv = [product.productVariants objectAtIndex:0]; 
    NSString *formatterOutput = [formatter stringFromNumber:[NSNumber numberWithFloat:pv.Price]];
    productPriceLabel.text = formatterOutput;
    [contentScrollView addSubview:productPriceLabel];

    if (pv.OldPrice != 0) {
        UILabel *productOldPriceLabel = [[[UILabel alloc] initWithFrame:CGRectMake(40 + productPriceLabel.frame.size.width, contentScrollViewHeight, 320, 20)] autorelease];
        productOldPriceLabel.backgroundColor = [UIColor clearColor];
        productOldPriceLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:20];
        productOldPriceLabel.textAlignment = UITextAlignmentLeft;
        productOldPriceLabel.textColor = [UIColor redColor];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        pv = [product.productVariants objectAtIndex:0]; 
        formatterOutput = [formatter stringFromNumber:[NSNumber numberWithFloat:pv.Price]];
        productOldPriceLabel.text = formatterOutput;
        [contentScrollView addSubview:productOldPriceLabel];
    }
    
    // product Full Description
    UITextView *productDescription = [[UITextView alloc] initWithFrame:CGRectMake(10, contentScrollViewHeight, 300, 100)];

    productDescription.font = [UIFont fontWithName:@"Arial" size:13];
    productDescription.text = [product.FullDescription stringByConvertingHTMLToPlainText];
    productDescription.frame = CGRectMake(10, contentScrollViewHeight, 300, productDescription.contentSize.height);
    // this is strange, setting twice and get the right height
    productDescription.frame = CGRectMake(10, contentScrollViewHeight, 300, productDescription.contentSize.height);
    [productDescription setEditable:NO];
    [contentScrollView addSubview:productDescription];
    [productDescription release];
    contentScrollViewHeight += productDescription.frame.size.height + kControlSeparationHeight;
    // physical gift card
    if (pv.IsGiftCard && [pv.GiftCardType isEqualToString:@"Physical"]) 
    {
        recipientName = [[UITextField alloc] init];
        recipientName.font = [UIFont fontWithName:@"Arial" size:15];
        recipientName.delegate = self;
        recipientName.tag = kRecipientNameTag;
        recipientName.placeholder = @"Recipient's Name";
        recipientName.borderStyle = UITextBorderStyleRoundedRect;
        recipientName.autocorrectionType = UITextAutocorrectionTypeNo;
        recipientName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        recipientName.clearButtonMode = UITextFieldViewModeWhileEditing;
        recipientName.frame = CGRectMake(30, contentScrollViewHeight, 200, 30);
        contentScrollViewHeight += recipientName.frame.size.height + kControlSeparationHeight;
        [contentScrollView addSubview:recipientName];
        
        senderName = [[UITextField alloc] init];
        senderName.font = [UIFont fontWithName:@"Arial" size:15];
        senderName.delegate = self;
        senderName.tag = kSenderNameTag;
        senderName.placeholder = @"Sender's Name";
        senderName.borderStyle = UITextBorderStyleRoundedRect;
        senderName.autocorrectionType = UITextAutocorrectionTypeNo;
        senderName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        senderName.clearButtonMode = UITextFieldViewModeWhileEditing;
        senderName.frame = CGRectMake(30, contentScrollViewHeight, 200, 30);
        contentScrollViewHeight += senderName.frame.size.height + kControlSeparationHeight;
        [contentScrollView addSubview:senderName];
    }
    // virtual gift card
    else if (pv.IsGiftCard && [pv.GiftCardType isEqualToString:@"Virtual"])
    {
        recipientName = [[UITextField alloc] init];
        recipientName.placeholder = @"Recipient's Name";
        recipientName.delegate = self;
        recipientName.tag = kRecipientNameTag;
        recipientName.borderStyle = UITextBorderStyleRoundedRect;
        recipientName.autocorrectionType = UITextAutocorrectionTypeNo;
        recipientName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        recipientName.clearButtonMode = UITextFieldViewModeWhileEditing;
        recipientName.frame = CGRectMake(30, contentScrollViewHeight, 200, 30);
        contentScrollViewHeight += recipientName.frame.size.height + kControlSeparationHeight;
        [contentScrollView addSubview:recipientName];
        
        recipientEmail = [[UITextField alloc] init];
        recipientEmail.placeholder = @"Recipient's Email";
        recipientEmail.delegate = self;
        recipientEmail.tag = kRecipientEmailTag;
        recipientEmail.borderStyle = UITextBorderStyleRoundedRect;
        recipientEmail.autocorrectionType = UITextAutocorrectionTypeNo;
        recipientEmail.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        recipientEmail.clearButtonMode = UITextFieldViewModeWhileEditing;
        recipientEmail.frame = CGRectMake(30, contentScrollViewHeight, 200, 30);
        contentScrollViewHeight += recipientEmail.frame.size.height + kControlSeparationHeight;
        [contentScrollView addSubview:recipientEmail];
        
        senderName = [[UITextField alloc] init];
        senderName.delegate = self;
        senderName.tag = kSenderNameTag;
        senderName.placeholder = @"Sender's Name";
        senderName.borderStyle = UITextBorderStyleRoundedRect;
        senderName.autocorrectionType = UITextAutocorrectionTypeNo;
        senderName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        senderName.clearButtonMode = UITextFieldViewModeWhileEditing;
        senderName.frame = CGRectMake(30, contentScrollViewHeight, 200, 30);
        contentScrollViewHeight += senderName.frame.size.height + kControlSeparationHeight;
        [contentScrollView addSubview:senderName];
        
        senderEmail = [[UITextField alloc] init];
        senderEmail.placeholder = @"Sender's Email";
        senderName.delegate = self;
        senderName.tag = kSenderNameTag;
        senderEmail.borderStyle = UITextBorderStyleRoundedRect;
        senderEmail.autocorrectionType = UITextAutocorrectionTypeNo;
        senderEmail.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        senderEmail.clearButtonMode = UITextFieldViewModeWhileEditing;
        senderEmail.frame = CGRectMake(30, contentScrollViewHeight, 200, 30);
        contentScrollViewHeight += senderEmail.frame.size.height + kControlSeparationHeight;
        [contentScrollView addSubview:senderEmail];
    }
    
    // ProductVariantAttribute
    // ControlType = 1. Dropdownlist
    // ControlType = 2. Dropdownlist
    // ControlType = 3. Multi-selection Dropdownlist
    // ControlType = 4. TextField
    else if (pv.ProductVariantAttributes.count > 0)
    {
        for (ProductVariantAttribute *pva in pv.ProductVariantAttributes) 
        {
            UITextField *textField = [[[UITextField alloc] init] autorelease];
            textField.delegate = self;
            textField.background = [UIImage imageNamed:@"DropdownBkground.png"];
            textField.borderStyle = UITextBorderStyleNone;
            textField.text = pva.ProductAttributeName;
            textField.clearButtonMode = UITextFieldViewModeNever;
            [textField addTarget:self action:@selector(selectAttributeValue:) forControlEvents:UIControlEventTouchDown];
            textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            textField.frame = CGRectMake(30, contentScrollViewHeight, 243, 28);
            contentScrollViewHeight += textField.frame.size.height + kControlSeparationHeight;
            UIView *paddingView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)] autorelease];
            textField.leftView = paddingView;
            textField.leftViewMode = UITextFieldViewModeAlways;
            [contentScrollView addSubview:textField];
        }
    }
    
    UIButton *addToBagBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addToBagBtn setFrame:CGRectMake(30, contentScrollViewHeight, 100, 37)];
    [addToBagBtn addTarget:self action:@selector(addToShoppingBag:) forControlEvents:UIControlEventTouchUpInside];
    [addToBagBtn setTitle:@"Add To Bag" forState:UIControlStateNormal];
    contentScrollViewHeight += addToBagBtn.frame.size.height + kControlSeparationHeight;
    [contentScrollView addSubview:addToBagBtn];
    
    UIButton *addToSaved = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addToSaved setFrame:CGRectMake(30, contentScrollViewHeight, 100, 37)];
    [addToSaved addTarget:self action:@selector(addToSaved:) forControlEvents:UIControlEventTouchUpInside];
    [addToSaved setTitle:@"Save For Later" forState:UIControlStateNormal];
    contentScrollViewHeight += addToSaved.frame.size.height + kControlSeparationHeight;
    [contentScrollView addSubview:addToSaved];
     
    contentScrollView.contentSize = CGSizeMake(320, contentScrollViewHeight + 30);
    
    [self.view addSubview:contentScrollView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.scrollView = nil;
    pageControl = nil;
    self.view = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark DDPageControl triggered actions

- (void)pageControlClicked:(id)sender
{
	DDPageControl *thePageControl = (DDPageControl *)sender ;
	
	// we need to scroll to the new index
	[scrollView setContentOffset: CGPointMake(kRecommendImageWidth * thePageControl.currentPage, scrollView.contentOffset.y) animated: YES] ;
    [pageControl updateCurrentPageDisplay];
}

#pragma mark -
#pragma mark UIScrollView delegate methods
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
	CGFloat pageWidth = kRecommendImageWidth ;
    float fractionalPage = scrollView.contentOffset.x / pageWidth ;
	NSInteger nearestNumber = lround(fractionalPage) ;
	
	if (pageControl.currentPage != nearestNumber)
	{
		pageControl.currentPage = nearestNumber ;
		
		// if we are dragging, we want to update the page control directly during the drag
		if (scrollView.dragging)
			[pageControl updateCurrentPageDisplay] ;
	}
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)aScrollView
{
	// if we are animating (triggered by clicking on the page control), we update the page control
	[pageControl updateCurrentPageDisplay] ;
}

#pragma mark -
#pragma mark UITextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ((textField.tag == kRecipientNameTag) || (textField.tag == kRecipientEmailTag) || (textField.tag == kSenderNameTag) || (textField.tag == kSenderEmailTag)) {
        return YES;
    }
    
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark button touchupinside event handler
-(void)addToShoppingBag:(id)sender
{
    // before product added into shopping bag
    // check product attribute and specification
    
    //NSLog(@"sender's name: %@", senderName.text);
    //NSLog(@"recipient's name: %@", recipientName.text);
    
    /*if ((senderName.text.length == 0) || (recipientName.text.length == 0)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"required fields are not filled" 
                                                        message:@"You need to fill in the required field" 
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {*/
        [BagAndSavedCommonMethods addBaggedProduct:self.product];
    //}
}

-(void)addToSaved:(id)sender
{

    [BagAndSavedCommonMethods addSavedProduct:self.product];

}

-(void)selectAttributeValue:(id)sender
{
    NSLog(@"im working");
    
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        if ([sender respondsToSelector:@selector(setText:)]) {
            [sender performSelector:@selector(setText:) withObject:selectedValue];
        }
    };
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    };
    NSArray *colors = [NSArray arrayWithObjects:@"Red", @"Green", @"Blue", @"Orange", nil];
    [ActionSheetStringPicker showPickerWithTitle:@"Select a Block" rows:colors initialSelection:0 doneBlock:done cancelBlock:cancel origin:sender];
}

- (void)shareProducts
{
    
}
@end
