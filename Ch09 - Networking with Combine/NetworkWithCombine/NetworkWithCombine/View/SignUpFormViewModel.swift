import SwiftUI
import Combine

class SignUpFormViewModel: ObservableObject {
    private var authenticationService = AuthenticationService()
    
    // MARK: Input
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var passwordConfirmation: String = ""
    
    // MARK: Output
    @Published var usernameMessage: String = ""
    @Published var passwordMessage: String = ""
    @Published var passwordStrengthValue: Double = 0.0
    @Published var passwordStrengthColor: Color = .red
    @Published var isValid: Bool = false

    private lazy var isUsernameLengthValidPublisher: AnyPublisher<Bool, Never> = {
        $username
            .map { $0.count >= 3 }
            .eraseToAnyPublisher()
    }()
    
    private lazy var isUsernameAvailablePublisher: AnyPublisher<Bool, Never> = {
        $username
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()  // jonyive [일시정지 후 1초 대기] s 입력 [백스페이스로 s지우기] 용도
            .flatMap { username -> AnyPublisher<Bool, Never> in
                self.authenticationService.checkUserNameAvailable(userName: username)
            }
            .receive(on: DispatchQueue.main)
            .share()
            .eraseToAnyPublisher()
    }()
    
    enum UserNameValid {
        case valid
        case tooShort
        case notAvailable
    }
    
    private lazy var isUsernameValidPublisher: AnyPublisher<UserNameValid, Never> = {
        Publishers.CombineLatest(isUsernameLengthValidPublisher, isUsernameAvailablePublisher).map { longEnough, available in
            if !longEnough {
                return .tooShort
            }
            if !available {
                return .notAvailable
            }
            return .valid
        }
        .share()
        .eraseToAnyPublisher()
    }()
    
    private lazy var isPasswordEmptyPublisher: AnyPublisher<Bool, Never> = {
        $password
            .map(\.isEmpty)
            .eraseToAnyPublisher()
    }()
    
    private lazy var isPasswordLengthValidPublisher: AnyPublisher<Bool, Never> = {
        $password
            .map { $0.count >= 8 }
            .eraseToAnyPublisher()
    }()
    
    private lazy var isPasswordMatchingPublisher: AnyPublisher<Bool, Never> = {
        Publishers.CombineLatest($password, $passwordConfirmation)
            .map(==)
            .eraseToAnyPublisher()
    }()
    
    private lazy var isPasswordValidPublisher: AnyPublisher<Bool, Never> = {
        Publishers.CombineLatest3(isPasswordEmptyPublisher, isPasswordLengthValidPublisher, isPasswordMatchingPublisher)
            .map { !$0 && $1 && $2 }
            .eraseToAnyPublisher()
    }()
    
    private lazy var isFormValidPublisher: AnyPublisher<Bool, Never> = {
        Publishers.CombineLatest(isUsernameValidPublisher, isPasswordValidPublisher)
            .map { ($0 == .valid) && $1 }
            .eraseToAnyPublisher()
    }()
    
    func isUsernameAvailable(username: String) {
        authenticationService.checkUserNameAvailableWithClosure(userName: username) { result in
            if case let .success(isAvailable) = result {
                print("Available: \(isAvailable)")
            } else if case let .failure(error) = result {
                print(error)
            }
        }
    }
    
    init() {
        isFormValidPublisher
            .assign(to: &$isValid)
        
        isUsernameValidPublisher
            .map { valid in
                switch valid {
                case .tooShort:
                    return "사용자 이름은 최소 3자 이상이어야 합니다."
                case .notAvailable:
                    return "이미 사용 중인 사용자 이름입니다. 다른 이름을 시도해보세요."
                default:
                    return ""
                }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$usernameMessage)
        
        $password
            .map { Double(min($0.count, 12)) / 12.0 }
            .assign(to: &$passwordStrengthValue)
        
        $password
            .map {
                switch $0.count {
                case 0..<4: return Color.red
                case 4..<8: return Color.orange
                case 8...: return Color.green
                default: return Color.red
                }
            }
            .assign(to: &$passwordStrengthColor)
        
        Publishers.CombineLatest3(
            isPasswordEmptyPublisher,
            isPasswordLengthValidPublisher,
            isPasswordMatchingPublisher
        )
        .map { isEmpty, isLongEnough, isMatching in
            if isEmpty {
                return "비밀번호를 입력해주세요."
            } else if !isLongEnough {
                return "비밀번호는 최소 8자 이상이어야 합니다."
            } else if !isMatching {
                return "비밀번호가 일치하지 않습니다."
            }
            return ""
        }
        .assign(to: &$passwordMessage)
    }
}
