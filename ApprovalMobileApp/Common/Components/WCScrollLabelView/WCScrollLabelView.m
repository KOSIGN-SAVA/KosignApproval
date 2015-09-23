//
//  WCScrollLabelView.m
//  scrollLabel
//
//  Created by donghwan kim on 11. 2. 28..
//  Copyright 2011 webcash. All rights reserved.
//

#import "WCScrollLabelView.h"
#import "JSON.h"
#import "Constants.h"

@interface WCScrollLabelView()
- (NSInteger)getLabelCount;
- (NSString *)getStringLabel:(NSInteger)aIndex;
- (void)setSelectedLabel:(NSInteger)aIndex;

- (void)startAni;
- (void)stopAni;
@end


@implementation WCScrollLabelView
@synthesize delegate		= _delegate;
@synthesize font			= _font;
@synthesize	textColor		= _textColor;
@synthesize stopInterval	= _stopInterval;
@synthesize currentIndex	= _currentIndex;

#pragma mark -
#pragma mark WCScrollLabelView LifeCycle method
#pragma mark -
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		// initialization
		_stopInterval	= 10; //5초간 머무는 행위를 한다.
		_font			= [[UIFont systemFontOfSize:12.0f] retain];
		_textColor		= [[UIColor blackColor] retain];
		_pointList		= [[NSMutableArray alloc] init];
		_currentIndex	= -1;
		_timer			= nil;
		_serverMode		= NO;
		_statusCode		= -1;
		
        UIScrollView* mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.bounds.size.width, self.bounds.size.height)];
		mainScroll.tag = 1000;
		[self addSubview:mainScroll];
		mainScroll.userInteractionEnabled = NO;
		
		
		UILabel* mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.bounds.size.width, self.bounds.size.height)];
		mainLabel.tag = 1001;
#ifdef IS_IOS_6_OR_LATER
        mainLabel.lineBreakMode = NSLineBreakByClipping;
#else
        mainLabel.lineBreakMode = UILineBreakModeClip;
#endif
		
		mainLabel.font = _font;
		mainLabel.backgroundColor = [UIColor clearColor];
		[mainScroll addSubview:mainLabel];
		
		[mainLabel release];
		[mainScroll release];
    }
    return self;
}


- (void)dealloc {
	if (_pointList) {
		[_pointList removeAllObjects];
		[_pointList release];
	}
	
	if (_tickerArray) {
		[_tickerArray release];
	}
	
	if (_responseServerData) {
		[_responseServerData release];
	}
	
    [super dealloc];
}


#pragma mark -
#pragma mark WCScrollLabelView Private method
#pragma mark -
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	if (_currentIndex >= 0) {
		[self setSelectedLabel:_currentIndex];
	}	
}


- (NSInteger)getLabelCount{
	if (_serverMode) {
		return [_tickerArray count];
	} else {
		if (_delegate == nil || [_delegate respondsToSelector:@selector(numberOfScrollLabel:)] == NO)
			return 0;
		
		return [_delegate numberOfScrollLabel:self];
	}
}


- (NSString *)getStringLabel:(NSInteger)aIndex {
	if (_serverMode) {
		return [[_tickerArray objectAtIndex:aIndex] objectForKey:@"_title"];
	} else {
		if (_delegate == nil || [_delegate respondsToSelector:@selector(scrollLabel:label:)] == NO)
			return nil;
	
		return [_delegate scrollLabel:self label:aIndex];
	}
}


- (void)setSelectedLabel:(NSInteger)aIndex{
	if (_serverMode) {
		if (_delegate == nil || [_delegate respondsToSelector:@selector(scrollLabel:didSelectURL:)] == NO)
			return;
		NSString *aURL = [[_tickerArray objectAtIndex:aIndex] objectForKey:@"_dt_url"];
		
		if (aURL) {
			[_delegate scrollLabel:self didSelectURL:aURL];
		}
		
		
	} else {
		if (_delegate == nil || [_delegate respondsToSelector:@selector(scrollLabel:didSelectItem:)] == NO)
			return;
		
		[_delegate scrollLabel:self didSelectItem:aIndex];
	}
}


- (void)animationEnd{
	if (_currentIndex + 1 == [_pointList count]-1) {
		UIScrollView* tempScroll = (UIScrollView *)[self viewWithTag:1000];	
		tempScroll.contentOffset = CGPointMake(0.0f, 0.0f);
		_currentIndex = 0;
	} else {
		_currentIndex = _currentIndex + 1;
	}
	
	
	[self startAni];
}


- (void)OnTimeout:(NSTimer *)timer {
	[self stopAni];
	
	UIScrollView* tempScroll = (UIScrollView *)[self viewWithTag:1000];	
	CGFloat nextWidth;
	CGFloat animationTime;
	
	nextWidth = [[_pointList objectAtIndex:_currentIndex + 1]CGPointValue].x;
	animationTime = [[_pointList objectAtIndex:_currentIndex]CGPointValue].y;
	
	if ([UIView areAnimationsEnabled]) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationEnd)];
		[UIView setAnimationDuration:animationTime];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		tempScroll.contentOffset = CGPointMake(nextWidth, 0.0f);
		
		[UIView commitAnimations];
	}
}


- (void)stopAni {
	if (_timer) {
		[_timer invalidate];
		[_timer release];
		_timer = nil;
	}
}


- (void)startAni {
	_timer = [[NSTimer scheduledTimerWithTimeInterval:_stopInterval target:self selector:@selector(OnTimeout:) userInfo:nil repeats:NO] retain];
}


#pragma mark -
#pragma mark WCScrollLabelView Public method
#pragma mark -
- (void)reloadData{
	NSInteger		totalCount= 0;
	NSString*		tempString = nil;
	CGFloat			tempWidth = 0.0f;
	CGFloat			tempTotalWidth = 0.0f;
	CGFloat			tempPaddingWidth;
	NSValue*		pointAsObject = nil;
	NSInteger		paddingCount = 0;
	UIScrollView*	tempScroll = (UIScrollView *)[self viewWithTag:1000];	
	UILabel*		tempLabel = (UILabel *)[self viewWithTag:1001];	
	
	 
	
	tempLabel.text		= @"";
	tempLabel.font		= _font;
	tempLabel.textColor = _textColor;

#ifdef IS_IOS_7_OR_LATER
    tempPaddingWidth = [@" " sizeWithAttributes:@{NSFontAttributeName: _font}].width;
#else
    tempPaddingWidth = [@" " sizeWithFont:_font].width;
#endif
	
	
	[_pointList removeAllObjects];
	
	totalCount = [self getLabelCount];
	
	if (totalCount > 0) {
		_currentIndex = 0;
		for (int i=0; i <= totalCount; i++) {
			
			if (i == totalCount) {
				// 맨 마지막의 라벨은 제일 처음 스트링으로 처리 한다.
				tempString = [self getStringLabel:0];
			} else {
				tempString = [self getStringLabel:i];
			}
			
#ifdef IS_IOS_7_OR_LATER
            tempWidth = [[NSString stringWithFormat:@"%@ ", tempString] sizeWithAttributes:@{NSFontAttributeName: _font}].width;
#else
            tempWidth = [[NSString stringWithFormat:@"%@ ", tempString] sizeWithFont:_font].width;
#endif
			
			//현재 사이즈가 전체 frame보다 작으면 String에 현 프레임의 길이 만큼 String에 Padding처리 하고 사이즈를 재계산하자.
			if (tempWidth < self.frame.size.width) {
				paddingCount =	(floor(self.frame.size.width - tempWidth) / tempPaddingWidth) + 1;
				tempString = [tempString stringByPaddingToLength:[tempString length] + paddingCount withString:@" " startingAtIndex:0];
				
#ifdef IS_IOS_7_OR_LATER
                tempWidth = [[NSString stringWithFormat:@"%@ ", tempString] sizeWithAttributes:@{NSFontAttributeName: _font}].width;
#else
                tempWidth = [[NSString stringWithFormat:@"%@ ", tempString] sizeWithFont:_font].width;
#endif
				
			}
			
			pointAsObject = [NSValue valueWithCGPoint:CGPointMake(tempTotalWidth, tempWidth/50)];
			
			[_pointList addObject:pointAsObject];
			tempTotalWidth += tempWidth;
			
			tempLabel.text = [NSString stringWithFormat:@"%@%@", tempLabel.text, [NSString stringWithFormat:@"%@ ", tempString]];
		}
		if (tempTotalWidth > 0) {
			tempScroll.contentSize = CGSizeMake(tempTotalWidth, tempScroll.contentSize.height);
			tempLabel.frame = CGRectMake(tempLabel.frame.origin.x, tempLabel.frame.origin.y, tempTotalWidth, tempLabel.frame.size.height);
		}
		[self startAni];
	}
}


- (void)startAnimation{
	[self startAni];
}


- (void)stopAnimation{
	[self stopAni];
}


- (void)receiveServerData:(NSString *)serverURL {
	if (!serverURL) {
		return;
	}

	//티커 전문 송신
	NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:serverURL]];
	[NSURLConnection connectionWithRequest:req delegate:self];

	_serverMode = YES;
}


#pragma mark -
#pragma mark NSURLConnection delegate methods
#pragma mark -
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	if (!response)
		return;
	
	_responseServerData = [[NSMutableData data] retain];
	_encodingName = [[response textEncodingName] copy];
	
	if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
		_statusCode   = ((NSHTTPURLResponse *)response).statusCode;
	}
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[_responseServerData appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

	NSString *stringReceiveData = nil;
	if (_statusCode = 200) {
		if ([_encodingName isEqualToString:@"euc-kr"] == YES){
			//암호화 되지 않은 에러를 처리 할때 _error_cd
			stringReceiveData = [[[[NSString alloc] initWithData:_responseServerData encoding:-2147481280] stringByReplacingOccurrencesOfString:@"\r" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
		}
		else if ([_encodingName isEqualToString:@"utf-8"] == YES){
			stringReceiveData = [[[[NSString alloc] initWithData:_responseServerData encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\r" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
		}
	}
	
	NSDictionary *tickerDataDic = [stringReceiveData JSONValue];
	
	if (!tickerDataDic)
		return;
	
	NSArray *resData		= [tickerDataDic objectForKey:@"_tran_res_data"];
	NSDictionary *detailDic	= [resData objectAtIndex:0];
	NSArray *listData		= [detailDic objectForKey:@"_ticker_list"];
	
	if (!listData)
		return;
	
	if (!_tickerArray) {
		_tickerArray = [[NSMutableArray alloc] init];
	} else {
		[_tickerArray removeAllObjects];
	}

	[_tickerArray addObjectsFromArray:[detailDic objectForKey:@"_ticker_list"]];
	[self reloadData];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
#if !_RELEASE_
	NSLog(@"티커 데이터 송신 실패: %@", [error localizedDescription]);
#endif
}



@end
