//
//  DataManager.swift
//  Landmark
//
//  Created by Ryan Zhou on 2/6/24.
//

import Foundation

public class DataManager {
    // MARK: - Singleton Stuff
    public static let sharedInstance = DataManager()

    //This prevents others from using the default '()' initializer
    private init() {}

    // Your code (these are just example functions, implement what you need)
    func saveFavorites(place: String) {
        var favorites = listFavorites()
        if !favorites.contains(place){
            favorites.append(place)
            UserDefaults.standard.set(favorites, forKey: "Favorites")
        }
    }
    
    func deleteFavorite(place: String) {
        var favorites = listFavorites()
        if let index = favorites.firstIndex(of: place) {
            favorites.remove(at: index)
            UserDefaults.standard.set(favorites, forKey: "Favorites")
        }
    }
    
    func listFavorites() -> [String] {
        return UserDefaults.standard.array(forKey: "Favorites") as? [String] ?? []
    }
}
