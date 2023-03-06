//
//  PhotoDetailViewModel.swift
//  PhotoAlbum
//
//  Created by Ramkumar Thiyyakat on 20/12/22.
//

import Foundation

struct PhotoDetailViewModelActions {
    let backAction: () -> Void
}


protocol PhotoDetailViewModelInput {
    func onViewDidLoad()
    func toggleFavourite()
    func backAction()
}

protocol PhotoDetailViewModelOutput {
    var photo: PhotoItemModel { get }
    var isFavourite:  Observable<Bool> { get }
    var screenTitle: String { get }
}

protocol PhotoDetailViewModel: PhotoDetailViewModelInput, PhotoDetailViewModelOutput{}

final class DefaultPhotoDetailViewModel: PhotoDetailViewModel {
    
    private let fetchFavouritePhotosUseCase: FetchFavouritePhotosUseCase
    private let actions: PhotoDetailViewModelActions?
    let photo: PhotoItemModel
    private var isFetching:Bool = false
    
    
    
    // Outputs
    var error: Observable<String> = Observable("")
    var screenTitle: String {
        return photo.author
    }
    var isFavourite: Observable<Bool> = Observable(false)
    var loading: Observable<DataLoading? > = Observable(.none)
    
    
    init(photo: PhotoItemModel,
         actions: PhotoDetailViewModelActions? = nil, fetchFavouritePhotosUseCase: FetchFavouritePhotosUseCase) {
        self.photo = photo
        self.actions = actions
        self.fetchFavouritePhotosUseCase = fetchFavouritePhotosUseCase
    }
    
    private  func checkIsFavourite() {
        
        print("onClickForDetails photo id \(photo.id)")
        
        fetchFavouritePhotosUseCase.checkFavouritePhoto(photo: photo.toRequestModel()) { result in
            switch result {
            case .success(let status):
                self.isFavourite.value = status
            case .failure(let error):
                self.handle(error: error)
                break
            }
        }
        
    }
    
    private  func setAsFavourite() {
        fetchFavouritePhotosUseCase.saveFavouritePhoto(photo: photo.toRequestModel()) { result in
            switch result {
            case .success(_):
                self.isFavourite.value = true
            case .failure(let error):
                self.handle(error: error)
                break
            }
        }
        
    }
    
    private  func removeAsFavourite() {
        fetchFavouritePhotosUseCase.deleteFavouritePhoto(photo: photo.toRequestModel()) { result in
            switch result {
            case .success(_):
                self.isFavourite.value = false
            case .failure(let error):
                self.handle(error: error)
                break
            }
        }
        
    }
    
    private func handle(error: Error) {
        self.error.value = NSLocalizedString("Stotage error", comment: "")
    }
}


// MARK: - INPUT. View event methods

extension DefaultPhotoDetailViewModel {
    
    
    func onViewDidLoad() {
        checkIsFavourite()
    }
    
    func toggleFavourite() {
        
        if isFavourite.value {
            removeAsFavourite()
            
        } else {
            setAsFavourite()
        }
    }
    
    func backAction() {
        actions?.backAction()
    }
    
}
