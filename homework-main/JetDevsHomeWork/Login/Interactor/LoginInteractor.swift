import Foundation
import RxSwift

struct LoginInteractor {
    
    static func loginAPICall(username: String, password: String) -> Observable<APIResult<Result>> {
        return APIClient.sharedClient.loginAPICall(email: username, password: password)
    }
}
