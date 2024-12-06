//
//  HitItemModel.h
//  CouchGame
//
//  Created by JAMES ARASIM on 12/6/24.
//  Copyright © 2024 JAMES K ARASIM. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface HitItemModel : NSObject

@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *soundName;
@property (nonatomic, assign) int basePoints;

- (instancetype)initWithImage:(NSString *)imageName
                      sound:(NSString *)soundName
                 basePoints:(int)points;

@end
