#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

NSString *const ISDefaultCalendarTitle = @"Reminder";

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        if (argc < 2) {
            printf("usage: remind [calendar] \"title of task\"");
            return 1;
        }
        
        NSInteger bodyIndex = 1;
        NSString *calendarTitle = ISDefaultCalendarTitle;
        
        if (argc > 2) {
            bodyIndex = 2;
            calendarTitle = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
        }
        
        EKEventStore *store = [[EKEventStore alloc] initWithAccessToEntityTypes:EKEntityMaskReminder];
        EKReminder *reminder = [EKReminder reminderWithEventStore:store];

        reminder.title = [NSString stringWithCString:argv[bodyIndex] encoding:NSUTF8StringEncoding];
        
        for (EKCalendar *calendar in [store calendarsForEntityType:EKEntityTypeReminder]) {
            if ([calendar.title caseInsensitiveCompare:calendarTitle] == NSOrderedSame) {
                reminder.calendar = calendar;
                break;
            }
        }
        if (!reminder.calendar) {
            NSLog(@"could not find specified calendar \"%@\".", ISDefaultCalendarTitle);
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

