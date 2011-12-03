//
//  ProductVariant.h
//  Ecommerce
//
//  Created by Pengyu Lan on 16/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductVariant : NSObject
{
    NSInteger ProductVariantId;
    NSString *Name;
    NSString *SKU;
    NSString *Description;
    BOOL IsGiftCard;
    NSString *GiftCardType;
    NSInteger OrderMinimumQuantity;
    NSInteger OrderMaximumQuantity;
    BOOL DisableBuyButton;
    BOOL DisableWishlistButton;
    BOOL CallForPrice;
    CGFloat Price;
    CGFloat OldPrice;
    NSInteger ProductVariantPictureId;

    NSMutableArray *ProductVariantAttributes;
}

@property (nonatomic) NSInteger ProductVariantId;
@property (nonatomic, retain) NSString *Name;
@property (nonatomic, retain) NSString *SKU;
@property (nonatomic, retain) NSString *Description;
@property (nonatomic) BOOL IsGiftCard;
@property (nonatomic, retain) NSString *GiftCardType;
@property (nonatomic) NSInteger OrderMinimumQuantity;
@property (nonatomic) NSInteger OrderMaximumQuantity;
@property (nonatomic) BOOL DisableBuyButton;
@property (nonatomic) BOOL DisableWishlistButton;
@property (nonatomic) BOOL CallForPrice;
@property (nonatomic) CGFloat Price;
@property (nonatomic) CGFloat OldPrice;
@property (nonatomic) NSInteger ProductVariantPictureId;
@property (nonatomic, retain) NSMutableArray *ProductVariantAttributes;
@end
