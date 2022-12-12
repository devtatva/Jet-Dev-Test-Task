//
//  UIViewController+Extensions.swift
//  JetDevsHomeWork
//
//  Created by pcq186 on 12/12/22.
//

import UIKit

extension UIViewController {
    
    func showMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
