/*
 * Copyright (c) 2008, Keith Lazuka, dba The Polypeptides
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *	- Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *	- Neither the name of the The Polypeptides nor the
 *	  names of its contributors may be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY Keith Lazuka ''AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL Keith Lazuka BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


#import <UIKit/UIKit.h>
typedef enum {
	IconType1,
	IconType2,
	IconType3
} IconTypes;


@interface KLTile : UIControl {
    NSDate*			_date;
	UILabel*		_dateLabel;          // 캘린더 일자표시
	UILabel*		_lunarLabel;         // 캘린더 음력표시
	UILabel*        _BadgeLabel;         // Badge 건수표시
	UIButton*		_testButton;
	UIImageView*	_selectedImage;
	NSString*		_selectedImageCode;
	NSString*		_todayImageCode;
	BOOL			_holiDay;
	BOOL			_iconDisplay;
	BOOL			_lunarDisplay;
	BOOL			_haveIcontype1;
	BOOL			_haveIcontype2;
	BOOL			_haveIcontype3;
	NSMutableArray*	_iconArray;
    NSString*       caleString;         //해당 일정 저장 
}

@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain, readonly) UILabel *dateLabel;
@property (nonatomic, retain, readonly) UILabel *lunarLabel;

@property (nonatomic, copy) NSString *selectedImageCode;
@property (nonatomic, copy) NSString *todayImageCode;

@property (nonatomic) BOOL holiDay;
@property (nonatomic) BOOL iconDisplay;
@property (nonatomic) BOOL lunarDisplay;
@property (nonatomic) BOOL haveIcontype1;
@property (nonatomic) BOOL haveIcontype2;
@property (nonatomic) BOOL haveIcontype3;

- (id)init;

- (void)addIconImage:(IconTypes)types imageName:(NSString *)imageName;

- (void)addBadge:(NSInteger)count imageName:(NSString *)imageName;

- (BOOL)isHaveIcon;


@end