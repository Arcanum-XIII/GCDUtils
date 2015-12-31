//
//  GCDUtils.swift
//
//  Created by Sébastien Orban on 3/06/14.
//  Copyright (c) 2014 Random Mechanicals. All rights reserved.
//

/**
GCD Utils class — various GCD help function, here to simplify and speed the
process of using recurring function. Port of the Objective C class
*/

import Foundation

/**
 Will initialize a simple timer the GCD way.
 Timer is started after being created, and is always put on the DISPATCH_QUEUE_PRIORITY_HIGH
 
 @param beginningTime when to start the timer. With a zero (or now) value, will
 execute immediately the block.
 @param repeatTime when to repeat it. With a value of 0 it will cancel itself to prevent unwanted loop
 @param queue on which queue to execute this timer. Accept serial and concurrent queue, but will always be executed with dispatch_async;
 @param job the block which will be executed
 @return the initialized timer
 */
func startTimerAt(beginningTime: dispatch_time_t, repeatTime:dispatch_time_t, queue:dispatch_queue_t, job:()->()) ->  dispatch_source_t
{
    let _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));
    dispatch_source_set_timer(_timer, beginningTime, repeatTime, 0);
    dispatch_source_set_event_handler(_timer, {
        job();
    });
    dispatch_resume(_timer);
    return _timer;
}

/**
 GCD timer class — added to be easily embedded in collections class. As a general
 rule, to not fall in compromise state, use the method to handle the timer. Some
 behavior with the suspend/resume/cancel state for dispatch source are clearly
 undefined if use manually.
 */
class GCDTimer {
    var timer:dispatch_source_t
    var state:Bool
    
    func startTimer() {
        if(!state) {
            dispatch_resume(timer);
            state = true;
        }
    }
    
    func stopTimer() {
        if(state) {
            dispatch_suspend(timer);
            state = false;
        }
    }
    
    init(beginningTime:dispatch_time_t, repeatTime: dispatch_time_t, queue: dispatch_queue_t, task: () -> ())
    {
        timer = startTimerAt(beginningTime, repeatTime:repeatTime, queue:queue, job:task)
        state = true;
    }
    
    deinit {
        dispatch_source_cancel(timer)
    }
}