//
//  SavedProductsParser.m
//  Ecommerce
//
//  Created by Pengyu Lan on 28/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BagAndSavedCommonMethods.h"
#import "GDataXMLNode.h"
#import "Product.h"
#import "EcommerceAppDelegate.h"
#import "LoadingScreenViewController.h"
#import "HomeTabController.h"
#import "GetProductsWithGXMLParser.h"

@implementation BagAndSavedCommonMethods

#pragma mark - SavedProducts Common Methods

+ (NSString *)savedProductsDataFilePath
{
    // get saved.xml file path
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *savedXMLFile = [documentPath stringByAppendingString:@"/saved.xml"];
    
    // check if saved.xml file exists
    BOOL isSavedXMLFileExists = [[NSFileManager defaultManager] fileExistsAtPath:savedXMLFile];
    
    // if it exists, return filePath
    if (isSavedXMLFileExists) 
    {
        return savedXMLFile;
    }
    
    // if not, create file and return file path
    else
    {
        NSString *rootXMLElement = @"<Products></Products>";
        [rootXMLElement writeToFile:savedXMLFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
        return savedXMLFile;
    }
    
    return savedXMLFile;
}


+ (NSMutableArray *)loadSavedProducts
{
    // find saved.xml file path
    NSString *filePath = [self savedProductsDataFilePath];
    
    // load data from saved.xml
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    if (doc == nil) {
        return nil;
    }
    
    NSMutableArray *savedProducts = [[NSMutableArray alloc] init];
    
    // use XPath to get saved products
    NSArray *productsInXML = [doc nodesForXPath:@"//Products/Product" error:nil];
    
    // populate product data one by one
    for (GDataXMLElement *p in productsInXML) 
    {
        // init product
        Product *product = [[Product alloc] init];
        
        NSArray *ProductIds = [p elementsForName:@"ProductId"];
        if (ProductIds.count > 0) {
            GDataXMLElement *firstProductId = (GDataXMLElement *)[ProductIds objectAtIndex:0];
            product.ProductId = firstProductId.stringValue.intValue;
        } else continue;
        
        NSArray *Names = [p elementsForName:@"Name"];
        if (Names.count > 0){
            GDataXMLElement *firstName = (GDataXMLElement *)[Names objectAtIndex:0];
            product.Name = firstName.stringValue;
        } else continue;
        
        [savedProducts addObject:product];
        [product release];
    }
    
    [doc release];
    [xmlData release];
    
    // return savedProducts
    return savedProducts;
}

+ (void)addSavedProduct:(Product *) product
{
    // load Saved Products
    NSMutableArray *savedProducts = [self loadSavedProducts];
    
    // try to add product into saved product array
    // if product already in the saved product array return by doing nothing
    // otherwise add it into saved product array and update the badge value
    
    BOOL in = NO;
    for (Product *p in savedProducts) {
        if (p.ProductId == product.ProductId) {
            in = YES;
        }
    }
    
    if (!in) {
        [savedProducts addObject:product];
        // reconstruct XML file
        GDataXMLElement *productsElement = [GDataXMLNode elementWithName:@"Products"];
        for (Product *p in savedProducts) 
        {
            GDataXMLElement *productElement = [GDataXMLNode elementWithName:@"Product"];
            GDataXMLElement *productIdElement = [GDataXMLNode elementWithName:@"ProductId" stringValue:[NSString stringWithFormat:@"%i", p.ProductId]];
            GDataXMLElement *nameElement = [GDataXMLNode elementWithName:@"Name" stringValue:p.Name];
        
            [productElement addChild:productIdElement];
            [productElement addChild:nameElement];
            [productsElement addChild:productElement];
        }
    
        // init the XML data
        GDataXMLDocument *document = [[[GDataXMLDocument alloc] initWithRootElement:productsElement] autorelease];
        NSData *xmlData = document.XMLData;
    
        // rewrite saved.xml file
        NSString *filePath = [self savedProductsDataFilePath];
        [xmlData writeToFile:filePath atomically:YES];
    
        // load saved products
        NSMutableArray *products = [self loadSavedProducts];
    
        // reset badge value
        if ([products count] != 0) {
            EcommerceAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            [[appDelegate.loadingScreenViewController.homeTabController.rootTabBarController.childViewControllers objectAtIndex:2] tabBarItem].badgeValue = 
            [NSString stringWithFormat:@"%i",[products count]];
        }
    }
    else return;
}

+ (void)saveSavedProduct: (NSArray *) products
{
    GDataXMLElement *productsElement = [GDataXMLNode elementWithName:@"Products"];
    for (Product *p in products) 
    {
        GDataXMLElement *productElement = [GDataXMLNode elementWithName:@"Product"];
        GDataXMLElement *productIdElement = [GDataXMLNode elementWithName:@"ProductId" stringValue:[NSString stringWithFormat:@"%i", p.ProductId]];
        GDataXMLElement *nameElement = [GDataXMLNode elementWithName:@"Name" stringValue:p.Name];
        
        [productElement addChild:productIdElement];
        [productElement addChild:nameElement];
        [productsElement addChild:productElement];
    }
    
    // init the XML data
    GDataXMLDocument *document = [[[GDataXMLDocument alloc] initWithRootElement:productsElement] autorelease];
    NSData *xmlData = document.XMLData;
    
    // rewrite saved.xml file
    NSString *filePath = [self savedProductsDataFilePath];
    [xmlData writeToFile:filePath atomically:YES];
}

#pragma mark - ShoppingBag Common Methods
+ (NSString *)baggedProductsDataFilePath
{
    // get shoppingbag.xml file path
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *XMLFile = [documentPath stringByAppendingString:@"/shoppingbag.xml"];
    
    // check if shoppingbag.xml file exists
    BOOL isXMLFileExists = [[NSFileManager defaultManager] fileExistsAtPath:XMLFile];
    
    // if it exists, return file Path
    if (isXMLFileExists) 
    {
        return XMLFile;
    }
    
    // if not, create file and return file path
    else
    {
        NSString *rootXMLElement = @"<Products></Products>";
        [rootXMLElement writeToFile:XMLFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
        return XMLFile;
    }
}

+(NSMutableArray *)loadBaggedProducts
{
    // find shoppingbag.xml file path
    NSString *filePath = [self baggedProductsDataFilePath];
    
    // load data from shoppingbag.xml

    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    if (doc == nil) {
        return nil;
    }
    
    NSMutableArray *baggedProducts = [[NSMutableArray alloc] init];
    
    // use XPath to get bagged products
    NSArray *productsInXML = [doc nodesForXPath:@"//Products/Product" error:nil];
    
    for (GDataXMLElement *p in productsInXML) 
    {
        // init product
        Product *product = [[Product alloc] init];
        
        NSArray *ProductIds = [p elementsForName:@"ProductId"];
        if (ProductIds.count > 0) {
            GDataXMLElement *firstProductId = (GDataXMLElement *)[ProductIds objectAtIndex:0];
            product.ProductId = firstProductId.stringValue.intValue;
        } else continue;
        
        NSArray *Names = [p elementsForName:@"Name"];
        if (Names.count > 0){
            GDataXMLElement *firstName = (GDataXMLElement *)[Names objectAtIndex:0];
            product.Name = firstName.stringValue;
        } else continue;
        
        [baggedProducts addObject:product];
        [product release];
    }
    
    [doc release];
    [xmlData release];
    
    // return baggedProducts
    return baggedProducts;
}

+ (void)addBaggedProduct:(Product *) product
{
    // load Bagged Products
    NSMutableArray *baggedProducts = [self loadBaggedProducts];
    
    // try to add product into bagged product array
    // if product already in the bagged product array return by doing nothing
    // otherwise add it into bagged product array and update the badge value
    
    BOOL in = NO;
    for (Product *p in baggedProducts) {
        if (p.ProductId == product.ProductId) {
            in = YES;
        }
    }
    
    if (!in) 
    {
        [baggedProducts addObject:product];
        
        // reconstruct XML file
        GDataXMLElement *productsElement = [GDataXMLNode elementWithName:@"Products"];
        for (Product *p in baggedProducts) 
        {
            GDataXMLElement *productElement = [GDataXMLNode elementWithName:@"Product"];
            GDataXMLElement *productIdElement = [GDataXMLNode elementWithName:@"ProductId" stringValue:[NSString stringWithFormat:@"%i", p.ProductId]];
            GDataXMLElement *nameElement = [GDataXMLNode elementWithName:@"Name" stringValue:p.Name];
            
            [productElement addChild:productIdElement];
            [productElement addChild:nameElement];
            [productsElement addChild:productElement];
        }

        GDataXMLDocument *document = [[[GDataXMLDocument alloc] initWithRootElement:productsElement] autorelease];
        NSData *xmlData = document.XMLData;
        
        // rewrite shopping.xml file
        NSString *filePath = [self baggedProductsDataFilePath];
        [xmlData writeToFile:filePath atomically:YES];
        
        // load saved products
        NSMutableArray *products = [self loadBaggedProducts];
        
        // reset badge value
        if ([products count] != 0) {
            EcommerceAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            [[appDelegate.loadingScreenViewController.homeTabController.rootTabBarController.childViewControllers objectAtIndex:1] tabBarItem].badgeValue = 
            [NSString stringWithFormat:@"%i",[products count]];
        }
    }
    else return;

}

+ (void)saveBaggedProducts:(NSArray *) products
{
}

#pragma mark -
#pragma mark - Custom methods
+ (NSMutableArray *) handleSearchTerm: (NSString *) searchTerm
{
    NSMutableArray *products = [GetProductsWithGXMLParser loadProducts];
    NSMutableArray *returnedProducts = [[[NSMutableArray alloc] init] autorelease];
    for (Product *p in products) {
        if(([p.Name rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location != NSNotFound) 
           || ([p.FullDescription rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location != NSNotFound))
        {
            [returnedProducts addObject:p];
        }
    }
    
    return returnedProducts;
}
@end
