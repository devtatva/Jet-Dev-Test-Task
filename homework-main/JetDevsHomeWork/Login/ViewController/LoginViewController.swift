import UIKit
import AVFoundation
import RxSwift

class LoginViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextfield: UITextField!
    @IBOutlet private weak var emailError: UILabel!
    @IBOutlet private weak var passwordError: UILabel!
    @IBOutlet private weak var loginButton: UIButton!
    
    // MARK: - Variables
    private lazy var viewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareView()
    }
    
    // MARK: - PrepareView
    private func prepareView() {
        
        self.loginButton.isEnabled = false
        if #available(iOS 13.0, *) {
            loginButton.backgroundColor = UIColor.systemGray2
        } else {
            loginButton.backgroundColor = UIColor.systemGray
        }
        self.emailTextField.setLeftPaddingPoints(14)
        self.emailTextField.setRightPaddingPoints(14)
        self.passwordTextfield.setLeftPaddingPoints(14)
        self.passwordTextfield.setRightPaddingPoints(14)
        self.viewModel.alertDialog.subscribe(onNext: { [weak self] alertMessage in
            guard let `self` = self else {
                return
            }
            self.showMessage(title: "JetDev", message: alertMessage)
        }).disposed(by: disposeBag)
        viewModel.state.observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] state in
            guard let `self` = self else {
                return
            }
            switch state {
            case .loading:
                self.showProgressActivity()
            case .failure:
                
                self.hideProgressActivity()
            case .success:
                self.hideProgressActivity()
                self.dismiss(animated: true)
                
            }
        }).disposed(by: disposeBag)
    }
    
    private func updateLoginButton(email: String, password: String) {
        if (Utility.shared.isValidEmail(email) == true) &&  (Utility.shared.isValidPassword(password) == true) {
            self.loginButton.isEnabled = true
            loginButton.backgroundColor = AppColors.appBlue
        } else {
            self.loginButton.isEnabled = false
            if #available(iOS 13.0, *) {
                loginButton.backgroundColor = UIColor.systemGray2
            } else {
                loginButton.backgroundColor = UIColor.systemGray
            }
        }
    }
    
    // MARK: - Action Methods
    @IBAction private func dismisButtonTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func loginButtonTap(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextfield.text {
            if (Utility.shared.isValidEmail(emailTextField.text ?? "") == true) &&  (Utility.shared.isValidPassword(passwordTextfield.text ?? "") == true) {
                viewModel.callLoginAPI(email: email, password: password)
            }
        }
    }
}

// MARK: - UITextFieldDelegate Methods
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == passwordTextfield {
            let maxLength = 16
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            updateLoginButton(email: emailTextField.text ?? "", password: newString)
            return newString.count <= maxLength
        } else {
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            updateLoginButton(email: newString, password: passwordTextfield.text ?? "")
        }
        return true
    }
}
