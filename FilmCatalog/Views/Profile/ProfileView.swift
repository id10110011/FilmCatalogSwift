import SwiftUI

struct ProfileView: View {
    @Binding var isAuthenticated: Bool
    @State var userInfo: UserInfo = UserInfo(email: "")
    @State var isEditing: Bool = false
    @State var isLoading: Bool = false
    @State var pageError: String = ""
    
    func editProfile() async {
        if (isEditing) {
            do {
                isLoading = true
                
                defer {
                    isLoading = false
                }
                
                guard let newUserData = try await UsersManager.shared.updateUser(data: userInfo) else {
                    pageError = "Error while updating profile"
                    return
                }
                
                userInfo = newUserData
            } catch {
                pageError = error.localizedDescription
                pageError.removeLast()
            }
        }
        isEditing.toggle()
    }
    
    func logOut() {
        do {
            try AuthManager.shared.logOut()
            isAuthenticated = false
        } catch {
            pageError = error.localizedDescription
            pageError.removeLast()
        }
    }
    
    func deleteAccount() async {
        do {
            try await AuthManager.shared.deleteUserAuth()
            try await UsersManager.shared.deleteUserDB(email: userInfo.email)
            isAuthenticated = false
        } catch {
            pageError = error.localizedDescription
            pageError.removeLast()
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Profile")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.bottom, 12)
                    .padding(.top, 64)
                
                Text(userInfo.email)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.bottom, 18)
                
                ProfileInputView(value: $userInfo.firstname, placeholder: "Firstname", isEditing: isEditing)
                ProfileInputView(value: $userInfo.lastname, placeholder: "Lastname", isEditing: isEditing)
                ProfileInputView(value: $userInfo.dateOfBirth, placeholder: "Date of birth", isEditing: isEditing)
                ProfileInputView(value: $userInfo.country, placeholder: "Country", isEditing: isEditing)
                ProfileInputView(value: $userInfo.city, placeholder: "City", isEditing: isEditing)
                ProfileInputView(value: $userInfo.education, placeholder: "Education", isEditing: isEditing)
                ProfileInputView(value: $userInfo.gender, placeholder: "Gender", isEditing: isEditing)
                ProfileInputView(value: $userInfo.description, placeholder: "Description", isEditing: isEditing)
                
                ErrorView(text: pageError)
                
                ButtonView(action: editProfile, text: isEditing ? "Save changes" : "Edit profile", disabled: isLoading, color: Color.green)
                    .padding(.top, pageError.isEmpty ? 0 : 14)
                
                ButtonView(action: logOut, text: "Logout", disabled: isLoading, color: Color.green)
                    .padding(.top, 6)
                
                ButtonView(action: deleteAccount, text: "Delete account", disabled: isLoading, color: Color(red: 0.78, green: 0, blue: 0.16, opacity: 1))
                    .padding(.top, 24)
                    .padding(.bottom, 100)
            }
            .frame(maxWidth: .infinity)
        }
        .background(Color.black.opacity(0.95))
        .ignoresSafeArea(.all)
        .onAppear {
            fetchUserInfo()
        }
    }
    
    private func fetchUserInfo() {
        if let authUser = AuthManager.shared.getAuthenticatedUser() {
            Task {
                do {
                    guard let user = try await UsersManager.shared.getUser(email: authUser.email) else {
                        pageError = "Error while getting profile info"
                        return
                    }
                    
                    userInfo = user
                } catch {
                    pageError = error.localizedDescription
                    pageError.removeLast()
                }
            }
        }
    }
}

#Preview {
    ProfileView(isAuthenticated: .constant(true))
}
