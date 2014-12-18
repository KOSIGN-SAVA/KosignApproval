//
//  IPAddress.h
//
//  Created by donghwan kim on 10. 5. 27..
//  Copyright 2010 webcash. All rights reserved.
//

#define MAXADDRS	32

extern char *if_names[MAXADDRS];
extern char *ip_names[MAXADDRS];
extern char *hw_addrs[MAXADDRS];
extern unsigned long ip_addrs[MAXADDRS];


void InitAddresses();
void FreeAddresses();
void GetIPAddresses();
void GetHWAddresses();
