//
//  AudioViewController.swift
//  CutipaSnapchat
//
//  Created by Maria Cutipa on 5/06/24.
//

import UIKit
import AVFoundation
import FirebaseStorage
import Firebase

class AudioViewController: UIViewController,  UINavigationControllerDelegate{
    
    @IBOutlet weak var grabarButton: UIButton!
    @IBOutlet weak var reproducirButton: UIButton!
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var agregarTapped: UIButton!
    @IBOutlet weak var tiempoGrabacion: UILabel!
    
    var grabarAudio:AVAudioRecorder?
    var reproducirAudio:AVAudioPlayer?
    var audioURL:URL?
    var timer: Timer?
    var storageReference: StorageReference!
    var audioID = NSUUID().uuidString
    
    @IBAction func grabarTapped(_ sender: Any) {
        if grabarAudio!.isRecording{
            grabarAudio?.stop()
            grabarButton.setTitle("GRABAR", for: .normal)
            reproducirButton.isEnabled = true
            agregarTapped.isEnabled = true
            timer?.invalidate()
            
        }else{
            grabarAudio?.record()
            grabarButton.setTitle("DETENER", for: .normal)
            reproducirButton.isEnabled = false
            iniciarTimer()
        }
    }
    
    @IBAction func reproducirTapped(_ sender: Any) {
        do{
            try reproducirAudio = AVAudioPlayer(contentsOf: audioURL!)
            reproducirAudio!.play()
            print("Reproduciendo")
        }catch{}
    }
    
    @IBAction func elegirContactoTapped(_ sender: Any) {
        guard let audioURL = audioURL else { return }
        let audioFileName = "\(audioID).m4a"
        let audioRef = storageReference.child("audios").child(audioFileName)
        audioRef.putFile(from: audioURL, metadata: nil) { (metadata, error) in
            guard let _ = metadata else {
                print("Error al subir el audio: \(error)")
                return
            }
            print("Audio subido exitosamente")
            audioRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    print("Error al obtener la URL de descarga del audio: \(error)")
                    return
                }
                let audioDownloadURL = downloadURL.absoluteString
                print("URL de descarga del audio: \(audioDownloadURL)")
                self.performSegue(withIdentifier: "AudioSelecContactoSegue", sender: audioDownloadURL)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurarGrabacion()
        reproducirButton.isEnabled = false
        agregarTapped.isEnabled = false
        storageReference = Storage.storage().reference()
    }
    
    func configurarGrabacion(){
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: [])
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)

            let basePath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!

            var settings: [String: AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?

            grabarAudio = try AVAudioRecorder(url: audioURL!, settings: settings)
            grabarAudio!.prepareToRecord()
        } catch let error as NSError {
            print(error)
        }
    }
    
    func iniciarTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if let grabarAudio = self.grabarAudio, grabarAudio.isRecording {
                let tiempoActual = grabarAudio.currentTime
                let minutos = Int(tiempoActual / 60)
                let segundos = Int(tiempoActual) % 60
                self.tiempoGrabacion.text = String(format: "%02d:%02d", minutos, segundos)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! ElegirUsuarioViewController
        siguienteVC.audioURL = sender as! String
        siguienteVC.titulo = nombreTextField.text!
        siguienteVC.audioID = audioID
        siguienteVC.contentType = .audio
    }


}
