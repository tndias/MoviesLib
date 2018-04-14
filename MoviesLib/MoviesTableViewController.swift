//
//  MoviesTableViewController.swift
//  MoviesLib
//
//  Created by Eric.
//  Copyright © 2017 EricBrito. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class MoviesTableViewController: UITableViewController {
    
    var label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 22))
    var fetchedResultController: NSFetchedResultsController<Movie>!
    var backgroundMusicPlayer: AVAudioPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 106
        tableView.rowHeight = UITableViewAutomaticDimension
        label.text = "Sem filmes"
        label.textAlignment = .center
        label.textColor = .white
        
        loadMovies()
        prepareMusic()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MovieViewController {
            vc.movie = fetchedResultController.object(at: tableView.indexPathForSelectedRow!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backgroundMusicPlayer.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        backgroundMusicPlayer.stop()
    }
    
    func prepareMusic() {
        let url = Bundle.main.url(forResource: "music", withExtension: "mp3")!
        backgroundMusicPlayer = try! AVAudioPlayer(contentsOf: url)
        backgroundMusicPlayer.volume = 0.2
        backgroundMusicPlayer.numberOfLoops = -1
    }
    
    func loadMovies() {
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Table view data source
    
    //Método que define a quantidade de seções de uma tableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Método que define a quantidade de células para cada seção de uma tableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fetchedResultController.fetchedObjects?.count {
            tableView.backgroundView = (count == 0) ? label : nil
            return count
        } else {
            tableView.backgroundView = label
            return 0
        }
    }
    
    //Método que define a célula que será apresentada em cada linha
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        let movie = fetchedResultController.object(at: indexPath)
        cell.lbRating.text = "\(movie.rating)"
        cell.lbTitle.text = movie.title
        cell.lbSummary.text = movie.summary
        if let image = movie.poster as? UIImage {
            cell.ivPoster.image = image
        } else {
            cell.ivPoster.image = nil
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let movie = fetchedResultController.object(at: indexPath)
            context.delete(movie)
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension MoviesTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}





