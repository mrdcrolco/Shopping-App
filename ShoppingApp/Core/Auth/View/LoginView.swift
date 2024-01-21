//
//  LoginView.swift
//  ShoppingApp
//
//  Created by Andrii Piddubnyi on 1/14/24.
//

import SwiftUI
import FirebaseAuth


struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack{
            VStack {
                  // image(Logo)
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 249)
                    .padding(.vertical, 32)
                 // form fields
                VStack(spacing: 24){
                    InputView(text: $email, title: "Email Adreess", placeholder: "name@example.com")
                        .autocapitalization(.none)
                    
                    InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)
                }
                .padding(.horizontal)
                .padding(.top, 12)
                //sign in button
                
                Button{
                    Task{
                        try await viewModel.signIn(withEmail: email, password: password)
                    }
                }label: {
                    HStack{
                        Text("SIGNIN")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color(.systemBlue))
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .cornerRadius(10.5)
                .padding(.top, 24)
                Spacer()
                
                //sign up button
                
                NavigationLink{
                    SignUpView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack{
                        Text("Don't have an account?")
                        Text("Sign up")
                    }
                }
                    
                }
            }
        }
    }


extension LoginView: AuthenicationFormProtocol{
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 7
    }
}

#Preview {
    LoginView()
}
