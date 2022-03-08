//
//  WelcomeViewController.swift
//  Spotify
//
//  Created by THANSEEF on 08/03/22.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private let signInButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In With Spotify", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Spotify"
        view.backgroundColor = .systemGreen
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInButton.frame = CGRect(
            x: 20,
            y: view.height-50-view.safeAreaInsets.bottom,
            width: view.width-40,
            height: 50
        )
        
    }
    
    @objc func didTapSignIn() {
        let vc = AuthViewController()
        //hanldling signin restult
        vc.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success : success)
            }
            
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleSignIn(success : Bool) {
        //log user in or not at them for error
        guard success else {
            //create a alert box when it pop some error.
            let alert = UIAlertController(title: "Oops", message: "Something went wrong when sign in.", preferredStyle: .alert)
            //created alert box action to cancel
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        //once the user signin it will go to the tabbarview controller page.
        let mainAppTabBarVC = TabBarViewController()
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVC, animated: true)
    }
}
