//
//  SavedViewController.m
//  Ecommerce
//
//  Created by Pengyu Lan on 25/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SavedViewController.h"
#import "BagAndSavedCommonMethods.h"
#import "Product.h"
#import "ProductColumnViewCell.h"

@implementation SavedViewController

@synthesize tableView;
@synthesize spinner;
@synthesize savedProducts;
@synthesize label;
@synthesize addToBagButton;
@synthesize subtitleView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        savedProducts = [[NSMutableArray alloc] init];
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
    [self.addToBagButton release];
    [self.tableView release];
    [self.spinner release];
    [self.savedProducts release];
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
    titleView.text = @"Saved";
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
    
    self.addToBagButton = [[UIBarButtonItem alloc] initWithTitle:@"Add All to Bag" style:UIBarButtonItemStylePlain target:self action:@selector(addSavedProductsToShoppingBag)];          
    self.navigationItem.rightBarButtonItem = addToBagButton;
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
        self.savedProducts = [BagAndSavedCommonMethods loadSavedProducts];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.spinner stopAnimating];
            if ([self.savedProducts count] == 0) {
                [self.label setHidden:NO];
                subtitleView.text = @"0 items";
            }
            else
            {
                [self.label setHidden:YES];
                subtitleView.text = [NSString stringWithFormat:@"%i items", [self.savedProducts count]];
                [self.tableView reloadData];
                self.tableView.alpha = 1;
                self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i", [self.savedProducts count]];
                [self.addToBagButton setEnabled:YES];
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
    self.savedProducts = nil;
    self.label = nil;
    self.addToBagButton = nil;
    self.subtitleView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - 
- (void)addSavedProductsToShoppingBag
{
    NSLog(@"add saved products to bag");
}

#pragma mark -
#pragma mark - UITableView data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.savedProducts count];
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
    
    cell.productName.text = ((Product *)[self.savedProducts objectAtIndex:[indexPath row]]).Name;
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
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // remove the row from data source
        [self.savedProducts removeObjectAtIndex:[indexPath row]];
        [BagAndSavedCommonMethods saveSavedProduct:self.savedProducts];
        
        // remove the row from table
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        // reset subtitle value
        subtitleView.text = [NSString stringWithFormat:@"%i items", [self.savedProducts count]];
        
        // reset badge value, if no saved products, hide tableview
        if (self.savedProducts.count == 0) {
            self.tableView.alpha = 0;
            [self.label setHidden:NO];
            self.navigationController.tabBarItem.badgeValue = nil;
        } 
        else
        { 
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i", [self.savedProducts count]];
        }
        
    }
    

}

@end
