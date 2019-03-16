//
//  ViewController.swift
//  URLShortener
//
//  Created by Stéphanie Meusling on 15.03.19.
//  Copyright © 2019 smeusling. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        return cell
    }
    

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var largeURLTextField: UITextField!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var tinyURLLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    
    @IBAction func convertButtonClicked(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tinyURLLabel.text = "Tcho"
        //ApiClient.sharedInstance.shortenUrl(longUrl: "https://docs.swift.org/swift-book/ReferenceManual/AboutTheLanguageReference.html")
        ApiClient.sharedInstance.shortenUrl(longUrl: "https://docs.swift.org/swift-book/ReferenceManual/AboutTheLanguageReference.html") { (tinyUrl, error) in
            if error == nil {
                print(tinyUrl!)
            }
        }
        //shortenUrl()
    }

    
    
}
