//
//  WebImageView.h
//  WebImage
//
//  Created by Yongjoo Park on 4/20/11.
//  Copyright 2011 Webcash. All rights reserved.
//

#import <UIKit/UIKit.h>


enum WebImageViewResponseType {
	WebImageViewResponseToRectangle,
	WebImageViewResponseToCircle
};


@interface WebImageView : UIImageView {
	
	// IMAGE LOADING
	
	// pageDomain is used again later to retrieve image (first is to get info page)
	NSString *pageDomain;		// URL domain to the json info page
	
	// temporarily holds data before getting full data (managed by NSURLConnection delegate)
	NSMutableData *activeDownload;
	
	// used to distinguish url connection
	NSURLConnection *infoPageConnection;	// info page holds image url to load
	NSURLConnection *imageConnection;
	
	// used to remember the image file path
	NSString *imageFileDirectory;			// image directory from info page
	NSString *imageFilePath;				// file path (= image directory + file name)
	NSString *linkURLStirng;
	
	
	// TOUCH HANDLING
	enum WebImageViewResponseType touchResponseType;
	
	// store the point where touch starts
	CGPoint initialTouchPoint;
	
	// store target-action setting
	id touchTarget;
	SEL touchAction;
	
	// area to respond (area is defined as a circle)
	CGPoint responseOrigin;
	CGFloat responseRadius;
	
	BOOL	_isUse;
}

// PUBLIC METHODS

// you should put common prefix url to the paramter 'domain'
// 'domain' will be used again when getting image
- (void)loadImageFromDomain:(NSString *)domain andPage:(NSString *)page;

- (void)addTarget:(id)target action:(SEL)action;

// can specify whether this image view's touch area is the entire rectangle or
// the circle region specified with below two properties
@property (assign) enum WebImageViewResponseType touchResponseType;

// not necessary if touchResponseType is equal to WebImageViewResponseToRectangle
@property (assign) CGPoint responseOrigin;
@property (assign) CGFloat responseRadius;
@property (nonatomic, retain) NSString *linkURLStirng;

@end
