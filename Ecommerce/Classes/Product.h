//
//  Product.h
//  Ecommerce
//
//  Created by Pengyu Lan on 14/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject
{
    NSInteger ProductId;
    NSString *Name;
    NSString *FullDescription;
    NSInteger ProductTemplateId;
    NSDate *CreatedOnUtc;
    
    NSMutableArray *productVariants;
    NSMutableArray *productPictures;
    NSMutableArray *productSpecificationAttributes;
}

@property (nonatomic) NSInteger ProductId;
@property (nonatomic, retain) NSString *Name;
@property (nonatomic, retain) NSString *FullDescription;
@property (nonatomic) NSInteger ProductTemplateId; // MultiVariants 1, SingleVariant 2
@property (nonatomic, retain) NSDate *CreatedOnUtc;

@property (nonatomic, retain) NSMutableArray *productVariants;
@property (nonatomic, retain) NSMutableArray *productPictures;
@property (nonatomic, retain) NSMutableArray *productSpecificationAttributes;
@end
