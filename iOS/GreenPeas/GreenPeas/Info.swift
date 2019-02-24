//
//  Info.swift
//  GreenPeas
//
//  Created by Calvin Tantio on 24/2/19.
//  Copyright © 2019 Calvin Tantio. All rights reserved.
//

import Foundation

struct Info: Decodable {
    let id: Int
    let cust_fact_1: String
    let cust_fact_2: String
    let env_friendly_score: Int
    let materials: String
    let origin_country: String
    let points_to_cust: Int
    let price: Double
    let product_name: String
    let recycling_info: String
}
