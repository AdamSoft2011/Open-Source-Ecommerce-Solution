//
//  BagViewController.m
//  Ecommerce
//
//  Created by Pengyu Lan on 25/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BagViewController.h"
#import "ProductColumnViewCell.h"
#import "BagAndSavedCommonMethods.h"
#import "Product.h"

@implementation BagViewController

@synthesize tableView;
@synthesize spinner;
@synthesize baggedProducts;
@synthesize label;
@synthesize saveBagButton;
@synthesize subtitleView;

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

#pragma mark - View lifecycle

- (void) dealloc
{
    [self.subtitleView release];
    [self.saveBagButton release];
    [self.tableView release];
    [self.spinner release];
    [self.baggedProducts release];
    [self.label release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGRect headerTitleSubtitleFrame = CGRectMake(0, 0, 320, 44);    
    UIView* headerTitleSubtitleView = [[[UILabel alloc] initWithFrame:headerTitleSubtitleFrame] autorelease];
    headerTitleSubtitleView.backgroundColor = [UIColor clearColor];
    headerTitleSubtitleView.autoresizesSubviews = YES;
    
    CGRect titleFrame = CGRectMake(0, 5, 320, 22);  
    UILabel *titleView = [[[UILabel alloc] initWithFrame:titleFrame] autorelease];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
    titleView.textAlignment = UITextAlignmentCenter;
    titleView.textColor = [UIColor whiteColor];
    titleView.text = @"Bag";
    titleView.shadowColor = [UIColor darkGrayColor];
    titleView.shadowOffset = CGSizeMake(0, -1);
    titleView.adjustsFontSizeToFitWidth = YES;
    [headerTitleSubtitleView addSubview:titleView];
    
    CGRect subtitleFrame = CGRectMake(0, 20, 320, 22);   
    subtitleView = [[[UILabel alloc] initWithFrame:subtitleFrame] autorelease];
    subtitleView.backgroundColor = [UIColor clearColor];
    subtitleView.font = [UIFont fontWithName:@"Arial" size:13]; 
    subtitleView.textAlignment = UITextAlignmentCenter;
    subtitleView.textColor = [UIColor grayColor];
    subtitleView.adjustsFontSizeToFitWidth = YES;
    [headerTitleSubtitleView addSubview:subtitleView];
    self.navigationItem.titleView = headerTitleSubtitleView;

    self.saveBagButton = [[UIBarButtonItem alloc] initWithTitle:@"Save Bag" style:UIBarButtonItemStylePlain target:self action:@selector(addBaggedProductsToSaved:)];          
    self.navigationItem.rightBarButtonItem = self.saveBagButton;
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320.f, 367.f)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.alpha = 0;
    [self.view addSubview:self.tableView];
    
    self.spinner = [[UIActivityIndicatorView alloc] init];
    self.spinner.center = CGPointMake(160.f, 184.f);
    [self.view addSubview:self.spinner];
    [self.spinner startAnimating];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.baggedProducts = [BagAndSavedCommonMethods loadBaggedProducts];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.spinner stopAnimating];
            if ([self.baggedProducts count] == 0) {
                [self.label setHidden:NO];
                subtitleView.text = @"0 items";
            }
            else
            {
                [self.label setHidden:YES];
                subtitleView.text = [NSString stringWithFormat:@"%i items", [self.baggedProducts count]];
                               
                UILabel *orderInTotalExcDeliveryFooter = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
                orderInTotalExcDeliveryFooter.text = @"Total(exc delivery): £410.00";
                orderInTotalExcDeliveryFooter.textAlignment = UITextAlignmentCenter;
                self.tableView.tableFooterView = orderInTotalExcDeliveryFooter;
                [orderInTotalExcDeliveryFooter release];
                
                [self.tableView reloadData];
                self.tableView.alpha = 1;
                self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i", [self.baggedProducts count]];
                [self.saveBagButton setEnabled:YES];
            }
        });
    });
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.tableView = nil;
    self.spinner = nil;
    self.baggedProducts = nil;
    self.label = nil;
    self.saveBagButton = nil;
    self.subtitleView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark - UITableView data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.baggedProducts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProductColumnViewCell";
    
    ProductColumnViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ProductColumnViewCell" owner:nil options:nil];
        
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                cell = (ProductColumnViewCell *)currentObject;
                break;
            }
        }
    }
    
    //cell.productName.text = ((Product *)[self.savedProducts objectAtIndex:[indexPath row]]).Name;
    return cell;
}

#pragma mark -
#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // navigate to ProductDetailViewController
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    // do nothing
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    // will be added later
}


@end
