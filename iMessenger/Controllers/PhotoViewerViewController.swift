//
//  PhotoViewerViewController.swift
//  iMessenger
//
//  Created by Charlie Nguyen on 28/07/2021.
//

import UIKit

class PhotoViewerViewController: UIViewController {

    private let url: URL
    
    init(with url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Photo"
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .black
        view.addSubview(imageView)
        imageView.sd_setImage(with: self.url, completed: nil)

    }
    
    override func viewDidLayoutSubviews() {
        imageView.frame = view.bounds
    }

}
