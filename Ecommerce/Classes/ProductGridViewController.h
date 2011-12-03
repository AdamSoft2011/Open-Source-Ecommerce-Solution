//
//  ProductGridViewController.h
//  Ecommerce
//
//  Created by Pengyu Lan on 09/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AQGridViewController.h"

@class Product;
@class ProductSingleVariantViewController;
@class AbstractActionSheetPicker;

@interface ProductGridViewController : UIViewController <AQGridViewDelegate, AQGridViewDataSource, UIActionSheetDelegate, UITextFieldDelegate>
{
    UIView *portrait;
    UIView *landscape;
    
    // controls
    AQGridView *gridView;
    UIButton *zoomInButton;
    UIButton *zoomOutButton;
    UITextField *sortTextfield;
    UIActivityIndicatorView *spinner;
    UILabel *titleView;
    UILabel *subtitleView;
    
    // data
    NSMutableArray *products;
    NSString *searchTerm;
    NSArray *pickerData;
    NSArray *pickerShowInTextFieldData;
    CGFloat imageHeightOfTwoItemsPerRow;
    CGFloat imageHeightOfThreeItemsPerRow;
    CGFloat imageHeightOfFourItemsPerRow;
    ProductSingleVariantViewController *productDetailViewController;
    //AbstractActionSheetPicker *actionSheetPicker;
    NSInteger selectedIndexNumber;
    NSInteger previousSelectedIndexNumber;
    NSString *navBartitle;
}

@property (retain, nonatomic) AQGridView *gridView;
@property (retain, nonatomic) UIButton *zoomInButton;
@property (retain, nonatomic) UIButton *zoomOutButton;
@property (retain, nonatomic) UITextField *sortTextfield;
@property (nonatomic) NSInteger numberOfItemsPerRow;
@property (retain, nonatomic) NSArray *pickerData;
@property (retain, nonatomic) NSMutableArray *products;
@property (nonatomic) CGFloat imageHeightOfTwoItemsPerRow;
@property (nonatomic) CGFloat imageHeightOfThreeItemsPerRow;
@property (nonatomic) CGFloat imageHeightOfFourItemsPerRow;
@property (nonatomic, retain) ProductSingleVariantViewController *productDetailViewController;
//@property (nonatomic, retain) AbstractActionSheetPicker *actionSheetPicker;
@property (nonatomic) NSInteger selectedIndexNumber;
@property (nonatomic) NSInteger previousSelectedIndexNumber;
@property (nonatomic, retain) NSString *navBartitle;
@property (retain, nonatomic) NSString *searchTerm;

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (retain, nonatomic) IBOutlet UIView *portrait;
@property (retain, nonatomic) IBOutlet UIView *landscape;

- (void) zoomIn:(id)sender;
- (void) zoomOut:(id)sender;
- (void) chooseSortMethod: (id)sender;
- (void) loadingProducts;
- (void) adjustZoomInZoomOutButtonImage;
- (void) itemWasSelected:(NSNumber *)selectedIndex element:(id)element;
@end
