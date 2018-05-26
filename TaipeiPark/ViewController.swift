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
        
        let request = try Router.readParks.asURLRequest()
        let datatask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("error: \(error)")
                return
            }

            guard let data = data else { return }
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data)
                let parkDatas = try Park.parseFromJsonToDecodableParks(jsonObject)
                for parkData in parkDatas {
                    let park = try JSONDecoder().decode(Park.self, from: parkData)
                    print("OO: \(park)")
                }
            } catch {
                print("XX: \(error)")
            }
            
            

        }
        
        datatask.resume()
    }
}

