//
//  AccountViewController.swift
//  JetDevsHomeWork
//
//  Created by Gary.yao on 2021/10/29.
//

import UIKit
import Kingfisher

class AccountViewController: UIViewController {

    // MARK: - IBOutlets
	@IBOutlet weak var nonLoginView: UIView!
	@IBOutlet weak var loginView: UIView!
	@IBOutlet weak var daysLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var headImageView: UIImageView!
    
    // MARK: - Life Cycle Methods
	override func viewDidLoad() {
        super.viewDidLoad()

		self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let user = Utility.shared.getLoggedInUserInfo() {
            print(user)
            nonLoginView.isHidden = true
            loginView.isHidden = false
            
            setLoggedInUI(user: user)
            
        } else {
            nonLoginView.isHidden = false
            loginView.isHidden = true
        }
    }
    
    // MARK: - Set UI
    private func setLoggedInUI(user: UserData?) {
        
        nameLabel.text = user?.user?.username
        
        if let imageUrl = user?.user?.userProfileUrl {
            headImageView.setImage(with: imageUrl)
        }
        
        if let createdDate = user?.user?.createdAt?.dateFromCustomString(withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") {
        let components = Set<Calendar.Component>([.day])
        let createdDate = Calendar.current.dateComponents(components, from: createdDate, to: Date())
            daysLabel.text = "Created \(createdDate.day ?? 0) days ago"
        }
    }
	
    // MARK: - Action Methods
	@IBAction func loginButtonTap(_ sender: UIButton) {
        let loginViewController = LoginViewController()
        loginViewController.modalPresentationStyle = .fullScreen
        self.present(loginViewController, animated: true, completion: nil)
	}
}
