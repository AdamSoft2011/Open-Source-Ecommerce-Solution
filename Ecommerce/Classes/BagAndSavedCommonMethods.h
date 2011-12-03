//
//  SavedProductsParser.h
//  Ecommerce
//
//  Created by Pengyu Lan on 28/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Product;

@interface BagAndSavedCommonMethods : NSObject
{
    
}

+ (NSString *)savedProductsDataFilePath;
+ (NSMutableArray *)loadSavedProducts;
+ (void)addSavedProduct:(Product *) product;
+ (void)saveSavedProduct:(NSArray *) products;

+ (NSString *)baggedProductsDataFilePath;
+ (NSMutableArray *)loadBaggedProducts;
+ (void)addBaggedProduct:(Product *) product;
+ (void)saveBaggedProducts:(NSArray *) products;

+ (NSMutableArray *) handleSearchTerm: (NSString *) searchTerm;
@end
