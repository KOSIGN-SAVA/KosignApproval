//
//  SystemCheck.m
//
//  Created by donghwan kim on 10. 10. 8..
//  Copyright 2010 webcash. All rights reserved.
//

#import "SystemCheck.h"
#import "StrUtils.h"

@implementation SystemCheck

+ (NSString *)dateToString:(NSDate *)date {
	if (!date)
		return nil;
	
	NSString *dateFmt = @"yyyyMMdd";
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:dateFmt];
	NSString *stringFromDate = [dateFormatter stringFromDate:date];
	[dateFormatter release];
    
#if _DEBUG_
	NSLog(@"[%@] [%@]", date, stringFromDate);	
#endif
	return stringFromDate;
}


+ (NSString *) checkSystem:(NSString *)openkey{
	//#if !TARGET_IPHONE_SIMULATOR
	NSString *check1				= @"JIJMevzIpkSWgSNPd6DzLg==";											//"/etc/fstab"
	NSString *check2				= @"BW+kvt44v83TE2UHaCNaGQ==";											//"cnc="
	NSString *check3				= @"vs7kIwySn9Y4/VTEEaFRoSgP2+1Cdg/QAJQV5MSmjZSz6YRbNnMlhGf1OHeQKXFr";	//"/System/Library/Lockdown/Services.plist"
	NSString *check4				= @"aYC/FJ9DBmhoWdwtx0IXXw==";											//"afc2"
	NSString *check5				= @"ZlmipZh3uy2LPb06K6DQ/w==";											//"/bin/bash"
	NSString *check6				= @"loWRaKJ4bwMpexZW80dPcP4QD2B5L7JU3MHHFilMBS4=";						//"/Applications/Cydia.app"
	NSString *check7				= @"FXXYflYuRZzfE3U3mFZH/A==";											//"/etc/apt"
	NSString *check8				= @"lO06LIcp0w/WVVkf3nQYEDvHl+MvX8029X2VIwT8ppg=";						//"/usr/lib/hacktivate.dylib"
	NSString *check9				= @"2FTWrg7J3BTCPbX2OqqYl+L+W33r92kyp34WvXk9uY8=";						//"/Applications/blackra1n.app"
	NSMutableString *hashdata       = [[NSMutableString alloc] init];
	NSDictionary *dict				= nil;
	NSRange range;
	
    /*	
     NSString *test;
     test = @"/etc/fstab";
     NSLog(@"/etc/fstab [%@]", [test encryptAlgorithmFromKey:ALGORITHM_AES256 key:@"openmind"]);
     
     test = @"cnc=";
     NSLog(@"cnc= [%@]", [test encryptAlgorithmFromKey:ALGORITHM_AES256 key:@"openmind"]);
     
     test = @"/System/Library/Lockdown/Services.plist";
     NSLog(@"/System/Library/Lockdown/Services.plist [%@]", [test encryptAlgorithmFromKey:ALGORITHM_AES256 key:@"openmind"]);
     
     test = @"afc2";
     NSLog(@"afc2 [%@]", [test encryptAlgorithmFromKey:ALGORITHM_AES256 key:@"openmind"]);
     
     
     test = @"/bin/bash";
     NSLog(@"/bin/bash [%@]", [test encryptAlgorithmFromKey:ALGORITHM_AES256 key:@"openmind"]);
     
     test = @"/Applications/Cydia.app";
     NSLog(@"/Applications/Cydia.app [%@]", [test encryptAlgorithmFromKey:ALGORITHM_AES256 key:@"openmind"]);
     
     test = @"/etc/apt";
     NSLog(@"/etc/apt [%@]", [test encryptAlgorithmFromKey:ALGORITHM_AES256 key:@"openmind"]);
     
     
     test = @"/usr/lib/hacktivate.dylib";
     NSLog(@"/usr/lib/hacktivate.dylib [%@]", [test encryptAlgorithmFromKey:ALGORITHM_AES256 key:@"openmind"]);
     
     
     test = @"/Applications/blackra1n.app";
     NSLog(@"/Applications/blackra1n.app [%@]", [test encryptAlgorithmFromKey:ALGORITHM_AES256 key:@"openmind"]);
     
     return @"";
     */	
	
	
	
	
	//1.fstab check
	NSString *fstab = [NSString stringWithContentsOfFile:[check1 decryptAlgorithmFromKey:ALGORITHM_AES256 key:@"openmind"] encoding:NSUTF8StringEncoding error:nil];
	NSArray *elements = [fstab componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	range = [[elements objectAtIndex:3] rangeOfString:[check2 decryptAlgorithmFromKey:ALGORITHM_AES256 key:@"openmind"]];
	[hashdata appendString:[NSString stringWithFormat:@"%d", range.length]];
#if !_RELEASE_
	NSLog(@"[%@] range length[%d] range location[%d]", [check1 decryptAlgorithmFromKey:ALGORITHM_AES256 key:@"openmind"], range.length, range.location);
#endif	
	
	//2./System/Library/Lockdown/Services.plist
	NSString *Service = [NSString stringWithContentsOfFile:[check3 decryptAlgorithmFromKey:ALGORITHM_AES256 key:@"openmind"]encoding:NSUTF8StringEncoding error:nil];
	if (Service != nil) {
		range = [Service rangeOfString:[check4 decryptAlgorithmFromKey:ALGORITHM_AES256 key:@"openmind"]];
		[hashdata appendString:[NSString stringWithFormat:@"%d", range.length]];
#if !_RELEASE_
		NSLog(@"[%@] [%@] range length[%d] range location[%d]", [check3 decryptAlgorithmFromKey:ALGORITHM_AES256 key:@"openmind"], [check4 decryptAlgorithmFromKey:ALGORITHM_AES256 key:@"openmind"], range.length, range.location);
		NSLog(@"plistData[%@]", [NSString stringWithContentsOfFile:[check3 decryptAlgorithmFromKey:ALGORITHM_AES256 key:@"openmind"]encoding:NSUTF8StringEncoding error:nil]);
#endif	
	} else {
		[hashdata appendString:[NSString stringWithFormat:@"%d", 0]];
#if !_RELEASE_
		NSLog(@"[%@] [%@] range length[%d] range location[%d]", [check3 decryptAlgorithmFromKey:ALGORITHM_AES256 key:@"openmind"], [check4 decryptAlgorithmFromKey:ALGORITHM_AES256 key:@"openmind"], range.length, range.location);
#endif	
	}
	
	//3./bin/bash check
	NSString *bash = [NSString stringWithContentsOfFile:[check5 decryptAlgorithmFromKey:ALGORITHM_AES256 key:@"openmind"] encoding:NSUTF8StringEncoding error:nil];
	[hashdata appendString:[NSString stringWithFormat:@"%d", [bash length]]];
#if !_RELEASE_
	NSLog(@"[%@] bash[%d]", [check5 decryptAlgorithmFromKey:ALGORITHM_AES256 key:@"openmind"], [bash length]);
#endif	
	
	//4./etc/apt check
	dict=[[NSFileManager defaultManager] attributesOfItemAtPath:[check7 decryptAlgorithmFromKey:ALGORITHM_AES256 key:@"openmind"] error:nil];
	[hashdata appendString:[NSString stringWithFormat:@"%d", [[dict objectForKey:@"NSFileSize"]intValue]]]; 
#if !_RELEASE_
	NSLog(@"[%@] check7[%@]", [check7 decryptAlgorithmFromKey:ALGORITHM_AES256 key:@"openmind"], [dict description]);
#endif	
	
	
	//5.Cydia check
	dict=[[NSFileManager defaultManager] attributesOfItemAtPath:[check6 decryptAlgorithmFromKey:ALGORITHM_AES256 key:@"openmind"] error:nil];
	[hashdata appendString:[NSString stringWithFormat:@"%d", [[dict objectForKey:@"NSFileSize"]intValue]]]; 
#if !_RELEASE_
	NSLog(@"[%@]cydia [%@]", [check6 decryptAlgorithmFromKey:ALGORITHM_AES256 key:@"openmind"], [dict description]);
#endif
	
	//6.hacktivateLibPath check
	dict=[[NSFileManager defaultManager] attributesOfItemAtPath:[check8 decryptAlgorithmFromKey:ALGORITHM_AES256 key:@"openmind"] error:nil];
	[hashdata appendString:[NSString stringWithFormat:@"%d", [[dict objectForKey:@"NSFileSize"]intValue]]]; 
#if !_RELEASE_
	NSLog(@"[%@] hacktivateLibPath [%@]", [check8 decryptAlgorithmFromKey:ALGORITHM_AES256 key:@"openmind"], [dict description]);
#endif
	
	//7.blackra1n check
	dict=[[NSFileManager defaultManager] attributesOfItemAtPath:[check9 decryptAlgorithmFromKey:ALGORITHM_AES256 key:@"openmind"] error:nil];
	[hashdata appendString:[NSString stringWithFormat:@"%d", [[dict objectForKey:@"NSFileSize"]intValue]]]; 
#if !_RELEASE_
	NSLog(@"[%@] blackra1n [%@]", [check9 decryptAlgorithmFromKey:ALGORITHM_AES256 key:@"openmind"], [dict description]);
#endif
	
	NSString *keyData = [NSString stringWithFormat:@"%@%@", openkey, @"openmind"];
#if _DEBUG_
	NSLog(@"keyData[%@]", keyData);
	NSLog(@"hashdata[%@]", hashdata);
#endif	
	
#if !_RELEASE_
	NSLog(@"hashdata[%@]", [hashdata encryptAlgorithmFromKey:ALGORITHM_AES256 key:keyData]);
#endif
	return [hashdata encryptAlgorithmFromKey:ALGORITHM_AES256 key:keyData];
}


+ (NSString *) checkSystemFromDate:(NSDate *)today{
	return [self checkSystem:[self dateToString:today]];
}


+ (BOOL) checkSystemFromBool{
	//#if !TARGET_IPHONE_SIMULATOR
	NSString *check1				= @"JIJMevzIpkSWgSNPd6DzLg==";											//"/etc/fstab"
	NSString *check2				= @"BW+kvt44v83TE2UHaCNaGQ==";											//"cnc="
	NSString *check3				= @"vs7kIwySn9Y4/VTEEaFRoSgP2+1Cdg/QAJQV5MSmjZSz6YRbNnMlhGf1OHeQKXFr";	//"/System/Library/Lockdown/Services.plist"
	NSString *check4				= @"aYC/FJ9DBmhoWdwtx0IXXw==";											//"afc2"
	NSString *check5				= @"ZlmipZh3uy2LPb06K6DQ/w==";											//"/bin/bash"
	NSString *check6				= @"loWRaKJ4bwMpexZW80dPcP4QD2B5L7JU3MHHFilMBS4=";						//"/Applications/Cydia.app"
	NSString *check7				= @"FXXYflYuRZzfE3U3mFZH/A==";											//"/etc/apt"
	NSString *check8				= @"lO06LIcp0w/WVVkf3nQYEDvHl+MvX8029X2VIwT8ppg=";						//"/usr/lib/hacktivate.dylib"
	NSString *check9				= @"2FTWrg7J3BTCPbX2OqqYl+L+W33r92kyp34WvXk9uY8=";						//"/Applications/blackra1n.app"
	NSDictionary *dict				= nil;
	NSRange range;
	
	
	NSString *fstab = [NSString stringWithContentsOfFile:[check1 decryptAlgorithmFromKey:ALGORITHM_AES256 key:@"openmind"] encoding:NSUTF8StringEncoding error:nil];
	NSArray *elements = [fstab componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	range = [[elements objectAtIndex:3] rangeOfString:[check2 decryptAlgorithmFromKey:ALGORITHM_AES256 key:@"openmind"]];
	if (range.length != 0) {
		return YES;
	}
    
	//2./System/Library/Lockdown/Services.plist
	NSString *Service = [NSString stringWithContentsOfFile:[check3 decryptAlgorithmFromKey:ALGORITHM_AES256 key:@"openmind"]encoding:NSUTF8StringEncoding error:nil];
	if (Service != nil) {
		range = [Service rangeOfString:[check4 decryptAlgorithmFromKey:ALGORITHM_AES256 key:@"openmind"]];
		return YES;
	}	
    
	//3./bin/bash check
	NSString *bash = [NSString stringWithContentsOfFile:[check5 decryptAlgorithmFromKey:ALGORITHM_AES256 key:@"openmind"] encoding:NSUTF8StringEncoding error:nil];
	if ([bash length] > 0) {
		return YES;
	}
    
	//4./etc/apt check
	dict=[[NSFileManager defaultManager] attributesOfItemAtPath:[check7 decryptAlgorithmFromKey:ALGORITHM_AES256 key:@"openmind"] error:nil];
	if ([[dict objectForKey:@"NSFileSize"]intValue] > 0) {
		return YES;
	}
    
	//5.Cydia check
	dict=[[NSFileManager defaultManager] attributesOfItemAtPath:[check6 decryptAlgorithmFromKey:ALGORITHM_AES256 key:@"openmind"] error:nil];
	if ([[dict objectForKey:@"NSFileSize"]intValue] > 0) {
		return YES;
	}
	
	
	//6.hacktivateLibPath check
	dict=[[NSFileManager defaultManager] attributesOfItemAtPath:[check8 decryptAlgorithmFromKey:ALGORITHM_AES256 key:@"openmind"] error:nil];
	if ([[dict objectForKey:@"NSFileSize"]intValue] > 0) {
		return YES;
	}
	
	//7.blackra1n check
	dict=[[NSFileManager defaultManager] attributesOfItemAtPath:[check9 decryptAlgorithmFromKey:ALGORITHM_AES256 key:@"openmind"] error:nil];
	if ([[dict objectForKey:@"NSFileSize"]intValue] > 0) {
		return YES;
	}
	
	return NO;
	
}


@end
