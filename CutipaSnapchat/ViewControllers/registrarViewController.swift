//
//  registrarViewController.swift
//  CutipaSnapchat
//
//  Created by Mac20 on 29/05/24.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import FirebaseDatabase

class registrarViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func registrarButton(_ sender: Any) {
        Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { [weak self] user, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Se presentó el siguiente error al crear el usuario: \(error.localizedDescription)")
                // Aquí podrías mostrar una alerta al usuario informando del error
                return
            }
            
            print("El usuario fue creado exitosamente")
            Database.database().reference().child("usuarios").child(user!.user.uid).child("email").setValue(user!.user.email)
            let alerta = UIAlertController(title: "Creación de Usuario", message: "Usuario: \(self.emailTextField.text!) se creó correctamente.", preferredStyle: .alert)
            let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: { _ in
                // Una vez creado el usuario, puedes navegar a la siguiente vista si lo deseas
                // Por ejemplo:
                self.performSegue(withIdentifier: "inicioSegue", sender: nil)
            })
            alerta.addAction(btnOK)
            self.present(alerta, animated: true, completion: nil)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
