import SwiftUI
import WidgetKit

enum F1WidgetStyle {
  static let bg = Color(red: 0.102, green: 0.102, blue: 0.102) // #1A1A1A
  static let brandRed = Color(red: 0.882, green: 0.153, blue: 0.118) // #E1271E
  static let muted = Color(white: 0.69)
  static let labelGray = Color(white: 0.53)
  static let place2 = Color(white: 0.8)
  static let place3 = Color(red: 0.69, green: 0.55, blue: 0.34)
}

extension View {
  /// iOS 17+: containerBackground; iOS 15–16: plain background.
  @ViewBuilder
  func widgetBackground(_ color: Color) -> some View {
    if #available(iOS 17.0, *) {
      containerBackground(color, for: .widget)
    } else {
      background(color)
    }
  }
}
