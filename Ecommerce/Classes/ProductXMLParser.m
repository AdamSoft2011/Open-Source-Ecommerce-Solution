//
//  ProductXMLParser.m
//  Ecommerce
//
//  Created by Pengyu Lan on 16/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ProductXMLParser.h"
#import "Product.h"
#import "ProductVariant.h"
#import "Picture.h"

@implementation ProductXMLParser

@synthesize products;

- (id)init
{
    self = [super init];
    if (self) {
        products = [[NSMutableArray alloc] init];
        tmpFullDescription = [[NSString alloc] init];
        tmpName = [[NSString alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [tmpFullDescription release];
    [tmpName release];
    [product release];
    [products release];
    [super dealloc];
}

#pragma mark - 
#pragma mark - NSXMLParserDelegate methods

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    currentDepth = 0;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"Error: %@", [parseError localizedDescription]);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    [currentElement release];
    currentElement = [elementName copy];
    
    if ([currentElement isEqualToString:@"Product"])
    {
        currentDepth ++;
        
        if (currentDepth == 1) {
            product = [[Product alloc] init];
        }

    }
    else if ([currentElement isEqualToString:@"ProductId"])
    {
        currentDepth ++;
    }
    else if ([currentElement isEqualToString:@"Name"])
    {
        currentDepth ++;
    }
    else if ([currentElement isEqualToString:@"FullDescription"])
    {
        currentDepth ++;
    }
    else if ([currentElement isEqualToString:@"ProductTemplateId"])
    {
        currentDepth ++;
    }
    else if ([currentElement isEqualToString:@"CreatedOnUtc"])
    {
        currentDepth ++;
    }
    else if ([currentElement isEqualToString:@"ProductVariants"])
    {
        currentDepth ++;
    }
    else if ([currentElement isEqualToString:@"ProductVariant"])
    {
        productVariant = [[ProductVariant alloc] init];
        currentDepth ++;
    }
    else if ([currentElement isEqualToString:@"ProductVariantId"])
    {
        currentDepth ++;
    }

    /* Description to CallForPrice will be added later*/
    
    else if ([currentElement isEqualToString:@"Price"])
    {
        currentDepth ++;
    }
    else if ([currentElement isEqualToString:@"OldPrice"])
    {
        currentDepth ++;
    }
    else if ([currentElement isEqualToString:@"ProductVariantPictureId"])
    {
        currentDepth ++;
    }
    else if ([currentElement isEqualToString:@"ProductPictures"])
    {
        currentDepth ++;
    }
    else if ([currentElement isEqualToString:@"ProductPicture"])
    {
        picture = [[Picture alloc] init];
        currentDepth ++;
    }
    else if ([currentElement isEqualToString:@"PictureId"])
    {
        currentDepth ++;
    }
    else if ([currentElement isEqualToString:@"PictureURL"])
    {
        currentDepth ++;
    }
    
    
    //NSLog(@"current OPEN element: %@, depth: %i" ,currentElement, currentDepth);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([currentElement isEqualToString:@"ProductId"] && (currentDepth == 2)) {
        [product setValue:string forKey:currentElement];
    }
    else if ([currentElement isEqualToString:@"Name"] && (currentDepth == 2)) {
        tmpName = [tmpName stringByAppendingString:string];
    }
    else if ([currentElement isEqualToString:@"FullDescription"]) {
        tmpFullDescription = [tmpFullDescription stringByAppendingString:string];
    }
    else if ([currentElement isEqualToString:@"ProductTemplateId"]) {
        [product setValue:string forKey:currentElement];
    }
    else if ([currentElement isEqualToString:@"CreatedOnUtc"] && (currentDepth == 2)) {
        [product setValue:string forKey:currentElement];
    }
    else if ([currentElement isEqualToString:@"ProductVariantId"]) {
        [productVariant setValue:string forKey:currentElement];
    }
    else if ([currentElement isEqualToString:@"ProductId"] && (currentDepth == 4)) {
        [productVariant setValue:string forKey:currentElement];
    }
    else if ([currentElement isEqualToString:@"Name"] && (currentDepth == 4)) {
        [product setValue:string forKey:currentElement];
    }
    /* Description to CallForPrice will be added later*/
    else if ([currentElement isEqualToString:@"Price"] && (currentDepth == 4)) {
        [productVariant setValue:string forKey:currentElement];
    }
    else if ([currentElement isEqualToString:@"OldPrice"] && (currentDepth == 4)) {
        [productVariant setValue:string forKey:currentElement];
    }
    else if ([currentElement isEqualToString:@"ProductVariantPictureId"] && (currentDepth == 4)) {
        [productVariant setValue:string forKey:currentElement];
    }
    else if ([currentElement isEqualToString:@"PictureId"] && (currentDepth == 4)) {
        [picture setValue:string forKey:currentElement];
    }
    else if ([currentElement isEqualToString:@"PictureURL"] && (currentDepth == 4)) {
        [picture setValue:string forKey:currentElement];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"Products"]) 
    {
        return;
    }
    
    if ([elementName isEqualToString:@"Product"]) 
    {
        [self.products addObject:product];
        currentDepth --;
    }
    else if ([elementName isEqualToString:@"ProductId"])
    {
        currentDepth --;
    }
    else if ([elementName isEqualToString:@"Name"] && (currentDepth == 2))
    {
        [product setValue:tmpName forKey:@"Name"];
        currentDepth --;
        tmpName = @"";
    }
    else if ([elementName isEqualToString:@"Name"] && (currentDepth == 4))
    {
        currentDepth --;
    }
    else if ([elementName isEqualToString:@"FullDescription"])
    {
        [product setValue:tmpFullDescription forKey:@"FullDescription"];
        tmpFullDescription = @"";
        currentDepth --;
    }
    else if ([elementName isEqualToString:@"ProductTemplateId"])
    {
        currentDepth --;
    }
    else if ([elementName isEqualToString:@"CreatedOnUtc"])
    {
        currentDepth --;
    }
    else if ([elementName isEqualToString:@"ProductVariants"])
    {
        currentDepth --;
    }
    else if ([elementName isEqualToString:@"ProductVariant"])
    {
        [product.productVariants addObject:productVariant];
        currentDepth --;
    }
    else if ([elementName isEqualToString:@"ProductVariantId"])
    {
        currentDepth --;
    }
    else if ([elementName isEqualToString:@"Price"])
    {
        currentDepth --;
    }
    else if ([elementName isEqualToString:@"OldPrice"])
    {
        currentDepth --;
    }
    else if ([elementName isEqualToString:@"ProductVariantPictureId"] && (currentDepth == 4))
    {
        currentDepth --;
    }
    
    else if ([elementName isEqualToString:@"ProductPictures"])
    {
        currentDepth --;
    }
    else if ([elementName isEqualToString:@"ProductPicture"])
    {
        [product.productPictures addObject:picture];
        currentDepth --;
    }
    else if ([elementName isEqualToString:@"PictureId"] && (currentDepth == 4))
    {
        currentDepth --;
    }
    else if ([elementName isEqualToString:@"PictureURL"] && (currentDepth == 4))
    {
        currentDepth --;
    }
    
    //NSLog(@"current CLOSE element: %@, depth: %i", elementName, currentDepth);
}

@end


