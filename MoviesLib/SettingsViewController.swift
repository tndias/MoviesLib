//
//  SettingsViewController.swift
//  MoviesLib
//
//  Created by Eric Brito.
//  Copyright © 2017 EricBrito. All rights reserved.
//

import UIKit
import CoreMotion

class SettingsViewController: UIViewController {

    @IBOutlet weak var scColors: UISegmentedControl!
    @IBOutlet weak var swAutoplay: UISwitch!
    @IBOutlet weak var tfGenre: UITextField!
    @IBOutlet weak var ivBG: UIImageView!
    

    lazy var motionManager = CMMotionManager()
    
    //PickerView que será usado como entrada para o textField de Gênero
    var pickerView: UIPickerView!
    
    //Objeto que servirá como fonte de dados para alimentar o pickerView
    var dataSource:[String] = ["Ação", "Comédia", "Drama", "Suspense", "Terror"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView = UIPickerView() //Instanciando o UIPickerView
        pickerView.backgroundColor = .white
        pickerView.delegate = self  //Definindo seu delegate
        pickerView.dataSource = self  //Definindo seu dataSource
        
//        //Criando uma toobar que servirá de apoio ao pickerView. Através dela, o usuário poderá
//        //confirmar sua seleção ou cancelar
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
//
//        //O botão abaixo servirá para o usuário cancelar a escolha de gênero, chamando o método cancel
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//
//        //O botão done confirmará a escolha do usuário, chamando o método done.
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.items = [btCancel, btSpace, btDone]
//
        
        
        //Definindo a toolbar como view de apoio do textField (view que fica acima do teclado)
        
        tfGenre.inputAccessoryView = toolbar
        
        //Aqui definimos que o pickerView será usado como entrada do extField
        tfGenre.inputView = pickerView
        
        
        
        if motionManager.isDeviceMotionAvailable {
            
            motionManager.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: { (data, error) in
                
                if error == nil {
                    guard let data = data else {return}
                    let angle = atan2(data.gravity.x, data.gravity.y) - .pi
                    self.ivBG.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
                }
                
            })
            
        }
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        scColors.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "color")
        swAutoplay.setOn(UserDefaults.standard.bool(forKey: "autoplay"), animated: false)
        tfGenre.text = UserDefaults.standard.string(forKey: "genre")
    }
    
    //O método cancel irá esconder o teclado e não irá atribuir a seleção ao textField
    @objc func cancel() {
        
        //O método resignFirstResponder() faz com que o campo deixe de ter o foco, fazendo assim
        //com que o teclado (pickerView) desapareça da tela
        tfGenre.resignFirstResponder()
    }
    
    //O método done irá atribuir ao textField a escolhe feita no pickerView
    @objc func done() {
        
        //Abaixo, recuperamos a linha selecionada na coluna (component) 0 (temos apenas um component
        //em nosso pickerView)
        tfGenre.text = dataSource[pickerView.selectedRow(inComponent: 0)]
        
        //Agora, gravamos esta escolha no UserDefaults
        UserDefaults.standard.set(tfGenre.text!, forKey: "genre")
        cancel()
    }

    @IBAction func changeColor(_ sender: UISegmentedControl) {
        //Este método será chamado sempre que o SegmentedControl for alterado. Usaremos o método
        //set(_ value: Int, forKey defaultName: String) para armazenar no UserDefaults o índice
        //do item selecionado.
        UserDefaults.standard.set(scColors.selectedSegmentIndex, forKey: "color")
    }
    
    @IBAction func changeAutoplay(_ sender: UISwitch) {
        //Da mesma forma, sempre que o Switch for modificado, armazenaremos o seu estado no
        //UserDefaults usando o método set(_ value: Bool, forKey defaultName: String), lembrando que
        //a propriedade isOn é um Bool que define se o Switch está ligado ou desligado
        UserDefaults.standard.set(swAutoplay.isOn, forKey: "autoplay")
    }
    
}

extension SettingsViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //Retornando o texto recuperado do objeto dataSource, baseado na linha selecionada
        return dataSource[row]
    }
}

extension SettingsViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1    //Usaremos apenas 1 coluna (component) em nosso pickerView
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count //O total de linhas será o total de itens em nosso dataSource
    }
}



