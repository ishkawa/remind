#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

NSString *const kCalendarTitle = @"Reminder";

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        if (argc < 2) {
            NSLog(@"usage: remind \"title of task\"");
            return 1;
        }
        
        EKEventStore *store = [[EKEventStore alloc] initWithAccessToEntityTypes:EKEntityMaskReminder];
        EKReminder *reminder = [EKReminder reminderWithEventStore:store];
        
        reminder.title = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
        
        for (EKCalendar *calendar in [store calendarsForEntityType:EKEntityTypeReminder]) {
            if ([calendar.title isEqualToString:kCalendarTitle]) {
                reminder.calendar = calendar;
                break;
            }
        }
        if (!reminder.calendar) {
            NSLog(@"could not find specified calendar \"%@\".", kCalendarTitle);
            return 1;
        }
        
        NSError *error = nil;
        if (![store saveReminder:reminder commit:YES error:&error]) {
            NSLog(@"error: %@", error);
            return 1;
        }
    }
    return 0;
}

