//
//  ViewController.swift
//  URLShortener
//
//  Created by Stéphanie Meusling on 15.03.19.
//  Copyright © 2019 smeusling. All rights reserved.
//

import UIKit
import Foundation

struct SavedUrl : Codable{
    let longUrl: String
    let tinyUrl: String
    let date: String
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var largeURLTextField: UITextField!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    
    var savedUrlArray:[SavedUrl] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readUrls()
        largeURLTextField.text = "https://docs.swift.org/swift-book/ReferenceManual/AboutTheLanguageReference.html"
    }
    
    @IBAction func convertButtonClicked(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let longUrl = largeURLTextField.text {
            if !longUrl.isEmpty{
                let isCorrectUrl = verifyUrl(urlString: longUrl)
                if isCorrectUrl{
                    ApiClient.sharedInstance.shortenUrl(longUrl: largeURLTextField.text!) { (tinyUrl, error) in
                        if let tinyUrl = tinyUrl {
                            self.addUrlToTableView(savedUrl: SavedUrl(longUrl: longUrl, tinyUrl: tinyUrl, date: dateFormatter.string(from: Date())), error:error)
                        }
                    }
                }else{
                    self.fillStatusLabel(statusText: "Your Url has not the right format", isError: true)
                }
            }else{
                self.fillStatusLabel(statusText: "Url field cannot be empty", isError: true)
            }
        }else{
            self.fillStatusLabel(statusText: "Url field cannot be empty", isError: true)
        }
        
    }
    
    func fillStatusLabel(statusText:String, isError:Bool){
        self.statusLabel.text = statusText
        if isError {
            self.statusLabel.textColor = .red
        }else{
            self.statusLabel.textColor = .gray
        }
        self.largeURLTextField.text = ""
    }
    
    func verifyUrl (urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create NSURL instance
            if let url = NSURL(string: urlString) {
                // check if your application can open the NSURL instance
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    func addUrlToTableView(savedUrl: SavedUrl, error: String?){
        self.savedUrlArray.append(savedUrl)
        self.saveUrls()
        DispatchQueue.main.async {
            if error == nil {
                self.fillStatusLabel(statusText: "Url correcty shorten and added in the table", isError: false)
                self.tableview.reloadData()
            }else{
                self.fillStatusLabel(statusText: "Error during the shorten processus : \(String(describing: error))", isError: true)
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedUrlArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let url = savedUrlArray[indexPath.row]
        cell.textLabel?.text = url.tinyUrl
        
        cell.detailTextLabel?.text = url.date
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let savedUrl = savedUrlArray[indexPath.row]
        guard let tinyUrl = URL(string: savedUrl.tinyUrl) else {
            return
        }
        
        UIApplication.shared.open(tinyUrl, options: [:], completionHandler: nil)
    }
    
    func saveUrls(){
        do {
            var savedUrls: [AnyObject] = []
            for url in savedUrlArray{
                var urlDict: [String : String] = [:]
                urlDict["longUrl"] = url.longUrl
                urlDict["tinyUrl"] = url.tinyUrl
                urlDict["date"] = url.date
                savedUrls.append(urlDict as AnyObject)
            }
            let jsonData = try JSONSerialization.data(withJSONObject: savedUrls, options: .sortedKeys)
            let fileManager = FileManager.default
            let url = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let jsonUrl = url.appendingPathComponent("saved_urls.json")
            print(jsonUrl)
            try jsonData.write(to: jsonUrl)
        }catch{
            print(error)
        }
    }
    
    func readUrls(){
        do {
            let fileManager = FileManager.default
            let url = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let jsonUrl = url.appendingPathComponent("saved_urls.json")
            
            if(fileManager.fileExists(atPath: jsonUrl.path)){
                let jsonReadData = try Data(contentsOf: jsonUrl)
                let parsedSavedUrls = try JSONSerialization.jsonObject(with: jsonReadData, options: .mutableContainers)
                let savedUrls = parsedSavedUrls as! [[String:String]]
                for savedUrl in savedUrls {
                    guard let tinyUrl = savedUrl["tinyUrl"], let longUrl = savedUrl["longUrl"], let date = savedUrl["date"] else {continue}
                    let newUrl = SavedUrl(longUrl: longUrl, tinyUrl: tinyUrl, date: date)
                    savedUrlArray.append(newUrl)
                }
            }
        }catch{
            print(error)
        }
    }
    
}
