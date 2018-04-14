//
//  MovieRegisterViewController.swift
//  MoviesLib
//
//  Created by Eric Brito.
//  Copyright © 2017 EricBrito. All rights reserved.
//

import UIKit

class MovieRegisterViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var lbCategories: UILabel!
    @IBOutlet weak var tfRating: UITextField!
    @IBOutlet weak var tfDuration: UITextField!
    @IBOutlet weak var tvSummary: UITextView!
    @IBOutlet weak var ivPoster: UIImageView!
    @IBOutlet weak var btAddUpdate: UIButton!
    
    // MARK: - Properties
    var movie: Movie!
    var smallImage: UIImage!
    
    // MARK:  Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if movie != nil {
            tfTitle.text = movie.title
            tfRating.text = "(movie.rating)"
            tfDuration.text = movie.duration
            tvSummary.text = movie.summary
            btAddUpdate.setTitle("Atualizar", for: .normal)
            if let image = movie.poster as? UIImage {
                ivPoster.image = image
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if movie != nil {
            if let categories = movie.categories {
                lbCategories.text = categories.map({($0 as! Category).name!}).joined(separator: " | ")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if movie == nil {
            movie = Movie(context: context)
        }
        let vc = segue.destination as! CategoriesViewController
        vc.movie = movie
    }
    
    // MARK: - IBActions
    @IBAction func addPoster(_ sender: UIButton) {
        //Criando o alerta que será apresentado ao usuário
        let alert = UIAlertController(title: "Selecionar poster", message: "De onde você quer escolher o poster?", preferredStyle: .actionSheet)
        
        //Verificamos se o device possui câmera. Se sim, adicionamos a devida UIAlertAction
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default, handler: { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            })
            alert.addAction(cameraAction)
        }
        
        //As UIAlertActions de Biblioteca de fotos e Álbum de fotos também são criadas e adicionadas
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Álbum de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func close(_ sender: UIButton?) {
        if movie != nil && movie.title == nil {
            context.delete(movie)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addUpdateMovie(_ sender: UIButton) {
        if movie == nil {
            movie = Movie(context: context)
        }
        movie.title = tfTitle.text!
        movie.rating = Double(tfRating.text!)!
        movie.summary = tvSummary.text
        movie.duration = tfDuration.text
        if smallImage != nil {
            movie.poster = smallImage
        }
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        close(nil)
    }
    
    // MARK:  Methods
    func selectPicture(sourceType: UIImagePickerControllerSourceType) {
        //Criando o objeto UIImagePickerController
        let imagePicker = UIImagePickerController()
        
        //Definimos seu sourceType através do parâmetro passado
        imagePicker.sourceType = sourceType
        
        //Definimos a MovieRegisterViewController como sendo a delegate do imagePicker
        imagePicker.delegate = self
        
        //Apresentamos a imagePicker ao usuário
        present(imagePicker, animated: true, completion: nil)
    }

}


// MARK: - UIImagePickerControllerDelegate
extension MovieRegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //O método abaixo nos trará a imagem selecionada pelo usuário em seu tamanho original
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String: AnyObject]?) {
        
        //Iremos usar o código abaixo para criar uma versão reduzida da imagem escolhida pelo usuário
        let smallSize = CGSize(width: 300, height: 280)
        UIGraphicsBeginImageContext(smallSize)
        image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
        
        //Atribuímos a versão reduzida da imagem à variável smallImage
        smallImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        ivPoster.image = smallImage //Atribuindo a imagem à ivPoster
        
        //Aqui efetuamos o dismiss na UIImagePickerController, para retornar à tela anterior
        dismiss(animated: true, completion: nil)
    }
}


