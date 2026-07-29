import Foundation

enum WidgetSharedStore {
  static let appGroupId = "group.com.example.f1PetProject"

  static var defaults: UserDefaults {
    UserDefaults(suiteName: appGroupId) ?? .standard
  }

  static func bool(_ key: String) -> Bool {
    defaults.bool(forKey: key)
  }

  static func string(_ key: String) -> String {
    defaults.string(forKey: key) ?? ""
  }

  static func save(_ data: [String: Any]) {
    let store = defaults
    for (key, value) in data {
      if value is NSNull {
        store.removeObject(forKey: key)
        continue
      }
      if let bool = value as? Bool {
        store.set(bool, forKey: key)
        continue
      }
      if let number = value as? NSNumber {
        // Flutter MethodChannel may encode bool as NSNumber.
        let objCType = String(cString: number.objCType)
        if objCType == "c" || objCType == "B" {
          store.set(number.boolValue, forKey: key)
        } else {
          store.set(number.stringValue, forKey: key)
        }
        continue
      }
      if let string = value as? String {
        store.set(string, forKey: key)
        continue
      }
      store.set(String(describing: value), forKey: key)
    }
    store.synchronize()
  }
}
