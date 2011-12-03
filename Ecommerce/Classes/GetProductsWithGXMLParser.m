//
//  GetProductsWithGXMLParser.m
//  Ecommerce
//
//  Created by Pengyu Lan on 30/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GetProductsWithGXMLParser.h"
#import "GDataXMLNode.h"
#import "Product.h"
#import "ProductVariant.h"
#import "Picture.h"
#import "ProductVariantAttribute.h"
#import "ProductVariantAttributeValue.h"

@implementation GetProductsWithGXMLParser
+(NSString *)dataFilePath
{
    return @"http://osshop.biz/downloads/Gift%20Cards.xml";
}


+(NSMutableArray *)loadProducts;
{
    NSString *filePath = [self dataFilePath];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfURL:[NSURL URLWithString:filePath]];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    if (doc == nil) {
        return nil;
    }
    
    NSMutableArray *products = [[NSMutableArray alloc] init];
    //NSArray *productsFromDataFeed = [doc.rootElement elementsForName:@"Product"];
    NSArray *productsFromDataFeed = [doc nodesForXPath:@"//Products/Product" error:nil];
    //NSLog(@"%i", productsFromDataFeed.count);
    
    for (GDataXMLElement *product in productsFromDataFeed) 
    {
        Product *p = [[Product alloc] init];
        NSInteger ProductId;
        NSString *Name;
        NSString *FullDescription;
        NSInteger ProductTemplateId;
        NSDate *CreatedOnUtc;
        NSInteger ProductVariantId;
        NSString *ProductVariantName;
        NSString *SKU;
        NSString *Description;
        BOOL isGiftCard;
        NSString *GiftCardType;
        NSInteger OrderMinQ;
        NSInteger OrderMaxQ;
        BOOL DisableBuyButton;
        BOOL DisableWishlistButton;
        BOOL CallForPrice;
        CGFloat Price;
        CGFloat OldPrice;
        NSInteger ProductAttributeId;
        NSString *ProductAttributeName;
        BOOL IsRequired;
        NSInteger AttributeControlTypeId;
        NSString *PVAVName;
        CGFloat PriceAdjustment;
        BOOL IsPreSelected;
        
        NSInteger PictureId;
        NSURL *PictureURL;
        
        // ProductId
        NSArray *ProductIds = [product nodesForXPath:@"ProductId" error:nil];       
        if (ProductIds.count > 0) {
            GDataXMLElement *firstProductId = (GDataXMLElement *)[ProductIds objectAtIndex:0];
            ProductId = firstProductId.stringValue.intValue;
            p.ProductId = ProductId;
            NSLog(@"ProductId: %i",ProductId);
        } else continue;

        
        // Name (Product)
        NSArray *Names = [product nodesForXPath:@"Name" error:nil];
        if (Names.count > 0) {
            GDataXMLElement *firstName = (GDataXMLElement *)[Names objectAtIndex:0];
            Name = firstName.stringValue;
            p.Name = Name;
            NSLog(@"Name: %@", Name);
        } else continue;
        
        // FullDescription
        NSArray *FullDescs = [product nodesForXPath:@"FullDescription" error:nil];
        if (FullDescs.count > 0) {
            GDataXMLElement *firstFullDesc = (GDataXMLElement *)[FullDescs objectAtIndex:0];
            FullDescription = firstFullDesc.stringValue;
            p.FullDescription = FullDescription;
            NSLog(@"FullDescription: %@", FullDescription);
        } else continue;

        
        // ProductTemplateId
        NSArray *ProductTemplateIds = [product nodesForXPath:@"ProductTemplateId" error:nil];
        if (ProductTemplateIds.count > 0) {
            GDataXMLElement *firstProductTemplateId = (GDataXMLElement *)[ProductTemplateIds objectAtIndex:0];
            ProductTemplateId = firstProductTemplateId.stringValue.intValue;
            p.ProductTemplateId = ProductTemplateId;
            NSLog(@"ProductTemplateId: %i", ProductTemplateId);
        } else continue;

        
        // CreatedOnUtcs
        NSArray *CreatedOnUtcs = [product nodesForXPath:@"CreatedOnUtc" error:nil];
        if (CreatedOnUtcs.count > 0) {
            GDataXMLElement *firstDate = (GDataXMLElement *)[CreatedOnUtcs objectAtIndex:0];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd/mm/yy hh:mm:ss a"];
            NSDate *dateFromString = [[NSDate alloc] init];
            dateFromString = [dateFormatter dateFromString:firstDate.stringValue];
            NSLog(@"Created on: %@", dateFromString);
            [dateFormatter release];
            CreatedOnUtc = dateFromString;
            p.CreatedOnUtc = CreatedOnUtc;
        } else continue;
        
        
        // ProductVariants
        NSArray *PVs = [product nodesForXPath:@"ProductVariants/ProductVariant" error:nil];
        NSLog(@"Product Variant count: %i", PVs.count);
        for (GDataXMLElement *PV in PVs) {
            ProductVariant *productVariant = [[[ProductVariant alloc] init] autorelease];
            
            // ProductVariantId
            NSArray *ProductVariantIds = [PV nodesForXPath:@"ProductVariantId" error:nil];
            if (ProductVariantIds.count> 0) {
                GDataXMLElement *firstProductVariantId = (GDataXMLElement *)[ProductVariantIds objectAtIndex:0];
                ProductVariantId = firstProductVariantId.stringValue.intValue;
                productVariant.ProductVariantId = ProductVariantId;
                NSLog(@"ProductVariantId: %i", ProductVariantId);
            } else continue;
            
            // Name(ProductVariant)
            NSArray *ProductVariantNames = [PV nodesForXPath:@"Name" error:nil];
            if (ProductVariantNames.count > 0) {
                GDataXMLElement *firstProductVariantName = (GDataXMLElement *)[ProductVariantNames objectAtIndex:0];
                ProductVariantName = firstProductVariantName.stringValue;
                productVariant.Name = ProductVariantName;
                NSLog(@"Name: %@", ProductVariantName);
            } else continue;
            
            [p.productVariants addObject:productVariant];
            
            // SKU
            NSArray *SKUs = [PV nodesForXPath:@"SKU" error:nil];
            if (SKUs.count > 0) {
                GDataXMLElement *firstSKU = (GDataXMLElement *)[SKUs objectAtIndex:0];
                SKU = firstSKU.stringValue;
                productVariant.SKU = SKU;
                NSLog(@"SKU: %@", SKU);
            } else continue;
            
            // Description
            NSArray *Descriptions = [PV nodesForXPath:@"Description" error:nil];
            if (Descriptions.count > 0) {
                GDataXMLElement *firstDesc = (GDataXMLElement *)[Descriptions objectAtIndex:0];
                Description = firstDesc.stringValue;
                productVariant.Description = Description;
                NSLog(@"Description: %@", Description);
            } else continue;
            
            // isGiftCard
            NSArray *isGiftCards = [PV nodesForXPath:@"IsGiftCard" error:nil];
            if (isGiftCards.count > 0) {
                GDataXMLElement *firstisGiftCard = (GDataXMLElement *)[isGiftCards objectAtIndex:0];
                isGiftCard = firstisGiftCard.stringValue.boolValue;
                productVariant.IsGiftCard = isGiftCard;
                NSLog(@"isGiftCard: %i", isGiftCard);
            } else continue;
            
            // GiftCardType
            NSArray *GiftCardTypes = [PV nodesForXPath:@"GiftCardType" error:nil];
            if (GiftCardTypes.count > 0) {
                GDataXMLElement *firstGiftCardType = (GDataXMLElement *)[GiftCardTypes objectAtIndex:0];
                GiftCardType = firstGiftCardType.stringValue;
                productVariant.GiftCardType = GiftCardType;
                NSLog(@"GiftCardType: %@", GiftCardType);
            } else continue;
            
            // OrderMinimumQuantity
            NSArray *OrderMinQs = [PV nodesForXPath:@"OrderMinimumQuantity" error:nil];
            if (OrderMinQs.count > 0) {
                GDataXMLElement *firstOrderMinQ = (GDataXMLElement *)[OrderMinQs objectAtIndex:0];
                OrderMinQ = firstOrderMinQ.stringValue.intValue;
                productVariant.OrderMinimumQuantity = OrderMinQ;
                NSLog(@"Order minimum quantity: %i", OrderMinQ);
            } else continue;
            
            // OrderMaximumQuantity
            NSArray *OrderMaxQs = [PV nodesForXPath:@"OrderMaximumQuantity" error:nil];
            if (OrderMaxQs.count > 0) {
                GDataXMLElement *firstOrderMaxQ = (GDataXMLElement *)[OrderMaxQs objectAtIndex:0];
                OrderMaxQ = firstOrderMaxQ.stringValue.intValue;
                productVariant.OrderMaximumQuantity = OrderMaxQ;
                NSLog(@"Order maximum quantity: %i", OrderMaxQ);
            } else continue;
            
            // DisableBuyButton
            NSArray *DisableBuyButtons = [PV nodesForXPath:@"DisableBuyButton" error:nil];
            if (DisableBuyButtons.count > 0) {
                GDataXMLElement *firstDisableBuyButton = (GDataXMLElement *)[DisableBuyButtons objectAtIndex:0];
                DisableBuyButton = firstDisableBuyButton.stringValue.boolValue;
                productVariant.DisableBuyButton = DisableBuyButton;
                NSLog(@"Disable buy button: %i", DisableBuyButton);
            } else continue;
            
            // DisableWishlistButton
            NSArray *DisableWishlistButtons = [PV nodesForXPath:@"DisableWishlistButton" error:nil];
            if (DisableBuyButtons.count > 0) {
                GDataXMLElement *firstDisableWishlistButton = (GDataXMLElement *)[DisableWishlistButtons objectAtIndex:0];
                DisableWishlistButton = firstDisableWishlistButton.stringValue.boolValue;
                productVariant.DisableWishlistButton = DisableWishlistButton;
                NSLog(@"Disable wishlist button: %i", DisableWishlistButton);
            } else continue;
            
            // CallForPrice
            NSArray *CallForPrices = [PV nodesForXPath:@"CallForPrice" error:nil];
            if (CallForPrices.count > 0) {
                GDataXMLElement *firstCallForPrice = (GDataXMLElement *)[CallForPrices objectAtIndex:0];
                CallForPrice = firstCallForPrice.stringValue.boolValue;
                productVariant.CallForPrice = CallForPrice;
                NSLog(@"Call For Price: %i", CallForPrice);
            } else continue;
            
            // Price
            NSArray *Prices = [PV nodesForXPath:@"Price" error:nil];
            if (Prices.count > 0) {
                GDataXMLElement *firstPrice = (GDataXMLElement *)[Prices objectAtIndex:0];
                Price = firstPrice.stringValue.floatValue;
                productVariant.Price = Price;
                NSLog(@"Price: %f", Price);
            } else continue;
            
            // OldPrice
            NSArray *OldPrices = [PV nodesForXPath:@"OldPrice" error:nil];
            if (OldPrices.count > 0) {
                GDataXMLElement *firstOldPrice = (GDataXMLElement *)[OldPrices objectAtIndex:0];
                OldPrice = firstOldPrice.stringValue.floatValue;
                productVariant.OldPrice = OldPrice;
                NSLog(@"Old Price: %f", OldPrice);
            } else continue;
            
            NSArray *ProductAttributes = [PV nodesForXPath:@"ProductAttributes/ProductVariantAttribute" error:nil];
            for (GDataXMLElement *ProductAttribute in ProductAttributes) 
            {
                ProductVariantAttribute *PVA = [[[ProductVariantAttribute alloc] init] autorelease]; 
                
                NSArray *ProductAttributeIds = [ProductAttribute nodesForXPath:@"ProductAttributeId" error:nil];
                if (ProductAttributeIds.count > 0) {
                    GDataXMLElement *firstPAId = (GDataXMLElement *)[ProductAttributeIds objectAtIndex:0];
                    ProductAttributeId = firstPAId.stringValue.intValue;
                    PVA.ProductAttributeId = ProductAttributeId;
                    NSLog(@"ProductAttributeId: %i", ProductAttributeId);
                }
                
                NSArray *ProductAttributeNames = [ProductAttribute nodesForXPath:@"ProductAttributeName" error:nil];
                if (ProductAttributeNames.count > 0) {
                    GDataXMLElement *firstName = (GDataXMLElement *)[ProductAttributeNames objectAtIndex:0];
                    ProductAttributeName = firstName.stringValue;
                    PVA.ProductAttributeName = ProductAttributeName;
                    NSLog(@"ProductAttributeName: %@", ProductAttributeName);
                }
                
                
                NSArray *IsRequireds = [ProductAttribute nodesForXPath:@"IsRequired" error:nil];
                if (IsRequireds.count > 0) {
                    GDataXMLElement *firstIsRequired = (GDataXMLElement *)[IsRequireds objectAtIndex:0];
                    IsRequired = firstIsRequired.stringValue.boolValue;
                    PVA.isRequired = IsRequired;
                    NSLog(@"isRequired: %i", IsRequired);
                }
                
                NSArray *AttributeControlTypeIds = [ProductAttribute nodesForXPath:@"AttributeControlTypeId" error:nil];
                if (IsRequireds.count > 0) {
                    GDataXMLElement *firstACTId = (GDataXMLElement *)[AttributeControlTypeIds objectAtIndex:0];
                    AttributeControlTypeId = firstACTId.stringValue.intValue;
                    PVA.AttributeControlTypeId = AttributeControlTypeId;
                    NSLog(@"AttributeControlTypeId: %i", AttributeControlTypeId);
                }
                
                NSArray *PVAVs = [ProductAttribute nodesForXPath:@"ProductVariantAttributeValues/ProductVariantAttributeValue" error:nil];
                NSLog(@"PVAV count: %i", PVAVs.count);
                for (GDataXMLElement *PVAV in PVAVs) {
                    ProductVariantAttributeValue *productVariantAttributeValue = [[ProductVariantAttributeValue alloc] init];
                    
                    NSArray *Names = [PVAV nodesForXPath:@"Name" error:nil];
                    if (Names.count > 0) {
                        GDataXMLElement *firstName = (GDataXMLElement *)[Names objectAtIndex:0];
                        PVAVName = firstName.stringValue;
                        productVariantAttributeValue.Name = PVAVName;
                        NSLog(@"PVAVName: %@", PVAVName);
                    }
                    
                    NSArray *PriceAdjustments = [PVAV nodesForXPath:@"PriceAdjustment" error:nil];
                    if (PriceAdjustments.count > 0) {
                        GDataXMLElement *firstPriceAdjustment = (GDataXMLElement *)[PriceAdjustments objectAtIndex:0];
                        PriceAdjustment = firstPriceAdjustment.stringValue.floatValue;
                        productVariantAttributeValue.PriceAdjustment = PriceAdjustment;
                        NSLog(@"PriceAdjustment: %f", PriceAdjustment);
                    }
                    
                    NSArray *IsPreselecteds = [PVAV nodesForXPath:@"IsPreSelected" error:nil];
                    if (IsPreselecteds.count > 0) {
                        GDataXMLElement *firstIsPreselected = (GDataXMLElement *)[IsPreselecteds objectAtIndex:0];
                        IsPreSelected = firstIsPreselected.stringValue.boolValue;
                        productVariantAttributeValue.isPreSelected = IsPreSelected;
                        NSLog(@"IsPreSelected: %i", IsPreSelected);
                    }
                    
                    [PVA.ProductVariantAttributeValues addObject:productVariantAttributeValue];
                }
                
                [productVariant.ProductVariantAttributes addObject:PVA];
            }
            
            [p.productVariants addObject:productVariant];
        }
        
        // Product Pictures
        NSArray *PPs = [product nodesForXPath:@"ProductPictures/ProductPicture" error:nil];
        NSLog(@"Product Picture count: %i", PPs.count);
        for (GDataXMLElement *PP in PPs) {
            Picture *picture = [[Picture alloc] init];
            
            NSArray *PictureIds = [PP nodesForXPath:@"PictureId" error:nil];
            if (PictureIds.count > 0) {
                GDataXMLElement *firstPictureId = (GDataXMLElement *) [PictureIds objectAtIndex:0];
                PictureId = firstPictureId.stringValue.intValue;
                picture.PictureId = PictureId;
                NSLog(@"PictureId: %i", PictureId);
            }
            
            NSArray *PictureURLs = [PP nodesForXPath:@"PictureURL" error:nil];
            if (PictureURLs.count > 0) {
                GDataXMLElement *firstURL = (GDataXMLElement *) [PictureURLs objectAtIndex:0];
                PictureURL = [NSURL URLWithString:firstURL.stringValue];
                picture.PictureURL = PictureURL;
                NSLog(@"PictureURL: %@", PictureURL);
            }
            
            [p.productPictures addObject:picture];
        }

        // Product Categories
        
        // Product Manufactures
        [products addObject:p];
        [p release];
    }
    
    [doc release];
    [xmlData release];
    return products;
}

@end
