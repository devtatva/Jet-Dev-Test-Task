import RxSwift
import Alamofire
import RxAlamofire

class APIManager {
    
    static let shared: APIManager = {
        let instance = APIManager()
        return instance
    }()
    
    let sessionManager: SessionManager
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 240
        
        sessionManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    func requestObservable(api: String, params: [String: Any] ) -> Observable<DataRequest> {
        var urlRequest: URLRequest?
        do {
            if let url = URL(string: api) {
                urlRequest = try URLRequest(url: url, method: .post)
            }
            if let postData = (try? JSONSerialization.data(withJSONObject: params, options: [])) {
                urlRequest?.httpBody = postData
            }
        } catch {
            print(error)
        }
        
        return sessionManager.rx.request(urlRequest: urlRequest!)
    }
}
