//
//  ProductViewCell.h
//  NavController
//
//  Created by 猪小小 on 01/11/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridViewCell.h"
#import "HJManagedImageV.h"

@class UILabelStrikethrough;
@class Product;

@interface ProductGridViewCell : AQGridViewCell {
    HJManagedImageV *productImageView;
    UILabel *productDescription;
    UILabel *productPrice;
    UILabelStrikethrough *productOldPrice;
    UIButton *saveProductBtn;
    
    NSInteger imageHeight;
    NSInteger imageWidth;
    NSInteger numberOfItemsPerRow;
    
    Product *product;
}

@property (nonatomic, retain) HJManagedImageV *productImageView;
@property (nonatomic, retain) UILabel *productDescription;
@property (nonatomic, retain) UILabel *productPrice;
@property (nonatomic, retain) UILabelStrikethrough *productOldPrice;
@property (nonatomic, retain) UIButton *saveProductBtn;

@property (nonatomic) NSInteger imageHeight;
@property (nonatomic) NSInteger imageWidth;
@property (nonatomic) NSInteger numberOfItemsPerRow;

@property (nonatomic, retain) Product *product;

- (void) saveProduct;
@end
