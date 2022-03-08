//
//  AuthManager.swift
//  Spotify
//
//  Created by THANSEEF on 08/03/22.
//

import Foundation

final class AuthManger {
    
    struct Constants {
        static let clientID = "085a2de5b7ed476b9a6ded73a096f7f9"
        static let clientSecret = "5c6235ce50be4bb09397a1a54c0306b3"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let scopes = "user-read-private%20playlist-modify-public%20playlist-modify-private%20playlist-read-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
        static let redirectURI = "https://www.eclidse.com/"
    }
    
    static let shared = AuthManger()
    
    private init() {}
    
    public var signInURL : URL? {
        
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        return URL(string: string)
    }
    
    var isSignedIn : Bool {
        //if access token is there then only it would return.
        return accessToken != nil
    }
    
    private var accessToken : String? {
        //accessing local storage saved file using forkey.
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken : String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokeExpirationDate : Date? {
        //downcasting as date.
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken : Bool {
        guard let expirationDate = tokeExpirationDate else {
            return false
        }
        let currentDate = Date()
        let fiveMinutes : TimeInterval = 300
        //checking the current time intervel 300(5min) is greaterthan equel to 3600 it will only return true.
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    public func exchangeCodeForToken(code : String, completion : @escaping ((Bool) -> Void)) {
        //get token here
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        var components = URLComponents()
        //query item header type with body creating.
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
        ]
        
        //json parsing
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        //concatinating client id and client secret id
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        //converting to utf8
        let data = basicToken.data(using: .utf8)
        //converting to base64encoded format.
        guard let base64String = data?.base64EncodedString() else {
            print("faliure to get base64")
            completion(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        //[weak self] is used to avoid memory leak.
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data,error == nil else {
                completion(false)
                return
            }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                completion(true)
                //                print("success \(json)")
            }catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    
    public func refreshIfNeeded(completion: @escaping (Bool) -> Void){
//        guard shouldRefreshToken else {
//            completion(true)
//            return
//        }
        
        guard let refreshToken = self.refreshToken else {
            return
        }
        
        //refresh token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        var components = URLComponents()
        //query item header type with body creating.
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken),
        ]
        
        //json parsing
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        //concatinating client id and client secret id
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        //converting to utf8
        let data = basicToken.data(using: .utf8)
        //converting to base64encoded format.
        guard let base64String = data?.base64EncodedString() else {
            print("faliure to get base64")
            completion(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        //[weak self] is used to avoid memory leak.
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data,error == nil else {
                completion(false)
                return
            }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
//                print("Successfully Refreshed")
                self?.cacheToken(result: result)
                completion(true)
                //print("success \(json)")
            }catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
        
    }
    public func cacheToken(result : AuthResponse){
        //saving the response to user local storage with key value pair.
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        //optional binding because the field we have changed to optional.
        if let refreshToken = result.refresh_token {
            UserDefaults.standard.setValue(refreshToken, forKey: "refresh_token")
        }
        
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
    }
}
