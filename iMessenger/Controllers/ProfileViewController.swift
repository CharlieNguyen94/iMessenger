//
//  ProfileViewController.swift
//  iMessenger
//
//  Created by Charlie Nguyen on 28/07/2021.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn
import SDWebImage

final class ProfileViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var data = [ProfileViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        data.append(ProfileViewModel(viewModelType: .info, title: "Name: \(UserDefaults.standard.value(forKey: "name") as? String ?? "No Name")", handler: nil))
        
        data.append(ProfileViewModel(viewModelType: .info, title: "E-mail: \(UserDefaults.standard.value(forKey: "email") as? String ?? "No E-mail")", handler: nil))
        
        data.append(ProfileViewModel(viewModelType: .logout, title: "Log Out", handler: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            let actionSheet = UIAlertController(title: "Logging out",
                                          message: "Are you sure you want to log out?",
                                          preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Log Out",
                                          style: .destructive,
                                          handler: { [weak self] _ in
                                            
                                            guard let strongSelf = self else {
                                                return
                                            }
                                            
                                            UserDefaults.standard.setValue(nil, forKey: "email")
                                            UserDefaults.standard.setValue(nil, forKey: "name")
                                            
                                            // Log out of Facebook
                                            FBSDKLoginKit.LoginManager().logOut()
                                            
                                            // Log out of Google
                                            GIDSignIn.sharedInstance()?.signOut()
                                            
                                            do {
                                                try FirebaseAuth.Auth.auth().signOut()
                                                
                                                let vc = LoginViewController()
                                                let nav = UINavigationController(rootViewController: vc)
                                                nav.modalPresentationStyle = .fullScreen
                                                strongSelf.present(nav, animated: true)
                                            }
                                            catch {
                                                print("Failed to log out")
                                            }
                
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel",
                                                style: .cancel,
                                                handler: nil))
            
            strongSelf.present(actionSheet, animated: true)
            
            
        }))
        
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = createTableHeader()

    }
    
    func createTableHeader() -> UIView? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        let fileName = safeEmail + "_profile_picture.png"
        let path = "images/" + fileName
        
        let headerView = UIView(frame: CGRect(x: 0,
                                        y: 0,
                                        width: self.view.width,
                                        height: 300))
        
        headerView.backgroundColor = .systemBackground
        
        let imageView = UIImageView(frame: CGRect(x: (view.width - 150) / 2,
                                                  y: 75,
                                                  width: 150,
                                                  height: 150))
        
        
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.width / 2
        headerView.addSubview(imageView)
        
        StorageManager.shared.downloadURL(for: path, completion: { result in
            switch result {
            case .success(let url):
                imageView.sd_setImage(with: url, completed: nil)
            case .failure(let error):
                print("Failed to get download url: \(error)")
            }
        })
        
        return headerView
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as! ProfileTableViewCell
        
        cell.setUp(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        data[indexPath.row].handler?()
        
    }
}

class ProfileTableViewCell: UITableViewCell {
    
    static let identifier = "ProfileTableViewCell"
    
    public func setUp(with viewModel: ProfileViewModel) {
        self.textLabel?.text = viewModel.title
        switch viewModel.viewModelType {
        case .info:
            textLabel?.textAlignment = .left
            selectionStyle = .none
        case .logout:
            textLabel?.textColor = .red
            textLabel?.textAlignment = .center
        }
    }
}
