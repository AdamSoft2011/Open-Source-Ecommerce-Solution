//
//  XMLParser.h
//  Ecommerce
//
//  Created by 猪小小 on 04/11/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Category;

@interface CategoryXMLParser : NSObject<NSXMLParserDelegate> {
@private
    NSMutableString *currentElementValue;
    NSMutableString *currentElement;
    NSInteger currentDepth;
    Category *category;
    Category *subCategory;
@public    
    NSMutableArray *subCategories;
}

@property (nonatomic, retain) NSMutableArray *subCategories;

@end
