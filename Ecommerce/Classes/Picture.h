//
//  Picture.h
//  Ecommerce
//
//  Created by Pengyu Lan on 16/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Picture : NSObject
{
    NSInteger PictureId;
    NSURL *PictureURL;
}

@property (nonatomic) NSInteger PictureId;
@property (nonatomic, retain) NSURL *PictureURL;

@end
