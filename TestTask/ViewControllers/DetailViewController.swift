//
//  DetailViewController.swift
//  TestTask
//
//  Created by sss on 12.05.2023.
//

import UIKit
import SDWebImage

final class DetailViewController: UIViewController {

    //MARK: - Properties
    
    var url: URL
    
    var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var isHiddenNavBar = false
    
    
    //MARK: - Init
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsSubViews()
        addGesture()
        
        photoImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        photoImageView.sd_setImage(with: url)
        
        view.backgroundColor = UIColor.systemBackground
        
    }
    
   
    
    //MARK: - Method
    
    private func settingsSubViews() {
        
        view.addSubview(photoImageView)
        
        NSLayoutConstraint.activate([
            photoImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            photoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            photoImageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            photoImageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor)
        ])
        
    }
    
    private func addGesture() {
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_ :)))
        pinchGesture.delegate = self
        view.addGestureRecognizer(pinchGesture)
        pinchGesture.delaysTouchesBegan = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hiddenNavBar))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let view = gesture.view else {return}
        
        if gesture.state == .began || gesture.state == .changed {
            view.transform = view.transform.scaledBy(x: gesture.scale, y: gesture.scale)
            gesture.scale = 1.0
        }
    }
    
    @objc private func hiddenNavBar() {
        isHiddenNavBar = !isHiddenNavBar
        navigationController?.navigationBar.isHidden = isHiddenNavBar
    }
}


//MARK: - UIGestureRecognizerDelegate

extension DetailViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
