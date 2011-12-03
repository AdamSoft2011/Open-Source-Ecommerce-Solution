//
//  Picture.m
//  Ecommerce
//
//  Created by Pengyu Lan on 16/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Picture.h"

@implementation Picture

@synthesize PictureId;
@synthesize PictureURL;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [PictureURL release];
    [super dealloc];
}

@end
