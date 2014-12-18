//
//  DateUtils.m
//  date
//
//  Created by donghwan kim on 10. 10. 29..
//  Copyright 2010 webcash. All rights reserved.
//

#import "DateUtils.h"
#include <iostream>
#include <cstring>

@implementation NSDate(DateUtils)

static const char _info_array[203][12] ={
	/* 1841 */    
	1, 2, 4, 1, 1, 2,    1, 2, 1, 2, 2, 1,
	2, 2, 1, 2, 1, 1,    2, 1, 2, 1, 2, 1,
	2, 2, 2, 1, 2, 1,    4, 1, 2, 1, 2, 1,
	2, 2, 1, 2, 1, 2,    1, 2, 1, 2, 1, 2,
	1, 2, 1, 2, 2, 1,    2, 1, 2, 1, 2, 1,
	2, 1, 2, 1, 5, 2,    1, 2, 2, 1, 2, 1,
	2, 1, 1, 2, 1, 2,    1, 2, 2, 2, 1, 2,
	1, 2, 1, 1, 2, 1,    2, 1, 2, 2, 2, 1,
	2, 1, 2, 3, 2, 1,    2, 1, 2, 1, 2, 2,
	2, 1, 2, 1, 1, 2,    1, 1, 2, 2, 1, 2,
	
	/* 1851 */    
	2, 2, 1, 2, 1, 1,    2, 1, 2, 1, 5, 2,
	2, 1, 2, 2, 1, 1,    2, 1, 2, 1, 1, 2,
	2, 1, 2, 2, 1, 2,    1, 2, 1, 2, 1, 2,
	1, 2, 1, 2, 1, 2,    5, 2, 1, 2, 1, 2,
	1, 1, 2, 1, 2, 2,    1, 2, 2, 1, 2, 1,
	2, 1, 1, 2, 1, 2,    1, 2, 2, 2, 1, 2,
	1, 2, 1, 1, 5, 2,    1, 2, 1, 2, 2, 2,
	1, 2, 1, 1, 2, 1,    1, 2, 2, 1, 2, 2,
	2, 1, 2, 1, 1, 2,    1, 1, 2, 1, 2, 2,
	2, 1, 6, 1, 1, 2,    1, 1, 2, 1, 2, 2,
	
	/* 1861 */    
	1, 2, 2, 1, 2, 1,    2, 1, 2, 1, 1, 2,
	2, 1, 2, 1, 2, 2,    1, 2, 2, 3, 1, 2,
	1, 2, 2, 1, 2, 1,    2, 2, 1, 2, 1, 2,
	1, 1, 2, 1, 2, 1,    2, 2, 1, 2, 2, 1,
	2, 1, 1, 2, 4, 1,    2, 2, 1, 2, 2, 1,
	2, 1, 1, 2, 1, 1,    2, 2, 1, 2, 2, 2,
	1, 2, 1, 1, 2, 1,    1, 2, 1, 2, 2, 2,
	1, 2, 2, 3, 2, 1,    1, 2, 1, 2, 2, 1,
	2, 2, 2, 1, 1, 2,    1, 1, 2, 1, 2, 1,
	2, 2, 2, 1, 2, 1,    2, 1, 1, 5, 2, 1,
	
	/* 1871 */    
	2, 2, 1, 2, 2, 1,    2, 1, 2, 1, 1, 2,
	1, 2, 1, 2, 2, 1,    2, 1, 2, 2, 1, 2,
	1, 1, 2, 1, 2, 4,    2, 1, 2, 2, 1, 2,
	1, 1, 2, 1, 2, 1,    2, 1, 2, 2, 2, 1,
	2, 1, 1, 2, 1, 1,    2, 1, 2, 2, 2, 1,
	2, 2, 1, 1, 5, 1,    2, 1, 2, 2, 1, 2,
	2, 2, 1, 1, 2, 1,    1, 2, 1, 2, 1, 2,
	2, 2, 1, 2, 1, 2,    1, 1, 2, 1, 2, 1,
	2, 2, 4, 2, 1, 2,    1, 1, 2, 1, 2, 1,
	2, 1, 2, 2, 1, 2,    2, 1, 2, 1, 1, 2,
	
	/* 1881 */    
	1, 2, 1, 2, 1, 2,    5, 2, 2, 1, 2, 1,
	1, 2, 1, 2, 1, 2,    1, 2, 2, 1, 2, 2,
	1, 1, 2, 1, 1, 2,    1, 2, 2, 2, 1, 2,
	2, 1, 1, 2, 3, 2,    1, 2, 2, 1, 2, 2,
	2, 1, 1, 2, 1, 1,    2, 1, 2, 1, 2, 2,
	2, 1, 2, 1, 2, 1,    1, 2, 1, 2, 1, 2,
	2, 2, 1, 5, 2, 1,    1, 2, 1, 2, 1, 2,
	2, 1, 2, 2, 1, 2,    1, 1, 2, 1, 2, 1,
	2, 1, 2, 2, 1, 2,    1, 2, 1, 2, 1, 2,
	1, 5, 2, 1, 2, 2,    1, 2, 1, 2, 1, 2,
	
	/* 1891 */     
	1, 2, 1, 2, 1, 2,    1, 2, 2, 1, 2, 2,
	1, 1, 2, 1, 1, 5,    2, 2, 1, 2, 2, 2,
	1, 1, 2, 1, 1, 2,    1, 2, 1, 2, 2, 2,
	1, 2, 1, 2, 1, 1,    2, 1, 2, 1, 2, 2,
	2, 1, 2, 1, 5, 1,    2, 1, 2, 1, 2, 1,
	2, 2, 2, 1, 2, 1,    1, 2, 1, 2, 1, 2,
	1, 2, 2, 1, 2, 1,    2, 1, 2, 1, 2, 1,
	2, 1, 5, 2, 2, 1,    2, 1, 2, 1, 2, 1,
	2, 1, 2, 1, 2, 1,    2, 2, 1, 2, 1, 2,
	1, 2, 1, 1, 2, 1,    2, 5, 2, 2, 1, 2,
	
	/* 1901 */    
	1, 2, 1, 1, 2, 1,    2, 1, 2, 2, 2, 1,
	2, 1, 2, 1, 1, 2,    1, 2, 1, 2, 2, 2,
	1, 2, 1, 2, 3, 2,    1, 1, 2, 2, 1, 2,
	2, 2, 1, 2, 1, 1,    2, 1, 1, 2, 2, 1,
	2, 2, 1, 2, 2, 1,    1, 2, 1, 2, 1, 2,
	1, 2, 2, 4, 1, 2,    1, 2, 1, 2, 1, 2,
	1, 2, 1, 2, 1, 2,    2, 1, 2, 1, 2, 1,
	2, 1, 1, 2, 2, 1,    2, 1, 2, 2, 1, 2,
	1, 5, 1, 2, 1, 2,    1, 2, 2, 2, 1, 2,
	1, 2, 1, 1, 2, 1,    2, 1, 2, 2, 2, 1,
	
	/* 1911 */    
	2, 1, 2, 1, 1, 5,    1, 2, 2, 1, 2, 2,
	2, 1, 2, 1, 1, 2,    1, 1, 2, 2, 1, 2,
	2, 2, 1, 2, 1, 1,    2, 1, 1, 2, 1, 2,
	2, 2, 1, 2, 5, 1,    2, 1, 2, 1, 1, 2,
	2, 1, 2, 2, 1, 2,    1, 2, 1, 2, 1, 2,
	1, 2, 1, 2, 1, 2,    2, 1, 2, 1, 2, 1,
	2, 3, 2, 1, 2, 2,    1, 2, 2, 1, 2, 1,
	2, 1, 1, 2, 1, 2,    1, 2, 2, 2, 1, 2,
	1, 2, 1, 1, 2, 1,    5, 2, 2, 1, 2, 2,
	1, 2, 1, 1, 2, 1,    1, 2, 2, 1, 2, 2,
	
	/* 1921 */     
	2, 1, 2, 1, 1, 2,    1, 1, 2, 1, 2, 2,
	2, 1, 2, 2, 3, 2,    1, 1, 2, 1, 2, 2,
	1, 2, 2, 1, 2, 1,    2, 1, 2, 1, 1, 2,
	2, 1, 2, 1, 2, 2,    1, 2, 1, 2, 1, 1,
	2, 1, 2, 5, 2, 1,    2, 2, 1, 2, 1, 2,
	1, 1, 2, 1, 2, 1,    2, 2, 1, 2, 2, 1,
	2, 1, 1, 2, 1, 2,    1, 2, 2, 1, 2, 2,
	1, 5, 1, 2, 1, 1,    2, 2, 1, 2, 2, 2,
	1, 2, 1, 1, 2, 1,    1, 2, 1, 2, 2, 2,
	1, 2, 2, 1, 1, 5,    1, 2, 1, 2, 2, 1,
	
	/* 1931 */   
	2, 2, 2, 1, 1, 2,    1, 1, 2, 1, 2, 1,
	2, 2, 2, 1, 2, 1,    2, 1, 1, 2, 1, 2,
	1, 2, 2, 1, 6, 1,    2, 1, 2, 1, 1, 2,
	1, 2, 1, 2, 2, 1,    2, 2, 1, 2, 1, 2,
	1, 1, 2, 1, 2, 1,    2, 2, 1, 2, 2, 1,
	2, 1, 4, 1, 2, 1,    2, 1, 2, 2, 2, 1,
	2, 1, 1, 2, 1, 1,    2, 1, 2, 2, 2, 1,
	2, 2, 1, 1, 2, 1,    4, 1, 2, 2, 1, 2,
	2, 2, 1, 1, 2, 1,    1, 2, 1, 2, 1, 2,
	2, 2, 1, 2, 1, 2,    1, 1, 2, 1, 2, 1,
	
	/* 1941 */    
	2, 2, 1, 2, 2, 4,    1, 1, 2, 1, 2, 1,
	2, 1, 2, 2, 1, 2,    2, 1, 2, 1, 1, 2,
	1, 2, 1, 2, 1, 2,    2, 1, 2, 2, 1, 2,
	1, 1, 2, 4, 1, 2,    1, 2, 2, 1, 2, 2,
	1, 1, 2, 1, 1, 2,    1, 2, 2, 2, 1, 2,
	2, 1, 1, 2, 1, 1,    2, 1, 2, 2, 1, 2,
	2, 5, 1, 2, 1, 1,    2, 1, 2, 1, 2, 2,
	2, 1, 2, 1, 2, 1,    1, 2, 1, 2, 1, 2,
	2, 2, 1, 2, 1, 2,    3, 2, 1, 2, 1, 2,
	2, 1, 2, 2, 1, 2,    1, 1, 2, 1, 2, 1,
	
	/* 1951 */    
	2, 1, 2, 2, 1, 2,    1, 2, 1, 2, 1, 2,
	1, 2, 1, 2, 4, 2,    1, 2, 1, 2, 1, 2,
	1, 2, 1, 1, 2, 2,    1, 2, 2, 1, 2, 2,
	1, 1, 2, 1, 1, 2,    1, 2, 2, 1, 2, 2,
	2, 1, 4, 1, 1, 2,    1, 2, 1, 2, 2, 2,
	1, 2, 1, 2, 1, 1,    2, 1, 2, 1, 2, 2,
	2, 1, 2, 1, 2, 1,    1, 5, 2, 1, 2, 2,
	1, 2, 2, 1, 2, 1,    1, 2, 1, 2, 1, 2,
	1, 2, 2, 1, 2, 1,    2, 1, 2, 1, 2, 1,
	2, 1, 2, 1, 2, 5,    2, 1, 2, 1, 2, 1,
	
	/* 1961 */    
	2, 1, 2, 1, 2, 1,    2, 2, 1, 2, 1, 2,
	1, 2, 1, 1, 2, 1,    2, 2, 1, 2, 2, 1,
	2, 1, 2, 3, 2, 1,    2, 1, 2, 2, 2, 1,
	2, 1, 2, 1, 1, 2,    1, 2, 1, 2, 2, 2,
	1, 2, 1, 2, 1, 1,    2, 1, 1, 2, 2, 1,
	2, 2, 5, 2, 1, 1,    2, 1, 1, 2, 2, 1,
	2, 2, 1, 2, 2, 1,    1, 2, 1, 2, 1, 2,
	1, 2, 2, 1, 2, 1,    5, 2, 1, 2, 1, 2,
	1, 2, 1, 2, 1, 2,    2, 1, 2, 1, 2, 1,
	2, 1, 1, 2, 2, 1,    2, 1, 2, 2, 1, 2,
	
	/* 1971 */    
	1, 2, 1, 1, 5, 2,    1, 2, 2, 2, 1, 2,
	1, 2, 1, 1, 2, 1,    2, 1, 2, 2, 2, 1,
	2, 1, 2, 1, 1, 2,    1, 1, 2, 2, 2, 1,
	2, 2, 1, 5, 1, 2,    1, 1, 2, 2, 1, 2,
	2, 2, 1, 2, 1, 1,    2, 1, 1, 2, 1, 2,
	2, 2, 1, 2, 1, 2,    1, 5, 2, 1, 1, 2,
	2, 1, 2, 2, 1, 2,    1, 2, 1, 2, 1, 1,
	2, 2, 1, 2, 1, 2,    2, 1, 2, 1, 2, 1,
	2, 1, 1, 2, 1, 6,    1, 2, 2, 1, 2, 1,
	2, 1, 1, 2, 1, 2,    1, 2, 2, 1, 2, 2,
	
	/* 1981 */     
	1, 2, 1, 1, 2, 1,    1, 2, 2, 1, 2, 2,
	2, 1, 2, 3, 2, 1,    1, 2, 2, 1, 2, 2,
	2, 1, 2, 1, 1, 2,    1, 1, 2, 1, 2, 2,
	2, 1, 2, 2, 1, 1,    2, 1, 1, 5, 2, 2,
	1, 2, 2, 1, 2, 1,    2, 1, 1, 2, 1, 2,
	1, 2, 2, 1, 2, 2,    1, 2, 1, 2, 1, 1,
	2, 1, 2, 2, 1, 5,    2, 2, 1, 2, 1, 2,
	1, 1, 2, 1, 2, 1,    2, 2, 1, 2, 2, 1,
	2, 1, 1, 2, 1, 2,    1, 2, 2, 1, 2, 2,
	1, 2, 1, 1, 5, 1,    2, 1, 2, 2, 2, 2,
	
	/* 1991 */    
	1, 2, 1, 1, 2, 1,    1, 2, 1, 2, 2, 2,
	1, 2, 2, 1, 1, 2,    1, 1, 2, 1, 2, 2,
	1, 2, 5, 2, 1, 2,    1, 1, 2, 1, 2, 1,
	2, 2, 2, 1, 2, 1,    2, 1, 1, 2, 1, 2,
	1, 2, 2, 1, 2, 2,    1, 5, 2, 1, 1, 2,
	1, 2, 1, 2, 2, 1,    2, 1, 2, 2, 1, 2,
	1, 1, 2, 1, 2, 1,    2, 2, 1, 2, 2, 1,
	2, 1, 1, 2, 3, 2,    2, 1, 2, 2, 2, 1,
	2, 1, 1, 2, 1, 1,    2, 1, 2, 2, 2, 1,
	2, 2, 1, 1, 2, 1,    1, 2, 1, 2, 2, 1,
	
	/* 2001 */    
	2, 2, 2, 3, 2, 1,    1, 2, 1, 2, 1, 2,
	2, 2, 1, 2, 1, 2,    1, 1, 2, 1, 2, 1,
	2, 2, 1, 2, 2, 1,    2, 1, 1, 2, 1, 2,
	1, 5, 2, 2, 1, 2,    1, 2, 1, 2, 1, 2,
	1, 2, 1, 2, 1, 2,    2, 1, 2, 2, 1, 1,
	2, 1, 2, 1, 2, 1,    5, 2, 2, 1, 2, 2,
	1, 1, 2, 1, 1, 2,    1, 2, 2, 2, 1, 2,
	2, 1, 1, 2, 1, 1,    2, 1, 2, 2, 1, 2,
	2, 2, 1, 1, 5, 1,    2, 1, 2, 1, 2, 2,
	2, 1, 2, 1, 2, 1,    1, 2, 1, 2, 1, 2,
	
	/* 2011 */   
	2, 1, 2, 2, 1, 2,    1, 1, 2, 1, 2, 1,
	2, 1, 6, 2, 1, 2,    1, 1, 2, 1, 2, 1,
	2, 1, 2, 2, 1, 2,    1, 2, 1, 2, 1, 2,
	1, 2, 1, 2, 1, 2,    1, 2, 5, 2, 1, 2,
	1, 2, 1, 1, 2, 1,    2, 2, 2, 1, 2, 1,
	2, 1, 2, 1, 1, 2,    1, 2, 2, 1, 2, 2,
	1, 2, 1, 2, 3, 2,    1, 2, 1, 2, 2, 2,
	1, 2, 1, 2, 1, 1,    2, 1, 2, 1, 2, 2,
	2, 1, 2, 1, 2, 1,    1, 2, 1, 2, 1, 2,
	2, 1, 2, 5, 2, 1,    1, 2, 1, 2, 1, 2,
	
	/* 2021 */    
	1, 2, 2, 1, 2, 1,    2, 1, 2, 1, 2, 1,
	2, 1, 2, 1, 2, 2,    1, 2, 1, 2, 1, 2,
	1, 5, 2, 1, 2, 1,    2, 2, 1, 2, 1, 2,
	1, 2, 1, 1, 2, 1,    2, 2, 1, 2, 2, 1,
	2, 1, 2, 1, 1, 5,    2, 1, 2, 2, 2, 1,
	2, 1, 2, 1, 1, 2,    1, 2, 1, 2, 2, 2,
	1, 2, 1, 2, 1, 1,    2, 1, 1, 2, 2, 2,
	1, 2, 2, 1, 5, 1,    2, 1, 1, 2, 2, 1,
	2, 2, 1, 2, 2, 1,    1, 2, 1, 1, 2, 2,
	1, 2, 1, 2, 2, 1,    2, 1, 2, 1, 2, 1,
	
	/* 2031 */   
	2, 1, 5, 2, 1, 2,    2, 1, 2, 1, 2, 1,
	2, 1, 1, 2, 1, 2,    2, 1, 2, 2, 1, 2,
	1, 2, 1, 1, 2, 1,    2, 1, 2, 2, 5, 2,
	1, 2, 1, 1, 2, 1,    2, 1, 2, 2, 2, 1,
	2, 1, 2, 1, 1, 2,    1, 1, 2, 2, 1, 2,
	2, 2, 1, 2, 1, 4,    1, 1, 2, 1, 2, 2,
	2, 2, 1, 2, 1, 1,    2, 1, 1, 2, 1, 2,
	2, 2, 1, 2, 1, 2,    1, 2, 1, 1, 2, 1,
	2, 2, 1, 2, 5, 2,    1, 2, 1, 2, 1, 1,
	2, 1, 2, 2, 1, 2,    2, 1, 2, 1, 2, 1, 
	
	/* 2041 */     
	2, 1, 1, 2, 1, 2,    2, 1, 2, 2, 1, 2,
	1, 5, 1, 2, 1, 2,    1, 2, 2, 2, 1, 2,
	1, 2, 1, 1, 2, 1,    1, 2, 2, 1, 2, 2, 
}; 

typedef struct _lunar_info{
	unsigned short      year_lunar;         // 음력변환후년도(양력과다를수있음)
	unsigned short		year_dangi;         // 당해년도단기
	unsigned char		month;              // 음력변환후달
	unsigned char		day;                // 음력변환후일
	unsigned char		dayofweek;          // 주중요일을숫자로( 0:일, 1:월... 6:토)
	bool                isyoondal;          // 윤달여부0:평달/1:윤달
	char                h_year[5];          // 당해년도갑자표기(한글)
	char                h_day1[3];          // 요일(한글)
	char                h_day2[5];          // 당일갑자표기(한글)
	char                h_ddi[7];           // 당해년도띠표기(한글)
	char                c_year[5];          // 당해년도갑자표기(한자)
	char                c_day1[3];          // 요일(한자)
	char                c_day2[5];          // 당일갑자표기(한자)
} lunar_t;

typedef struct _solar_info{
	unsigned short      year;               // 양력변환후년도(음력과다를수있음)
	unsigned char		month;              // 양력변환후달
	unsigned char		day;                // 양력변환후일
	unsigned char		dayofweek;          // 주중요일을숫자로( 0:일, 1:월... 6:토)
} solar_t;

static const char* _info_gan[10]	= {"갑","을","병","정","무","기","경","신","임","계"};

static const char* _info_gan2[10]	= {"甲","乙","丙","丁","戊","己","庚","辛","壬","癸"};

static const char* _info_gee[12]	= {"자","축","인","묘","진","사","오","미","신","유","술","해"};

static const char* _info_gee2[12]	= {"子","丑","寅","卯","辰","巳","午","米","申","酉","戌","亥"};

static const char* _info_ddi[12]	= {"쥐","소","범","토끼","용","뱀","말","양","원숭이","닭","개","돼지"};

static const char* _info_week[7]	= {"일","월","화","수","목","금","토"};

static const char* _info_week2[7]	= {"日","月","火","水","木","金","土"};

static int _info_month[12]			= {31, 0, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};



static void febdays(int y){
	_info_month[1] = 28;
	
	if(y%4 == 0){
		if(y%100 == 0 && y%400 == 0)
			return;
	} else {
		return;
	}	
	_info_month[1] = 29;
}

BOOL SolarToLunar(int Year, int Month, int Day, lunar_t& lunar){
	if(Year < 1841 || 2043 < Year){
		return FALSE;
	}
	
	if(Month < 1 || 12 < Month)	{
		return FALSE;
	}
	
	febdays(Year);
	
	if(Day < 1 || _info_month[Month-1] < Day){
		return FALSE;
	}
	
	int ly, lm, ld;
	int m1, m2, mm, i, j, w;
	int sy = Year, sm = Month, sd = Day;
	long td, td1, td2;
	int dt[203], k1, k2;
	BOOL Yoon = FALSE;
	
	td1 = 1840 * 365L + 1840/4 - 1840/100 + 1840/400 + 23;
	td2 = (sy-1) * 365L + (sy-1)/4 - (sy-1)/100 + (sy-1)/400 + sd;
	
	for(i=0; i<sm-1; i++)
		td2 += _info_month[i];
	
	td = td2 - td1 + 1;
	
	//1841년 부터 음력 날수를 계산
	for(i=0; i<=sy-1841; i++){
		dt[i] = 0;
		for(j=0; j<12; j++){
			switch( _info_array[i][j]){
				case 1 : mm = 29;
					break;
				case 2 : mm = 30;
					break;
				case 3 : mm = 58;   /* 29+29 */
					break;
                case 4 : mm = 59;   /* 29+30 */
					break;
                case 5 : mm = 59;   /* 30+29 */
					break;
				case 6 : mm = 60;   /* 30+30 */
					break;
			}
			dt[i] += mm;
		}
	}
	ly = 0;     
	
	//1840년 이후의 년도를 계산 - 현재 까지의 일수에서 위에서 계산된 1841년 부터의 매년 음력일수를 빼가면서 년돌를 계산 
	while(1){
		if( td > dt[ly]){
			td -= dt[ly];
			ly++;
		} else {
			break;
		}	
	}
	lm = 0;
	
	while(1){
		if( _info_array[ly][lm] <= 2 ){
			mm = _info_array[ly][lm] + 28;
			if( td > mm ){
				td -= mm;
				lm++;
			} else {
				break;
			}	
		} else {
			switch( _info_array[ly][lm] ){
				case 3 : 
					m1 = 29;
					m2 = 29;
					break;                                
				case 4 : 
					m1 = 29;
					m2 = 30;
					break;
				case 5 : 
					m1 = 30;
					m2 = 29;
					break;
				case 6 : 
					m1 = 30;
					m2 = 30;
					break;
			}
			
			if( td > m1 ){
				td -= m1;
				if( td > m2 ){
					td -= m2;
					lm++;
				} else {
					//윤달일 경우 처리.
					Yoon = TRUE;
					break;
				}
			} else {
				break;
			}	
		}
	}
	
	ly += 1841;
	lm += 1;
	ld = (Year%400==0 || Year%100!=0 || Year%4==0) ? td : td -1;
	w = td2 % 7;
	i = (td2+4) % 10;
	j = (td2+2) % 12;
	k1 = (ly+6) % 10;
	k2 = (ly+8) % 12;
	
	lunar.day = ld;
	strcpy(lunar.h_ddi, _info_ddi[k2]);
	
	strcpy(lunar.h_day1, _info_week[w]);
	
	strcpy(lunar.h_day2, _info_gan[i]);
	strcat(lunar.h_day2, _info_gee[j]);
	
	strcpy(lunar.h_year, _info_gan[k1]);
	strcat(lunar.h_year, _info_gee[k2]);
	
	strcpy(lunar.c_day1, _info_week2[w]);
	
	strcpy(lunar.c_day2, _info_gan2[i]);
	strcat(lunar.c_day2, _info_gee2[j]);
	
	strcpy(lunar.c_year, _info_gan2[k1]);
	strcat(lunar.c_year, _info_gee2[k2]);
	
	lunar.isyoondal = Yoon ? true : false;
	lunar.month = lm;
	lunar.year_dangi = sy+2333;
	lunar.year_lunar = ly;
	lunar.dayofweek = w;
	
	return TRUE;
}

BOOL LunarToSolar(int Year, int Month, int Day, BOOL Leaf, solar_t& solar){
	if(Year < 1841 || 2043 < Year)
	{
//		cerr << "이프로그램은1841 ~ 2043 까지만지원합니다." << endl;
		return FALSE;
	}
	
	if(Month < 1 || 12 < Month)
	{
//		cerr << "1 ~ 12 사이값을입력하세요." << endl;
		return FALSE;
	}
	
	int lyear, lmonth, lday, leapyes;
	int syear, smonth, sday;
	int mm, y1, y2, m1;
	int i, j, k1, k2, leap, w;
	long td, y;
	lyear = Year;
	lmonth = Month;
	y1 = lyear - 1841;
	m1 = lmonth - 1;
	leapyes = 0;
	if( _info_array[y1][m1] > 2)
		leapyes = Leaf;
	
	if( leapyes == 1){
		switch( _info_array[y1][m1] ){
			case 3 :
			case 5 :
				mm = 29;
				break;
			case 4 :
			case 6 :
				mm = 30;
				break;
		}
	} else {
		switch( _info_array[y1][m1] ){
			case 1 :
			case 3 :
			case 4 :
				mm = 29;
				break;
			case 2 :
			case 5 :
			case 6 :
				mm = 30;
				break;
		}
	}
	
	if(Day < 1 || mm < Day) {
//		cerr << "1 ~ " << mm << " 사이값을입력하세요." << endl;
		return FALSE;
	}
	
	lday = Day;
	td = 0;
	for(i=0; i<y1; i++) {
		for(j=0; j<12; j++)	{
			switch( _info_array[i][j]) {
				case 1 :
					td += 29;
					break;
				case 2 :
					td += 30;
					break;
				case 3 :
					td += 58;   // 29+29
					break;
				case 4 :
					td += 59;   // 29+30
					break;
				case 5 :
					td += 59;   // 30+29
					break;
				case 6 :
					td += 60;   // 30+30
					break;
			}
		}
	}
	
	for (j=0; j<m1; j++) {
		switch( _info_array[y1][j] ) {
			case 1 :
				td +=29;
				break;
			case 2 :
				td += 30;
				break;
			case 3 :
				td += 58;   // 29+29
				break;
			case 4 :
				td += 59;   // 29+30
				break;
			case 5 :
				td += 59;   // 30+29
				break;
			case 6 :
				td += 60;   // 30+30
				break;
		}
	}
	
	if( leapyes == 1 ) {
		switch( _info_array[y1][m1] ) {
			case 3 :
			case 4 :
				td += 29;
				break;
			case 5 :
			case 6 :
				td += 30;
				break;
		}
	}
	td += lday + 22;
	// td : 1841년1월1일부터원하는날까지의전체날수의합
	
	y1 = 1840;
	do {
		y1++;
		leap = (y1 % 400 == 0) || (y1 % 100 != 0) && (y1 % 4 ==0);
		if(leap)
			y2 = 366;
		else    
			y2 = 365;
		if(td <= y2)
			break;
		td -= y2;
	} while(1);
	
	syear = y1;
	_info_month[1] = y2 - 337;
	m1 = 0;
	do {
		m1++;
		if( td <= _info_month[m1-1] )
			break;
		td -= _info_month[m1-1];
	} while(1);
	
	smonth = m1;
	sday = td;
	y = syear - 1;
	td = y * 365L + y/4 - y/100 + y/400;
	for(i=0; i<smonth-1; i++) td += _info_month[i];
	td += sday;
	w = td % 7;
	
	i = (td + 4) % 10;
	j = (td + 2) % 12;
	k1 = (lyear + 6) % 10;
	k2 = (lyear + 8) % 12;
	
	solar.year = syear;
	solar.month = smonth;
	solar.day = sday;
	solar.dayofweek = w;
	
	return TRUE;
}


- (NSString *)dateToString:(NSString *)format{
	NSString *dateFmt = format;
	if (dateFmt == nil ||  [dateFmt isEqualToString:@""]== YES)
		dateFmt = @"yyyyMMddHHmmss";
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:dateFmt];
	
	NSString *stringFromDate = [dateFormatter stringFromDate:self];
	
	return stringFromDate;
}


- (NSString *)dateToString:(NSString *)format localeIdentifier:(NSString *)localeIdentifier{
	NSString *dateFmt = format;
	if (dateFmt == nil ||  [dateFmt isEqualToString:@""]== YES)
		dateFmt = @"yyyyMMddHHmmss";
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:dateFmt];

	if (localeIdentifier && [localeIdentifier isEqualToString:@""]==NO) {
		[dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:localeIdentifier] ];
	}
	
	
	NSString *stringFromDate = [dateFormatter stringFromDate:self];
	
	return stringFromDate;
}


- (NSInteger)year{
	unsigned unitFlags = NSYearCalendarUnit;
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comps = [gregorian components:unitFlags fromDate:self];
	
	return [comps year];
}


- (NSInteger)month{
	unsigned unitFlags = NSMonthCalendarUnit;
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comps = [gregorian components:unitFlags fromDate:self];
	
	return [comps month];
}


- (NSInteger)day{
	unsigned unitFlags = NSDayCalendarUnit;
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comps = [gregorian components:unitFlags fromDate:self];
	
	return [comps day];
}


- (NSInteger)hour{
	unsigned unitFlags = NSHourCalendarUnit;
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comps = [gregorian components:unitFlags fromDate:self];
	
	if ([comps hour] == 12 || [comps hour] == 24){
		return 12;
	} else {
		div_t divHour = div([comps hour],  12);
		return divHour.rem;
	}
}


- (NSInteger)hour24{
	unsigned unitFlags = NSHourCalendarUnit;
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comps = [gregorian components:unitFlags fromDate:self];
	
	return [comps hour];
}


- (NSInteger)minute{
	unsigned unitFlags = NSMinuteCalendarUnit;
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comps = [gregorian components:unitFlags fromDate:self];
	
	return [comps minute];
}


- (NSInteger)quarter{
	unsigned unitFlags = NSQuarterCalendarUnit;
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comps = [gregorian components:unitFlags fromDate:self];
	
	return [comps quarter];
}


- (NSInteger)second{
	unsigned unitFlags = NSSecondCalendarUnit;
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comps = [gregorian components:unitFlags fromDate:self];
	
	return [comps second];
}


- (NSDate *)addYear:(NSInteger)years{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
	[offsetComponents setYear:years];
	return [gregorian dateByAddingComponents:offsetComponents toDate:self options:0];
}


- (NSDate *)addMonth:(NSInteger)months{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
	[offsetComponents setMonth:months];
	return [gregorian dateByAddingComponents:offsetComponents toDate:self options:0];
}


- (NSDate *)addDay:(NSInteger)days{
	return [self dateByAddingTimeInterval:86400 * days];
}


- (NSDate *)addHours:(NSInteger)hours{
	return [self dateByAddingTimeInterval:3600 * hours];
}


- (NSDate *)firstDayOfMonth{
	NSInteger day = [self day];
	return [self addDay:(-1 * (day -1))];
}


- (NSDate *)lastDayOfMonth{
	return [[[self firstDayOfMonth] addMonth:1]addDay:-1];
	
}


- (NSInteger)dayOfWeek{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *weekdayComps = [gregorian components:NSWeekdayCalendarUnit fromDate:self];
	return [weekdayComps weekday];
}


- (NSString *)lunarDateToStringMMdd:(NSString *)seperate{
	lunar_t lunar;
	
	if (seperate == nil) {
		seperate = @"-";
	}
	
	if (SolarToLunar([self year], [self month], [self day], lunar)){
		return [NSString stringWithFormat:@"%02d%@%02d", (int)lunar.month, seperate, (int)lunar.day];
	} else {
		return nil;
	}
}


- (NSString *)lunarDateToString:(NSString *)seperate{
	lunar_t lunar;

	if (seperate == nil) {
		seperate = @"-";
	}
	
	if (SolarToLunar([self year], [self month], [self day], lunar)){
		return [NSString stringWithFormat:@"%d%@%02d%@%02d", (int)lunar.year_lunar, seperate, (int)lunar.month, seperate, (int)lunar.day];
	} else {
		return nil;
	}
}


- (NSInteger)lunarDateYear{
	lunar_t lunar;
	if (SolarToLunar([self year], [self month], [self day], lunar)){
		return (int)lunar.year_lunar;	
	} else {
		return 0;
	}
}


- (NSInteger)lunarDateMonth{
	lunar_t lunar;
	if (SolarToLunar([self year], [self month], [self day], lunar)){
		return (int)lunar.month;
	} else {
		return 0;
	}
}


- (NSInteger)lunarDateDay{
	lunar_t lunar;
	if (SolarToLunar([self year], [self month], [self day], lunar)){
		return (int)lunar.day;	
	} else {
		return 0;
	}
}	


- (NSDate *)setDateYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day{
	return [[[[NSDate dateWithTimeIntervalSince1970:0] addYear:(year-1970)] addMonth:(month-1)] addDay:(day - 1)];
}


- (BOOL)isEarlierThan:(NSDate *)date{
	NSComparisonResult compareResult =  [self compare:date];
	switch (compareResult) {
		case  NSOrderedSame:
			return NO;
			break;
		case  NSOrderedDescending:
			return NO;
			break;
			
		case  NSOrderedAscending:
			return YES;
			break;
	}
	return NO;
}


- (BOOL)isLaterThan:(NSDate *)date{
	NSComparisonResult compareResult =  [self compare:date];
	switch (compareResult) {
		case  NSOrderedSame:
			return NO;
			break;
		case  NSOrderedDescending:
			return YES;
			break;
			
		case  NSOrderedAscending:
			return NO;
			break;
	}
	return NO;
}


- (NSString *)koreanDayName {
	NSInteger iDayOfWeek = [self dayOfWeek];
	
	return [NSString stringWithCString:_info_week[iDayOfWeek - 1] encoding:NSUTF8StringEncoding];
}


@end