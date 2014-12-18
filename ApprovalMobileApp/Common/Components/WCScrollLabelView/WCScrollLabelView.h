//
//  WCScrollLabelView.h
//  scrollLabel
//
//  Created by donghwan kim on 11. 2. 28..
//  Copyright 2011 webcash. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScrollLabelViewDelegate;


@interface WCScrollLabelView : UIView {
	CGFloat						_stopInterval;
	UIFont*						_font;
	UIColor*					_textColor;
	NSInteger					_currentIndex;
	BOOL						_serverMode; //YES : 통신 부분을 내부에서 처리 한다. NO이면 외부 Delegate에서 넘겨주는 값으로 처리 한다.
    NSMutableData*				_responseServerData;
	NSString*					_encodingName;
	NSInteger					_statusCode;

	NSMutableArray*				_tickerArray;
	
	id<ScrollLabelViewDelegate>	_delegate;
	
@private
	NSMutableArray*				_pointList;
	NSTimer*					_timer;
}

@property (nonatomic) CGFloat stopInterval;
@property (nonatomic, retain) UIFont* font;
@property (nonatomic, retain) UIColor* textColor;
@property (nonatomic, readonly) NSInteger currentIndex;
@property (nonatomic, assign) id<ScrollLabelViewDelegate> delegate;

- (void)reloadData;
- (void)receiveServerData:(NSString *)serverURL;
- (void)startAnimation;
- (void)stopAnimation;
@end


@protocol ScrollLabelViewDelegate<NSObject>;
@optional
- (NSInteger)numberOfScrollLabel:(WCScrollLabelView *)aScrollLabelView;

- (NSString *)scrollLabel:(WCScrollLabelView *)aScrollLabelView label:(NSInteger)aIndex;

- (void)scrollLabel:(WCScrollLabelView *)aScrollLabelView didSelectItem:(NSInteger)aIndex;

- (void)scrollLabel:(WCScrollLabelView *)aScrollLabelView didSelectURL:(NSString *)aURL;

@end


