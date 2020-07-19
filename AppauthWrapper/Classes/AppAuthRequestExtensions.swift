//
//  AppAuthRequestExtensions.swift
//  AppauthWrapper
//
//  Created by Somendra Yadav on 06/07/20.
//  Copyright © 2020 Somendra Yadav. All rights reserved.
//

import Foundation
import UIKit
import AppAuth

//=============================================
//MARK: Request for sign-in & sign-out
//=============================================
extension AppAuth {

    /*
     * Performs the authorization code flow.
     *
     * Attempts to perform a request to authorization endpoint by utilizing AppAuth's convenience method.
     *
     * Completes authorization code flow with automatic code exchange.
     *
     * The response is then passed to the completion handler, which lets the caller to handle the results.
     *
     */
    func authorizeWithAutoCodeExchange(_ VC: UIViewController,_ currentAuthorizationFlow: @escaping completionAuthorizationFlow,
        configuration: OIDServiceConfiguration,
        clientId: String,
        redirectionUri: String,
        scopes: [String] = [OIDScopeOpenID, OIDScopeProfile],
        completion: @escaping (OIDAuthState?, Error?) -> Void
        ) {
        
        // Checking if the redirection URL can be constructed.
        guard let redirectURI = URL(string: redirectionUri) else {
            print("Error creating redirection URL for : \(redirectionUri)")
            
            return
        }

        // Building authorization request.
        let request = OIDAuthorizationRequest(configuration: configuration,
                                              clientId: clientID!,
                                              clientSecret: clientSecret,
                                              scopes: [OIDScopeOpenID, OIDScopeProfile],
                                              redirectURL: redirectURI,
                                              responseType: OIDResponseTypeCode,
                                              additionalParameters: nil)
        
        // Making authorization request.
        print("Initiating authorization request with scopes: \(request.scope ?? "no scope requested")")
        
        currentAuthorizationFlow(OIDAuthState.authState(byPresenting: request, presenting: VC) {
            authState, error in
            
            if let authState = authState {
                self.setAuthState(authState)
                print("Got authorization tokens. Access token: " +
                    "\(authState.lastTokenResponse?.accessToken ?? "nil")")
            } else {
                print("Authorization error: \(error?.localizedDescription ?? "Unknown error")")
                self.setAuthState(nil)
            }
            
            completion(authState, error)
        })
    }
    
    // get error in second parameter if we get error
    public func getRefreshToken() -> (String?,String?) {
        let userinfoEndpoint = URL(string: user_info_endpoint_uri!)!
        var token: String?
        var errorStr: String?
        
        AppAuth.authState?.performAction() { (accessToken, idToken, error) in
            
            if error != nil  {
                print("Error fetching fresh tokens: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            guard let accessToken = accessToken else {
                return
            }
            
            token    = accessToken
            errorStr = error?.localizedDescription ?? "Unknown error"
            
            // Add Bearer token to request
            var urlRequest = URLRequest(url: userinfoEndpoint)
            urlRequest.allHTTPHeaderFields = ["Authorization": "Bearer \(accessToken)"]
            // Perform request...
        }
        
        return (token,errorStr)
    }
    
    /*
     * Sends a URL request.
     *
     * Sends a predefined request and handles common errors.
     
     - Parameter urlRequest: URLRequest optionally crafted with additional information, which may include access token.
     - Parameter completion: Escaping completion handler allowing the caller to process the response.
     */
    func sendUrlRequest(urlRequest: URLRequest, completion: @escaping (Data?, HTTPURLResponse, URLRequest) -> Void) {
        let task = URLSession.shared.dataTask(with: urlRequest) {
            data, response, error in
            
            DispatchQueue.main.async {
                guard error == nil else {
                    // Handling transport error
                    print("HTTP request failed \(error?.localizedDescription ?? "")")
                    
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    // Expecting HTTP response
                    print("Non-HTTP response")
                    
                    return
                }
                
                completion(data, response, urlRequest)
            }
        }
        
        task.resume()
    }
}

