//
//  ProductColumnViewCell.m
//  Ecommerce
//
//  Created by Pengyu Lan on 29/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ProductColumnViewCell.h"

@implementation ProductColumnViewCell
@synthesize productImageView;
@synthesize productName;
@synthesize productSpec;
@synthesize productPrice;
@synthesize productOldPrice;
@synthesize editBtn;
@synthesize moveToBagBtn;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialisation
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}
@end
