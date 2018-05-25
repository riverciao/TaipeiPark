//
//  ViewController.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/5/25.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        readParks()
    }
    
    func readParks() {
        
        guard let request = Router.readParks.urlRequest else { return }
        let datatask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("error: \(error)")
                return
            }

            guard let data = data else { return }

            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            if let jsonObject = json as? [String: Any] {
                print("json:\(jsonObject)")
            }
        }
        
        datatask.resume()
    }
}

