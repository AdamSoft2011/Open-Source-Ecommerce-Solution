//
//  ProductVariantAttributeValue.h
//  Ecommerce
//
//  Created by Pengyu Lan on 01/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductVariantAttributeValue : NSObject
{
    NSString *Name;
    CGFloat PriceAdjustment;
    BOOL isPreSelected;
}
@property (nonatomic, retain) NSString *Name;
@property (nonatomic) CGFloat PriceAdjustment;
@property (nonatomic) BOOL isPreSelected;
@end
