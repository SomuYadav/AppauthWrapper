//
//  ViewController.swift
//  AppauthWrapper
//
//  Created by Somendra Yadav on 06/07/20.
//  Copyright © 2020 Somendra Yadav. All rights reserved.
//

#if canImport(UIKit)
import UIKit
import AppAuth

open class AppAuth: NSObject {

   /*
    * The key under which the authorization state will be saved in a keyed archive.
    */
    let authStateKey = "authState"
    
    // property of the containing class
    public static var authState: OIDAuthState?
    
    var clientID: String?
    var clientSecret: String?
    var redirectURI: String?
    var authorization_scope: String?
    var registration_endpoint_uri: String?
    var user_info_endpoint_uri: String?
    var issuer: URL?
    var authorizationEndpoint: URL?
    var tokenEndpoint: URL?
    var endSessionPointsURL: String?
    var configuration: OIDServiceConfiguration?
    
    // @typealias closure
    public typealias completionHandler = (_ Success: Bool) -> Void
    public typealias completionAuthorizationFlow = (OIDExternalUserAgentSession) -> Void
    public typealias completionHandlerStatusCode = (_ statusCode: Int?,_ desc: String) -> Void
    
    public init(_ clientID: String,_ clientSecret: String,_ redirectURI: String,_ authorization_scope: String,_ registration_endpoint_uri: String,_ user_info_endpoint_uri: String,_ issuer: URL,_ authorizationEndpoint: URL,_ tokenEndpoint: URL,_ endSessionPointsURL: String) {
        self.clientID                  = clientID
        self.clientSecret              = clientSecret
        self.redirectURI               = redirectURI
        self.authorization_scope       = authorization_scope
        self.registration_endpoint_uri = registration_endpoint_uri
        self.user_info_endpoint_uri    = user_info_endpoint_uri
        self.issuer                    = issuer
        self.authorizationEndpoint     = authorizationEndpoint
        self.tokenEndpoint             = tokenEndpoint
        self.endSessionPointsURL       = endSessionPointsURL
        self.configuration             = OIDServiceConfiguration(authorizationEndpoint: authorizationEndpoint,tokenEndpoint: tokenEndpoint)
    }
}
#endif
