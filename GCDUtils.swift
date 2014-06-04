//
//  GCDUtils.swift
//  pingudp
//
//  Created by Sébastien Orban on 3/06/14.
//  Copyright (c) 2014 Random Mechanicals. All rights reserved.
//

import Foundation

func startTimerAt(beginningTime: dispatch_time_t, repeatTime:dispatch_time_t, queue:dispatch_queue_t, job:()->()) ->  dispatch_source_t
{
    var _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));
    dispatch_source_set_timer(_timer, beginningTime, repeatTime, 0);
    dispatch_source_set_event_handler(_timer, {
        job();
        });
    dispatch_resume(_timer);
    return _timer;
}

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
        timer = startTimerAt(beginningTime, repeatTime, queue, task)
        state = true;
    }
    
    deinit {
        dispatch_source_cancel(timer)
    }
}
