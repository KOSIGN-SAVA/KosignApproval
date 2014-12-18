//
//  WebImageView.m
//  WebImage
//
//  Created by Yongjoo Park on 4/20/11.
//  Copyright 2011 Webcash. All rights reserved.
//

#import "WebImageView.h"
#import "JSON.h"


static const NSString *imageDirectory = @"event";



@interface WebImageView ()

@property (nonatomic, retain) NSString *pageDomain;
@property (nonatomic, retain) NSMutableData *activeDownload;
@property (nonatomic, retain) NSURLConnection *infoPageConnection;
@property (nonatomic, retain) NSURLConnection *imageConnection;
@property (nonatomic, retain) NSString *imageFileDirectory;
@property (nonatomic, retain) NSString *imageFilePath;

@property (nonatomic, retain) id touchTarget;

@end






@implementation WebImageView

// private properties
@synthesize pageDomain;
@synthesize activeDownload;
@synthesize infoPageConnection;
@synthesize imageConnection;
@synthesize imageFileDirectory;
@synthesize imageFilePath;

@synthesize touchTarget;

// public properties
@synthesize touchResponseType;
@synthesize responseOrigin;
@synthesize responseRadius;
@synthesize linkURLStirng;




#pragma mark -
#pragma mark Public Method


- (void)loadImageFromDomain:(NSString *)domain andPage:(NSString *)page {
	// initialize temporary storage
	self.activeDownload = [NSMutableData data];
	
	// store domain name to use later
	self.pageDomain = domain;
	
	// create url connection; connection starts immediately after creating a new one
	NSString *urlInString = [NSString stringWithFormat:@"%@%@", domain, page];
	NSURL *url = [NSURL URLWithString:urlInString];
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
	self.infoPageConnection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
	
	// response data is handled in delegate methods
}


- (void)addTarget:(id)target action:(SEL)action {
	self.touchTarget = target;
	touchAction = action;
}



#pragma mark -
#pragma mark Helpers

- (CGFloat)distanceFrom:(CGPoint)a To:(CGPoint)b {
	return pow(pow(a.x - b.x, 2) + pow(a.y - b.y, 2), 0.5);
}





#pragma mark -
#pragma mark NSURLConnection Delegate


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	if (connection == self.infoPageConnection) {
		// failed to load info page
		
		// release the temporary data storage
		self.activeDownload = nil;
		
		// release the connection
		self.infoPageConnection = nil;
	}
	else if (connection == self.imageConnection) {
		// failed to load image
		
		// release the temporary data storage
		self.activeDownload = nil;
		
		// release the connection
		self.imageConnection = nil;
	}
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	if (connection == self.infoPageConnection) {
		// retrived json data from the server
		
		// get image folder and image name
		NSString *info = [[NSString alloc] initWithData:self.activeDownload encoding:NSUTF8StringEncoding];
#if TARGET_IPHONE_SIMULATOR
		NSLog(@"%@", info);
#endif
		NSDictionary *jdic = [info JSONValue];
		NSDictionary *dataDic = [[jdic valueForKey:@"_tran_res_data"] objectAtIndex:0];
		NSString *imageFileName = [dataDic valueForKey:@"_imgnm"];
		NSString *imageFolder = [dataDic valueForKey:@"_imgurl"];
		NSString *linkURL = [dataDic valueForKey:@"_linkurl"];
		_isUse = [[[dataDic objectForKey:@"_use_yn"] uppercaseString] isEqualToString:@"Y"];
		// release the temporary data storage and prepare for next connection
		self.activeDownload = [NSMutableData data];
		
		if (!_isUse) {
			return;
		}
		
		
		// check if the same image exist in document directory
		NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString *absoluteImageDirectory = [NSString stringWithFormat:@"%@/%@/%@", documentsDirectory, imageDirectory, imageFolder];
		NSString *absoluteImagePath = [NSString stringWithFormat:@"%@/%@", absoluteImageDirectory, imageFileName];
		
		if (linkURL) {
			self.linkURLStirng = linkURL;
		}
		
		NSFileManager *fm = [[NSFileManager alloc] init];
		
		if (![fm fileExistsAtPath:absoluteImagePath]) {
			// no file exist in directory and get the image file from the server
			
			self.imageFileDirectory = absoluteImageDirectory;	// used in imageConnection's delegate
			self.imageFilePath = absoluteImagePath;				// used in imageConnection's delegate
			
			// create image url connection
			//			NSString *urlInString = [NSString stringWithFormat:@"http://%@/%@/%@", self.pageDomain, imageFolder, imageFileName];
			NSString *urlInString = [NSString stringWithFormat:@"%@/%@", self.pageDomain, imageFolder];
			NSURL *url = [NSURL URLWithString:urlInString];
			NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
			self.imageConnection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
			
			// setting image is handled in delegate
		}
		else {
			// the same file exist and get the file instead
			UIImage *img = [UIImage imageWithContentsOfFile:absoluteImagePath];
			if (img) self.image = img;
			
#ifdef _DEBUG_
			NSLog(@"Image loaded from local directory");
#endif
		}
		
		[fm release];
		
		// release the connection
		self.infoPageConnection = nil;
	}
	else if (connection == self.imageConnection) {
		// retrived image data from the server
		
		// set image
		UIImage *img = [[UIImage alloc] initWithData:self.activeDownload];
		if (img) self.image = img;
		[img release];
		
#ifdef _DEBUG_
		NSLog(@"Image loaded from web");
#endif
		
		// save the image in document folder
		NSFileManager *fm = [[NSFileManager alloc] init];
		
		
#ifdef _DEBUG_
		// directory creation doesn't do anything if already exists
		BOOL isDirCreated = [fm createDirectoryAtPath:self.imageFileDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
		BOOL isFileSaved = [fm createFileAtPath:self.imageFilePath contents:self.activeDownload attributes:nil];

		if (isDirCreated) NSLog(@"Directory exist or created at: %@", self.imageFileDirectory);
		if (isFileSaved) NSLog(@"File saved at: %@", self.imageFilePath);
#endif
		
		[fm release];
		
		
		// release the temporary data storage
		self.activeDownload = nil;
		
		// release the connection
		self.imageConnection = nil;
	}
}




#pragma mark -
#pragma mark UIResponder Overriding

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	//	[super touchesBegan:touches withEvent:event];
	
	UITouch *aTouch = [touches anyObject];
	CGPoint touchedPoint = [aTouch locationInView:self];
	
	initialTouchPoint = touchedPoint;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	//	[super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	//	[super touchesEnded:touches withEvent:event];
	
	UITouch *aTouch = [touches anyObject];
	CGPoint touchedPoint = [aTouch locationInView:self];
	
	CGPoint finalTouchPoint = touchedPoint;
	
	if ([self distanceFrom:finalTouchPoint To:initialTouchPoint] < 20.0) {
		// user didn't drag on the image
		
#ifdef _DEBUG_
		NSLog(@"simple touched at: (%f, %f)", touchedPoint.x, touchedPoint.y);
#endif
		
		if (_isUse == NO) {
			return;
		}
		
		// perform target-action stored		
		if (touchResponseType == WebImageViewResponseToRectangle) {
			if (touchedPoint.x >= 0 && touchedPoint.y >= 0 &&
				touchedPoint.x <= self.bounds.size.width &&
				touchedPoint.y <= self.bounds.size.height) {
				// touched inside image rectangle
				[touchTarget performSelector:touchAction withObject:self];
			}
		}
		else if (touchResponseType == WebImageViewResponseToCircle) {
			if (touchedPoint.x >= 0 && touchedPoint.y >= 0 &&
				touchedPoint.x <= self.bounds.size.width &&
				touchedPoint.y <= self.bounds.size.height &&
				[self distanceFrom:responseOrigin To:finalTouchPoint] <= responseRadius) {
				// touched inside image rectangle and specified circle
				[touchTarget performSelector:touchAction withObject:self];
			}
		}
	}
}





#pragma mark -
#pragma mark View LifeCycle


- (void)customInit {
	self.userInteractionEnabled = YES;
	touchResponseType = WebImageViewResponseToRectangle;
	
	touchTarget = nil;
	touchAction = NULL;
	
	responseOrigin = CGPointZero;
	responseRadius = 0;	
	_isUse = NO;
}


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		[self customInit];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image {
	
	self = [super initWithImage:image];
	if (self) {
		// Initialization code.
		[self customInit];
	}
	return self;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code.
 }
 */

- (void)dealloc {
	self.pageDomain = nil;
	self.activeDownload = nil;		// in case of abnormal termination of app
	self.infoPageConnection = nil;	// in case of abnormal termination of app
	self.imageConnection = nil;		// in case of abnormal termination of app
	self.imageFilePath = nil;
	
	self.touchTarget = nil;
	
	
	
    [super dealloc];
}


@end
