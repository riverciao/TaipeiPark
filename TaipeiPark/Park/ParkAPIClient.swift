//
//  ParkAPIClient.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/5/26.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import Foundation

protocol ParkAPIClient {
    typealias ReadParksSuccess = (_ parks: [Park], _ next: Page) -> Void
    typealias ReadParksFailure = (_ error: Error) -> Void
    
    func ReadParks(page: Page, success: @escaping ReadParksSuccess, failure: ReadParksFailure?)
}
