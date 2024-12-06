//
//  HitItemModel.m
//  CouchGame
//
//  Created by JAMES ARASIM on 12/6/24.
//  Copyright © 2024 JAMES K ARASIM. All rights reserved.
//
#import "HitItemModel.h"

@implementation HitItemModel

- (instancetype)initWithImage:(NSString *)imageName
                      sound:(NSString *)soundName
                 basePoints:(int)points {
    if (self = [super init]) {
        self.imageName = imageName;
        self.soundName = soundName;
        self.basePoints = points;
    }
    return self;
}

@end
