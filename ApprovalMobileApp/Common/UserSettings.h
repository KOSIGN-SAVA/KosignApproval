//
//  UserSettings.h
//  Office365
//
//  Created by jung woon Kwon on 11. 8. 9..
//  Copyright 2011 coocon. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserSettings : NSObject {
	NSMutableDictionary*	userSettingsDic;
}


@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userCompName;
@property (nonatomic, copy) NSString *userGateUrl;
@property (nonatomic, copy) NSArray *myMenuInfo;
@property (nonatomic) NSInteger	compSeq;
@property (nonatomic, copy) NSString *memoVerType;
@property (nonatomic, copy) NSString *userCompNum;


+ (UserSettings*)sharedUserSettings;



@end
