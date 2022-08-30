//
//  PokemonHomeViewController.swift
//  Poke iOS
//
//  Created by Davin Djayadi on 29/08/22.
//

import UIKit

class PokemonHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    private static let TABLE_CELL_IDENTIFIER = "PokemonCell"
    
    var semaphore: DispatchSemaphore = DispatchSemaphore(value: 1) // Load 1 API at a time
    var pokemons: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavigation()
        setupTableView()
        loadPokemons()
    }
    
    func setupNavigation(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Pokemon"
    }
    
    func setupTableView(){
        tableView.dataSource = self
        tableView.separatorColor = UIColor.clear
        tableView.register(
            UINib(nibName: "PokemonTableViewCell", bundle: nil),
            forCellReuseIdentifier: PokemonHomeViewController.TABLE_CELL_IDENTIFIER
        )
    }
    
    func loadPokemons(){
        let nPokemon = 20 // Total pokemon to be loaded by app
        let globalQueue = DispatchQueue.global()
        globalQueue.async{
            for idPokemon in 1...nPokemon{
                self.semaphore.wait()
                Pokemon.getPokemonById(idPokemon: idPokemon){ [weak self] pokemon in
                    print(idPokemon)
                    print("berhasil")
                    self?.pokemons.append(pokemon)
                    self?.semaphore.signal()
                    if idPokemon % 5 == 0{
                        DispatchQueue.main.async { [weak self] in
                            self?.tableView.reloadData()
                        }
                        sleep(2)
                    }
                }
                
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: PokemonHomeViewController.TABLE_CELL_IDENTIFIER,
            for: indexPath
        ) as? PokemonTableViewCell{
            let pokemon = pokemons[indexPath.row]
            cell.applyUI(pokemon: pokemon)
            return cell
        } else{
            return UITableViewCell()
        }
    }
}

