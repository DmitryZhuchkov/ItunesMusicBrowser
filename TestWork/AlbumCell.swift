//
//  AlbumCell.swift
//  TestWork
//
//  Created by Дмитрий Жучков on 14.12.2020.
//


import UIKit

class AlbumCell: UICollectionViewCell {
    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var albumArtistLabel: UILabel!
    // Запись информации в ячейку
    func updateCell (album: Album) {
        let imageUrl = URL(string: album.artworkUrl100)
        albumTitleLabel.text = album.collectionName
        albumArtistLabel.text = album.artistName
        DispatchQueue.global().async {
            if let imageData = try? Data(contentsOf: imageUrl!) {
                // Присваивание изображение в ячейке возможно только из главного ядра
                DispatchQueue.main.async {
                    self.albumImage.image = UIImage(data: imageData)
                }
            }
        }
    }
    
}
