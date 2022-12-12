import UIKit
import AVFoundation
import RxSwift

class LoginViewController: UIViewController {

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextfield: UITextField!
    @IBOutlet private weak var emailError: UILabel!
    @IBOutlet private weak var passwordError: UILabel!
    @IBOutlet private weak var loginButton: UIButton!
    
    private lazy var viewModel = LoginViewModel(viewController: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareView()
    }
    
    private func prepareView() {
        
        self.emailTextField.setLeftPaddingPoints(14)
        self.emailTextField.setRightPaddingPoints(14)
        self.passwordTextfield.setLeftPaddingPoints(14)
        self.passwordTextfield.setRightPaddingPoints(14)
    }

    @IBAction private func dismisButtonTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func loginButtonTap(_ sender: Any) {
        
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField {
            let isVaidEmail = Utility.shared.isValidEmail(textField.text ?? "")
            if isVaidEmail == false {
                emailError.text = "This is a invalid email."
            } else {
                emailError.text = ""
            }
        } else if textField == passwordTextfield {
            let isVaidPassword = Utility.shared.isValidPassword(textField.text ?? "")
            if isVaidPassword == false {
                passwordError.text = "Passwords require at least 1 uppercase, 1 lowercase, and 1 number."
                
            } else {
                passwordError.text = ""
            }
        }
    }
}
