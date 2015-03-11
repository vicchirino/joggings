#import <UIKit/UIKit.h>


@protocol CalendarDelegate <NSObject>

@optional
- (void)tapFromDate:(NSDate *)fromDate toDate:(NSDate *) toDate;
- (void)tapedAcceptStartDate:(NSDate *)firstDate andEndDate:(NSDate*) secondDate;
- (void)tappedDeleteDates;
- (void)didChangeStartDate:(NSDate *) startDate andEndDate:(NSDate *) endDate;
@end

@interface CalendarView : UIView
{
    NSInteger _selectedDate;
    NSArray *_weekNames;
}

@property (nonatomic,strong) NSDate *calendarDate;
@property (nonatomic,strong) NSDate *startDate;
@property (nonatomic,strong) NSDate *endDate;
@property (nonatomic,weak) id<CalendarDelegate> delegate;

- (void) paintButtonsBetween:(NSDate *) minDate and: (NSDate *) maxDate;


@end
