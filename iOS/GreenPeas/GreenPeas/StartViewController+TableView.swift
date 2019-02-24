//
//  StartViewController+TableView.swift
//  GreenPeas
//
//  Created by Calvin Tantio on 24/2/19.
//  Copyright © 2019 Calvin Tantio. All rights reserved.
//

import UIKit
import FirebaseDatabase

extension StartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoKey.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let key = infoKey[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath) as! Cell

        Database.database().reference().child("Chairs/\(key)").observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            guard let self = self else { return }

            guard let dict = snapshot.value as? [String : Any] else { return }

            guard let cust_fact_1 = dict["cust_fact_1"] as? String,
                let cust_fact_2 = dict["cust_fact_2"] as? String,
                let env_friendly_score = dict["env_friendly_score"] as? Int,
                let materials = dict["materials"] as? String,
                let origin_country = dict["origin_country"] as? String,
                let points_to_cust = dict["points_to_cust"] as? Int,
                let price = dict["price"] as? Double,
                let product_name = dict["product_name"] as? String,
                let recycling_info = dict["recycling_info"] as? String,
                let id = dict["id"] as? Int else { return }

            if id == 1 {
                cell.cardArticle?.backgroundImage = UIImage(named: "F1")
            } else if id == 2 {
                cell.cardArticle?.backgroundImage = UIImage(named: "F2")
            } else {
                cell.cardArticle?.backgroundImage = UIImage(named: "F3")
            }
            
            cell.cardArticle?.title = "\(env_friendly_score) pts"
            cell.cardArticle?.subtitle = product_name
            cell.cardArticle?.category = "NUS Green Mart"

            let content = CardContent()
            content.fact1.text = cust_fact_1
            content.fact2.text = cust_fact_2
            content.materials.text = "Materials: \(materials)"
            content.country.text = "Country of origin: \(origin_country)"
            content.points.text = "Points for you: \(points_to_cust)"
            content.recycling.text = "Recycling info: \(recycling_info)"
            content.price.text = "Price: SGD \(price)"
            content.id = id

            cell.cardArticle?.shouldPresent(content, from: self, fullscreen: false)
        })
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 2 + 37.5
    }
}
