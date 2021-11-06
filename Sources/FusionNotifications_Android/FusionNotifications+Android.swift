import Java
import Android
import AndroidOS
import AndroidApp
import AndroidContent

import FusionNotifications_Common
import Foundation

public class NotificationManager: NSObject, NotificationManagerProtocol, FusionNotifications_Common.Notification {
  public var content: NotificationContent?
  
  public var trigger: NotificationTrigger?
  
  public static var shared = NotificationManager()
  
  public var delegate: NotificationDelegate?
    
  public var categories: [NotificationCategory]  
 
  public required override init() {
    self.categories = []
    super.init()
  }
  
  public func registerNotificationCategory(category: NotificationCategory) {
  }
  
  public func add(identifier: String, content: NotificationContent, trigger: NotificationTrigger) {
  }
  
  public func remove(identifier: String) {
  }
}
