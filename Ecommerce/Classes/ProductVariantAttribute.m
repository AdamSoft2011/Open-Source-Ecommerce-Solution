//
//  ProductVariantAttribute.m
//  Ecommerce
//
//  Created by Pengyu Lan on 16/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ProductVariantAttribute.h"
@implementation ProductVariantAttribute
@synthesize ProductAttributeId, isRequired, AttributeControlTypeId, ProductAttributeName, ProductVariantAttributeValues;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        ProductVariantAttributeValues = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void) dealloc
{
    [ProductAttributeName release];
    [ProductVariantAttributeValues release];
    [super dealloc];
}


@end
