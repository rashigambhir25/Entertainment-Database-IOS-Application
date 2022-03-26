//
//  TableViewCell.swift
//  MovieDetailsTask
//
//  Created by Rashi Gambhir on 21/03/22.
//

import UIKit

class MovieCell: UITableViewCell {
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var yearReleased: UILabel!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var addToWatchlist: UIButton!
    @IBOutlet weak var posterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.backgroundColor = UIColor.white
        self.contentView.layer.cornerRadius = 10
        self.contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        self.contentView.layer.borderColor = UIColor.lightGray.cgColor
        self.contentView.layer.borderWidth = 1
    }
    
}
