// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSColor
  typealias Color = NSColor
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIColor
  typealias Color = UIColor
#endif

// swiftlint:disable file_length

// swiftlint:disable operator_usage_whitespace
extension Color {
  convenience init(rgbaValue: UInt32) {
    let red   = CGFloat((rgbaValue >> 24) & 0xff) / 255.0
    let green = CGFloat((rgbaValue >> 16) & 0xff) / 255.0
    let blue  = CGFloat((rgbaValue >>  8) & 0xff) / 255.0
    let alpha = CGFloat((rgbaValue      ) & 0xff) / 255.0

    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}
// swiftlint:enable operator_usage_whitespace

// swiftlint:disable identifier_name line_length type_body_length
struct ColorName {
  let rgbaValue: UInt32
  var color: Color { return Color(named: self) }

  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#555555"></span>
  /// Alpha: 100% <br/> (0x555555ff)
  static let darkGray = ColorName(rgbaValue: 0x555555ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#cbcccd"></span>
  /// Alpha: 100% <br/> (0xcbcccdff)
  static let gray = ColorName(rgbaValue: 0xcbcccdff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#77cca4"></span>
  /// Alpha: 100% <br/> (0x77cca4ff)
  static let green = ColorName(rgbaValue: 0x77cca4ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#f0f1f2"></span>
  /// Alpha: 100% <br/> (0xf0f1f2ff)
  static let lightGray = ColorName(rgbaValue: 0xf0f1f2ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ff8b60"></span>
  /// Alpha: 100% <br/> (0xff8b60ff)
  static let orange = ColorName(rgbaValue: 0xff8b60ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#9494ff"></span>
  /// Alpha: 100% <br/> (0x9494ffff)
  static let purple = ColorName(rgbaValue: 0x9494ffff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffcc00"></span>
  /// Alpha: 100% <br/> (0xffcc00ff)
  static let yellow = ColorName(rgbaValue: 0xffcc00ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#007aff"></span>
  /// Alpha: 100% <br/> (0x007affff)
  static let iosBlue = ColorName(rgbaValue: 0x007affff)
}
// swiftlint:enable identifier_name line_length type_body_length

extension Color {
  convenience init(named color: ColorName) {
    self.init(rgbaValue: color.rgbaValue)
  }
}
