//
//  ViewController.swift
//  MoviesLib
//
//  Created by Eric.
//  Copyright © 2017 EricBrito. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class MovieViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var ivPoster: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbGenre: UILabel!
    @IBOutlet weak var lbDuration: UILabel!
    @IBOutlet weak var lbScore: UILabel!
    @IBOutlet weak var tvSinopsis: UITextView!
    @IBOutlet weak var lcButtonX: NSLayoutConstraint!
    @IBOutlet weak var viTrailer: UIView!
    
    //Variável que receberá o filme selecionado na tabela
    var movie: Movie!
    var moviePlayer: AVPlayer!
    var moviePlayerController: AVPlayerViewController!
    
    // MARK: Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareVideo()
        
        if UserDefaults.standard.bool(forKey: "autoplay") {
            changeMovieStatus(play: true)
        } else {
            
            let oldWidth = ivPoster.frame.size.width
            ivPoster.frame.size.width = 0
            
            UIView.animate(withDuration: 0.75, delay: 1.0, options: .curveEaseInOut, animations: {
                self.ivPoster.frame.size.width = oldWidth
            }, completion: { (success) in
                print("Animação chegou ao fim")
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lbTitle.text = movie.title
        lbDuration.text = movie.duration
        lbScore.text = "⭐️ \(movie.rating)/10"
        tvSinopsis.text = movie.summary
        if let categories = movie.categories {
            lbGenre.text = categories.map({($0 as! Category).name!}).joined(separator: " | ")
        }
        if let image = movie.poster as? UIImage {
            ivPoster.image = image
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MovieRegisterViewController {
            vc.movie = movie
        }
    }
    
    //Dessa forma, podemos voltar à tela anterior
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Super Methods
    @IBAction func playVideo(_ sender: UIButton) {
        sender.isHidden = true
        changeMovieStatus(play: true)
    }
    
    func prepareVideo() {
        let url = Bundle.main.url(forResource: "spiderman-trailer", withExtension: "mp4")!
        moviePlayer = AVPlayer(url: url)
        moviePlayerController = AVPlayerViewController()
        moviePlayerController.player = moviePlayer
        moviePlayerController.showsPlaybackControls = true
        moviePlayerController.view.frame = viTrailer.bounds
        viTrailer.addSubview(moviePlayerController.view)
    }
    
    func changeMovieStatus(play: Bool) {
        viTrailer.isHidden = false
        if play {
            moviePlayer.play()
        } else {
            moviePlayer.pause()
        }
    }
    
}















