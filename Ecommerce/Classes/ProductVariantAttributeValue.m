//
//  ProductVariantAttributeValue.m
//  Ecommerce
//
//  Created by Pengyu Lan on 01/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ProductVariantAttributeValue.h"

@implementation ProductVariantAttributeValue
@synthesize Name,isPreSelected,PriceAdjustment;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void) dealloc
{
    [Name release];
    [super dealloc];
}

@end
