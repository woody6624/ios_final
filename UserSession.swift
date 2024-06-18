//
//  UserSession.swift
//  ios_final
//
//  Created by ios프로젝트 on 6/16/24.
//

//
//  UserSession.swift
//  cheermessage
//
//  Created by ios프로젝트 on 6/16/24.
import Foundation

class UserSession {
    static let shared = UserSession()

    public var currentUser: User?

    var isLoggedIn: Bool {
        return currentUser != nil
    }
    var username: String? {
        return currentUser?.userName
    }

    private init() {}
    
    func loginUser(user: User) {
        currentUser = user
    }

    func logout() {
        currentUser = nil
    }
}

