//
//  PointsViewController.swift
//  GreenPeas
//
//  Created by Calvin Tantio on 24/2/19.
//  Copyright © 2019 Calvin Tantio. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseDatabase

class PointsViewController: UIViewController {

    let ref = Database.database().reference()

    let pointLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Your points"
        label.font = UIFont.systemFont(ofSize: 50)
        return label
    }()

    let point: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "0"
        label.font = UIFont.boldSystemFont(ofSize: 60)
        return label
    }()

    let backBtn: UIButton = {
        let button:UIButton = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        button.setTitle("OK! Thanks", for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        ref.child("MyPoint").observeSingleEvent(of: .value) { [weak self] (snapshot) in
            guard let self = self else { return }
            guard let myPoint = snapshot.value as? Int else {
                print("shit")
                return
            }
            self.point.text = "\(myPoint)"
        }
        view.backgroundColor = .white

        view.addSubview(pointLabel)
        pointLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(70)
            make.centerY.equalToSuperview().inset(-80)
        }

        view.addSubview(point)
        point.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(70)
            make.centerY.equalToSuperview().inset(10)
        }

        view.addSubview(backBtn)
        backBtn.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
        backBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-80)
            make.height.equalTo(50)
            make.centerY.equalToSuperview().inset(100)
        }
    }

    @objc
    private func buttonClicked() {
        dismiss(animated: true, completion: nil)
    }

}
