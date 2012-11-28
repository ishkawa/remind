#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        if (argc < 2) {
            NSLog(@"usage: remind \"reminder title\"");
            return 1;
        }
        
        EKEventStore *store = [[EKEventStore alloc] initWithAccessToEntityTypes:EKEntityMaskReminder];
        NSArray *calendars = [store calendarsForEntityType:EKEntityTypeReminder];
        
        if (![calendars count]) {
            NSLog(@"could not find any calendar.");
            return 1;
        }
        
        EKReminder *reminder = [EKReminder reminderWithEventStore:store];
        reminder.title = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
        reminder.calendar = [calendars objectAtIndex:0];
        
        NSError *error = nil;
        if (![store saveReminder:reminder commit:YES error:&error]) {
            NSLog(@"error: %@", error);
            return 1;
        }
    }
    return 0;
}

