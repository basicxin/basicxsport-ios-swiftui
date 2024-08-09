//
//  Extensions.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 12/01/22.
//

import Foundation
import Kingfisher
import SwiftUI
import UIKit

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }

    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}

public extension Color {
    static let lightText = Color(UIColor.lightText)
    static let darkText = Color(UIColor.darkText)

    static let label = Color(UIColor.label)
    static let secondaryLabel = Color(UIColor.secondaryLabel)
    static let tertiaryLabel = Color(UIColor.tertiaryLabel)
    static let quaternaryLabel = Color(UIColor.quaternaryLabel)

    static let systemBackground = Color(UIColor.systemBackground)
    static let secondarySystemBackground = Color(UIColor.secondarySystemBackground)
    static let tertiarySystemBackground = Color(UIColor.tertiarySystemBackground)
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension View {
    func fullWidth(alignement: Alignment = .center) -> some View {
        self.frame(maxWidth: .infinity, alignment: alignement)
    }

    func fullHeight() -> some View {
        self.frame(maxHeight: .infinity)
    }

    func fullSize(alignement: Alignment = .center) -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignement)
    }

    func withDefaultShadow() -> some View {
        self.background(.background).clipped().shadow(color: Color.quaternaryLabel, radius: 1, x: 0.5, y: 0.5)
    }
}

extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        self?.isEmpty ?? true
    }

    var isNil: Bool {
        self == nil
    }
}

extension Optional where Wrapped == String {
    func asStringOrEmpty() -> String {
        switch self {
            case .some(let value):
                return String(describing: value)
            case _:
                return ""
        }
    }

    func asStringOrNilText() -> String {
        switch self {
            case .some(let value):
                return String(describing: value)
            case _:
                return "(nil)"
        }
    }
}

extension Optional where Wrapped == Int {
    func asStringOrZero() -> String {
        switch self {
            case .some(let value):
                return String(describing: value)
            case _:
                return "0"
        }
    }

    func asStringOrNilText() -> String {
        switch self {
            case .some(let value):
                return String(describing: value)
            case _:
                return "(nil)"
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
            case 3: // RGB (12-bit)
                (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: // RGB (24-bit)
                (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8: // ARGB (32-bit)
                (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default:
                (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

public extension View {
    func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)

        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)

        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()

        // here is the call to the function that converts UIView to UIImage: `.asImage()`
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
}

public extension UIView {
    // This is the function to convert UIView to UIImage
    func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension Decodable {
    init(from: Any) throws {
        let data = try JSONSerialization.data(withJSONObject: from, options: .prettyPrinted)
        let decoder = JSONDecoder()
        self = try decoder.decode(Self.self, from: data)
    }
}

public extension UIDevice {
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
                case "iPod5,1": return "iPod touch (5th generation)"
                case "iPod7,1": return "iPod touch (6th generation)"
                case "iPod9,1": return "iPod touch (7th generation)"
                case "iPhone3,1", "iPhone3,2", "iPhone3,3": return "iPhone 4"
                case "iPhone4,1": return "iPhone 4s"
                case "iPhone5,1", "iPhone5,2": return "iPhone 5"
                case "iPhone5,3", "iPhone5,4": return "iPhone 5c"
                case "iPhone6,1", "iPhone6,2": return "iPhone 5s"
                case "iPhone7,2": return "iPhone 6"
                case "iPhone7,1": return "iPhone 6 Plus"
                case "iPhone8,1": return "iPhone 6s"
                case "iPhone8,2": return "iPhone 6s Plus"
                case "iPhone9,1", "iPhone9,3": return "iPhone 7"
                case "iPhone9,2", "iPhone9,4": return "iPhone 7 Plus"
                case "iPhone10,1", "iPhone10,4": return "iPhone 8"
                case "iPhone10,2", "iPhone10,5": return "iPhone 8 Plus"
                case "iPhone10,3", "iPhone10,6": return "iPhone X"
                case "iPhone11,2": return "iPhone XS"
                case "iPhone11,4", "iPhone11,6": return "iPhone XS Max"
                case "iPhone11,8": return "iPhone XR"
                case "iPhone12,1": return "iPhone 11"
                case "iPhone12,3": return "iPhone 11 Pro"
                case "iPhone12,5": return "iPhone 11 Pro Max"
                case "iPhone13,1": return "iPhone 12 mini"
                case "iPhone13,2": return "iPhone 12"
                case "iPhone13,3": return "iPhone 12 Pro"
                case "iPhone13,4": return "iPhone 12 Pro Max"
                case "iPhone14,4": return "iPhone 13 mini"
                case "iPhone14,5": return "iPhone 13"
                case "iPhone14,2": return "iPhone 13 Pro"
                case "iPhone14,3": return "iPhone 13 Pro Max"
                case "iPhone8,4": return "iPhone SE"
                case "iPhone12,8": return "iPhone SE (2nd generation)"
                case "iPhone14,6": return "iPhone SE (3rd generation)"
                case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return "iPad 2"
                case "iPad3,1", "iPad3,2", "iPad3,3": return "iPad (3rd generation)"
                case "iPad3,4", "iPad3,5", "iPad3,6": return "iPad (4th generation)"
                case "iPad6,11", "iPad6,12": return "iPad (5th generation)"
                case "iPad7,5", "iPad7,6": return "iPad (6th generation)"
                case "iPad7,11", "iPad7,12": return "iPad (7th generation)"
                case "iPad11,6", "iPad11,7": return "iPad (8th generation)"
                case "iPad12,1", "iPad12,2": return "iPad (9th generation)"
                case "iPad4,1", "iPad4,2", "iPad4,3": return "iPad Air"
                case "iPad5,3", "iPad5,4": return "iPad Air 2"
                case "iPad11,3", "iPad11,4": return "iPad Air (3rd generation)"
                case "iPad13,1", "iPad13,2": return "iPad Air (4th generation)"
                case "iPad13,16", "iPad13,17": return "iPad Air (5th generation)"
                case "iPad2,5", "iPad2,6", "iPad2,7": return "iPad mini"
                case "iPad4,4", "iPad4,5", "iPad4,6": return "iPad mini 2"
                case "iPad4,7", "iPad4,8", "iPad4,9": return "iPad mini 3"
                case "iPad5,1", "iPad5,2": return "iPad mini 4"
                case "iPad11,1", "iPad11,2": return "iPad mini (5th generation)"
                case "iPad14,1", "iPad14,2": return "iPad mini (6th generation)"
                case "iPad6,3", "iPad6,4": return "iPad Pro (9.7-inch)"
                case "iPad7,3", "iPad7,4": return "iPad Pro (10.5-inch)"
                case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4": return "iPad Pro (11-inch) (1st generation)"
                case "iPad8,9", "iPad8,10": return "iPad Pro (11-inch) (2nd generation)"
                case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7": return "iPad Pro (11-inch) (3rd generation)"
                case "iPad6,7", "iPad6,8": return "iPad Pro (12.9-inch) (1st generation)"
                case "iPad7,1", "iPad7,2": return "iPad Pro (12.9-inch) (2nd generation)"
                case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8": return "iPad Pro (12.9-inch) (3rd generation)"
                case "iPad8,11", "iPad8,12": return "iPad Pro (12.9-inch) (4th generation)"
                case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11": return "iPad Pro (12.9-inch) (5th generation)"
                case "AppleTV5,3": return "Apple TV"
                case "AppleTV6,2": return "Apple TV 4K"
                case "AudioAccessory1,1": return "HomePod"
                case "AudioAccessory5,1": return "HomePod mini"
                case "i386", "x86_64", "arm64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
                default: return identifier
            }
            #elseif os(tvOS)
            switch identifier {
                case "AppleTV5,3": return "Apple TV 4"
                case "AppleTV6,2": return "Apple TV 4K"
                case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
                default: return identifier
            }
            #endif
        }

        return mapToDevice(identifier: identifier)
    }()
}

extension Bundle {
    var releaseVersionNumber: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }

    var buildVersionNumber: String? {
        infoDictionary?["CFBundleVersion"] as? String
    }

    var releaseVersionNumberPretty: String {
        "v\(self.releaseVersionNumber ?? "1.0.0")"
    }
}


