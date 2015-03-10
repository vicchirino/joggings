#import "CalendarView.h"
#import "PureLayout.h"
#import "UIColor+FlatColors.h"

#define kCellWidth self.bounds.size.width/7.7 //41 para iPhone 5
#define kDistanceToWeekDays self.bounds.size.width/10
#define kLeftMargin 15
#define kLightGrayColor [UIColor whiteColor]
#define kRangeDate [UIColor flatPeterRiverColor]
#define kGrayColorDays [UIColor colorWithRed:150.0/255.0 green:150/255.0 blue:150/255.0 alpha:1]
#define kSelectedDate [UIColor flatBelizeHoleColor]

@interface CalendarView()

{
    
    NSCalendar *gregorian;
    NSInteger _selectedMonth;
    NSInteger _selectedYear;
    UILabel *titleText;
    UIView *titleBackgroundView;
    NSMutableArray *datesSelected;
    BOOL manyDates;
    NSRange days;
    UIButton *button;
    NSDateComponents *todayComponents;
    UILabel *textLabel;
}

@end
@implementation CalendarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        datesSelected = [NSMutableArray new];
        self.endDate = nil;
        self.startDate = nil;
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    
    [self setCalendarParameters];
    _weekNames = @[@"M",@"T",@"W",@"T",@"F",@"S",@"S"];
    NSDateComponents *components = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.calendarDate];
    components.day = 1;
    NSDate *firstDayOfMonth = [gregorian dateFromComponents:components];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:firstDayOfMonth];
    NSInteger weekday = [comps weekday];
    weekday  = weekday - 2;
    
    todayComponents = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay ) fromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    
    if(weekday < 0)
        weekday += 7;
    
    NSCalendar *c = [NSCalendar currentCalendar];
    days = [c rangeOfUnit:NSCalendarUnitDay
                           inUnit:NSCalendarUnitMonth
                          forDate:self.calendarDate];
    
    NSInteger columns = 7;
    NSInteger monthLength = days.length;
    
    UIView *clearView = [UIView new];
    clearView.backgroundColor = [UIColor clearColor];
    [self addSubview:clearView];
    
    [clearView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [clearView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [clearView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [clearView autoSetDimension:ALDimensionHeight toSize:48];
    
    titleBackgroundView = [UIView new];
    titleBackgroundView.backgroundColor = [UIColor flatMidnightBlueColor];
    titleBackgroundView.alpha = 0.6;
    [clearView addSubview:titleBackgroundView];
    
    [titleBackgroundView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [titleBackgroundView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [titleBackgroundView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [titleBackgroundView autoSetDimension:ALDimensionHeight toSize:48];
    
    UIButton *rightArrow = [UIButton new];
    [rightArrow setImage:[UIImage imageNamed:@"rightarrow"] forState:UIControlStateNormal];
    [rightArrow addTarget:self action:@selector(swipeleft:) forControlEvents:UIControlEventTouchUpInside];
    [clearView addSubview:rightArrow];
    
    [rightArrow autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [rightArrow autoAlignAxis:ALAxisHorizontal toSameAxisOfView:titleBackgroundView];
    [rightArrow autoSetDimensionsToSize:CGSizeMake(40, 40)];
    
    UIButton *leftArrow = [UIButton new];
    [leftArrow setImage:[UIImage imageNamed:@"leftarrow"] forState:UIControlStateNormal];
    [leftArrow addTarget:self action:@selector(swiperight:) forControlEvents:UIControlEventTouchUpInside];
    [clearView addSubview:leftArrow];
    
    [leftArrow autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [leftArrow autoAlignAxis:ALAxisHorizontal toSameAxisOfView:titleBackgroundView];
    [leftArrow autoSetDimensionsToSize:CGSizeMake(40, 40)];
    
    titleText = [UILabel new];
    titleText.textAlignment = NSTextAlignmentCenter;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMMM yyyy"];
    NSString *dateString = [[format stringFromDate:self.calendarDate] capitalizedString];
    [titleText setText:dateString];
    [titleText setFont:[UIFont fontWithName:@"OpenSans" size:16.0f]];
    [titleText sizeToFit];
    [titleText setTextColor:[UIColor whiteColor]];
    [clearView addSubview:titleText];
//
//    textLabel = [UILabel new];
//    textLabel.text = @"";
//    textLabel.textAlignment = NSTextAlignmentCenter;
//    textLabel.textColor = [UIColor grayColor];
//    textLabel.numberOfLines = 2;
//    [textLabel setFont:[UIFont fontWithName:@"OpenSans" size:12]];
//
//
//    [self addSubview:textLabel];

    
    //constraints
    
    [titleText autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [titleText autoAlignAxis:ALAxisHorizontal toSameAxisOfView:titleBackgroundView];
    [titleText autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self];
    [titleText autoAlignAxis:ALAxisVertical toSameAxisOfView:titleBackgroundView];


    
    for (int i =0; i<_weekNames.count; i++) {
        UIButton *weekNameLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        weekNameLabel.titleLabel.text = [_weekNames objectAtIndex:i];
        [weekNameLabel setTitle:[_weekNames objectAtIndex:i] forState:UIControlStateNormal];
        [weekNameLabel setTitleColor:kGrayColorDays forState:UIControlStateNormal];
        [weekNameLabel.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:14.0f]];
        weekNameLabel.userInteractionEnabled = NO;
        [self addSubview:weekNameLabel];
        
        [weekNameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kLeftMargin+kCellWidth*(i%columns)];
        [weekNameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:titleBackgroundView withOffset:0];
        [weekNameLabel autoSetDimensionsToSize:CGSizeMake(kCellWidth, kCellWidth)];
    }
    

    for (NSInteger i= 0; i<monthLength; i++)
    {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        
        NSDateComponents *todayDate = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
        
        if (((todayDate.day > i+1) && (todayDate.month >= components.month)) || todayDate.month > components.month){
            button.userInteractionEnabled = YES;
        }
        
        if (todayDate.day == i && todayDate.month == components.month){
            button.userInteractionEnabled = YES;
        }
        
        
        button.tag = i+1;
        button.titleLabel.text = [NSString stringWithFormat:@"%ld",i+1];
        [button setTitle:[NSString stringWithFormat:@"%ld",i+1] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:14.0f]];
//        button.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1];
        button.backgroundColor = [UIColor whiteColor];
        [button addTarget:self action:@selector(tappedDate:) forControlEvents:UIControlEventTouchUpInside];
        NSInteger offsetX = (kCellWidth*((i+weekday)%columns));
        NSInteger offsetY = (kCellWidth *((i+weekday)/columns));
        [button.layer setBorderColor:[[UIColor clearColor] CGColor]];
        [button.layer setBorderWidth:1.5];
        button.layer.cornerRadius = 20.0;
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor whiteColor];

        if(i+1 == [todayComponents day] && components.month == [todayComponents month] && components.year == [todayComponents year]) {
            [button setBackgroundColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1]];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:14.0f]];
        }
        
        [self addSubview:button];
        
        [button autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kLeftMargin+offsetX];
        [button autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:titleBackgroundView withOffset:kDistanceToWeekDays+offsetY];
        [button autoSetDimensionsToSize:CGSizeMake(kCellWidth, kCellWidth)];
    }
    
    //Accept Button
//
//    [textLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:button];
//    [textLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self];
//    [textLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self];
//    [textLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:self];
//    [textLabel autoSetDimension:ALDimensionHeight toSize:35];


    UIButton *acceptButton = [UIButton new];
    acceptButton.backgroundColor = [UIColor flatSilverColor];
    acceptButton.layer.cornerRadius = 5.0;
    acceptButton.layer.borderWidth = 1.5f;
    acceptButton.layer.borderColor = [UIColor clearColor].CGColor;
    [acceptButton setTitle:@"Filter" forState:UIControlStateNormal];
    [acceptButton addTarget:self action:@selector(tapAccept) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:acceptButton];

    [acceptButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    [acceptButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:button withOffset:0];
    [acceptButton autoSetDimensionsToSize:CGSizeMake(110, 40)];
    [self bringSubviewToFront:acceptButton];
    
    //Delete Dates
    
    UIButton *deleteDatesButton = [UIButton new];
    deleteDatesButton.backgroundColor = [UIColor flatAsbestosColor];
    [deleteDatesButton addTarget:self action:@selector(tapDeleteDates) forControlEvents:UIControlEventTouchUpInside];
    deleteDatesButton.layer.cornerRadius = 5.0;
    deleteDatesButton.layer.borderWidth = 1.5;
    deleteDatesButton.layer.borderColor = [UIColor clearColor].CGColor;
    [deleteDatesButton setTitle:@"Delete dates" forState:UIControlStateNormal];
    [self addSubview:deleteDatesButton];
    
    [deleteDatesButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
    [deleteDatesButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:acceptButton];
    [deleteDatesButton autoSetDimensionsToSize:CGSizeMake(110, 40)];

    [self bringSubviewToFront:deleteDatesButton];
    
    
    NSDateComponents *previousMonthComponents = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.calendarDate];
    previousMonthComponents.month -=1;
    
//    NSDate *previousMonthDate = [gregorian dateFromComponents:previousMonthComponents];
//    NSRange previousMonthDays = [c rangeOfUnit:NSCalendarUnitDay
//                   inUnit:NSCalendarUnitMonth
//                  forDate:previousMonthDate];
//    NSInteger maxDate = previousMonthDays.length - weekday;
    
    if (self.startDate && self.endDate){
        [self paintButtonsBetween:self.startDate and:self.endDate];
    }

}
-(IBAction)tappedDate:(UIButton *)sender
{
    gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.calendarDate];
    
    if(!(_selectedDate == sender.tag && _selectedMonth == [components month] && _selectedYear == [components year])) {
        
        [self paintCalendarAsDefaultWithComponents:components];
       
        NSDateComponents *touchComponents = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.calendarDate];
        touchComponents.day = sender.tag;
        NSDate *date = [gregorian dateFromComponents:touchComponents];
        
        if (!self.endDate && !self.startDate){
            self.endDate = date;
            self.startDate = date;
        }
        
        if ([date compare:self.startDate] == NSOrderedAscending){
            self.startDate = date;
        } else if ([date compare:self.endDate] == NSOrderedDescending){
            self.endDate = date;
        } else if ([date isEqualToDate:self.startDate] || [date isEqualToDate:self.endDate]){
            self.startDate = date;
            self.endDate = date;
        }
        
        NSTimeInterval startDateTimeStamp = [self.startDate timeIntervalSince1970];
        NSTimeInterval endDateTimeStamp = [self.endDate timeIntervalSince1970];
        NSTimeInterval dateTimeStamp = [date timeIntervalSince1970];
        
        if (abs (dateTimeStamp - startDateTimeStamp) <= (abs(dateTimeStamp - endDateTimeStamp))){
            self.startDate = date;
        }   else {
            self.endDate = date;
        }
        
        
        _selectedDate = sender.tag;
        
        [self paintButtonsBetween:self.startDate and:self.endDate];
        
        NSDateComponents *components = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.calendarDate];
        components.day = _selectedDate;
        _selectedMonth = components.month;
        _selectedYear = components.year;
    }
    else {
        self.startDate = [gregorian dateFromComponents:components];
        self.endDate = [gregorian dateFromComponents:components];
        [self paintButtonsBetween:self.startDate and:self.endDate];
    }
    
    [self.delegate tapFromDate:self.startDate toDate:self.endDate];
}

-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSDateComponents *components = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.calendarDate];
    components.day = 1;
    components.month += 1;
    self.calendarDate = [gregorian dateFromComponents:components];
    
    [UIView animateWithDuration:.5f
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self setNeedsDisplay];
                     }
                     completion:nil];
    
    
}

-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{

    NSDateComponents *components = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.calendarDate];
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        components.day = 1;
        components.month -= 1;
        self.calendarDate = [gregorian dateFromComponents:components];
        
        [UIView animateWithDuration:.5f
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self setNeedsDisplay];
                         }
                         completion:nil];

}
-(void)setCalendarParameters
{
    if(gregorian == nil)
    {
        self.calendarDate = [NSDate date];
        gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.calendarDate];
        _selectedDate  = components.day;
        _selectedMonth = components.month;
        _selectedYear = components.year;
    }
}

- (NSDate*) saveDateWithTag:(NSInteger) tag andComponent: (NSDateComponents*) components{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:tag];
    [comps setMonth:[components month]];
    [comps setYear:[components year]];
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
    
}

- (void) paintButtonsBetween:(NSDate *) minDate and: (NSDate *) maxDate{
    
    gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.calendarDate];
    components.day = _selectedDate;
    
    NSDateComponents *startComponent = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:minDate];
    NSDateComponents *endComponent = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:maxDate];
    if (components == startComponent){
        UIButton *previousSelected =(UIButton *) [self viewWithTag:[startComponent day]];
        [previousSelected setBackgroundColor:kSelectedDate];
        [previousSelected setTitleColor:[UIColor flatCloudsColor] forState:UIControlStateNormal];
    }
    
    if ([startComponent month] > [components month] && ([startComponent year] == [components year] || [startComponent year] > [components year])){
//        return;
    }
    
    if ([startComponent month] == [endComponent month] && [components month] == [startComponent month]){
        for (NSInteger i = [startComponent day]; i < [endComponent day]; i++){
            UIButton *previousSelected =(UIButton *) [self viewWithTag:i];
            [previousSelected setBackgroundColor:kRangeDate];
            [previousSelected setTitleColor:[UIColor flatCloudsColor] forState:UIControlStateNormal];
        }
        
        UIButton *previousSelected =(UIButton *) [self viewWithTag:[startComponent day]];
        [previousSelected setBackgroundColor:kSelectedDate];
        [previousSelected setTitleColor:[UIColor flatCloudsColor] forState:UIControlStateNormal];
        
        UIButton *endButton =(UIButton *) [self viewWithTag:[endComponent day]];
        [endButton setBackgroundColor:kSelectedDate];
        [endButton setTitleColor:[UIColor flatCloudsColor] forState:UIControlStateNormal];
        
    } else {
        
        if ([startComponent month] < [components month] && [endComponent month] == [components month] && [endComponent year] == [components year]){
            for (NSInteger i = [endComponent day]; i >= 1; i--){
                UIButton *previousSelected =(UIButton *) [self viewWithTag:i];
                [previousSelected setBackgroundColor:kRangeDate];
                [previousSelected setTitleColor:[UIColor flatCloudsColor] forState:UIControlStateNormal];
            }
            UIButton *previousSelected =(UIButton *) [self viewWithTag:[endComponent day]];
            [previousSelected setBackgroundColor:kSelectedDate];
            [previousSelected setTitleColor:[UIColor flatCloudsColor] forState:UIControlStateNormal];
        }
        
        
        //FIX-ME chequeo año (si vas un año antes/despues de lo seleccionado tambien te lo marca)
        if ([endComponent month] > [components month] && [startComponent month] < [components month]){
            for (int i = 1; i <= days.length; i++){
                UIButton *previousSelected =(UIButton *) [self viewWithTag:i];
                [previousSelected setBackgroundColor:kRangeDate];
                [previousSelected setTitleColor:[UIColor flatCloudsColor] forState:UIControlStateNormal];
            }
            return;
        }
        
        if ([endComponent month] > [components month] && [endComponent year] == [components year]){
            for (NSInteger i = [startComponent day]; i <= days.length; i++){
                UIButton *previousSelected =(UIButton *) [self viewWithTag:i];
                [previousSelected setBackgroundColor:kRangeDate];
                [previousSelected setTitleColor:[UIColor flatCloudsColor] forState:UIControlStateNormal];
            }
            UIButton *previousSelected =(UIButton *) [self viewWithTag:[startComponent day]];
            [previousSelected setBackgroundColor:kSelectedDate];
            [previousSelected setTitleColor:[UIColor flatCloudsColor] forState:UIControlStateNormal];
        }
    }
}

- (void) paintCalendarAsDefaultWithComponents: (NSDateComponents*) components {
    UIButton *previousSelected;
    for (int i = 1; i <= days.length; i++){
        previousSelected = (UIButton *) [self viewWithTag:i];

        [previousSelected setBackgroundColor:kLightGrayColor];
        [previousSelected setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

//        NSDateComponents *todayDate = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
//        if ((todayDate.day > i && todayDate.month >= components.month) || todayDate.month > components.month){
//            
//            previousSelected.userInteractionEnabled = NO;
//            
//        }


        
        if(i == [todayComponents day] && components.month == [todayComponents month] && components.year == [todayComponents year]) {
            [previousSelected setBackgroundColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1]];
            [previousSelected.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:14.0f]];
        }
    }
}

- (void) tapAccept {
    NSLog(@"Aceptar");
    [self.delegate didChangeStartDate:self.startDate andEndDate:self.endDate];
}

- (void) tapDeleteDates {
    self.startDate = nil;
    self.endDate = nil;
    [self paintCalendarAsDefaultWithComponents:todayComponents];
    [self.delegate tappedDeleteDates];
}
@end
