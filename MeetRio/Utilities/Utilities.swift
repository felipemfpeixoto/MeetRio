//
//  UIApplicationExtension.swift
//  MeetRio
//
//  Created by Felipe on 16/08/24.
//
import SwiftUI
import Foundation


@Observable
class ToastVariables{
    static let shared = ToastVariables()
    
    // Add to calendar Button
    var isOnAdd: Bool = false
    var isOnRemove: Bool = false
    
    // Call Siri Button
    var isOnAddCalendar: Bool = false
    
    // Translate Button
    var isOnTranslate: Bool = false
    var isTranslated: Bool = false
    var isTranslateError: Bool = false
    
    // Image changed
    var isImageChanged: Bool = false
    var isImageChangedError: Bool = false
    var isImageRequest: Bool = false
}


final class Utilities {
    
    static let shared = Utilities()
    private init() {}
    
    @MainActor
    func topViewController(controller: UIViewController? = nil) -> UIViewController? {
        
        let controller = controller ?? UIApplication.shared.keyWindow?.rootViewController
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}


import UIKit

// VisualEffectBlur Customizado
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
