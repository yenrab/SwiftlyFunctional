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
    let theButton = getViewByUniqueID(userView, anID: "theButton") as! UIButton
    
    addTouchEventHandler(theButton, touchEventType:UIControlEvents.TouchDown){(touchedButton:UIControl,theEvent:UIEvent) -> UIControl in
        print("view: \(userView.isFirstResponder())")
        print("in the down handler!!")
        return touchedButton
    }
    addTouchEventHandler(theButton, touchEventType:UIControlEvents.TouchUpInside){(touchedButton:UIControl,theEvent:UIEvent) -> UIControl in
        
        print("in the end inside handler!!")
        return touchedButton
    }
    
    addTouchEventHandler(theButton, touchEventType:UIControlEvents.TouchUpOutside){(touchedButton:UIControl,theEvent:UIEvent) -> UIControl in
        
        print("in the end outside handler!!")
        return touchedButton
    }
    
    //Example: creating handlers for gesture events
    
    let theImage = getViewByUniqueID(userView, anID: "chalkImage")
    
    if let theRecognizer = getGestureRecognizerByUniqueID(theImage!, anID: "imageTap"){
        addTouchEventHandler(theRecognizer){
            print("tapped")
        }
    }
   
    return (application,userView,launchReasons,true)
}