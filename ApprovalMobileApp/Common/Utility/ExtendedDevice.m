//
//  ExtendedDevice.m
//
//  Created by 종욱 윤 on 10. 12. 3..
//  Copyright 2010 (주) 쿠콘. All rights reserved.
//

#include <sys/sysctl.h>
#import "ExtendedDevice.h"


@implementation UIDevice (Hardware)

- (NSString *)getSysInfoByName:(char *)typeSpecifier {
	size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
	
    char *answer = malloc(size);
	sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
	
	NSString* sResults = [NSString stringWithCString:answer encoding:NSUTF8StringEncoding];
	free(answer);
	
	return sResults;
}


- (NSString *)getPlatform {
	return [self getSysInfoByName:"hw.machine"];
}


- (NSString *)getHardwareModel {
	return [self getSysInfoByName:"hw.model"];
}


- (NSUInteger)getSysInfo:(uint)typeSpecifier {
	size_t size = sizeof(int);
	int results;
	int mib[2] = {CTL_HW, typeSpecifier};
	sysctl(mib, 2, &results, &size, NULL, 0);
	
	return (NSUInteger)results;
}


- (NSUInteger)getCPUFrequency {
	return [self getSysInfo:HW_CPU_FREQ];
}


- (NSUInteger)getBusFrequency {
	return [self getSysInfo:HW_BUS_FREQ];
}


- (NSUInteger)getTotalMemory {
	return [self getSysInfo:HW_PHYSMEM];
}


- (NSUInteger)getUserMemory {
	return [self getSysInfo:HW_USERMEM];
}


- (NSUInteger)getMaxSocketBufferSize {
	return [self getSysInfo:KIPC_MAXSOCKBUF];
}


- (NSNumber *)getTotalDiskSpace {
	NSDictionary* dicAttributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
	return [dicAttributes objectForKey:NSFileSystemSize];
}


- (NSNumber *)getFreeDiskSpace {
	NSDictionary* dicAttributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
	return [dicAttributes objectForKey:NSFileSystemFreeSize];
}


- (NSUInteger)getPlatformType {
	NSString* platform = [self getPlatform];
	
	if ([platform isEqualToString:@"iFPGA"])
		return UIDeviceIFPGA;
	
	if ([platform isEqualToString:@"iPhone1,1"])	
		return UIDevice1GiPhone;
	
	if ([platform isEqualToString:@"iPhone1,2"])	
		return UIDevice3GiPhone;
	
	if ([platform hasPrefix:@"iPhone2"])	
		return UIDevice3GSiPhone;
	
	if ([platform hasPrefix:@"iPhone3"])			
		return UIDevice4iPhone;
	
	if ([platform hasPrefix:@"iPhone4"])			
		return UIDevice5iPhone;
	
	if ([platform isEqualToString:@"iPod1,1"])   
		return UIDevice1GiPod;
	
	if ([platform isEqualToString:@"iPod2,1"])   
		return UIDevice2GiPod;
	
	if ([platform isEqualToString:@"iPod3,1"])   
		return UIDevice3GiPod;
	
	if ([platform isEqualToString:@"iPod4,1"])   
		return UIDevice4GiPod;
	
	if ([platform isEqualToString:@"iPad1,1"])   
		return UIDevice1GiPad;
	
	if ([platform isEqualToString:@"iPad2,1"])   
		return UIDevice2GiPad;
	
	if ([platform isEqualToString:@"AppleTV2,1"])	
		return UIDeviceAppleTV2;
	
	/*
	 MISSING A SOLUTION HERE TO DATE TO DIFFERENTIATE iPAD and iPAD 3G.... SORRY!
	 */
	
	if ([platform hasPrefix:@"iPhone"]) 
		return UIDeviceUnknowniPhone;
	
	if ([platform hasPrefix:@"iPod"]) 
		return UIDeviceUnknowniPod;
	
	if ([platform hasPrefix:@"iPad"]) 
		return UIDeviceUnknowniPad;
	
	if ([platform hasSuffix:@"86"] || [platform isEqual:@"x86_64"]) {
		if ([[UIScreen mainScreen] bounds].size.width < 768)
			return UIDeviceiPhoneSimulatoriPhone;
		else 
			return UIDeviceiPhoneSimulatoriPad;
		
		return UIDeviceiPhoneSimulator;
	}
	
	return UIDeviceUnknown;
}


- (NSString *)getPlatformString {
	switch ([self getPlatformType]) {
		case UIDevice1GiPhone: 
			return IPHONE_1G_NAMESTRING;
			
		case UIDevice3GiPhone: 
			return IPHONE_3G_NAMESTRING;
			
		case UIDevice3GSiPhone:	
			return IPHONE_3GS_NAMESTRING;
			
		case UIDevice4iPhone:	
			return IPHONE_4_NAMESTRING;
			
		case UIDevice5iPhone:	
			return IPHONE_5_NAMESTRING;
			
		case UIDeviceUnknowniPhone: 
			return IPHONE_UNKNOWN_NAMESTRING;
			
		case UIDevice1GiPod: 
			return IPOD_1G_NAMESTRING;
			
		case UIDevice2GiPod: 
			return IPOD_2G_NAMESTRING;
			
		case UIDevice3GiPod: 
			return IPOD_3G_NAMESTRING;
			
		case UIDevice4GiPod: 
			return IPOD_4G_NAMESTRING;
			
		case UIDeviceUnknowniPod: 
			return IPOD_UNKNOWN_NAMESTRING;
			
		case UIDevice1GiPad: 
			return IPAD_1G_NAMESTRING;
			
		case UIDevice2GiPad: 
			return IPAD_2G_NAMESTRING;
			
		case UIDeviceAppleTV2: 
			return APPLETV_2G_NAMESTRING;
			
		case UIDeviceiPhoneSimulator: 
			return IPHONE_SIMULATOR_NAMESTRING;
			
		case UIDeviceiPhoneSimulatoriPhone: 
			return IPHONE_SIMULATOR_IPHONE_NAMESTRING;
			
		case UIDeviceiPhoneSimulatoriPad: 
			return IPHONE_SIMULATOR_IPAD_NAMESTRING;
			
		case UIDeviceIFPGA: 
			return IFPGA_NAMESTRING;
			
		default: 
			return IPOD_FAMILY_UNKNOWN_DEVICE;
	}
}


- (NSString *)getPlatformCode {
	switch ([self getPlatformType]) {
		case UIDevice1GiPhone: 
			return @"M68";
			
		case UIDevice3GiPhone: 
			return @"N82";
			
		case UIDevice3GSiPhone:	
			return @"N88";
			
		case UIDevice4iPhone: 
			return @"N89";
			
		case UIDevice5iPhone: 
			return IPHONE_UNKNOWN_NAMESTRING;
			
		case UIDeviceUnknowniPhone: 
			return IPHONE_UNKNOWN_NAMESTRING;
			
		case UIDevice1GiPod: 
			return @"N45";
			
		case UIDevice2GiPod: 
			return @"N72";
			
		case UIDevice3GiPod: 
			return @"N18"; 
			
		case UIDevice4GiPod: 
			return @"N80";
			
		case UIDeviceUnknowniPod: 
			return IPOD_UNKNOWN_NAMESTRING;
			
		case UIDevice1GiPad: 
			return @"K48";
			
		case UIDevice2GiPad: 
			return IPAD_UNKNOWN_NAMESTRING;
			
		case UIDeviceUnknowniPad: 
			return IPAD_UNKNOWN_NAMESTRING;
			
		case UIDeviceAppleTV2:	
			return @"K66";
			
		case UIDeviceiPhoneSimulator: 
			return IPHONE_SIMULATOR_NAMESTRING;
			
		default: 
			return IPOD_FAMILY_UNKNOWN_DEVICE;
	}
}


@end
