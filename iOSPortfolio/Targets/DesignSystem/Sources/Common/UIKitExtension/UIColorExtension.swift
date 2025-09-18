//
//  UIColorExtension.swift
//  View
//
//  Created by JuYoung choi on 7/22/25.
//

import UIKit

public extension UIColor {

    /// RGB값을 UIColor로 변경
    public static func rgba(_ red:Float, _ green:Float, _ blue:Float, _ alpha:Float = 100) -> UIColor {

        let divin: Float = 255
        let alphaDivin: Float = 100
        
        var tmpRed   = red   / divin
        var tmpGreen = green / divin
        var tmpBlue  = blue  / divin
        var tmpAlpha = alpha / alphaDivin
        
        if tmpRed > 1 {
            tmpRed = 1.0
        }
        
        if tmpGreen > 1 {
            tmpGreen = 1.0
        }
        
        if tmpBlue > 1 {
            tmpBlue = 1.0
        }
        
        if tmpAlpha > 1 {
            tmpAlpha = 1.0
        }
        
        let colorSpace    = CGColorSpace(name:CGColorSpace.sRGB)!
        let rgbaLikeArray = [CGFloat(tmpRed), CGFloat(tmpGreen), CGFloat(tmpBlue), CGFloat(tmpAlpha) ]
        let cgColorWithColorSpace = CGColor(colorSpace: colorSpace, components: rgbaLikeArray)!
        let makeCgcolor  = cgColorWithColorSpace.converted(to: colorSpace, intent: .absoluteColorimetric, options: nil)!
        
        let rtnColor = UIColor(cgColor: makeCgcolor)

        return rtnColor
    }
    
    
    /// RGB값을 UIColor로 변경
    public static func rgb(_ red:Float, _ green:Float, _ blue:Float) -> UIColor {

        return UIColor.rgba(red, green, blue)
    }
    
    /// comment : 핵사 텍스트를 UIColor로 변환
    public static func fromHex(_ hexString: String, alpha: CGFloat = 100) -> UIColor {

        let formatted = hexString.replacingOccurrences(of: "0x", with: "").replacingOccurrences(of: "#", with: "")
        
        if let hex = Int(formatted, radix: 16) {
            
            let red   = Float((hex & 0xFF0000) >> 16)
            let green = Float((hex & 0x00FF00) >> 8)
            let blue  = Float((hex & 0x0000FF) >> 0)
            
            return .rgba(red, green, blue, Float(alpha ))
        } else {
            
            return .black
        }
    }
}
