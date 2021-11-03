import Foundation

public protocol Notification {
  var content: NotificationContent { get }
  var trigger: NotificationTrigger { get }
}


public struct NotificationContent {
  var title: String = ""
  var body: String = ""
  var category: String = ""
  
  // TODO: to be extended based on iOS and Android API
}


public protocol NotificationTrigger {
  var repeats: Bool { get }
}


// For every type of a trigger we add a struct/class based on OS capabilities
// Here we should take a look at iOS and see whther we can make as much as possible
// BUT, the API should be the same for both OSes

public struct TimeNotificationTrigger: NotificationTrigger {
  var timeInterval: Double
  public var repeats: Bool
}

public struct CalenderNotificationTrigger {
  // Extend based on the iOS docs and add conformance to NotificationTrigger
}

public struct LocationNotificationTrigger {
  // Extend based on the iOS docs and add conformance to NotificationTrigger
}

public struct PushNotificationTrigger {
  // Extend based on the iOS docs and add conformance to NotificationTrigger
}

public struct NotificationCategory {
  var identifier: String
  var actions: [NotificationAction]
}

public struct NotificationAction {
  var identifier: String
  var title: String
}


public protocol NotificationManagerProtocol {
   
  var delegate: NotificationDelegate? { get set }
    
  var categories: [NotificationCategory] {get}
  
  func registerNotificationCategory(category: NotificationCategory)
  
  // Schedules a local notification
  func add(identifier: String,
           content: NotificationContent,
           trigger: NotificationTrigger)
  
  // Removes a pending notification
  func remove(identifier: String)
  
}


// Has to be implemented by the app to receive notification
public protocol NotificationDelegate {

  func didReceive(notification: Notification, userActionIdentifier: String)
  
  // Look at the iOS docs
  func willPresent(notification: Notification)
}
