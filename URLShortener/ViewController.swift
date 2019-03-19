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
    @IBOutlet weak var tinyURLLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    
    var savedUrlArray:[SavedUrl] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        readUrls()
    }
    
    @IBAction func convertButtonClicked(_ sender: Any) {
        let longUrl = "https://docs.swift.org/swift-book/ReferenceManual/AboutTheLanguageReference.html"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        ApiClient.sharedInstance.shortenUrl(longUrl: longUrl) { (tinyUrl, error) in
            if let tinyUrl = tinyUrl {
                self.addUrlToTableView(savedUrl: SavedUrl(longUrl: longUrl, tinyUrl: tinyUrl, date: dateFormatter.string(from: Date())))
            }
            if error == nil {
                print(tinyUrl!)
            }
        }
    }
    
    func addUrlToTableView(savedUrl: SavedUrl){
        self.savedUrlArray.append(savedUrl)
        self.saveUrls()
        DispatchQueue.main.async {
            self.tinyURLLabel.text = savedUrl.tinyUrl
            self.tableview.reloadData()
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
