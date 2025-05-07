//
//  LoginView.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 04.03.2025.
//

import SwiftUI
import ShroomHubDesignLibrary
import FirebaseAuthPackage
import SHUtils
import SHNavigation

struct LoginView: View {
    @EnvironmentObject private var router: NavigationRouter
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var loginState: LoadableState<Void, Error> = .idle
    let authManager: FirebaseAuthenticator
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            Text(header)
                .font(.bold30)
            Text(subHeadear)
                .font(.regular16)
            emailField
            passwordField
            forgotPassword
            divider
            Spacer()
            loginButton
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, Spacing.medium)
        .padding(.horizontal, Spacing.medium)
    }
}

// MARK: - Views
private extension LoginView {
    @ViewBuilder
    var emailField: some View {
        VStack(alignment: .leading) {
            Text("Email")
                .font(.bold16)
            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(SHColor.forestGreen)
                TextField(text: $email) {
                    Text("Email")
                        .font(.bold14)
                        .foregroundStyle(SHColor.forestGreen)
                }
                .foregroundStyle(SHColor.forestGreen)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
            }
            .padding()
            .background(SHColor.mistWhite)
            .cornerRadius(CornerRadius.medium)
        }
    }
    
    @ViewBuilder
    var passwordField: some View {
        VStack(alignment: .leading) {
            Text("Password")
                .font(.bold16)
            HStack {
                Image(systemName: "lock")
                    .foregroundStyle(SHColor.forestGreen)
                if isPasswordVisible {
                    TextField(text: $password) {
                        Text("Password")
                            .font(.bold14)
                            .foregroundStyle(SHColor.forestGreen)
                    }
                } else {
                    SecureField(text: $password) {
                        Text("Password")
                            .font(.bold14)
                            .foregroundStyle(SHColor.forestGreen)
                    }
                }
                Spacer()
                Button {
                    isPasswordVisible.toggle()
                } label: {
                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                        .foregroundStyle(SHColor.forestGreen)
                }
            }
            .padding()
            .background(SHColor.mistWhite)
            .cornerRadius(CornerRadius.medium)
        }
    }
    
    @ViewBuilder
    var forgotPassword: some View {
        HStack {
           Spacer()
            Button {
                print("login")
            } label: {
                Text(forgotPasswordString)
                    .font(.bold16)
                    .foregroundStyle(SHColor.forestGreen)
            }

        }
    }
    
    @ViewBuilder
    var divider: some View {
        HStack(spacing: Spacing.small) {
            Rectangle()
                .foregroundStyle(SHColor.lightGray)
                .frame(height: 1)
            Text(dividerString)
            Rectangle()
                .foregroundStyle(SHColor.lightGray)
                .frame(height: 1)
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    var loginButton: some View {
        SHLoadableButton(
            label: {
                Text(loginString)
            },
            state: $loginState,
            style: .primary) {
                await $loginState.load {
                    try await authManager.signIn(email: email,
                                       password: password)
                    router.navigate(to: AppRootDestination.dashboard)
                }
            }
        
    }
}
            
// MARK: - Strings
private extension LoginView {
    var header: String {
        "Welcome Back!"
    }
    
    var subHeadear: String {
        "Let's Continue Your Journey"
    }
    
    var forgotPasswordString: String {
        "Forgot Password?"
    }
    
    var registerString: String {
        "Sign up"
    }
    
    var loginString: String {
        "Log in"
    }
    
    var dividerString: String {
        "or"
    }
}

#Preview {
    LoginView(authManager: FirebaseAuthenticator())
}
