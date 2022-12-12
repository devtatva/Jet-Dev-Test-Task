import Foundation
import RxSwift
import RxCocoa

enum ViewModelState<T> {
    case loading
    case failure
    case success(T)
}

enum CoordinatorError {
    case noInternetConnection
    case tokenExpired
}

typealias CoordinationTask = (() -> Void)?

class BaseViewModel {
    
    // Dispose Bag
    let disposeBag = DisposeBag()
    let alertDialog = PublishSubject<(String)>()
    let toastMessage = PublishSubject<(String)>()
    static let coordinatorError = PublishSubject<(CoordinationTask, CoordinatorError)>()
    static let reloadDashboard = PublishSubject<(Bool)>()
    static let backFromSendMail = PublishSubject<([URL])>()
}
