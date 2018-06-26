//
//  AppDelegate.h
//  WVRMediator
//
//  Created by Wang Tiger on 17/7/11.
//  Copyright © 2017年 WhaleyVR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

