//
//  ViewController.swift
//  DemoDay1
//
//  Created by Nattapol Chittrichat on 16/11/2561 BE.
//  Copyright © 2561 Nattapol Chittrichat. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var button1: UIButton!

    var shops: Array<shop> = Array<shop>()

    struct shop {
        var shopId: String?
        var shopName: String?
        var shopDescription: String?
        var lat: Double?
        var lng: Double?
        var create: String?
        var thumbnail: String?
        
        init(item: NSDictionary) {
            shopId = item["shop_id"] as? String
            shopName = item["shop_name"] as? String
            shopDescription = item["shop_description"] as? String
            lat = item["lat"] as? Double
            lng = item["lng"] as? Double
            create = item["create"] as? String
            thumbnail = item["thumbnail"] as? String
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func pressMe()
    {
        self.fetchAndParseShops()
    }

    func fetchAndParseShops()
    {
        let url: URL = URL(string: "http://178.128.170.56/shop.php")!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("JSON downloaded successfully.")
                
                do{
                    do {
                        let resultsDict = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! Dictionary<String, Any>
                        
                        print("Total object(s) in JSON = \(resultsDict.count)")
                        
                        // Get all results.
                        let items: Array<Dictionary<String, Any>> = resultsDict["shops"] as! Array<Dictionary<String, Any>>
                        
                        print("Total item(s) in object = \(items.count)")
                        
                        
                        // Use a loop to go through all items.
                        for i in 0 ..< items.count {
                            // Initialize a new dictionary and store the data of interest.
                            var item = Dictionary<String, Any>()
                            
                            item["shop_id"] = items[i]["shop_id"]
                            item["shop_name"] = items[i]["shop_name"]
                            item["shop_description"] = items[i]["shop_description"]
                            item["lat"] = items[i]["lat"]
                            item["lng"] = items[i]["lng"]
                            item["create"] = items[i]["create"]
                            item["thumbnail"] = items[i]["thumbnail"]
                            self.shops.append(shop(item: item as NSDictionary))
                            //print("\(items[i]["shop_name"])")
                        }
                        
                    }
                    
                }catch {
                    print("Error with Json: \(error)")
                }
                
                
            }
            DispatchQueue.main.async(execute: {
                self.textField1.text = self.shops[0].shopName!
                return
            })
            
        }
        
        task.resume()
        
    }
    
}

