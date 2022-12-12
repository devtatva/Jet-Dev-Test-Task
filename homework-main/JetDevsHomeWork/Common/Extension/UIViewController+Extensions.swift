import UIKit
import SVProgressHUD

extension UIViewController {
    
    func showMessage(title: String, message: String) {
        DispatchQueue.main.async {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showProgressActivity() {
        DispatchQueue.main.async {
            self.view.endEditing(true)
            SVProgressHUD.show(withStatus: "Logging in...")
        }
    }
    
    func hideProgressActivity() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
}
