//
//  UserSettings.m
//  Office365
//
//  Created by jung woon Kwon on 11. 8. 9..
//  Copyright 2011 coocon. All rights reserved.
//

#import "UserSettings.h"
#import "JSON.h"
#import "AllUtils.h"

static NSString *userSettingSaveFileName	= @"userSettings.json";
static UserSettings *sharedUserSettings		= nil;

@interface UserSettings()

- (id)initSingleton;
- (void)fileSave;

@end

@implementation UserSettings

@synthesize memoVerType;

#pragma mark -
#pragma mark private Method
- (id)initSingleton {
	if (self = [super init]) {
        
		NSString *filePath			= [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), userSettingSaveFileName];
		NSString *jsonSourceString	= [NSString stringWithEncrytionFile_AES256:filePath];
        
		if ([SysUtils isNull:jsonSourceString] == NO) 
			userSettingsDic = [[jsonSourceString JSONValue] retain];
		
		if ([SysUtils isNull:userSettingsDic] == YES) {
            
			userSettingsDic		= [[NSMutableDictionary alloc] init];
            
			self.userId			= @"";
			self.userCompName	= @"";
			self.userGateUrl	= @"";
            self.userCompNum		= @"";

            self.compSeq		= 0;
			self.myMenuInfo		= [[NSArray alloc] init];
            self.memoVerType    = @"";
		}
	}
	
	return self;
}

- (void)fileSave {
	
    NSString *userSettingsString	= [userSettingsDic JSONRepresentation];
    NSString *filePath				= [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), userSettingSaveFileName];
    
    [userSettingsString writeToEncrytionFile_AES256:filePath];
}



#pragma mark -
#pragma mark LifeCycle Method
+ (UserSettings*)sharedUserSettings {
    if (!sharedUserSettings) 
        sharedUserSettings = [[super allocWithZone: NULL] initSingleton];
	
    return sharedUserSettings;
}


- (void)dealloc {
	[userSettingsDic release];	
	[super dealloc];
}


+ (id)allocWithZone:(NSZone *)zone {
    return [[self sharedUserSettings] retain];
}


- (id)copyWithZone:(NSZone *)zone {
    return self;
}


- (id)retain {
    return self;
}


- (NSUInteger)retainCount {
    return NSUIntegerMax;  //denotes an object that cannot be released
}


- (void)release {
    //do nothing
}


- (id)autorelease {
    return self;
}




#pragma mark -
#pragma mark property getter setter
- (NSString *)userId {
	return [userSettingsDic objectForKey:@"User_ID"];
}


- (void)setUserId:(NSString *)value {
	[userSettingsDic setObject:value forKey:@"User_ID"];
	[self fileSave];
}


- (NSString *)userCompName {
	return [userSettingsDic objectForKey:@"User_CompName"];
}


- (void)setUserCompName:(NSString *)value {
	[userSettingsDic setObject:value forKey:@"User_CompName"];
	[self fileSave];
}


- (NSString *)userCompNum {
	return [userSettingsDic objectForKey:@"User_CompNum"];
}


- (void)setUserCompNum:(NSString *)value {
	[userSettingsDic setObject:value forKey:@"User_CompNum"];
	[self fileSave];
}

- (NSString *)userGateUrl {
	return [userSettingsDic objectForKey:@"User_GatewayUrl"];
}


- (void)setUserGateUrl:(NSString *)value {
	[userSettingsDic setObject:value forKey:@"User_GatewayUrl"];
	[self fileSave];
}


- (NSArray *)myMenuInfo {
	return [userSettingsDic objectForKey:@"MyMenu_Info"];
}


- (void)setMyMenuInfo:(NSArray *)value {
	[userSettingsDic setObject:value forKey:@"MyMenu_Info"];
	[self fileSave];
}


- (NSInteger)compSeq {
    NSNumber* num = [userSettingsDic objectForKey:@"Comp_Seq"];
    
    return [num intValue];
}


- (void)setCompSeq:(NSInteger)value {
    NSNumber* num = [NSNumber numberWithInt:value];
    [userSettingsDic setObject:num forKey:@"Comp_Seq"];
    [self fileSave];
}


- (NSString *)memoVerType {
	return [userSettingsDic objectForKey:@"New_Memo_Type"];
}


- (void)setMemoVerType:(NSString *)value {
	[userSettingsDic setObject:value forKey:@"New_Memo_Type"];
	[self fileSave];
}


@end
