import Foundation
import RxAlamofire
import RxSwift
import Alamofire

enum APIResult <Value> {
    
    case success(value: Value)
    
    case failure(error: String)
    
    // Remove it if not needed.
    init(_ result: () throws -> Value) {
        do {
            let value = try result()
            self = .success(value: value)
        } catch let error {
            print(error.localizedDescription)
            self = .failure(error: error.localizedDescription)
        }
    }
}

class APIClient {
    
    static let sharedClient = APIClient()
    
    func loginAPICall(email: String, password: String) -> Observable<APIResult<Result>> {
        let param: [String: Any] = ["email": email, "password": password]
        
        return self.handleDataRequest(dataRequest: APIManager.shared.requestObservable(api: loginAPIURL, params: param)).map { (response) -> APIResult<Result> in
            
            if let responseData = response, let loginStatus = responseData.resultStatus, loginStatus
                == 1 {
                return APIResult.success(value: responseData)
            } else {
                
                return APIResult.failure(error: response?.errorMessage ?? "Something went wrong. Try again later.")
            }
        }
        
    }
    @discardableResult
    func handleDataRequest(dataRequest: Observable<DataRequest>) -> Observable<Result?> {
        
        return Observable<Result?>.create({ (observer) -> Disposable in
            dataRequest.observeOn(MainScheduler.instance).subscribe({ (event) in
                
                switch event {
                    
                case .next(let eventResponse):
                    print(eventResponse.debugDescription)
                    eventResponse.responseJSON(completionHandler: { (dataResponse) in
                        print("******* \(String(describing: dataResponse.response)) *******")
                        switch dataResponse.result {
                        case .success(let data):
                            
                            let jsonDecoder = JSONDecoder()
                            do {
                                if let responseHeader = eventResponse.response?.allHeaderFields, let strxAcc = responseHeader["X-Acc"] as? String {
                                    Utility.shared.saveXAccToken(data: strxAcc as NSString)
                                }
                                let jsonData = try JSONSerialization.data(withJSONObject: data)
                                let json = try jsonDecoder.decode(Result.self, from: jsonData)
                                let resultData = json
                                observer.onNext(resultData)
                                
                            } catch {
                                observer.onNext(nil)
                            }
                        case .failure(let error):
                            print(error)
                            observer.onNext(nil)
                            observer.on(.completed)
                        }
                    })
                case .error(let error):
                    print(error)
                    observer.on(.next(nil))
                case .completed:
                    observer.onCompleted()
                }
            })
        })
    }
}
