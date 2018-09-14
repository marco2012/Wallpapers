//
//  ThemeManager.swift
//  PH
//
//  Created by Marco on 21/08/2018.
//  Copyright © 2018 Vikings. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    func colorFromHexString (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
enum Theme: Int {
    
    case theme1, theme2
    
    var mainColor: UIColor {
        switch self {
        case .theme1:
            return UIColor().colorFromHexString("ffffff")
        case .theme2:
            return UIColor().colorFromHexString("000000")
        }
    }
    
    //Customizing the Navigation Bar
    var barStyle: UIBarStyle {
        switch self {
        case .theme1:
            return .default
        case .theme2:
            return .black
        }
    }
    
    var navigationBackgroundImage: UIImage? {
        return self == .theme1 ? UIImage(named: "navBackground") : nil
    }
    
    var tabBarBackgroundImage: UIImage? {
        return self == .theme1 ? UIImage(named: "tabBarBackground") : nil
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .theme1:
            return UIColor().colorFromHexString("ffffff")
        case .theme2:
            return UIColor().colorFromHexString("000000")
        }
    }
    
    //buttons in nav bar
    var tintColor: UIColor {
        switch self {
        case .theme1:
            return UIColor().colorFromHexString("000000")
        case .theme2:
            return orange
        }
    }
    
    var secondaryColor: UIColor {
        switch self {
        case .theme1:
            return UIColor().colorFromHexString("ffffff")
        case .theme2:
            return  UIColor().colorFromHexString("2B2B2B")
        }
    }
    
    var titleTextColor: UIColor {
        switch self {
        case .theme1:
            return UIColor().colorFromHexString("ffffff")
        case .theme2:
            return orange
        }
    }
    var subtitleTextColor: UIColor {
        switch self {
        case .theme1:
            return UIColor().colorFromHexString("ffffff")
        case .theme2:
            return orange
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .theme1:
            return UIColor().colorFromHexString("000000")
        case .theme2:
            return UIColor().colorFromHexString("ffffff")
        }
    }
    
    var fontName : String {
        return "Avenir-Book"
    }
    
    var boldFontName : String {
        return "Avenir-Black"
    }
    
    var semiBoldFontName : String {
        return "Avenir-Heavy"
    }
    
    var lighterFontName : String {
        return "Avenir-Light"
    }
    
    var darkColor : UIColor {
        return UIColor.black
    }
    
    var lightColor : UIColor {
        return UIColor(white: 0.6, alpha: 1.0)
    }
}

// Enum declaration
let SelectedThemeKey = "SelectedTheme"
let red = UIColor(red:0.58, green:0.20, blue:0.18, alpha:1.0)
let orange = UIColor(red:0.88, green:0.62, blue:0.32, alpha:1.0)

// This will let you use a theme in the app.
class ThemeManager {
    
    // ThemeManager
    static func currentTheme() -> Theme {
        if let storedTheme = (UserDefaults.standard.value(forKey: SelectedThemeKey) as AnyObject).integerValue {
            return Theme(rawValue: storedTheme)!
        } else {
            return .theme2
        }
    }
    
    static func applyTheme(theme: Theme) {
        
        // First persist the selected theme using NSUserDefaults.
        UserDefaults.standard.setValue(theme.rawValue, forKey: SelectedThemeKey)
        UserDefaults.standard.synchronize()
        
        // You get your current (selected) theme and apply the main color to the tintColor property of your application’s window.
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = theme.mainColor
        
        UINavigationBar.appearance().barStyle = theme.barStyle
        UINavigationBar.appearance().setBackgroundImage(theme.navigationBackgroundImage, for: .default)
        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "backArrow")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "backArrowMaskFixed")
        UINavigationBar.appearance().tintColor = theme.tintColor
        
        //color navbar title
        //        if #available(iOS 11.0, *) {
        //            UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): theme.tintColor]
        //        } else {
        //            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): theme.tintColor]
        //        }
        
        UITabBar.appearance().barStyle = theme.barStyle
        UITabBar.appearance().backgroundImage = theme.tabBarBackgroundImage
        
        let tabIndicator = UIImage(named: "tabBarSelectionIndicator")?.withRenderingMode(.alwaysTemplate)
        let tabResizableIndicator = tabIndicator?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 2.0, bottom: 0, right: 2.0))
        UITabBar.appearance().selectionIndicatorImage = tabResizableIndicator
        
        let controlBackground = UIImage(named: "controlBackground")?.withRenderingMode(.alwaysTemplate)
            .resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
        let controlSelectedBackground = UIImage(named: "controlSelectedBackground")?
            .withRenderingMode(.alwaysTemplate)
            .resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
        
        UISegmentedControl.appearance().setBackgroundImage(controlBackground, for: .normal, barMetrics: .default)
        UISegmentedControl.appearance().setBackgroundImage(controlSelectedBackground, for: .selected, barMetrics: .default)
        
        UIStepper.appearance().setBackgroundImage(controlBackground, for: .normal)
        UIStepper.appearance().setBackgroundImage(controlBackground, for: .disabled)
        UIStepper.appearance().setBackgroundImage(controlBackground, for: .highlighted)
        UIStepper.appearance().setDecrementImage(UIImage(named: "fewerPaws"), for: .normal)
        UIStepper.appearance().setIncrementImage(UIImage(named: "morePaws"), for: .normal)
        
        UISlider.appearance().setThumbImage(UIImage(named: "sliderThumb"), for: .normal)
        UISlider.appearance().setMaximumTrackImage(UIImage(named: "maximumTrack")?
            .resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 6.0)), for: .normal)
        UISlider.appearance().setMinimumTrackImage(UIImage(named: "minimumTrack")?
            .withRenderingMode(.alwaysTemplate)
            .resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 6.0, bottom: 0, right: 0)), for: .normal)
        
        UISwitch.appearance().onTintColor = theme.mainColor.withAlphaComponent(0.3)
        UISwitch.appearance().thumbTintColor = theme.mainColor
        
        //search bar
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = theme.textColor
        
        UITabBar.appearance().tintColor = theme.tintColor
        
        UITextField.appearance().keyboardAppearance = .dark

        
    }
}