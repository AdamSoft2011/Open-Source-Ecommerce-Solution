//
//  SavedViewController.h
//  Ecommerce
//
//  Created by Pengyu Lan on 25/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SavedViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    // User interface controls
    UIBarButtonItem *addToBagButton;
    UITableView *tableView;
    UIActivityIndicatorView *spinner;
    UILabel *subtitleView;
    UILabel *label;
    
    // fields
    NSMutableArray *savedProducts;
}

@property (nonatomic, retain) UIBarButtonItem *addToBagButton;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;
@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) UILabel *subtitleView;

@property (nonatomic, retain) NSMutableArray *savedProducts;

- (void)addSavedProductsToShoppingBag;
@end
