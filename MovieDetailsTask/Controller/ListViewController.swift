//
//  ListViewController.swift
//  MovieDetailsTask
//
//  Created by Rashi Gambhir on 21/03/22.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , UITextFieldDelegate,TransferButton {
    
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var movieDetails : MovieData?
    let movieManager =  MovieManager()
    var titleMovie: String?
    
    var selected : Int?
    var seletedItem: IndexPath?
    var listViewFlag: Bool?
    
    let imageUrl = "https://logos-world.net/wp-content/uploads/2020/11/Pixar-Emblem.jpg"
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let cellNib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "cell")
        
        tableView.delegate = self
        tableView.dataSource = self
        searchTextField.delegate = self
        
        movieManager.completionHandler = {(movieModel) in
            if self.movieDetails == nil{
                self.movieDetails = movieModel
            }
            else {
                if let data  =  movieModel.Search{
                    self.movieDetails?.Search?.append(contentsOf: data)
                }
            }
            DispatchQueue.main.async {
                if self.movieDetails?.Search?.count == nil{
                    self.alertLabel.isHidden = false
                    self.alertLabel.text = "No Data Found"
                }
                else if self.movieDetails?.Search?.count == 0{
                    self.alertLabel.isHidden = false
                    self.alertLabel.text = "No Data Found"
                }
                else{
                    self.alertLabel.isHidden = true
                }
                self.tableView.reloadData()
            }
        }
        if let name = titleMovie{
            movieManager.fetchMovie(movieName: name)}
        searchTextField.text = titleMovie
    }
    
    // MARK: Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let noOfRows = self.movieDetails?.Search?.count else{
            return 0
        }
        return noOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MovieCell{
            cell.movieName?.text = self.movieDetails?.Search?[indexPath.row].Title
            cell.yearReleased?.text = "Released Year: \(self.movieDetails?.Search?[indexPath.row].Year ?? "N/A")"
            cell.typeLabel?.text = self.movieDetails?.Search?[indexPath.row].`Type`
            cell.typeImage?.image = UIImage(systemName: self.movieDetails?.Search?[indexPath.row].typeImage ?? "underLine")
            
            DispatchQueue.global().async {
                if let url = URL(string: self.movieDetails?.Search?[indexPath.row].Poster ?? self.imageUrl), let data = try? Data(contentsOf: url){
                    DispatchQueue.main.async {
                        cell.posterImageView.image = UIImage(data: data)
                    }
                }
            }
            
            cell.addToWatchlist.layer.cornerRadius = 15
            cell.addToWatchlist.clipsToBounds = true
            cell.addToWatchlist.backgroundColor = UIColor.red
            
            cell.addToWatchlist.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
            cell.addToWatchlist.tag = indexPath.row
            
            if movieDetails?.Search?[indexPath.row].flag == true {
                cell.addToWatchlist?.backgroundColor = UIColor.green
                cell.addToWatchlist.setTitle("ADDED TO WATCHLIST", for: .normal)
            }
            else{
                cell.addToWatchlist?.backgroundColor = UIColor.red
                cell.addToWatchlist.setTitle("ADD TO WATCHLIST", for: .normal)
            }
            self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailViewController = storyboard?.instantiateViewController(withIdentifier:"detailViewController") as? DetailViewController{
            detailViewController.movieId = self.movieDetails?.Search?[indexPath.row].imdbID
            detailViewController.buttonFlag = self.movieDetails?.Search?[indexPath.row].flag
            detailViewController.buttonIndexPath = indexPath
            detailViewController.delegate = self
            detailViewController.modalPresentationStyle = .fullScreen
            present(detailViewController,animated: true,completion: nil)
        }
    }
    
    // MARK: Button Function
    
    @IBAction func searchButton(_ sender: Any) {
        movieManager.fetchMovie(movieName: searchTextField.text ?? " ")
    }
    
    @IBAction func backButton(_ sender: Any) {
        if let homeViewController = storyboard?.instantiateViewController(withIdentifier:"homeViewController") as? HomeViewController{
            homeViewController.modalPresentationStyle = .fullScreen
            navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: Text Field
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.searchTextField{
            let count = self.searchTextField.text?.count ?? 0 + string.count
            if count >= 4{
                self.movieDetails?.Search?.removeAll()
                if let name = textField.text{
                    movieManager.fetchMovie(movieName: name)}
            }
        }else{
            return true
        }
        return true
        
    }
    
    // MARK: Pagination
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset - 150
        if distanceFromBottom < height {
            if let name = titleMovie{
                movieManager.fetchMovie(movieName: name)
            }
        }
    }
    
    // MARK: Button Function
    
    @objc func connected(sender: UIButton){
        
        selected = sender.tag
        if movieDetails?.Search?[sender.tag].flag == false{
            movieDetails?.Search?[sender.tag].flag = true
        }
        else{
            movieDetails?.Search?[sender.tag].flag = false
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func transferButtonData(flag: Bool, indexPath: IndexPath) {
        self.listViewFlag = flag
        self.seletedItem = indexPath
        if let selectedItemData = seletedItem{
            movieDetails?.Search?[selectedItemData.row].flag = listViewFlag}
    }
    
}
