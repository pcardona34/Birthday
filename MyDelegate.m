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
### Birthday.app
####################################################
### >>> Renaissance Release <<<
#################################################
### Implementation: MyDelegate.m
####################################################
*/

#import <AppKit/AppKit.h>
#include "MyDelegate.h"

@implementation MyDelegate : NSObject 

- (void) showEventsToday: (id)sender
{
    NSArray *events = [self eventsForToday];
    if ([events count] == 0) {
        [message setText: _(@"Nobody to celebrate today.")];
    }else{
        NSMutableString *str = [NSMutableString string]; 
        [str appendString: _(@"Today, we celebrate:\n")];  
        
    for (NSDictionary *event in events) {
        NSString *name = [event objectForKey:@"name"];
        NSString *type = [event objectForKey:@"type"];
        NSString *localized_type = ( [type isEqualToString: @"bd"] ) ? _(@"birthday") : _(@"feast");
         
        [str appendString:@"\n"];
        [str appendFormat:@"%@ (%@)", name, localized_type];
      } // end of for
          
      [self showMainEvents: str];
  }
}

/* ************************************************************************
* showEventsOfTheMonth
* show a list of available events this month in the Window view object
*/
- (void) showEventsOfTheMonth: (id)sender
{
    NSString *monthNumber = [self getCurrentMonth];
    NSArray *events = [self eventsForMonth: monthNumber];
	       
    if ([events count] == 0) {
        [message setText: _(@"Nobody to celebrate this month.")];
    }else{
        NSMutableString *str = [NSMutableString string]; 
        [str appendString: _(@"This month, we shall celebrate:\n")];  
        
    for (NSDictionary *event in events) {
        NSString *name = [event objectForKey:@"name"];
        NSString *type = [event objectForKey:@"type"];
        NSString *localized_type = ( [type isEqualToString: @"bd"] ) ? _(@"birthday") : _(@"feast");
        NSString *date = [event objectForKey:@"date"];
         
        [str appendString:@"\n"];
        [str appendFormat:@"%@ (%@), %@", name, localized_type, date];
      } // end of for
         
      [self showEvents: str];
  }
}

/* ************************************************************************
* showEventsOfNextMonth
* show a list of available events next month in the Window view object
*/
- (void) showEventsOfNextMonth: (id)sender
{
    NSString *monthNumber = [self getNextMonth];
    NSArray *events = [self eventsForMonth: monthNumber];
	 
    if ([events count] == 0) {
        [message setText: _(@"Nobody to celebrate next month.")];
    }else{
        NSMutableString *str = [NSMutableString string]; 
        [str appendString: _(@"Next month, we shall celebrate:\n")];  
        
    for (NSDictionary *event in events) {
        NSString *name = [event objectForKey:@"name"];
        NSString *type = [event objectForKey:@"type"];
        NSString *localized_type = ( [type isEqualToString: @"bd"] ) ? _(@"birthday") : _(@"feast");
        NSString *date = [event objectForKey:@"date"];
         
        [str appendString:@"\n"];
        [str appendFormat:@"%@ (%@), %@", name, localized_type, date];
      } // end of for    
      
      [self showEvents: str];
      
  }
}

- (void) showEvents: (NSString *) content
{
	 // Loading but not visible yet: see gsmarkup
    [NSBundle loadGSMarkupNamed: @"Window" owner: self];
    // Min Size of the Window
    NSSize minSize = [myWindow minSize];
    	minSize.width = 400;
    	minSize.height = 200;
    	[myWindow setMinSize:minSize];
    	
    [scroll setHasVerticalScroller:YES];
    [scroll setHasHorizontalScroller:NO];
    [scroll setDocumentView:message];
    [message setString: content];
    [message setEditable: NO];
      
    // Centering and displaying
    [myWindow center];
    [myWindow makeKeyAndOrderFront:nil];
}

- (void) showMainEvents: (NSString *) content
{
	//Loading but not visible yet: see gsmarkup
    [NSBundle loadGSMarkupNamed: @"Main-Window" owner: self];
    // Min Size of the Window
    NSSize minSize = [MainWindow minSize];
    	minSize.width = 400;
    	minSize.height = 200;
    	[MainWindow setMinSize:minSize];
    	
    [scroll setHasVerticalScroller:YES];
    [scroll setHasHorizontalScroller:NO];
    [scroll setDocumentView:message];
    [message setString: content];
    [message setEditable: NO];
      
    // Centering and displaying
    [MainWindow center];
    [MainWindow makeKeyAndOrderFront:nil];
}



/* ****************************************************************************
 * eventCountForToday
 * Counts and returns the number of available events
 */
- (NSUInteger)eventCountForToday
{
    NSArray *events = [self eventsForToday];
    return [events count];
}

/* ****************************************************************************
 * eventsForToday
 * Retrieve an array events from a local file 
 * and compares each date to current
 */
- (NSArray *)eventsForToday
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:
                      @"Documents/Private/Birthdays"];
    NSLog(@"Birthday file path: %@", path);
    
    NSError *error = nil;
    NSString *contents = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:&error];
    // NSLog(@"Birthday file contents:\n%@", contents);

    if (contents == nil) {
        NSLog(@"Could not read file: %@", error);
        return nil;
    }

    NSDate *today = [NSDate date];

    NSDateFormatter *dateFormatter =
      [[[NSDateFormatter alloc] init] autorelease];

    [dateFormatter setDateFormat:@"dd/MM"];

    NSString *shortDate = [dateFormatter stringFromDate:today];


    NSArray *lines = [contents componentsSeparatedByCharactersInSet:
                      [NSCharacterSet newlineCharacterSet]];

    NSMutableArray *events = [NSMutableArray array];

    for (NSString *line in lines) {
        // NSLog(@"RAW LINE: %@", line);
        line = [line stringByTrimmingCharactersInSet:
                [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        // Ignore blank lines.
        if ([line length] == 0) {
            // NSLog(@"Skipped blank line");
            continue;
        }
      
        // Ignore comment lines.
        if ([line hasPrefix:@"#"]) {
            // NSLog(@"Skipped comment line: %@", line);
            continue;
        }

        // Separate "Somebody" from "06/10/26 bd # comment".
        NSRange equalsRange = [line rangeOfString:@"="];

        if (equalsRange.location == NSNotFound) {
            continue;
        }

        NSString *name = [line substringToIndex:equalsRange.location];

        NSString *rightSide =
            [line substringFromIndex:equalsRange.location + 1];

        // Remove the optional comment.
        NSRange commentRange = [rightSide rangeOfString:@"#"];

        if (commentRange.location != NSNotFound) {
            rightSide = [rightSide substringToIndex:commentRange.location];
        }

        rightSide = [rightSide stringByTrimmingCharactersInSet:
                     [NSCharacterSet whitespaceCharacterSet]];

        // The first whitespace-separated field is the date.
        NSArray *fields = [rightSide componentsSeparatedByCharactersInSet:
                           [NSCharacterSet whitespaceCharacterSet]];

        NSString *dateField = nil;

        for (NSString *field in fields) {
            if ([field length] > 0) {
                dateField = field;
                break;
            }
        }

        if (dateField == nil) {
            continue;
        }
      
        BOOL matchesToday = NO;

        // Feast: date format is dd/MM.
           if ([dateField isEqualToString:shortDate]) {
             // Feast, for example: 06/10
                          matchesToday = YES;
        }

        // Birthday or other dated event: compare only dd/MM.
        else if ([dateField length] >= 5) {
            // Birthday, by example: 06/10/1987
            NSString *monthAndDay = [dateField substringToIndex:5];

          if ([monthAndDay isEqualToString:shortDate]) {
                           matchesToday = YES;
          }
        }
      
        if (!matchesToday) {
            continue;
        }
      

        NSString *type = @"";
        if ([fields count] > 1) {
            for (NSUInteger i = 1; i < [fields count]; i++) {
                NSString *field = [fields objectAtIndex:i];

                if ([field length] > 0) {
                    type = field;
                    break;
                }
            }
        }
      
        NSDictionary *event =
            [NSDictionary dictionaryWithObjectsAndKeys:
             name, @"name",
             dateField, @"date",
             type, @"type",
             line, @"line",
             nil];
             
      /* 
      NSLog(@"Line: %@ | dateField: %@ | shortDate: %@ | match: %@",
      line,
      dateField,
      shortDate,
      matchesToday ? @"YES" : @"NO");
      */

        [events addObject:event];
    }
    return [events count] > 0 ? events : nil;
}

/* ****************************************************************************
 * Get current month
 */
- (NSString *) getCurrentMonth
{
	NSDate *date = [NSDate date];

    NSDateFormatter *dateFormatter =
      [[[NSDateFormatter alloc] init] autorelease];

    [dateFormatter setDateFormat:@"MM"];

    NSString *monthNumber = [dateFormatter stringFromDate:date];
	
	//NSLog(@"Month Number: %@", monthNumber);
	return monthNumber;
}

/* ****************************************************************************
 * Get next month
 */
- (NSString *) getNextMonth
{
	NSDate *currentDate = [NSDate date];
   NSCalendar *calendar = [NSCalendar currentCalendar];
   NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:currentDate];
   NSInteger nextMonth = (components.month % 12) + 1; // This will give us the next month number (1-12)
   NSString *nextMonthString;
   if (nextMonth < 10) {
   		nextMonthString = [NSString stringWithFormat: @"0%lu", nextMonth];
   	}else{
   		nextMonthString = [NSString stringWithFormat: @"%lu", nextMonth];
   		}
   return nextMonthString;
}

/* ****************************************************************************
 * eventsForMonth
 * Retrieve an array events from a local file 
 * and compares each date to specified month
 */
- (NSArray *)eventsForMonth: (NSString *) monthNumber
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:
                      @"Documents/Private/Birthdays"];
    NSLog(@"Birthday file path: %@", path);
    
    NSError *error = nil;
    NSString *contents = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:&error];
    // NSLog(@"Birthday file contents:\n%@", contents);

    if (contents == nil) {
        NSLog(@"Could not read file: %@", error);
        return nil;
    }

    NSArray *lines = [contents componentsSeparatedByCharactersInSet:
                      [NSCharacterSet newlineCharacterSet]];

    NSMutableArray *events = [NSMutableArray array];

    for (NSString *line in lines) {
        //NSLog(@"RAW LINE: %@", line);
        line = [line stringByTrimmingCharactersInSet:
                [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        // Ignore blank lines.
        if ([line length] == 0) {
            // NSLog(@"Skipped blank line");
            continue;
        }
      
        // Ignore comment lines.
        if ([line hasPrefix:@"#"]) {
            // NSLog(@"Skipped comment line: %@", line);
            continue;
        }

        // Separate "Somebody" from "06/10/26 bd # comment".
        NSRange equalsRange = [line rangeOfString:@"="];

        if (equalsRange.location == NSNotFound) {
            continue;
        }

        NSString *name = [line substringToIndex:equalsRange.location];
        //NSLog(@"Name: %@", name);

        NSString *rightSide =
            [line substringFromIndex:equalsRange.location + 1];
            //NSLog(@"RightSide: %@", rightSide);

        // Remove the optional comment.
        NSRange commentRange = [rightSide rangeOfString:@"#"];

        if (commentRange.location != NSNotFound) {
            rightSide = [rightSide substringToIndex:commentRange.location];
        }

        rightSide = [rightSide stringByTrimmingCharactersInSet:
                     [NSCharacterSet whitespaceCharacterSet]];

        // The first whitespace-separated field is the date.
        NSArray *fields = [rightSide componentsSeparatedByCharactersInSet:
                           [NSCharacterSet whitespaceCharacterSet]];

        NSString *dateField = nil;

        for (NSString *field in fields) {
            if ([field length] > 0) {
                dateField = field;
                //NSLog(@"DateField: %@", dateField);
                break;
            }
        }

        if (dateField == nil) {
            continue;
        }
      
        BOOL matchesThisMonth = NO;

        // Feast: date format is dd/MM. Birthday is dd/MM/aaaa
        //NSLog(@"DateField length: %lu", [dateField length]);
        if([dateField length] == 5) {
           //NSLog(@"Extracted month of dateField: %@", [dateField substringFromIndex: 3]);
           if ([[dateField substringFromIndex: 3] isEqualToString:monthNumber]) {
             // Feast, for example: 06/10
                          matchesThisMonth = YES;
                          //NSLog(@"A feast matches.");
           }
		}
        
        // Birthday or other dated event: compare only MM.
        if ([dateField length] == 10) {
            // Birthday, by example: 06/10/1987
            //NSLog(@"Birthday case: %@", dateField);
            NSString *month = [[dateField substringFromIndex: 3] substringToIndex: 2];
            //NSLog(@"Extracted month of dataField: %@", month);

          if ([month isEqualToString: monthNumber]) {
                           matchesThisMonth = YES;
                           //NSLog(@"A birthday matches.");
          }
        }
      
        if (!matchesThisMonth) {
            continue;
        }
      

        NSString *type = @"";
        if ([fields count] > 1) {
            for (NSUInteger i = 1; i < [fields count]; i++) {
                NSString *field = [fields objectAtIndex:i];

                if ([field length] > 0) {
                    type = field;
                    break;
                }
            }
        }
      
        NSDictionary *event =
            [NSDictionary dictionaryWithObjectsAndKeys:
             name, @"name",
             dateField, @"date",
             type, @"type",
             line, @"line",
             nil];
             
       
      /*
      NSLog(@"Line: %@ | dateField: %@ | monthNumber: %@ | match: %@",
      line,
      dateField,
      monthNumber,
      matchesThisMonth ? @"YES" : @"NO");
      */

        [events addObject:event];
    }
    return [events count] > 0 ? events : nil;
}

/* ****************************************************************************
 * UpdateBadge
 */
- (void) updateBadge
{
  NSUInteger count = [self eventCountForToday];
  NSLog(@"Count: %lu", (unsigned long)count);

  NSString *label = nil;
  if (count > 0) {
    label = (count > 99)
        ? @"99+"
        : [NSString stringWithFormat:@"%lu", (unsigned long)count];
  }
  NSLog(@"Setting dock Badge Label with : %@", label);
  [dockTile setBadgeLabel: label];
  NSLog(@"Got badge label value: %@", [dockTile badgeLabel]);
  [dockTile setShowsApplicationBadge: (count > 0)];
  NSLog(@"Status of showsApplicationBadge: %d", 
    (int)[dockTile showsApplicationBadge]);
  [dockTile display];
}

/* ****************************************************************************
  * Close window
  */

- (void) close : (id) sender 
{
	[myWindow close];
}

/* ****************************************************************************
  * Close app
  */

- (void) terminate : (id) sender 
{
	[NSApp terminate: sender];
}


/* ****************************************************************************
 *
 * Standard method to prepare the UI from the delegate: applicationDidFinishLaunching
 *
 */

- (void)applicationDidFinishLaunching:(NSNotification *)notification 
{
 // Diagnosis for Menu:
 NSLog(@"Main menu: %@", [NSApp mainMenu]);
 NSLog(@"Main menu items: %lu",
      (unsigned long)[[[NSApp mainMenu] itemArray] count]);

 [self showEventsToday: nil];
 // Diagnosis for Active state again
 NSLog(@"Active: %@",
      [NSApp isActive] ? @"YES" : @"NO");
 NSLog(@"Key window: %@", [NSApp keyWindow]);
 NSLog(@"Main window: %@", [NSApp mainWindow]);

 // DockTile was previouly declared in the @interface
 dockTile = [[NSDockTile  alloc] init];
 [dockTile setOwner: NSApp];
 [self updateBadge]; // We retrieve the badge state once at startup

 // Timer to call Update Badge method every 3600 sec. 
 [NSTimer scheduledTimerWithTimeInterval: 3600.0 
                      target: self
                      selector:@selector(updateBadge)
                      userInfo: nil 
                      repeats:YES];
}

- (void) dealloc
{
 [dockTile release];
 [super dealloc];
}


@end
