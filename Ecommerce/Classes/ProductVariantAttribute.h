//
//  ProductVariantAttribute.h
//  Ecommerce
//
//  Created by Pengyu Lan on 16/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductVariantAttribute : NSObject
{
    NSInteger ProductAttributeId;
    NSString *ProductAttributeName;
    BOOL isRequired;
    NSInteger AttributeControlTypeId;
    NSMutableArray *ProductVariantAttributeValues;
}

@property (nonatomic) NSInteger ProductAttributeId;
@property (nonatomic, retain) NSString *ProductAttributeName;
@property (nonatomic) BOOL isRequired;
@property (nonatomic) NSInteger AttributeControlTypeId;
@property (nonatomic, retain) NSMutableArray *ProductVariantAttributeValues;
@end
