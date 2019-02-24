//
//  Cell.swift
//  GreenPeas
//
//  Created by Calvin Tantio on 24/2/19.
//  Copyright © 2019 Calvin Tantio. All rights reserved.
//

import UIKit
import Cards

class Cell: UITableViewCell {
    static let identifier = "Cell"

    var cardArticle: CardArticle?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        cardArticle = CardArticle(frame: CGRect(x: 25, y: 25, width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.height / 2))
        cardArticle?.title = ""
        cardArticle?.subtitle = ""
        cardArticle?.category = ""
        cardArticle?.subtitleSize = CGFloat(30)
        if let article = cardArticle {
            contentView.addSubview(article)
        }

        backgroundColor = .clear
        selectionStyle = .none
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
