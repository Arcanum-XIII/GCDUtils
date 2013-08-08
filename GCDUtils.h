//
//  GCDUtils.h
//  beCherry
//
//  Created by Sébastien Orban on 2/05/12.
//  Copyright (c) 2012 Mondial Telecom. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 GCD Utils class — various GCD help function, here to simplify and speed the
 process of using recurring function.
 */

@interface GCDUtils : NSObject

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
+(dispatch_source_t) timerBeginAt:(dispatch_time_t) beginningTime repeatEvery:(dispatch_time_t) repeatTime withQueue:(dispatch_queue_t) queue doing:(void(^)()) job;

@end


/**
 GCD timer class — added to be easily embedded in collections class. As a general
 rule, to not fall in compromise state, use the method to handle the timer. Some
 behavior with the suspend/resume/cancel state for dispatch source are clearly
 undefine.
 */
@interface GCDTimer : NSObject {
    dispatch_source_t timer;
    BOOL state;
}

/**
 Init the timer and launch the timer.
 
 @param beginningTime when to start the timer. With a zero (or now) value, will
 execute immediately the block.
 @param repeatTime when to repeat it.
 @param queue on which queue to execute this timer. Accept serial and concurrent queue
 @param task the block which will be executed
 @return self
 */
-(id) initTimerAt:(dispatch_time_t) beginningTime
      repeatEvery:(dispatch_time_t) repeatTime
        withQueue: (dispatch_queue_t) queue
        doingTask:(void(^)()) task;

/**
 Start the timer.
 */
-(void) startTimer;
/**
 Stop the timer.
 */
-(void) stopTimer;
/**
 Return the state of the timer, activated or not
 */
-(BOOL) timerState;

@end
