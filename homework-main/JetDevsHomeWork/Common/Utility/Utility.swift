import Foundation

class Utility {
    
    static let shared = Utility()
    
    func setLoggedInUserInfo(user: UserData?) {
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
    
    func getLoggedInUserInfo() -> UserData? {
        let key = "user"
        if let user = UserDefaults.standard.object(forKey: key) as? Data {
            let decoder = JSONDecoder()
            if let storedUser = try? decoder.decode(UserData.self, from: user) {
                return storedUser
            }
        }
        return nil
    }
    
    func setStrxAcc(strxAcc: String?) {
        let key = "strxAcc"
        if let strxAcc = strxAcc {
            UserDefaults.standard.set(strxAcc, forKey: key)
        }
        UserDefaults.standard.synchronize()
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let passRegEx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{3,17}$"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passRegEx)
        return passwordPred.evaluate(with: password)
    }
    
    func saveXAccToken(service: NSString = "X-Acc", data: NSString) {
        
        let userAccount                   = "X-AccToken"
        let kSecClassValue                = NSString(format: kSecClass)
        let kSecAttrAccountValue          = NSString(format: kSecAttrAccount)
        let kSecValueDataValue            = NSString(format: kSecValueData)
        let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
        let kSecAttrServiceValue          = NSString(format: kSecAttrService)
        
        let dataFromString : NSData = data.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)! as NSData
        
        // Instantiate a new default keychain query
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, dataFromString], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])
        
        // Delete any existing items
        SecItemDelete(keychainQuery as CFDictionary)
        
        // Add the new keychain item
        SecItemAdd(keychainQuery as CFDictionary, nil)
    }
}
