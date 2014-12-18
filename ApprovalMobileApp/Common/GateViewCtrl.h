//
//  GateViewCtrl.h
//  OfficeWB
//
//  Created by donghwan kim on 11. 2. 10..
//  Copyright 2011 webcash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaitingSplashView.h"
#import "SecurityManager.h"
@interface GateViewCtrl : UINavigationController<UIAlertViewDelegate,SecurityManagerDelegate> {
	WaitingSplashView* _waitingSplash;
		
}

@property (nonatomic, retain)WaitingSplashView* waitingSplash;

@end
