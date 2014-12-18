//
//  AsyncImageView.m
//
//
//  Created by Wayne Cochran on 7/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AsyncImageView.h"
#import "ImageCacheObject.h"
#import "ImageCache.h"

#import "Constants.h"
#import "SysUtils.h"
#import "SessionManager.h"

//
// Key's are URL strings.
// Value's are ImageCacheObject's
//
static ImageCache *imageCache = nil;

@implementation AsyncImageView
@synthesize selectImage;

+ (UIImage *)getCacheImageFromURL:(NSURL*)url {
    
    if ([imageCache imageForKey:[url absoluteString]] == nil) {
        
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSError *error = nil;
        
        // image 경로를 구한다.
        NSString *cacheImagePath = [SysUtils filenameFromDocDir:kImagesPath];
        
        // image 경로의 존재 여부를 확인해서 없다면 폴더를 생성한다.
        if ([fileManager fileExistsAtPath:cacheImagePath] == NO) {
            if ([fileManager createDirectoryAtPath:cacheImagePath
                       withIntermediateDirectories:NO
                                        attributes:nil
                                             error:&error] == NO) {
                
                
            }
        }
        
        
        NSString *changeString = [[NSString alloc] initWithString:[[url absoluteString] stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
        
        
        // 이미지 가져올 경로를 구한다.
        NSString *imgPath	= [[[NSString alloc] initWithFormat:@"%@/%@", [SysUtils filenameFromDocDir:kImagesPath], [changeString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] autorelease];
        [changeString release];
        
        
        if ([fileManager fileExistsAtPath:imgPath] == YES){
            
            
            return [UIImage imageWithContentsOfFile:imgPath];
            
            
        } else {
            
            return nil;
        }
    }
    else {
        UIImage *cachedImage = [imageCache imageForKey:[url absoluteString]];
        return cachedImage;
    }
}


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [connection cancel];
    [connection release];
    [data release];
    [super dealloc];
}


- (void)loadImageFromURL:(NSURL*)url {
    if (connection != nil) {
        [connection cancel];
        [connection release];
        connection = nil;
    }
    if (data != nil) {
        [data release];
        data = nil;
    }
    
    if (imageCache == nil) // lazily create image cache
        imageCache = [[ImageCache alloc] initWithMaxSize:2*1024*1024];  // 2 MB Image cache
    
    [urlString release];
    urlString = [[url absoluteString] copy];
    UIImage *cachedImage = [imageCache imageForKey:urlString];
    if (cachedImage != nil) {
        if ([[self subviews] count] > 0) {
            [[[self subviews] objectAtIndex:0] removeFromSuperview];
        }
//        UIImageView *imageView = [[[UIImageView alloc] initWithImage:cachedImage] autorelease];
//        if ([SessionManager sharedSessionManager].isPhotoMain == YES) {
//            imageView.contentMode = UIViewContentModeScaleAspectFill;
//
//            imageView.autoresizingMask =
//            UIViewAutoresizingFlexibleWidth  | UIViewAutoresizingFlexibleHeight;
//        }else{
//            if ([SessionManager sharedSessionManager].isPhotoDetail == YES) {
//                imageView.contentMode = UIViewContentModeScaleAspectFit;
//
//            }else{
//                imageView.contentMode = UIViewContentModeScaleAspectFill;
//
//            }
//            imageView.autoresizingMask =
//            UIViewAutoresizingFlexibleWidth  | UIViewAutoresizingFlexibleHeight;
//        }
        
//        imageView.frame = self.bounds;
//        
//        [self addSubview:imageView];
//        
//        [imageView setNeedsLayout]; // is this necessary if superview gets setNeedsLayout?
//        [self setNeedsLayout];
        return;
	}
	
	// andy@luibh.ie 6th March 2010 - including modified code by Robert A of http://photoaperture.com/
	// this shows a default place holder image if no cached image exists.
	else {
        
		// Use a default placeholder when no cached image is found
		UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage
                                                                      imageNamed:@""]] autorelease];
//        if ([SessionManager sharedSessionManager].isPhotoMain == YES) {
//            imageView.contentMode = UIViewContentModeScaleAspectFill;
//            
//            imageView.autoresizingMask =
//            UIViewAutoresizingFlexibleWidth  | UIViewAutoresizingFlexibleHeight;
//        }else{
//            if ([SessionManager sharedSessionManager].isPhotoDetail == YES) {
//                imageView.contentMode = UIViewContentModeScaleAspectFit;
//                
//            }else{
//                imageView.contentMode = UIViewContentModeScaleAspectFill;
//                
//            }
//            imageView.autoresizingMask =
//            UIViewAutoresizingFlexibleWidth  | UIViewAutoresizingFlexibleHeight;
//        }
		[self addSubview:imageView];
		imageView.frame = self.bounds;
		[imageView setNeedsLayout];
		[self setNeedsLayout];
	}
	
#define SPINNY_TAG 5555
    
    UIActivityIndicatorView *spinny = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinny.tag = SPINNY_TAG;
    spinny.center = self.center;
    [spinny startAnimating];
    [self addSubview:spinny];
    [spinny release];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:60.0];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)incrementalData {
    if (data==nil) {
        data = [[NSMutableData alloc] initWithCapacity:2048];
    }
    [data appendData:incrementalData];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection {
    [connection release];
    connection = nil;
    
    UIView *spinny = [self viewWithTag:SPINNY_TAG];
    [spinny removeFromSuperview];
    
    if ([[self subviews] count] > 0) {
        [[[self subviews] objectAtIndex:0] removeFromSuperview];
    }
    
    UIImage *image = [UIImage imageWithData:data];
    selectImage = image;

    [imageCache insertImage:image withSize:[data length] forKey:urlString];
    
//    UIImageView *imageView = [[[UIImageView alloc]
//                               initWithImage:image] autorelease];
//    if ([SessionManager sharedSessionManager].isPhotoMain == YES) {
//        imageView.contentMode = UIViewContentModeScaleAspectFill;
//        
//        imageView.autoresizingMask =
//        UIViewAutoresizingFlexibleWidth  | UIViewAutoresizingFlexibleHeight;
//    }else{
//        if ([SessionManager sharedSessionManager].isPhotoDetail == YES) {
//            imageView.contentMode = UIViewContentModeScaleAspectFit;
//            
//        }else{
//            imageView.contentMode = UIViewContentModeScaleAspectFill;
//            
//        }
//        
//        imageView.autoresizingMask =
//        UIViewAutoresizingFlexibleWidth  | UIViewAutoresizingFlexibleHeight;
//    }
//
//    [self addSubview:imageView];
//    imageView.frame = self.bounds;
//    [imageView setNeedsLayout]; // is this necessary if superview gets setNeedsLayout?
    [self setNeedsLayout];
    [data release];
    data = nil;
}

@end
