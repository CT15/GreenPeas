//
//  CardContent.swift
//  GreenPeas
//
//  Created by Calvin Tantio on 24/2/19.
//  Copyright © 2019 Calvin Tantio. All rights reserved.
//

import UIKit

class CardContent: UIViewController {
    var id: Int?

    let fact1: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()

    let fact2: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()

    let materials: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()

    let country: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()

    let points: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()

    let recycling: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()

    let price: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()

    let button: UIButton = {
        let button:UIButton = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        button.setTitle("Add to Shopping Cart", for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(fact1)
        view.addSubview(fact2)
        view.addSubview(materials)
        view.addSubview(country)
        view.addSubview(points)
        view.addSubview(recycling)
        view.addSubview(price)
        view.addSubview(button)

        fact1.snp.makeConstraints { (make) in
            make.width.equalToSuperview().inset(50)
            make.height.greaterThanOrEqualTo(25)
            make.top.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
        }

        fact2.snp.makeConstraints { (make) in
            make.width.equalToSuperview().inset(50)
            make.height.greaterThanOrEqualTo(25)
            make.top.equalTo(fact1.snp_bottomMargin).offset(30)
            make.centerX.equalToSuperview()
        }

        materials.snp.makeConstraints { (make) in
            make.width.equalToSuperview().inset(50)
            make.height.greaterThanOrEqualTo(25)
            make.top.equalTo(fact2.snp_bottomMargin).offset(30)
            make.centerX.equalToSuperview()
        }

        country.snp.makeConstraints { (make) in
            make.width.equalToSuperview().inset(50)
            make.height.greaterThanOrEqualTo(25)
            make.top.equalTo(materials.snp_bottomMargin).offset(30)
            make.centerX.equalToSuperview()
        }

        points.snp.makeConstraints { (make) in
            make.width.equalToSuperview().inset(50)
            make.height.greaterThanOrEqualTo(25)
            make.top.equalTo(country.snp_bottomMargin).offset(30)
            make.centerX.equalToSuperview()
        }

        recycling.snp.makeConstraints { (make) in
            make.width.equalToSuperview().inset(50)
            make.height.greaterThanOrEqualTo(25)
            make.top.equalTo(points.snp_bottomMargin).offset(30)
            make.centerX.equalToSuperview()
        }

        price.snp.makeConstraints { (make) in
            make.width.equalToSuperview().inset(50)
            make.height.greaterThanOrEqualTo(25)
            make.top.equalTo(recycling.snp_bottomMargin).offset(30)
            make.centerX.equalToSuperview()
        }

        button.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-80)
            make.height.equalTo(50)
            make.top.equalTo(price.snp_bottomMargin).offset(30)
        }

        button.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)

    }

    @objc
    private func buttonClicked() {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: UIView.KeyframeAnimationOptions.calculationModeLinear, animations: {

            // make the button grow and become dark gray
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                self.button.backgroundColor = .gray
            }

            // restore the button to original size and color
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                self.button.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            }
        }, completion: nil)

        guard let myId = id else { return }

        if myId == 1 {
            UserDefaults.standard.set(true, forKey: "F1")
        } else if myId == 2 {
            UserDefaults.standard.set(true, forKey: "F2")
        } else if myId == 3 {
            UserDefaults.standard.set(true, forKey: "F3")
        }

        let alertController = UIAlertController(title: "Added to Cart", message: "This product has been successfully added to your Shopping Cart", preferredStyle: .alert)

        let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            print("You've pressed default");
        }

        alertController.addAction(action1)

        self.present(alertController, animated: true, completion: nil)

    }

}
