import SwiftUI

// MARK: - View
struct SignUpFormView: View {
    @StateObject private var viewModel = SignUpFormViewModel()
    
    var body: some View {
        Form {
            Section {
                TextField("사용자 이름", text: $viewModel.username)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                Button("사용자 이름 중복 확인") {
                    viewModel.isUsernameAvailable(username: viewModel.username)
                }
            } footer: {
                Text(viewModel.usernameMessage)
                    .foregroundColor(.red)
            }
            
            Section {
                SecureField("비밀번호", text: $viewModel.password)
                SecureField("비밀번호 확인", text: $viewModel.passwordConfirmation)
            } footer: {
                VStack(alignment: .leading) {
                    ProgressView(value: viewModel.passwordStrengthValue, total: 1)
                        .tint(viewModel.passwordStrengthColor)
                        .progressViewStyle(.linear)
                    Text(viewModel.passwordMessage)
                        .foregroundColor(.red)
                }
            }
            
            Section {
                Button("회원가입") {
                    print("회원가입 시도: \(viewModel.username)")
                }
                .disabled(!viewModel.isValid)
            }
        }
    }
}
