//
//  FavoritesViewController.swift
//  Landmark
//
//  Created by Ryan Zhou on 2/6/24.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: PlacesFavoritesDelegate?
    var favoritePlaces: [String] = []
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoritePlaces = DataManager.sharedInstance.listFavorites()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritePlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue a reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritePlacesCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = favoritePlaces[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favoritePlace = favoritePlaces[indexPath.row]
        delegate?.favoritePlace(name: favoritePlace)
        dismiss(animated: true, completion: nil)
    }
    
    

}
