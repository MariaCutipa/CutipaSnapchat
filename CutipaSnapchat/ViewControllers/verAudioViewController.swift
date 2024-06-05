//
//  verAudioViewController.swift
//  CutipaSnapchat
//
//  Created by Maria Cutipa on 5/06/24.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseStorage

class verAudioViewController: UIViewController {

    @IBOutlet weak var lblTitulo: UILabel!
        var audioPlayer: AVPlayer?
        var snap = Snap()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            lblTitulo.text = "Titulo: " + snap.titulo
        }
        
    @IBAction func reproducirAudio(_ sender: Any) {
        if !snap.audioURL.isEmpty {
            guard let audioURL = URL(string: snap.audioURL) else {
                print("URL de audio inválida")
                return
            }
            let playerItem = AVPlayerItem(url: audioURL)
            audioPlayer = AVPlayer(playerItem: playerItem)
            audioPlayer?.play()
        } else {
            print("No hay URL de audio disponible")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").child(snap.id).removeValue()
        
        Storage.storage().reference().child("audios").child("\(snap.audioID).m4a").delete{ (error) in
            print("Se elimino el audio correctamente")
        }
    }
}
