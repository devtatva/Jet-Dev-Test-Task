//
//  Utility.swift
//  JetDevsHomeWork
//
//  Created by pcq186 on 12/12/22.
//

import Foundation

class Utility {
    
    static let shared = Utility()
    
    func setLoggedInUserInfo(user: User?) {
        let key = "user"
        if let user = user {
            if let encodedData = try? JSONEncoder().encode(user) {
                UserDefaults.standard.set(encodedData, forKey: key)
            }
        } else {
            UserDefaults.standard.removeObject(forKey: key)
        }
        UserDefaults.standard.synchronize()
    }
    
    func getLoggedInUserInfo() -> User? {
        let key = "user"
        if let user = UserDefaults.standard.object(forKey: key) as? Data {
            let decoder = JSONDecoder()
            if let storedUser = try? decoder.decode(User.self, from: user) {
                return storedUser
            }
        }
        return nil
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let passRegEx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,16}$"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passRegEx)
        return passwordPred.evaluate(with: password)
    }
}
