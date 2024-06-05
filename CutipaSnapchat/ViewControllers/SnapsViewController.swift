//
//  SnapsViewController.swift
//  CutipaSnapchat
//
//  Created by Mac20 on 29/05/24.
//

import UIKit
import Firebase

class SnapsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tablaSnaps: UITableView!
    var snaps:[Snap] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if snaps.count == 0 {
            return 1
        }else{
            return snaps.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if snaps.count == 0{
            cell.textLabel?.text = "No tienes Snaps TT"
        }else{
            let snap = snaps[indexPath.row]
            cell.textLabel?.text = snap.from
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snap = snaps[indexPath.row]
        if !snap.imagenURL.isEmpty {
            performSegue(withIdentifier: "versnapsegue", sender: snap)
        } else if !snap.audioURL.isEmpty {
            performSegue(withIdentifier: "verAudioSegue", sender: snap)
        }
    }

    
    @IBAction func cerrarSesionTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaSnaps.delegate = self
        tablaSnaps.dataSource = self
        
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").observe(DataEventType.childAdded, with: {(snapshot) in
            let snap = Snap()
            snap.from = (snapshot.value as! NSDictionary)["from"] as! String
            snap.id = snapshot.key
            if let imagenURL = (snapshot.value as? NSDictionary)?["imagenURL"] as? String {
                snap.imagenURL = imagenURL
                snap.imagenID = (snapshot.value as! NSDictionary)["imagenID"] as! String
                snap.descrip = (snapshot.value as! NSDictionary)["descripcion"] as! String
            } else if let audioURL = (snapshot.value as? NSDictionary)?["audioURL"] as? String {
                snap.audioURL = audioURL
                snap.audioID = (snapshot.value as! NSDictionary)["audioID"] as! String
                snap.titulo = (snapshot.value as! NSDictionary)["titulo"] as! String
            }
            self.snaps.append(snap)
            self.tablaSnaps.reloadData()
        })
        
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").observe(DataEventType.childRemoved, with: {(snapshot) in
            var iterator = 0
            for snap in self.snaps {
                if snap.id == snapshot.key{
                    self.snaps.remove(at: iterator)
                }
                iterator += 1
            }
            self.tablaSnaps.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "versnapsegue" {
            let siguienteVC = segue.destination as! VerSnapViewController
            siguienteVC.snap = sender as! Snap
        } else if segue.identifier == "verAudioSegue" {
            let siguienteVC = segue.destination as! verAudioViewController
            siguienteVC.snap = sender as! Snap
        }
        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
