//
//  ViewController.swift
//  MovieDetailsTask
//
//  Created by Rashi Gambhir on 21/03/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var imageViewPixar: UIImageView!
    @IBOutlet weak var movieTextField: UITextField!
    @IBOutlet weak var searchMovie: UIButton!
    
    let movieManager = MovieManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.imageViewPixar.layer.cornerRadius = 50
        self.imageViewPixar.clipsToBounds = true
        
        searchMovie.layer.cornerRadius = 15
        searchMovie.clipsToBounds = true
    }
    
    @IBAction func searchMovieButton(_ sender: Any) {
        if let listViewController = storyboard?.instantiateViewController(withIdentifier:"listViewController") as? ListViewController{
            if let movieName = movieTextField.text{
                listViewController.titleMovie = movieName}
            listViewController.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(listViewController, animated: true)
        }
    }
}

