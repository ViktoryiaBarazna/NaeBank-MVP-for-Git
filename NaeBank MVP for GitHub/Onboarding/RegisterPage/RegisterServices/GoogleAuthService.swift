//
//  GoogleAuthService.swift
//  NaeBank
//

import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import UIKit

protocol GoogleAuthServiceProtocol: AnyObject {
    func signIn(
        presentingViewController: UIViewController,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}

final class GoogleAuthService: GoogleAuthServiceProtocol {

    func signIn(
        presentingViewController: UIViewController,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(.failure(GoogleAuthServiceError.missingClientID))
            return
        }

        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)

        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { result, error in
            if let error {
                completion(.failure(error))
                return
            }

            guard
                let user = result?.user,
                let idToken = user.idToken?.tokenString
            else {
                completion(.failure(GoogleAuthServiceError.missingToken))
                return
            }

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )

            Auth.auth().signIn(with: credential) { _, error in
                if let error {
                    completion(.failure(error))
                    return
                }

                Self.persistSession()
                completion(.success(()))
            }
        }
    }

    private static func persistSession() {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "isLoggedIn")
        defaults.set(true, forKey: "onboardingCompleted")
    }
}

enum GoogleAuthServiceError: LocalizedError {
    case missingClientID
    case missingToken

    var errorDescription: String? {
        switch self {
        case .missingClientID:
            return "Google client ID is missing."
        case .missingToken:
            return "Google authorization token is missing."
        }
    }
}
