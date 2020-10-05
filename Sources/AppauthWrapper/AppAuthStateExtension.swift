//
//  AppAuthStateExtension.swift
//  AppauthWrapper
//
//  Created by Somendra Yadav on 06/07/20.
//  Copyright © 2020 Somendra Yadav. All rights reserved.
//

#if canImport(UIKit)
import Foundation
import UIKit
import AppAuth

//=============================================
// MARK: OIDAuthState methods
//=============================================
extension AppAuth {
    /*
     * Saves authorization state in a storage.
     *
     * As an example, the user's defaults database serves as the persistent storage.
     *
     */
    func saveState() {
        var data: Data? = nil
        
        if let authState = AppAuth.authState {
            if #available(iOS 12.0, *) {
                data = try! NSKeyedArchiver.archivedData(withRootObject: authState, requiringSecureCoding: false)
            } else {
                data = NSKeyedArchiver.archivedData(withRootObject: authState)
            }
        }
        
        UserDefaults.standard.set(data, forKey: authStateKey)
        UserDefaults.standard.synchronize()
        
        print("Authorization state has been saved.")
    }
    
    /*
     *
     * Reacts on authorization state changes events.
     *
     */
    public func stateChanged() {
        self.saveState()
    }
    
    /*
     * Assigns the passed in authorization state to the class property.
     *
     * Assigns this controller to the state delegate property.
     *
     */
    func setAuthState(_ authState: OIDAuthState?) {
        if (AppAuth.authState != authState) {
            AppAuth.authState = authState
            
            AppAuth.authState?.stateChangeDelegate = self
            
            self.stateChanged()
        }
    }
    
    /*
     * Loads authorization state from a storage.
     *
     * As an example, the user's defaults database serves as the persistent storage.
     *
     */
    public func loadState() {
        guard let data = UserDefaults.standard.object(forKey: authStateKey) as? Data else {
            return
        }
        
        var authState: OIDAuthState? = nil
        
        if #available(iOS 12.0, *) {
            authState = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? OIDAuthState
        } else {
            authState = NSKeyedUnarchiver.unarchiveObject(with: data) as? OIDAuthState
        }
        
        if let authState = authState {
            print("Authorization state has been loaded.")
            
            self.setAuthState(authState)
        }
    }
    
    /*
     *
     * Displays selected information from the current authorization data.
     *
     */
    public func showState() {
        print("Current authorization state: ")
        
        print("Access token: \(AppAuth.authState?.lastTokenResponse?.accessToken ?? "none")")
        
        print("ID token: \(AppAuth.authState?.lastTokenResponse?.idToken ?? "none")")
        
        print("Expiration date: \(String(describing: AppAuth.authState?.lastTokenResponse?.accessTokenExpirationDate))")
    }
}

//=============================================
// MARK: Authorization methods
//=============================================
extension AppAuth {
    // . . .
    
    /*
     * Authorizes the Relying Party with an OIDC Provider.
     
     - Parameter issuerUrl: The OP's `issuer` URL to use for OpenID configuration discovery
     - Parameter configuration: Ready to go OIDServiceConfiguration object populated with the OP's endpoints
     - Parameter completion: (Optional) Completion handler to execute after successful authorization.
     */
    func authorizeRp(_ VC: UIViewController,issuerUrl: String?, configuration: OIDServiceConfiguration?, completion: ((Bool) -> Void)? = nil,_ currentAuthorizationFlow: @escaping completionAuthorizationFlow,_ status: @escaping completionHandlerStatusCode) {
        /*
         * Performs authorization with an OIDC Provider configuration.
         
         A nested function to complete the authorization process after the OP's configuration has became available.
         
         - Parameter configuration: Ready to go OIDServiceConfiguration object populated with the OP's endpoints
         */
        func authorize(configuration: OIDServiceConfiguration) {
            print("Authorizing with configuration: \(configuration)")
            
            self.authorizeWithAutoCodeExchange(VC, currentAuthorizationFlow,
                configuration: configuration,
                clientId: clientID!,
                redirectionUri: redirectURI!
            ) {
                authState, error in
                
                if let authState = authState {
                    self.setAuthState(authState)
                    print("Successful authorization.")
                    
                    self.showState()
                    
                    if let completion = completion {
                        completion(true)
                    }
                } else {
                    print("Authorization error: \(error?.localizedDescription ?? "")")
                    if let completion = completion {
                        completion(false)
                    }
                    self.setAuthState(nil)
                }
                
                status(nil,error?.localizedDescription ?? "")
            }
        }
        
        //Accepting passed-in OP configurati
        authorize(configuration: configuration!)
    }
}

//=============================================
// MARK: Manage Sign-In & Sign-Out
//=============================================
extension AppAuth {
    /*
     *
     * Responds to the UI and initiates the authorization flow.
     *
     */
    public func signIn(_ VC: UIViewController,_ callBack: @escaping completionHandler,_ currentAuthorizationFlow: @escaping completionAuthorizationFlow,_ status: @escaping completionHandlerStatusCode) {
        authorizeRp(VC,issuerUrl: issuer!.absoluteString, configuration: configuration,completion: {callBack($0)}, currentAuthorizationFlow,status)
    }
    
    /*
     * Signs out from the app and, optionally, from the OIDC Provider.
     *
     * Resets the authorization state and signs out from the OIDC Provider using its [RP-initiated logout](https://openid.net/specs/openid-connect-session-1_0.html#RPLogout) `end_session_endpoint`.
     *
     */
    public func signOut(_ callBack: @escaping completionHandler,_ statusCode: @escaping completionHandlerStatusCode) {
      
        
        if let idToken = AppAuth.authState?.lastTokenResponse?.idToken {
            /*
             * OIDC Provider `end_session_endpoint`.
             *
             * At the moment, AppAuth does not support [RP-initiated logout](https://openid.net/specs/openid-connect-session-1_0.html#RPLogout), although it [may in the future](https://github.com/openid/AppAuth-iOS/pull/191), and the `end_session_endpoint` is not captured from the OIDC discovery document; hence, the endpoint may need to be provided manually.
             *
             */
            if let endSessionEndpointUrl = URL(string: endSessionPointsURL! + idToken) {
                let urlRequest = URLRequest(url: endSessionEndpointUrl)

                self.sendUrlRequest(urlRequest: urlRequest) {
                    data, response, request in
                    
                    var strData: String?
                    
                    if data != nil {
                       strData = (String(describing: String(data: data!, encoding: .utf8)))
                    }
                    
                    if !(200...299).contains(response.statusCode) {
                        // Handling server errors
                        print("RP-initiated logout HTTP response code: \(response.statusCode)")
                        callBack(false)
                    } else {
                        // Clearing the authorization state
                        self.setAuthState(nil)
                        callBack(true)
                    }
                    
                    statusCode(response.statusCode,"\(response.description), Log Out Response:  \(strData ?? "")")
                    
                    if data != nil, data!.count > 0 {
                        // Handling RP-initiated logout errors
                        print("RP-initiated logout response: \(String(describing: String(data: data!, encoding: .utf8)))")
                    }
                }
            }
        }
    }
}

//=============================================
// MARK: OIDAuthState delegates
//=============================================
// . . .
extension AppAuth: OIDAuthStateChangeDelegate {
    /*
     *
     * Responds to authorization state changes in the AppAuth library.
     *
     */
    public func didChange(_ state: OIDAuthState) {
        print("Authorization state change event.")
        self.stateChanged()
    }
}
#endif
