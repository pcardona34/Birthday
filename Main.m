/* 
####################################################
### A G N o S t e p  -  Desktop - by Patrick Cardona
### (c) 2026 - pcardona34 @ Github
### Author: Patrick Cardona
###
### Thanks for the GNUstep Developers Community.
### This application is a free software.
### Read complete LICENSE.txt in the root directory.
####################################################

####################################################
### Birthday.app: a Family Events Reminder
### for the Agnostep Desktop Project
### Main.m
####################################################
*/

#include <Foundation/Foundation.h>
#include <AppKit/AppKit.h>
#include "MyDelegate.h"

int main ( int argc, const char **argv )
{ 
  
CREATE_AUTORELEASE_POOL (pool);
MyDelegate *delegate;
[NSApplication sharedApplication];

delegate = [MyDelegate new];
[NSApp setDelegate: delegate];

#ifdef GNUSTEP
  [NSBundle loadGSMarkupNamed: @"Menu-GNUstep"  owner: delegate];
#else
  [NSBundle loadGSMarkupNamed: @"Menu-OSX"  owner: delegate];
#endif

RELEASE (pool);
return NSApplicationMain (argc, argv);

}