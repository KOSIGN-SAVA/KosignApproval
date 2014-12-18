/*
 *  WaitingSplashView.h
 *
 *  Created by 종욱 윤 on 10. 10. 5..
 *  Copyright 2010 (주) 쿠콘. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** @brief Defines a concrete @c WaitingSplashView 
 
 WaitingSplash 화면 클래스.
 
 */
@interface WaitingSplashView:UIView {

}
/////////////////////////////////////////////////////////////////////////////////////////////
/** WaitingSplash 시작 함수
 */
- (void)show;

- (void)chageText:(NSString *)text;



/////////////////////////////////////////////////////////////////////////////////////////////
/** WaitingSplash 종료 함수
 */
- (void)close;


- (void)changeOrientation:(UIInterfaceOrientation)orient;


@end
