//
//  Misc.swift
//  Maofan
//
//  Created by Catt Liu on 2016/11/12.
//  Copyright © 2016年 Catt Liu. All rights reserved.
//

import OAuthSwift
import AudioToolbox

class PlaySound {
    
    static var paths_bubble: [String] = [
        "bubble_1",
        "bubble_2",
        ]
    
    static var paths_elastic: [String] = [
        "Elastic_Note1",
        "Elastic_Done11",
        ]
    
    static var soundIDs_bubble: [SystemSoundID] = {
        return setupSoundIDs(paths: paths_bubble)
    }()
    
    static var soundIDs_elastic: [SystemSoundID] = {
        return setupSoundIDs(paths: paths_elastic)
    }()
    
    static func setupSoundIDs(paths: [String]) -> [SystemSoundID] {
        var soundIDs: [SystemSoundID] = []
        var soundID: SystemSoundID = 0
        for path in paths {
            let fileURL = Bundle.main.url(forResource: path, withExtension: "wav")
            AudioServicesCreateSystemSoundID(fileURL! as CFURL, &soundID)
            soundIDs.append(soundID)
        }
        return soundIDs
    }
    
    enum SoundLoadType: Int {
        case start
        case success
        case fail
        case none
    }
    
    static func load(_ type: SoundLoadType) {
        AudioServicesPlaySystemSound(soundIDs_bubble[type.rawValue])
    }
    
    static func touch() {
        AudioServicesPlaySystemSound(soundIDs_bubble.randomItem())
    }
}

class Misc {
    
    static func handleError(_ error: OAuthSwiftError) {
        let error = error.underlyingError! as NSError
        print(error)
    }
    
    static func handleError(_ error: NSError) {
        print(error)
    }
    
    static func handleError(_ error: Error) {
        print(error)
    }
    
    static var timeMark = Date() {
        didSet {
            print(timeMark.timeIntervalSince1970 - oldValue.timeIntervalSince1970)
        }
    }
    
    static func markTime() {
        timeMark = Date()
    }
    
    static func screenSizeScale() -> CGFloat {
        switch UIScreen.main.bounds.width {
        case 320:
            return 3/4
        case 375:
            return 5/6
        default:
            return 1
        }
    }

}

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex:String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.characters.count) == 6) {
            var rgbValue:UInt32 = 0
            Scanner(string: cString).scanHexInt32(&rgbValue)
            self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: 1.0)
        } else {
            self.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        }
    }
    
    func alpha(_ alpha: CGFloat) -> UIColor {
        return self.withAlphaComponent(alpha)
    }
    
}

extension Array {
    
    func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
    
}

extension UIView {
    
    func cleanBlurBar(color: UIColor = Style.blurBarColor) {
        let allSubViews = self.allSubViews
        for view in allSubViews {
            if view is UIImageView, view.bounds.height <= 1, view.bounds.width == UIScreen.main.bounds.width {
                print("****************** find shadow")
                view.isHidden = true
                break
            }
        }
        for view in allSubViews {
            if view is UIVisualEffectView {
                print("****************** find original blur")
                view.isHidden = true
                break
            }
        }
        guard let _UIBarBackground = NSClassFromString("_UIBarBackground"), let _UIVisualEffectFilterView = NSClassFromString("_UIVisualEffectFilterView") else {
            print("****************** class failed")
            return
        }
        for view in allSubViews {
            if view.isKind(of: _UIBarBackground) {
                print("****************** find _UIBarBackground")
                let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
                blurView.frame = view.frame
                blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                for view in blurView.allSubViews {
                    if view.isKind(of: _UIVisualEffectFilterView) {
                        print("****************** find _UIVisualEffectFilterView")
                        view.backgroundColor = color.alpha(0.9)
                        break
                    }
                }
                view.addSubview(blurView)
                break
            }
        }
    }
    
    var allSubViews : [UIView] {
        var array = [self.subviews].flatMap {$0}
        array.forEach { array.append(contentsOf: $0.allSubViews) }
        return array
    }
    
}

extension UIImage {
    
    func imageWithColor(_ color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        color.setFill()
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1, y: -1)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context.clip(to: rect, mask: self.cgImage!)
        context.fill(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
}

extension String {
    
    subscript(integerIndex: Int) -> Character {
        let index = self.index(startIndex, offsetBy: integerIndex)
        return self[index]
    }
    
    subscript(integerRange: Range<Int>) -> String {
        let start = self.index(startIndex, offsetBy: integerRange.lowerBound)
        let end = self.index(startIndex, offsetBy: integerRange.upperBound)
        let range = start..<end
        return self[range]
    }
    
}
