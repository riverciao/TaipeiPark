//
//  ViewController.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/5/25.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import UIKit

enum HTTPError: Error {
    case statusCodeNotNormal(Int)
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let page = Page.begin
        let client = APIClient()
        client.ReadParks(page: page, success: { (parks, next) in
            print("continue OO\(parks.count, next)")
        }) { (error) in
            print("error XX \(error)")
        }
        
    }
    
    func readParks() throws {
        
        let request = try Router.readParks(forAmount: 15, fromLastReadIndex: 770).asURLRequest()
        let datatask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("error: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                switch statusCode {
                case 200: break
                default:
                    print(HTTPError.statusCodeNotNormal(statusCode))
                    return
                }
            }
            

            guard let data = data else { return }
            
            do {
                let parksData = try Park.parseToDecodableParks(data)
                let parks = try JSONDecoder().decode([Park].self, from: parksData)
                print("OO: \(parks.count)")
            } catch {
                print("XX: \(error)")
            }
        }
        
        datatask.resume()
    }
}

