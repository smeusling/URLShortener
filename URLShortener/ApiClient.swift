//
//  ApiClient.swift
//  URLShortener
//
//  Created by Stéphanie Meusling on 16.03.19.
//  Copyright © 2019 smeusling. All rights reserved.
//

import Foundation

class ApiClient {
    
    struct Singleton {
        static let sharedInstance = ApiClient()
    }
    
    class var sharedInstance: ApiClient {
        return Singleton.sharedInstance
    }
    
    func shortenUrl(longUrl: String, completion:@escaping (_ tinyUrl: String?, _ error: String?) ->Void){
        let url = URL(string: "http://tinyurl.com/api-create.php")!
        
        // post the data
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let postString = "url=\(longUrl)"
        let postData = postString.data(using: .utf8)
        request.httpBody = postData
        
        // execute the datatask and validate the result
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if error == nil, let userObject = String(data: data!, encoding: .utf8) {
                completion(userObject, nil)
            }else{
                completion(nil, "Error during the shortening")
            }
        }
        task.resume()
    }
}
