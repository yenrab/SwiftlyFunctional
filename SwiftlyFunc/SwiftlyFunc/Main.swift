/*
The MIT License (MIT)

Copyright (c) 2015 Lee Barney

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

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
            print("\(theRecognizer.uniqueID!) activated at \(theRecognizer.locationInView(theImage))")
        }
    }
   
    return (application,userView,launchReasons,true)
}