//
//  Extensions.swift
//  KadamaVnext
//
//  Created by mobile on 21/07/21.
//

import Foundation
import UIKit

class AlertFactory{
    
    
    static func showAlert(title:String? = nil,message:String,completion:( (_ result: Bool) -> Void)? = nil) {
        AlertFactory.showAlert(title: title ?? "", message: message, cancelTitle: "", okTitle: "Ok", completion: completion)
    }
    
    func showLogoutAlert(title:String,message:String,completion:( (_ result: Bool) -> Void)?) {
        
        AlertFactory.showAlert(title: title, message: message, cancelTitle: "No", okTitle: "Yes", completion: completion)
    }
    
    static func showConfirmAlert(title:String,message:String,completion:( (_ result: Bool) -> Void)?) {
        
        AlertFactory.showAlert(title: title, message: message, cancelTitle: "Edit", okTitle: "Confirm", completion: completion)
        
    }
    
    
    
    static func showAlert(title:String,message:String,cancelTitle:String,okTitle:String,completion:( (_ result: Bool) -> Void)?) {
        DispatchQueue.main.async {
            let window = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: okTitle, style: .default, handler: { (action) -> Void in
                completion?(true)
            })
            if !cancelTitle.isEmpty {
                let cancel = UIAlertAction(title: cancelTitle, style: .destructive, handler: { (action) -> Void in
                    completion?(false)
                })
                alertController.addAction(cancel)
            }
            alertController.addAction(ok)
            window?.visibleViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    
}

public extension UIWindow {
    var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(vc: self.rootViewController)
    }
    
    static func getVisibleViewControllerFrom(vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(vc: nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(vc: tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(vc: pvc)
            } else {
                return vc
            }
        }
    }
}
