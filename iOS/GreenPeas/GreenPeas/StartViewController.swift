//
//  StartViewController.swift
//  GreenPeas
//
//  Created by Calvin Tantio on 23/2/19.
//  Copyright © 2019 Calvin Tantio. All rights reserved.
//

import UIKit
import CBZSplashView
import Floaty
import Cards
import SnapKit
import FirebaseDatabase

class StartViewController: UIViewController {

    let ref = Database.database().reference()

    let splashView: CBZSplashView = {
        let icon = UIImage(named: "logo")
        let color: UIColor = UIColor(red: 0.329, green: 0.753, blue: 0.012, alpha: 1)
        let splashView = CBZSplashView(icon: icon, backgroundColor: color)

        if let size = icon?.size {
            splashView?.iconStartSize = CGSize(width: size.width, height: size.height)
        }

        splashView?.animationDuration = 1
        return splashView!
    }()

    let tableView = UITableView()

    let treeImg: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "leaf"))
        iv.alpha = 0.3
        return iv
    }()

    var infoKey = [String]() {
        didSet {
            if infoKey.isEmpty { treeImg.alpha = 0.3 }
            else { treeImg.alpha = 0 }
            let range = NSMakeRange(0, self.tableView.numberOfSections)
            let sections = NSIndexSet(indexesIn: range)
            self.tableView.reloadSections(sections as IndexSet, with: .automatic) 
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewWillAppear(_ animated: Bool) {

        if UserDefaults.standard.bool(forKey: "photosTaken") {
            //observeDatabase()
            infoKey = ["F1", "F2", "F3"]
        }

        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        ref.removeAllObservers()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.5745640966, green: 0.8862745166, blue: 0.391798071, alpha: 1)

        tableView.register(Cell.self, forCellReuseIdentifier: Cell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.trailing.leading.height.top.equalToSuperview()
        }

        view.addSubview(treeImg)
        treeImg.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.width.equalTo(300)
        }

        if !infoKey.isEmpty { treeImg.alpha = 0 }

        setUpFloaty()
        setUpSplashView()
    }

    private func observeDatabase() {
        ref.child("MyChairs").observe(.value, with: { [weak self] (snapshot) in
            guard let me = self else { return }

            guard let array = snapshot.value as? [String] else { return }

            me.infoKey = array
        })
    }

    private func setUpSplashView() {
        let tapRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(tapped(gestureRecognizer:))
        )
        splashView.addGestureRecognizer(tapRecognizer)
        view.addSubview(splashView)
    }

    private func setUpFloaty() {
        let floaty = Floaty()

        floaty.plusColor = .white
        floaty.buttonColor = UIColor(red: 0.329, green: 0.753, blue: 0.012, alpha: 1)
        floaty.overlayColor = UIColor(white: 0, alpha: 0.5)
        floaty.sticky = true
        
        floaty.addItem("Camera", icon: UIImage(named: "camera")) { [weak self] item in
            guard let self = self else { return }
            let cameraViewController = CameraViewController()
            self.present(cameraViewController, animated: true)
        }

        floaty.addItem("Shopping Cart", icon: UIImage(named: "shopping_cart_loaded")) { [weak self] item in
            guard let self = self else { return }
            let vc = ShoppingCartViewController()
            self.present(vc, animated: true)
        }

        floaty.addItem("My Points", icon: UIImage(named: "following")) { [weak self] item in
            guard let self = self else { return }
            let pvc = PointsViewController()
            self.present(pvc, animated: true)
        }

        self.view.addSubview(floaty)
    }

    @objc
    private func tapped(gestureRecognizer: UITapGestureRecognizer) {
        splashView.startAnimation()
    }
}
