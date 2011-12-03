//
//  XMLParser.m
//  Ecommerce
//
//  Created by 猪小小 on 04/11/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CategoryXMLParser.h"
#import "Category.h"
#import "EcommerceAppDelegate.h"

@implementation CategoryXMLParser
@synthesize subCategories;


- (id)init
{
    self = [super init];
    if (self) {
        subCategories = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    [currentElementValue release];
    [category release];
    [super dealloc];
}

#pragma mark - 
#pragma mark - NSXMLParserDelegate methods

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    currentDepth = 0;
    currentElement = nil;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"Error: %@", [parseError localizedDescription]);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    [currentElement release];
    currentElement = [elementName copy];
    
    //NSLog(@"current open element: %@, depth: %i" ,currentElement, currentDepth);
    
    if ([currentElement isEqualToString:@"Category"])    
    {
        currentDepth ++;
        if (currentDepth == 1)
        {
            category = [[Category alloc] init];
            //NSLog(@"init category");
        }
        else if (currentDepth == 3)
        {
            subCategory = [[Category alloc] init];
        }
    }
    else if ([currentElement isEqualToString:@"Id"])
    {
        currentDepth ++;
    }
    else if ([currentElement isEqualToString:@"Name"])
    {
        currentDepth ++;
    }
    else if ([currentElement isEqualToString:@"SubCategories"])
    {
        currentDepth ++;
    }
    
    //NSLog(@"%i", currentDepth);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (!currentElementValue)
    {
        currentElementValue = [[NSMutableString alloc] initWithString:string];
    }
    else
    {
        [currentElementValue appendString:string];
    }

    if ([currentElement isEqualToString:@"Id"] && (currentDepth == 2)) 
    {
        [category setValue:currentElementValue forKey:currentElement];
    }
    else if ([currentElement isEqualToString:@"Name"] && (currentDepth == 2))
    {
        [category setValue:currentElementValue forKey:currentElement];
    }
    else if ([currentElement isEqualToString:@"Id"] && (currentDepth == 4)) 
    {
        [subCategory setValue:currentElementValue forKey:currentElement];
    }
    else if ([currentElement isEqualToString:@"Name"] && (currentDepth == 4)) 
    {
        [subCategory setValue:currentElementValue forKey:currentElement];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //NSLog(@"current close element: %@" ,elementName);
    // We reached the end of the XML document
    if ([elementName isEqualToString:@"Categories"]) {
        return;
    }
    
    if ([elementName isEqualToString:@"Category"])
    {
        if (currentDepth == 1) {
            EcommerceAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            [appDelegate.categories addObject:category];
        }
        else if (currentDepth == 3)
        {
            [category.subCategories addObject:subCategory];
        }
        currentDepth --;
    }
    else if ([elementName isEqualToString:@"SubCategories"])
    {
        currentDepth --;
    } 

    else if ([elementName isEqualToString:@"Name"])
    {
        currentDepth --;
    }
    else if ([elementName isEqualToString:@"Id"])
    {
        currentDepth --;
    }
    //NSLog(@"%i", currentDepth);
    
    [currentElementValue release];
    currentElementValue = nil;
}
@end
