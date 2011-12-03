//
//  ProductColumnViewCell.h
//  Ecommerce
//
//  Created by Pengyu Lan on 29/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductColumnViewCell : UITableViewCell
{
    UIImageView *productImageView;
    UILabel *productName;
    UILabel *productSpec;
    UILabel *productPrice;
    UILabel *productOldPrice;
    UIButton *editBtn;
    UIButton *moveToBagBtn;
}

@property (nonatomic, retain) IBOutlet UIImageView *productImageView;
@property (nonatomic, retain) IBOutlet UILabel *productName;
@property (nonatomic, retain) IBOutlet UILabel *productSpec;
@property (nonatomic, retain) IBOutlet UILabel *productPrice;
@property (nonatomic, retain) IBOutlet UILabel *productOldPrice;
@property (nonatomic, retain) IBOutlet UIButton *editBtn;
@property (nonatomic, retain) IBOutlet UIButton *moveToBagBtn;
@end
