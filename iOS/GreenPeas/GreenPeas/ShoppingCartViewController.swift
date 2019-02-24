//
//  ShoppingCartViewController.swift
//  GreenPeas
//
//  Created by Calvin Tantio on 24/2/19.
//  Copyright © 2019 Calvin Tantio. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ShoppingCartViewController: UIViewController {

    let ref = Database.database().reference()

    let tableView = UITableView()

    var infoKey = [String]() {
        didSet {
            let range = NSMakeRange(0, self.tableView.numberOfSections)
            let sections = NSIndexSet(indexesIn: range)
            self.tableView.reloadSections(sections as IndexSet, with: .automatic)
        }
    }

    let backBtn: UIButton = {
        let button:UIButton = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        button.setTitle("Back", for: .normal)
        return button
    }()

    let purchase: UIButton = {
        let button:UIButton = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        button.setTitle("Check Out", for: .normal)
        return button
    }()

    override func viewWillAppear(_ animated: Bool) {
        var arr = [String]()

        if UserDefaults.standard.bool(forKey: "F1") {
            arr.append("F1")
        }

        if UserDefaults.standard.bool(forKey: "F2") {
            arr.append("F2")
        }

        if UserDefaults.standard.bool(forKey: "F3") {
            arr.append("F3")
        }

        infoKey = arr
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        ref.child("/Customers/C123").observe(.value) { [weak self](snapshot) in
            guard let self = self else { return }
            guard let myPoint = snapshot.value as? String else {
                print("shit")
                return
            }

            if myPoint == "verified" {
                let alertController = UIAlertController(title: "Done Purchasing", message: "You have gained 16 points.", preferredStyle: .alert)

                let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                    self.dismiss(animated: true, completion: nil)
                    print("You've pressed default");
                }

                alertController.addAction(action1)

                self.present(alertController, animated: true, completion: nil)
            }
        }

        view.backgroundColor = .white
        tableView.register(Cell.self, forCellReuseIdentifier: Cell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.trailing.leading.top.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5).inset(-110)
        }

        view.addSubview(purchase)
        purchase.addTarget(self, action:#selector(self.purchasing), for: .touchUpInside)
        purchase.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-80)
            make.height.equalTo(50)
            make.top.equalTo(tableView.snp_bottomMargin).offset(30)
        }

        view.addSubview(backBtn)
        backBtn.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
        backBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-80)
            make.height.equalTo(50)
            make.top.equalTo(purchase.snp_bottomMargin).offset(30)
        }
    }

    @objc
    private func buttonClicked() {
        dismiss(animated: true, completion: nil)
    }

    @objc
    private func purchasing() {
        let alertController = UIAlertController(title: "Checking Out", message: "Your code is C123. Show this code to the cashier!", preferredStyle: .alert)

        let action1 = UIAlertAction(title: "Done", style: .default) { (action:UIAlertAction) in
            print("You've pressed default");
        }

        alertController.addAction(action1)

        self.present(alertController, animated: true, completion: nil)

    }

}

extension ShoppingCartViewController: UITableViewDataSource, UITableViewDelegate {
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
