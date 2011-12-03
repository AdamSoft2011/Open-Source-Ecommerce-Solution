//
//  ProductDetailViewController.h
//  Ecommerce
//
//  Created by Pengyu Lan on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Product;
@class DDPageControl;

@interface ProductSingleVariantViewController : UIViewController<UIScrollViewDelegate, UITextFieldDelegate>
{
    Product *product;
    UIScrollView *scrollView;
    DDPageControl *pageControl;
    UITextField *recipientName;
    UITextField *recipientEmail;
    UITextField *senderName;
    UITextField *senderEmail;
}

@property (nonatomic, retain) Product *product;
@property (nonatomic, retain) UIScrollView *scrollView;

- (void)selectAttributeValue:(id)sender;
- (void)pageControlClicked:(id)sender;
- (void)addToShoppingBag:(id)sender;
- (void)addToSaved:(id)sender;
- (void)shareProducts;
@end
