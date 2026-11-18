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
### Birthday.app: date and reminder of Birthdays
### and Feasts
####################################################
### >>> Renaissance Release <<<
#################################################
### Header: MyDelegate.h
####################################################
*/


#include <Foundation/Foundation.h>
#include <AppKit/AppKit.h>
#include <Renaissance/Renaissance.h>

@interface MyDelegate : NSObject
{
 IBOutlet NSWindow *myWindow;
 IBOutlet NSScrollView *scroll;
 IBOutlet NSTextView *message;
 IBOutlet NSButton *closer;
 NSDockTile *dockTile;
}

- (void) updateBadge;
- (void) showEvents: (NSString *) content;
- (void) showEventsToday: (id) sender;
- (void) showEventsOfTheMonth: (id) sender;
- (void) showEventsOfNextMonth: (id)sender;
- (NSArray *)eventsForToday;
- (NSArray *)eventsForMonth: (NSString *) monthNumber;
- (NSUInteger)eventCountForToday;
- (NSString *) getNextMonth;
- (NSString *) getCurrentMonth;
- (void) close: (id) sender;
- (void) applicationDidFinishLaunching: (NSNotification *)notification;

@end