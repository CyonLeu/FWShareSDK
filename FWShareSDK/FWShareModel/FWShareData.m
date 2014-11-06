//
//  FWShareData.m
//  FWShareSDKDemo
//
//  Created by Liuyong on 14-8-8.
//  Copyright (c) 2014年 FlyWire. All rights reserved.
//

#import "FWShareData.h"

@implementation FWShareData

+ (id)message
{
    FWShareData *data = [[[self class] alloc] init];
    return data;
}

@end


@implementation FWBaseMediaObject

+ (id)object
{
    FWBaseMediaObject *object = [[[self class] alloc] init];
    
    return object;
}

@end


@implementation FWImageObject

+ (id)object
{
    FWImageObject *imageObject = [[[self class] alloc] init];
    
    return imageObject;
}

- (UIImage *)image
{
    if (self.imageData) {
        return  [UIImage imageWithData:self.imageData];
    }
    
    return nil;
}
@end


@implementation FWWebpageObject



@end