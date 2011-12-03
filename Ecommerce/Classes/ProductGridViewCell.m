//
//  ProductViewCell.m
//  NavController
//
//  Created by 猪小小 on 01/11/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProductGridViewCell.h"
#import "UILabelStrikethrough.h"
#import "Product.h"
#import "BagAndSavedCommonMethods.h"

@implementation ProductGridViewCell

@synthesize productImageView, productPrice,productOldPrice, productDescription,saveProductBtn;
@synthesize imageHeight, imageWidth, numberOfItemsPerRow;
@synthesize product;

- (void)dealloc
{
    [productImageView release];
    [productPrice release];
    [productDescription release];
    [saveProductBtn release];
    [productOldPrice release];
    [self.product release];
    [super dealloc];
}

- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *) reuseIdentifier
{
    self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier];
    if (self == nil) {
        return nil;
    }
    
    productImageView = [[HJManagedImageV alloc] initWithFrame:CGRectZero];
    
    productDescription = [[UILabel alloc] initWithFrame:CGRectZero];
    productDescription.font = [UIFont fontWithName:@"Arial" size:12.0];
    productDescription.adjustsFontSizeToFitWidth = YES;
    productDescription.minimumFontSize = 12.0;
    
    productPrice = [[UILabel alloc] initWithFrame:CGRectZero];
    productPrice.font = [UIFont fontWithName:@"Arial" size:13.0];
    productPrice.adjustsFontSizeToFitWidth = YES;
    productPrice.minimumFontSize = 13.0;
    
    productOldPrice = [[UILabelStrikethrough alloc] initWithFrame:CGRectZero];
    productOldPrice.font = [UIFont fontWithName:@"Arial" size:13.0];
    productOldPrice.adjustsFontSizeToFitWidth = YES;
    productOldPrice.minimumFontSize = 13.0;
    productOldPrice.textColor = [UIColor redColor];
    
    saveProductBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveProductBtn addTarget:self action:@selector(saveProduct) forControlEvents:UIControlEventTouchUpInside];
    UIImage *saveProductImage = [UIImage imageNamed:@"addToSave.png"];
    [saveProductBtn setBackgroundImage:saveProductImage forState:UIControlStateNormal];
    saveProductBtn.frame = CGRectZero;
    
    [self setSelectionStyle:AQGridViewCellSelectionStyleNone];
    
    [self.contentView addSubview:productImageView];
    [self.contentView addSubview:productDescription];
    [self.contentView addSubview:productPrice];
    [self.contentView addSubview:productOldPrice];
    [self.contentView addSubview:saveProductBtn];
    
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGSize imageSize = CGSizeMake(imageWidth, imageHeight);
    CGRect bounds = CGRectInset(self.contentView.bounds, 7.0, 4.0);    
    
    [productImageView sizeToFit];
    CGRect frame = productImageView.frame;
    
    CGFloat hRatio = bounds.size.width / imageSize.width;
    CGFloat vRatio = bounds.size.height / imageSize.height;
    CGFloat ratio = MIN(hRatio, vRatio);
    
    frame.size.width = floorf(imageSize.width * ratio);
    frame.size.height = floorf(imageSize.height * ratio);
    frame.origin.x = 7.0;
    frame.origin.y = 4.0;

    productImageView.frame = frame;
    
    [productDescription sizeToFit];
    frame = productDescription.frame;
    frame.size.width = MIN(frame.size.width, bounds.size.width) - 8;
    frame.origin.y = imageSize.height + 4;
    frame.origin.x = 7.0;
    productDescription.frame = frame;
    
    [productPrice sizeToFit];
    frame = productDescription.frame;
    frame.size.width = MIN(frame.size.width, bounds.size.width);
    frame.origin.y = imageSize.height + 4 + 13;
    frame.origin.x = 7.0;
    productPrice.frame = frame;
    
    [productOldPrice sizeToFit];
    frame = productDescription.frame;
    frame.size.width = MIN(frame.size.width, bounds.size.width);
    frame.origin.y = imageSize.height + 4 + 13 + 13;
    frame.origin.x = 7.0;
    productOldPrice.frame = frame;
    
    [saveProductBtn sizeToFit];
    saveProductBtn.frame = CGRectMake(bounds.size.width - 13, imageSize.height + 4, 24, 24);
}

- (void) saveProduct
{
    [BagAndSavedCommonMethods addSavedProduct:self.product];
    UIImage *saveProductImage = [UIImage imageNamed:@"addedToSave.png"];
    [saveProductBtn setBackgroundImage:saveProductImage forState:UIControlStateNormal];
}

@end
