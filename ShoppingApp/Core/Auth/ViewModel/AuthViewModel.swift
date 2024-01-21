//
//  AuthViewModel.swift
//  ShoppingApp
//
//  Created by Andrii Piddubnyi on 1/14/24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

protocol AuthenicationFormProtocol{
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
        } catch {
            print("Debug: Failed to log in. ERROR: 24234")
        }
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do{
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email)
            let encodedUser = try Firestore.Encoder().encode(user) 
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
          } catch {
              fatalError("Debug: Fialded to create user with error \(error.localizedDescription)")
        }
    }
    
    func resetPassword() async throws {
        Auth.auth().sendPasswordReset(withEmail: "apiddubnij21@gmail.com") { error in
            // Your code here
            print("Error ")
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            fatalError("Debug: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func fetchUser() async{
        guard let uid = Auth.auth().currentUser?.uid else { return}
        
        guard let snapshot =  try? await
                Firestore.firestore().collection("users").document(uid).getDocument() else {return}
        self.currentUser = try? snapshot.data(as: User.self)
    }
}


