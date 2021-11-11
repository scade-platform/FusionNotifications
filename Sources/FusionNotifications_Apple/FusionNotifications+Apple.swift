#if os(macOS) || os(iOS)
import FusionNotifications_Common
import UserNotifications

public class NotificationManager: NSObject, NotificationManagerProtocol, FusionNotifications_Common.Notification {
  public var content: NotificationContent?
  
  public var trigger: NotificationTrigger?
  
  public static var shared = NotificationManager()
  
  public var delegate: NotificationDelegate?
    
  public var categories: [NotificationCategory]
  
  private let userNotificationCenter = UNUserNotificationCenter.current()
  
  public required override init() {
    self.categories = []
    super.init()
    userNotificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in    }    
  }
  
  public func registerNotificationCategory(category: NotificationCategory) {
    if !self.categories.contains(where: { $0.identifier == category.identifier }) {
      self.categories.append(category)
    }
    
    userNotificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in      if granted {        let unCategories = self.categories.map { category -> UNNotificationCategory in          let unActions = category.actions.map({ UNNotificationAction(identifier: $0.identifier, title: $0.title, options: [])})          return UNNotificationCategory(identifier: category.identifier, actions: unActions, intentIdentifiers: [], options: [])        }        self.userNotificationCenter.setNotificationCategories(Set(unCategories))        self.userNotificationCenter.delegate = self      }    }
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
        } else {
          self.content = content
          self.trigger = trigger
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
    self.delegate?.didReceive(notification: self, userActionIdentifier: response.actionIdentifier)
    completionHandler()
  }
  
  public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    self.delegate?.willPresent(notification: self)
    completionHandler(.alert)
  }
}
#endif