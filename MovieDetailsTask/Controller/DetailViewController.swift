//
//  DetailViewController.swift
//  MovieDetailsTask
//
//  Created by Rashi Gambhir on 22/03/22.
//

import UIKit

protocol TransferButton: AnyObject{
    func transferButtonData(flag: Bool, indexPath: IndexPath)
}

class DetailViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var movieDetailTitle: UILabel!
    @IBOutlet weak var posterDetailImage: UIImageView!
    @IBOutlet weak var plotDetailLabel: UILabel!
    @IBOutlet weak var languageDetailLabel: UILabel!
    @IBOutlet weak var ratingDetailLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var starImage: UIImageView!
    var movieId: String?
    var detailsData: DetailData?
    let detailsManager = DetailManager()
    
    var buttonFlag: Bool?
    var buttonIndexPath: IndexPath?
    
    var delegate: TransferButton?
    
    let imageURL = "https://logos-world.net/wp-content/uploads/2020/11/Pixar-Emblem.jpg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        detailsManager.completionHandler = { [self](details) in
            detailsData = details
            DispatchQueue.main.async {
                movieDetailTitle.text = detailsData?.Title
                plotDetailLabel.text = detailsData?.Plot
                languageDetailLabel.text = detailsData?.Language
                ratingDetailLabel.text = detailsData?.imdbRating
                if ratingDetailLabel.text == "N/A"{
                    starImage.isHidden = true
                }
                else{
                    starImage.isHidden = false
                }
                DispatchQueue.global().async {
                    if  let url = URL(string: detailsData?.Poster ?? imageURL), let data = try? Data(contentsOf: url){
                        DispatchQueue.main.async {
                            posterDetailImage.image = UIImage(data: data)
                            posterDetailImage.layer.cornerRadius = 20
                            posterDetailImage.clipsToBounds = true
                            posterDetailImage.layer.borderColor = UIColor.white.cgColor
                            posterDetailImage.layer.borderWidth = 1
                            
                        }
                    }
                }
            }
            
        }
        if let id = movieId{
            detailsManager.fetchMovie(imdbID: id)}
        
        addButton.layer.cornerRadius = addButton.frame.width/2
        addButton.layer.masksToBounds = true
        
        if (buttonFlag == false){
            addButton.setTitle("+", for: .normal)
            addButton.backgroundColor = UIColor.red
        }
        else{
            addButton.setTitle("-", for: .normal)
            addButton.backgroundColor = UIColor.green
        }
        
        
    }
    
    @IBAction func addButton(_ sender: Any) {
        if (addButton.backgroundColor == UIColor.red){
            addButton.setTitle("-", for: .normal)
            addButton.backgroundColor = UIColor.green
            buttonFlag = true
        }
        else{
            addButton.setTitle("+", for: .normal)
            addButton.backgroundColor = UIColor.red
            buttonFlag = false
        }
    }
    
    @IBAction func doneButtonDetail(_ sender: Any) {
        if let indexPath = buttonIndexPath{
            self.delegate?.transferButtonData(flag: buttonFlag ?? true, indexPath: indexPath)
        }
        dismiss(animated: true, completion: nil)
    }
}
