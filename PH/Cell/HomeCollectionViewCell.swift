//
//  HomeCollectionViewCell.swift
//  PH
//
//  Created by Marco on 18/08/2018.
//  Copyright © 2018 Vikings. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    let theme = ThemeManager.currentTheme()
    
    override func awakeFromNib() {
        
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont(name: theme.fontName, size: 14)
        
        countLabel.textColor = UIColor(white: 0.65, alpha: 1.0)
        countLabel.font = UIFont(name: theme.fontName, size: 13)
        
        coverImageView.layer.borderColor = UIColor(white: 0.2, alpha: 1.0).cgColor
        coverImageView.layer.borderWidth = 0.5
        coverImageView.layer.cornerRadius = 6

    }
    
}
