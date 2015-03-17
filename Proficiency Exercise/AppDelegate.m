//
//  AppDelegate.m
//  ProficiencyExercise
//  ProficiencyExercise
//
//  Created by Vinay kumar Nishad on 16/03/2015.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//
//

#import "AppDelegate.h"
#import "RootViewController.h"

@implementation AppDelegate

@synthesize navigationController;
@synthesize window;


#pragma mark - UIApplicationDelegate Protocol Methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    RootViewController* rootObject = [[RootViewController alloc]initWithStyle:UITableViewStylePlain];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:rootObject];
    [[self window] setRootViewController:navController];
    [[self window] makeKeyAndVisible];
    return YES;
}

@end