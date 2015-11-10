//
//  main.swift
//  SwiftlyFunc
//
//  Created by Lee Barney on 10/28/15.
//  Copyright © 2015 Lee Barney. All rights reserved.
//

import UIKit


func main(application:UIApplication, userView:UIView, launchReasons:[NSObject:AnyObject]?)->(UIApplication,UIView,[NSObject:AnyObject]?,Bool){
    
    //Example: creating handlers for application events
    addApplicationEventHandler(application, theEventType: AppEventType.appDidBecomeActive){
        
        print("in became active")
    }
    
    //Example: creating handlers for touch events
    let aButton = getViewByUniqueID(userView, anID: "theButton") as! UIButton
    
    addTouchEventHandler(aButton, touchEventType:UIControlEvents.TouchDown){(theEvent:UIEvent) -> Void in
        print("\(aButton.uniqueID!) using the down handler at \(theEvent.allTouches()!.first!.locationInView(aButton))")
    }
    addTouchEventHandler(aButton, touchEventType:UIControlEvents.TouchUpInside){(theEvent:UIEvent) -> Void in
        
        print("\(aButton.uniqueID!) using the end inside handler at \(theEvent.allTouches()!.first!.locationInView(aButton))")

    }
    
    addTouchEventHandler(aButton, touchEventType:UIControlEvents.TouchUpOutside){(theEvent:UIEvent) -> Void in
        
        print("\(aButton.uniqueID!) using the end outside handler at \(theEvent.allTouches()!.first!.locationInView(userView))")

    }
    
    //Example: creating handlers for gesture events
    
    let theImage = getViewByUniqueID(userView, anID: "chalkImage")
    
    if let theRecognizer = getGestureRecognizerByUniqueID(theImage!, anID: "imageTap"){
        addTouchEventHandler(theRecognizer){
            print("\(theRecognizer.uniqueID!) activated")
        }
    }
   
    return (application,userView,launchReasons,true)
}