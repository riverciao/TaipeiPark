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
        do {
            try readParks()
        } catch {
            print(error)
        }
    }
    
    func readParks() throws {
        
        let request = try Router.readParks(forAmount: 15, fromLastReadIndex: 15).asURLRequest()
        let datatask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("error: \(error)")
                return
            }

            guard let data = data else { return }
            
            do {
                let parksData = try Park.parseToDecodableParks(data)
                let parks = try JSONDecoder().decode([Park].self, from: parksData)
                print("OO: \(parks)")
            } catch {
                print("XX: \(error)")
            }
        }
        
        datatask.resume()
    }
}

