//
//  Product.m
//  Ecommerce
//
//  Created by Pengyu Lan on 14/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Product.h"

@implementation Product
@synthesize ProductId, Name, FullDescription;
@synthesize ProductTemplateId, CreatedOnUtc;
@synthesize productVariants, productPictures, productSpecificationAttributes;


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        productVariants = [[NSMutableArray alloc] init];
        productPictures = [[NSMutableArray alloc] init];
        productSpecificationAttributes = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    [Name release];
    [CreatedOnUtc release];
    [FullDescription release];
    [productVariants release];
    [productPictures release];
    [productSpecificationAttributes release];
    [super dealloc];
}

//- (void) getProductImageUrlWithProductId:(NSInteger)productImageId ProductName: (NSString *)productName
//{
    
//}

@end
