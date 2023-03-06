//
//  PhotoDetailViewController.swift
//  PhotoAlbum
//
//  Created by Ramkumar Thiyyakat on 17/12/22.
//

import UIKit

final class PhotoDetailViewController: UIViewController, Alertable {
    
    private  var vm: PhotoDetailViewModel!
    
    var isFavourite = false {
        didSet {
            navigationItem.rightBarButtonItem = UIBarButtonItem.favouriteButton(target: self, action: #selector(didTapFavourite(_:)), isSelected: isFavourite)
        }
    }
    
    // MARK: - Lifecycle
    static func create(with viewModel: PhotoDetailViewModel) -> PhotoDetailViewController {
        let vc = PhotoDetailViewController()
        vc.vm = viewModel
        vc.navigationController?.isNavigationBarHidden = false
        return vc
    }
    
    
    override func loadView() {
        view = View()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        self.bind(to: vm)
        vm.onViewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    private func setUpViews() {
        title = vm.screenTitle
        navigationItem.leftBarButtonItem = UIBarButtonItem.backButton(target: self, action: #selector(didTapBack(_:)))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.favouriteButton(target: self, action: #selector(didTapFavourite(_:)), isSelected: false)
        
        self.navigationController?.navigationBar.barTintColor = .white
        
        (view as? View)?.configure(photo: vm.photo)
        
    }
    
    private func bind(to viewModel: PhotoDetailViewModel) {
        
        viewModel.isFavourite.observe(on: self) { [weak self] in
            self?.isFavourite = $0
        }
    }
    
    
    @objc func didTapBack(_ sender: UIBarButtonItem) {
        vm.backAction()
    }
    
    @objc func didTapFavourite(_ sender: UIBarButtonItem) {
        //  sender.customView as UIButton = true
        isFavourite.toggle()
        vm.toggleFavourite()
    }
    
    private class View: UIView {
        
        let imageView = UIImageView()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            commonInit()
        }
        
        private func commonInit() {
            backgroundColor = .white
            
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            setupViewsHierarchy()
            setupConstraints()
            
        }
        
        private func setupViewsHierarchy() {
            addSubview(imageView)
        }
        
        private func setupConstraints() {
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate(
                [
                    imageView.topAnchor.constraint(equalTo: topAnchor),
                    imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                    imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
                    imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
                ]
            )
            
        }
        
        func configure(photo: PhotoItemModel?) {
            // imageView.dm_setImage(posterPath: photo?.download_url)
            LoadingView.show()
            imageView.dm_setImage(posterPath:  photo?.download_url) {
                LoadingView.hide()
            }
        }
    }
    
}

