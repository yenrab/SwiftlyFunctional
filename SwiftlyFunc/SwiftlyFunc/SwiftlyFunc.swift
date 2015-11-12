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

enum AppEventType:String{
    case appWillResignActive
    case appDidEnterBackground
    case appWillEnterForeground
    case appDidBecomeActive
    case appWillTerminate
}

enum GestureEventType:String{
    case tap
    case pinch
    case rotate
    case swipe
    case pan
    case screenEdgePan
    case longPress
}

extension UIView {
    private struct SwiftlyFuncCustomProperties {
        static var uniqueID:String? = nil
        static var dragEntered:Bool = false
        static var dragExited:Bool = false
    }
    
    var uniqueID: String? {
        get {
            return objc_getAssociatedObject(self, &SwiftlyFuncCustomProperties.uniqueID) as? String
        }
        set {
            if let unwrappedValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &SwiftlyFuncCustomProperties.uniqueID,
                    unwrappedValue as NSString?,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
    
    var dragEntered: Bool {
        get {
            return objc_getAssociatedObject(self, &SwiftlyFuncCustomProperties.dragEntered) as! Bool
        }
        
        set {
            objc_setAssociatedObject(
                self,
                &SwiftlyFuncCustomProperties.dragEntered,
                newValue as ObjCBool.BooleanLiteralType,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    var dragExited: Bool {
        get {
            return objc_getAssociatedObject(self, &SwiftlyFuncCustomProperties.dragExited) as! Bool
        }
        
        set {
            objc_setAssociatedObject(
                self,
                &SwiftlyFuncCustomProperties.dragExited,
                newValue as ObjCBool.BooleanLiteralType,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
}


extension UIGestureRecognizer {
    private struct SwiftlyFuncCustomProperties {
        static var uniqueID:String? = nil
    }
    
    var uniqueID: String? {
        get {
            return objc_getAssociatedObject(self, &SwiftlyFuncCustomProperties.uniqueID) as? String
        }
        
        set {
            if let unwrappedValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &SwiftlyFuncCustomProperties.uniqueID,
                    unwrappedValue as NSString?,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
}

typealias appClosure = () -> Void
private var applicationEventToHandlerDictionary = [AppEventType:appClosure]()

typealias touchClosure = (UIEvent) -> Void
private var touchEventToHandlerDictionary = [UIControl:[UInt:touchClosure]]()


typealias gestureClosure = () -> Void
private var gestureEventToHandlerDictionary = [String:[GestureEventType:gestureClosure]]()

func addApplicationEventHandler(theApplication:UIApplication,theEventType:AppEventType,handler:() -> Void) -> UIApplication{
    applicationEventToHandlerDictionary[theEventType] = handler
    return theApplication
}

func addTouchEventHandler(theControl:UIControl,touchEventType:UIControlEvents,handler:(UIEvent) -> Void) -> UIControl{
    theControl.addTarget(UIApplication.sharedApplication().delegate!, action: "doEventHandler:forEvent:", forControlEvents: touchEventType)
    var currentHandlerDictionary = touchEventToHandlerDictionary[theControl]
    if currentHandlerDictionary == nil{
        currentHandlerDictionary = [UInt:touchClosure]()
    }
    currentHandlerDictionary![touchEventType.rawValue] = handler
    touchEventToHandlerDictionary[theControl] = currentHandlerDictionary
    return theControl
}

func addTouchEventHandler(theGestureRecognizer:UIGestureRecognizer, handler:() -> Void) -> UIGestureRecognizer{
    guard let recognizerId = theGestureRecognizer.uniqueID else {
        return theGestureRecognizer
    }
    theGestureRecognizer.view?.userInteractionEnabled = true
    theGestureRecognizer.addTarget(UIApplication.sharedApplication().delegate!, action: "doEventHandler:")
    print(theGestureRecognizer.valueForKeyPath("_targets"))
    var currentHandlerDictionary = gestureEventToHandlerDictionary[recognizerId]
    if currentHandlerDictionary == nil{
        currentHandlerDictionary = [GestureEventType:gestureClosure]()
    }
    let touchEventType = gestureRecognizerToGestureType(theGestureRecognizer)
    currentHandlerDictionary![touchEventType] = handler
    gestureEventToHandlerDictionary[recognizerId] = currentHandlerDictionary
    return theGestureRecognizer
}

func getViewByUniqueID(containingView:UIView, anID:String) ->UIView?{
    
    let filteredSubviews = containingView.subviews.filter(){$0.uniqueID == anID}
    if filteredSubviews.count > 0{
        return filteredSubviews[0]
    }
    return nil
}

func getGestureRecognizerByUniqueID(aViewWithGestureRecognizer:UIView, anID:String) ->UIGestureRecognizer?{
    var foundRecognizer:UIGestureRecognizer? = nil
    guard let recognizers = aViewWithGestureRecognizer.gestureRecognizers else{
        return foundRecognizer
    }
    let filteredRecognizers = recognizers.filter(){$0.uniqueID == anID}
    if filteredRecognizers.count > 0{
        foundRecognizer = filteredRecognizers[0]
    }
    return foundRecognizer
}


private func touchEventToUIControlEvents(theTarget:UIView,theEvent:UIEvent) ->UIControlEvents{
    
    
    /* The ✔︎ symbol means code has been implemented for that event.
    The ✖︎ symbol means there is currently no intention of implementing that event.
    
    TouchDown ✔︎
    TouchDownRepeat ✔︎
    TouchDragInside ✔︎
    TouchDragOutside ✔︎
    TouchDragEnter ✔︎
    TouchDragExit ✔︎
    TouchUpInside ✔︎
    TouchUpOutside ✔︎
    TouchCancel ✔︎
    ValueChanged
    PrimaryActionTriggered
    EditingDidBegin
    EditingChanged
    EditingDidEnd
    EditingDidEndOnExit
    AllTouchEvents ✖︎
    AllEditingEvents ✖︎
    ApplicationReserved ✖︎
    SystemReserved ✖︎
    AllEvents ✖︎
    */
    //set TouchDown as the default
    var theControlEventType = UIControlEvents.TouchDown
    guard let aTouch = theEvent.allTouches()?.first else{
        return theControlEventType
    }
    let touchPhase = aTouch.phase.rawValue
    if touchPhase == UITouchPhase.Began.rawValue && aTouch.tapCount > 1{
        theControlEventType = UIControlEvents.TouchDownRepeat
    }
    else if touchPhase == UITouchPhase.Ended.rawValue{
        /*
        * UITouchPhase.Ended and touch location is within bounds yeilds UITouchUpInside
        * UITouchPhase.Ended and touch location is outside bounds yeilds UITouchUpOutside
        */
        let endLocation = theEvent.allTouches()?.first?.locationInView(nil)
        if theTarget.frame.contains(endLocation!){
            theControlEventType = UIControlEvents.TouchUpInside
        }
        else{
            theControlEventType = UIControlEvents.TouchUpOutside
        }
    }
    else if touchPhase == UITouchPhase.Cancelled.rawValue{
        theControlEventType = UIControlEvents.TouchCancel
    }
    else if touchPhase == UITouchPhase.Moved.rawValue{
        //moved into, out of, within, or without
        let moveLocation = theEvent.allTouches()?.first?.locationInView(nil)
        if theTarget.frame.contains(moveLocation!){
            if theTarget.dragEntered{
                theControlEventType = UIControlEvents.TouchDragInside
            }
            else{
                theTarget.dragEntered = true
                theControlEventType = UIControlEvents.TouchDragEnter
            }
        }
        else{
            if theTarget.dragExited{
                theControlEventType = UIControlEvents.TouchDragOutside
            }
            else{
                theTarget.dragExited = true
                theControlEventType = UIControlEvents.TouchDragExit
            }
        }
    }
    
    
    
    return theControlEventType
}

private func gestureRecognizerToGestureType(aRecognizer:UIGestureRecognizer) -> GestureEventType{
    
    var gestureType = GestureEventType.tap
    if let _ = aRecognizer as? UIPinchGestureRecognizer{
        gestureType = GestureEventType.pinch
    }
    if let _ = aRecognizer as? UIRotationGestureRecognizer{
        gestureType = GestureEventType.rotate
    }
    if let _ = aRecognizer as? UISwipeGestureRecognizer{
        gestureType = GestureEventType.swipe
    }
    if let _ = aRecognizer as? UIPanGestureRecognizer{
        gestureType = GestureEventType.pan
    }
    if let _ = aRecognizer as? UIScreenEdgePanGestureRecognizer{
        gestureType = GestureEventType.screenEdgePan
    }
    if let _ = aRecognizer as? UILongPressGestureRecognizer{
        gestureType = GestureEventType.longPress
    }
    return gestureType
}

var appLaunchOptions: [NSObject: AnyObject]?


//one instance of Eventor will be created as the AppDelegate and another as the ViewController
@UIApplicationMain
class Eventor:UIViewController, UIApplicationDelegate{
    var window: UIWindow?
    
    @IBAction func labelTapped(sender: AnyObject) {
        print("label tapped")
    }
    //App events
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        appLaunchOptions = launchOptions
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        guard let handler = applicationEventToHandlerDictionary[AppEventType.appWillResignActive] else{
            return
        }
        handler()
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        guard let handler = applicationEventToHandlerDictionary[AppEventType.appDidEnterBackground] else{
            return
        }
        handler()
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        guard let handler = applicationEventToHandlerDictionary[AppEventType.appWillEnterForeground] else{
            return
        }
        handler()
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        guard let handler = applicationEventToHandlerDictionary[AppEventType.appDidBecomeActive] else{
            return
        }
        handler()
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        guard let handler = applicationEventToHandlerDictionary[AppEventType.appWillTerminate] else{
            return
        }
        handler()
    }
    //view events
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.subviews.filter({$0 is UIControl || $0.gestureRecognizers?.count > 0}).map({setup($0)})
        let (_,_,_,success) = main(UIApplication.sharedApplication(), userView: self.view, launchReasons:appLaunchOptions)
        if !success{
            //these two calls duplicate the behavior of the application exiting 'normally'
            self.applicationWillTerminate(UIApplication.sharedApplication())
            exit(0)
        }
    }
    //this function for gesture recognizers
    func doEventHandler(sender:UIGestureRecognizer){
        
        guard let recognizerId = sender.uniqueID else{
            return
        }
        guard let mappedEvents = gestureEventToHandlerDictionary[recognizerId] else{
            return
        }
        let gestureType = gestureRecognizerToGestureType(sender)
        
        guard let handler = mappedEvents[gestureType] else{
            return
        }
        handler()

        
    }
    //this function for UIButtons, etc.
    func doEventHandler(sender: AnyObject, forEvent event: UIEvent) {
        let theControl = sender as? UIControl
        guard let control = theControl else{
            return
        }
        if let mappedEvents = touchEventToHandlerDictionary[control]{
            //set touch up inside as the devault touch type
            var type = UIControlEvents.TouchUpInside
            if let senderView = sender as? UIView {
                type = touchEventToUIControlEvents(senderView,theEvent: event)
            }
            guard let handler = mappedEvents[type.rawValue] else{
                return
            }
            handler(event)

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
