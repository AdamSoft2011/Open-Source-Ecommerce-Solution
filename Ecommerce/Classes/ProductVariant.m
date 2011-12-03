//
//  ProductVariant.m
//  Ecommerce
//
//  Created by Pengyu Lan on 16/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ProductVariant.h"

@implementation ProductVariant

@synthesize ProductVariantId, Name, SKU,Description, IsGiftCard, GiftCardType, DisableBuyButton, DisableWishlistButton, CallForPrice, Price, OldPrice, ProductVariantPictureId, OrderMaximumQuantity, OrderMinimumQuantity;
@synthesize ProductVariantAttributes;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        ProductVariantAttributes = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    [ProductVariantAttributes release];
    [SKU release];
    [Name release];
    [Description release];
    [GiftCardType release];
    [super dealloc];
}

@end
