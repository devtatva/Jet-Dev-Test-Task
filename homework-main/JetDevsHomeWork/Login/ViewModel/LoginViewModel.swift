import Alamofire
import Foundation
import RxSwift
import RxRelay
import RxDataSources
import RxCocoa

final class LoginViewModel: BaseViewModel {
    
    var state = PublishSubject<ViewModelState<LoginViewModel>>()
    var getPhyData = PublishSubject<ViewModelState<LoginViewModel>>()

    var username: BehaviorRelay<String> = BehaviorRelay(value: "")
    var password: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    var isValidFirstname: Driver<Bool>
    var isValidaPassword: Driver<Bool>
    var currentUser: UserData?
    var updateDeviceToken = PublishSubject<Void>()
    var newDeviceTokenAfterSignout = String()
    
    override init() {
        self.isValidFirstname = username.asObservable().map { ($0.count) > 0 }.asDriver(onErrorJustReturn: false)
        self.isValidaPassword = password.asObservable().map { ($0.count) > 0  }.asDriver(onErrorJustReturn: false)
    }
    
    func callLoginAPI(email: String, password: String) {
        
        self.state.onNext(.loading)
        LoginInteractor.loginAPICall(username: email, password: password)
            .observeOn(SerialDispatchQueueScheduler(qos: .default))
            .subscribe(onNext: { [weak self] (result) in
                guard let `self` = self else {
                    return
                }
                switch result {
                case .success(let response):
                    if response.data != nil {
                        self.currentUser = response.data
                        Utility.shared.setLoggedInUserInfo(user: self.currentUser)
                    }
                    self.state.onNext(.success(self))
                case .failure(let error):
                    print(error)
                    self.alertDialog.onNext(error)
                    self.state.onNext(.failure)
                }
            }).disposed(by: disposeBag)
    }
}
