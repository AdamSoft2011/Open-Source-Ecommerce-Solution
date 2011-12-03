//
//  BagViewController.h
//  Ecommerce
//
//  Created by Pengyu Lan on 25/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BagViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    // User interface controls
    UIBarButtonItem *saveBagButton;
    UITableView *tableView;
    UIActivityIndicatorView *spinner;
    UILabel *subtitleView;
    UILabel *label;
    
    // fields
    NSMutableArray *baggedProducts;
}

@property (nonatomic, retain) UIBarButtonItem *saveBagButton;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;
@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) UILabel *subtitleView;

@property (nonatomic, retain) NSMutableArray *baggedProducts;

- (void)addBaggedProductsToSaved;;
@end
