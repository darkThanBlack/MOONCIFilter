//
//  MAFColorAdapter.swift
//  MountingAndFraming
//
//  Created by 徐一丁 on 2023/5/26.
//

import UIKit

/// 依赖解耦 - 色值
class MAFColorAdapter {
    
    ///#000000
    @objc(MAFColorAdapterBlackA)
    static var BlackA: UIColor {
        return maf_dynamicColor(unknown: 0x000000)
    }
    
    ///#FFFFFF
    @objc(MAFColorAdapterWhiteA)
    static var WhiteA: UIColor {
        return maf_dynamicColor(unknown: 0xFFFFFF)
    }
    
    ///#D8D8D8
    @objc(MAFColorAdapterWhiteB)
    static var WhiteB: UIColor {
        return maf_dynamicColor(unknown: 0xD8D8D8)
    }
    
    ///#EEEEEE
    @objc(MAFColorAdapterWhiteD)
    static var WhiteD: UIColor {
        return maf_dynamicColor(unknown: 0xEEEEEE)
    }
    
    ///#F6F7F8
    @objc(MAFColorAdapterWhiteL)
    static var WhiteL: UIColor {
        return maf_dynamicColor(unknown: 0xF6F7F8)
    }
    
    ///#666666
    @objc(MAFColorAdapterGrayA)
    static var GrayA: UIColor {
        return maf_dynamicColor(unknown: 0x666666)
    }
    
    ///#999999
    @objc(MAFColorAdapterLightGrayA)
    static var LightGrayA: UIColor {
        return maf_dynamicColor(unknown: 0x999999)
    }
    
    ///#333333
    @objc(MAFColorAdapterDarkGrayA)
    static var DarkGrayA: UIColor {
        return maf_dynamicColor(unknown: 0x333333)
    }
    
    ///#FF8534
    @objc(MAFColorAdapterOrangeA)
    static var OrangeA: UIColor {
        return maf_dynamicColor(unknown: 0xFF8534)
    }
    
    ///#FFAB1A
    @objc(MAFColorAdapterOrangeB)
    static var OrangeB: UIColor {
        return maf_dynamicColor(unknown: 0xFFAB1A)
    }
    
    ///#2F91EB
    @objc(MAFColorAdapterBlueC)
    static var BlueC: UIColor {
        return maf_dynamicColor(unknown: 0x2F91EB)
    }
    
    /// Hex -> UIColor, 需要 alpha 请使用 `withAlphaComponent` 方法
    /// - Parameter hex: 0xFFFFFF
    /// - Returns: alpha == 1.0
    static private func maf_color(hex: Int64) -> UIColor {
        return UIColor(red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((hex & 0xFF00) >> 8) / 255.0,
                       blue: CGFloat(hex & 0xFF) / 255.0,
                       alpha: 1.0)
    }
    
    /// Hex -> UIColor，适配暗黑模式
    /// - Parameters:
    ///   - unknown: 未指定，iOS 13.0 以下系统版本直接作为色值使用
    ///   - light: 浅色状态
    ///   - dark: 深色状态
    /// - Returns: alpha == 1.0
    static private func maf_dynamicColor(unknown: Int64, light: Int64? = nil, dark: Int64? = nil) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.init { (traitCollection) -> UIColor in
                switch traitCollection.userInterfaceStyle {
                case .unspecified:
                    return maf_color(hex: unknown)
                case .light:
                    return maf_color(hex: light ?? unknown)
                case .dark:
                    return maf_color(hex: dark ?? unknown)
                @unknown default:
                    return maf_color(hex: unknown)
                }
            }
        } else {
            return maf_color(hex: unknown)
        }
    }
}
