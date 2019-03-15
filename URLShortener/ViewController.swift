//
//  ViewController.swift
//  URLShortener
//
//  Created by Stéphanie Meusling on 15.03.19.
//  Copyright © 2019 smeusling. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    @IBOutlet weak var urlLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        urlLabel.text = "Tcho"
        shortenUrl()
    }

    func shortenUrl() {
        let url = URL(string: "http://tinyurl.com/api-create.php")!
        
        // post the data
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let postData = "url=https://docs.swift.org/swift-book/ReferenceManual/AboutTheLanguageReference.html".data(using: .utf8)
        request.httpBody = postData
        
        // execute the datatask and validate the result
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            if error == nil, let userObject = String(data: data!, encoding: .utf8) {
                print(userObject)
            }
        }
        task.resume()
    }
    
}
