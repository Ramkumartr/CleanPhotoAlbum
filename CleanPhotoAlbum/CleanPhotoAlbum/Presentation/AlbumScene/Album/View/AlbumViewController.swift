//
//  AlbumViewController.swift
//  CleanPhotoAlbum
//
//  Created by Ramkumar Thiyyakat on 26/02/23.
//

import UIKit

class AlbumViewController: UIViewController, Alertable {
    
    // a property to hold the collectionView
    var collectionView: UICollectionView!
    fileprivate var activityIndicator: LoadMoreActivityIndicator!
    
    private var vm: AlbumViewModel!
    private var photos = [PhotoItemModel]()
    
    
    // MARK: - Lifecycle
    
    static func create(with viewModel: AlbumViewModel) -> AlbumViewController {
        let view = AlbumViewController()
        view.vm = viewModel
        view.navigationController?.isNavigationBarHidden = true
        return view
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set the dataSource
        self.collectionView.dataSource = self
        // set the delegate
        self.collectionView.delegate = self
        
        self.collectionView.register(AlbumImageCollectionViewCell.self, forCellWithReuseIdentifier: AlbumImageCollectionViewCell.dm_defaultIdentifier)
        
        // bounce at the bottom of the collection view
        self.collectionView.alwaysBounceVertical = true
        // set the background to be white
        self.collectionView.backgroundColor = .white
        
        activityIndicator = LoadMoreActivityIndicator(scrollView: collectionView, spacingFromLastCell: 10, spacingFromLastCellWhenLoadMoreActionStart: 60)
        self.title = vm.screenTitle
        self.bind(to: vm)
        self.vm.onViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.vm.onViewWillAppear()
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func loadView() {
        // create a layout to be used
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        // make sure that there is a slightly larger gap at the top of each row
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        // set a standard item size of 60 * 60
        layout.itemSize = CGSize(width: 60, height: 60)
        // the layout scrolls horizontally
        layout.scrollDirection = .vertical
        // set the frame and layout
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        // set the view to be this UICollectionView
        self.view = collectionView
    }
    
    
    private func bind(to viewModel: AlbumViewModel) {
        vm.images.observe(on: self) { [weak self] _ in
            self?.updateData()
        }
        
        viewModel.loading.observe(on: self) { [weak self] in
            self?.updateLoading($0)
        }
        
        viewModel.error.observe(on: self) { [weak self] in self?.showError($0) }
        
    }
    
    private func updateData() {
        self.photos = self.vm.images.value
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stop()
            self?.collectionView.reloadData()
        }
    }
    
    private func updateLoading(_ status: DataLoading?) {
        if status == .requesting {
            // self.displayAnimatedActivityIndicatorView()
        } else {
            // self.hideAnimatedActivityIndicatorView()
        }
    }
    
    private func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showAlert(title: vm.errorTitle, message: error)
    }
    
}

extension AlbumViewController: UICollectionViewDelegate {
    // if the user clicks on a cell, display a message
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
        
        let photoModel = photos[indexPath.row]
        vm.onClickForDetails(photo: photoModel)
    }
}

extension AlbumViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // the number of cells are wholly dependent on the number of colours
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumImageCollectionViewCell.dm_defaultIdentifier, for: indexPath) as? AlbumImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        let photo = photos[indexPath.row]
        cell.configure(photo)
        return cell
    }
}


extension AlbumViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !self.vm.isFavouriteView {
            activityIndicator.start {[weak self] in
                self?.vm.updatePage()
                
            }
        }
    }
}
