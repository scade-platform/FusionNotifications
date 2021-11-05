#if os(macOS) || os(iOS)
import FusionNotification_Common
import UserNotifications

public class NotificationManager: NSObject, NotificationManagerProtocol {
  public static var shared = NotificationManager()
  
  public var delegate: NotificationDelegate?
    
  public var categories: [NotificationCategory]
  
  private let userNotificationCenter = UNUserNotificationCenter.current()
  
  public required override init() {
    self.categories = []
  }
  
  public func registerNotificationCategory(category: NotificationCategory) {
    if !self.categories.contains(where: { $0.identifier == category.identifier }) {
      self.categories.append(category)
    }
    
    let unCategories = self.categories.map { category -> UNNotificationCategory in
      let unActions = category.actions.map({ UNNotificationAction(identifier: $0.identifier, title: $0.title, options: [])})
      return UNNotificationCategory(identifier: category.identifier, actions: unActions, intentIdentifiers: [], options: [])
    }
    userNotificationCenter.setNotificationCategories(Set(unCategories))
  }
  
  public func add(identifier: String, content: NotificationContent, trigger: NotificationTrigger) {
    if let trigger = trigger as? TimeNotificationTrigger {
      let timeInterval = trigger.repeats && trigger.timeInterval < 60 ? 60 : trigger.timeInterval
      let unTrigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: trigger.repeats)
      let unContent = UNMutableNotificationContent()
      unContent.title = content.title
      unContent.body = content.body
      unContent.categoryIdentifier = content.category
      let unRequest = UNNotificationRequest(identifier: identifier, content: unContent, trigger: unTrigger)
      userNotificationCenter.add(unRequest) { error in
        if let error = error {
            print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
        }
      }
    }
  }
  
  public func remove(identifier: String) {
    userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
  }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
  public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    switch response.actionIdentifier {
    case response.actionIdentifier:
        print("Read tapped")
    default:
        print("Other Action")
    }

    completionHandler()
  }
  
  public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler(.list)
  }
}
#endif