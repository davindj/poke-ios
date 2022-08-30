//
//  PokemonTableViewCell.swift
//  Poke iOS
//
//  Created by Davin Djayadi on 29/08/22.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {
    @IBOutlet weak var pokeImage: UIImageView!
    @IBOutlet weak var pokeNameLabel: UILabel!
    @IBOutlet weak var pokeTypeLabel: UILabel!
    @IBOutlet weak var pokedexLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func applyUI(pokemon: Pokemon){
        pokeNameLabel.text = pokemon.name
        pokeTypeLabel.text = pokemon.typesDisplay
        pokedexLabel.text = pokemon.idDisplay
        loadImage(urlString: pokemon.imageUrl)
    }
    
    func loadImage(urlString: String){
        let keyCache = urlString as NSString
        if Cache.isImageCached(key: keyCache){
            pokeImage.image = Cache.getImageCache(key: keyCache)
            return
        }
        
        pokeImage.image = UIImage(systemName: "circle.dashed")
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, data.count > 0 {
                if let image = UIImage(data: data) {
                    Cache.setImageCache(key: keyCache, image: image)
                }else{
                    self.pokeImage.image = UIImage(systemName: "xmark.octagon")
                }
            } else {
                self.pokeImage.image = UIImage(systemName: "xmark.octagon")
            }
        }.resume()
    }
}
