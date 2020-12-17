//
//  ViewController.swift
//  TestWork
//
//  Created by Дмитрий Жучков on 12.12.2020.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var AlbumCollection: UICollectionView!
    @IBOutlet weak var AlbumSearch: UISearchBar!
    var albums = [Album]()
    override func viewDidLoad() {
        super.viewDidLoad()
        AlbumSearch.delegate = self
        AlbumCollection.delegate = self
        AlbumCollection.dataSource = self
    }
// Передача данных следующему контроллеру
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "DetailsViewController" {
               if let destinationVC = segue.destination as? DetailsViewController {
                   if let album = sender as? Album {
                       destinationVC.albums = album
                    let index = albums.firstIndex(where: {$0 === album})
                       let indexPath = IndexPath(row: index!, section: 0)
                       if let cell = AlbumCollection.cellForItem(at: indexPath) as? AlbumCell {
                           destinationVC.image = cell.albumImage.image
                       }
                   }
               }
           }
       }
    
}


extension ViewController: UISearchBarDelegate {
// Получение информации с SearchBar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if AlbumSearch.text != nil || AlbumSearch.text != "" {
            DataService.service.getAlbums(searchRequest: AlbumSearch.text!) { (requestedAlbums) in
                // Сортировка по алфавиту
                self.albums = requestedAlbums.sorted(by: {$0.collectionName < $1.collectionName})
                DispatchQueue.main.async {
                 self.AlbumCollection.reloadData()
                }
            }
            AlbumSearch.resignFirstResponder()
        }
    }
}
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as? AlbumCell
        cell!.updateCell(album: albums[indexPath.row])
        return cell!
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let album = albums[indexPath.row]
        performSegue(withIdentifier: "DetailsViewController", sender: album)
        AlbumSearch.resignFirstResponder()
    }

}
