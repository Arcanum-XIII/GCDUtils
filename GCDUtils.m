//
//  GCDUtils.m
//  beCherry
//
//  Created by Sébastien Orban on 2/05/12.
//  Copyright (c) 2012 Mondial Telecom. All rights reserved.
//

#import "GCDUtils.h"

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

@implementation GCDUtils

+(dispatch_source_t) timerBeginAt:(dispatch_time_t) beginningTime repeatEvery:(dispatch_time_t) repeatTime withQueue:(dispatch_queue_t) queue doing:(void(^)()) job {
    BOOL jobOnce = NO;
    if(repeatTime == 0) {
        repeatTime = 2ull * NSEC_PER_SEC;
        jobOnce = YES;
    }
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));
    dispatch_source_set_timer(_timer, beginningTime, repeatTime, 0);
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(queue, ^{
            if(jobOnce){
                if(_timer)
                    dispatch_suspend(_timer);
            }
            job();
        });
    });
    dispatch_resume(_timer);
    job = nil;
    return _timer;
}

@end

@implementation GCDTimer

-(id) initTimerAt:(dispatch_time_t) beginningTime
      repeatEvery:(dispatch_time_t) repeatTime
        withQueue: (dispatch_queue_t) queue
        doingTask:(void(^)()) task {
    if(self = [super init]) {
        timer = [GCDUtils timerBeginAt:beginningTime repeatEvery:repeatTime withQueue:queue doing:task];
        state = YES;
    }
    return self;
}
-(void) startTimer {
    if(!state) {
        dispatch_resume(timer);
        state = YES;
    }
}
-(void) stopTimer {
    if(state) {
        dispatch_suspend(timer);
        state = NO;
    }
}
-(BOOL) timerState {
    return state;
}

@end