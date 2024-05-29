//
//  ViewController.swift
//  CutipaSnapchat
//
//  Created by Maria Cutipa on 20/05/24.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import FirebaseDatabase

class iniciarSesionViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func buttonGoogle(_ sender: GIDSignInButton) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
          guard error == nil else {
              print("Google Sign In error: \(error!)")
              return  // Exit the scope
          }

          guard let user = result?.user,
            let idToken = user.idToken?.tokenString
          else {
              print("Error obtaining user or idToken.")
              return  // Exit the scope
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)

          print("Inicio de sesion exitoso")
        }
    }
    @IBAction func iniciarSesionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { [weak self] (user, error) in
            guard let self = self else { return }
            
            if let error = error {
                self.mostrarAlertaUsuarioNoCreado()
                
                return
            }
            
            print("Inicio de sesión exitoso")
            self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func mostrarAlertaUsuarioNoCreado() {
       let alerta = UIAlertController(title: "Usuario no registrado", message: "El usuario no está registrado. ¿Deseas crear una cuenta?", preferredStyle: .alert)
       let crearCuentaAction = UIAlertAction(title: "Crear", style: .default) { _ in
           self.performSegue(withIdentifier: "registrarseSegue", sender: nil)
       }
       let cancelarAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
       alerta.addAction(crearCuentaAction)
       alerta.addAction(cancelarAction)
       present(alerta, animated: true, completion: nil)
   }
    
    


}
