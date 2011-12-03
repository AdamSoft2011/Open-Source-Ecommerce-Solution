//
//  ProductXMLParser.h
//  Ecommerce
//
//  Created by Pengyu Lan on 16/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Product;
@class ProductVariant;
@class Picture;

@interface ProductXMLParser : NSObject<NSXMLParserDelegate>
{
    @private
    NSInteger currentDepth;
    Product *product;
    ProductVariant *productVariant;
    Picture *picture;
    NSMutableString *currentElement;
    
    NSString *tmpFullDescription;
    NSString *tmpName;
    
    @public
    NSMutableArray *products;
}
@property (nonatomic, retain) NSMutableArray *products;
@end
