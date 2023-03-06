//
//  AlbumViewModel.swift
//  CleanPhotoAlbum
//
//  Created by Ramkumar Thiyyakat on 26/02/23.
//

import Foundation

let pageLimitConstant = "100"

struct AlbumViewModelActions {
    let showPhotoDetails: (PhotoItemModel) -> Void
}


enum DataLoading {
    case requesting
    case finished
}
protocol AlbumViewModelInput {
    func onViewDidLoad()
    func onViewWillAppear()
    func onClickForDetails(photo: PhotoItemModel)
    func updatePage()
}

protocol AlbumViewModelOutput {
    var images: Observable<[PhotoItemModel]> { get }
    var error:  Observable<String> { get }
    var screenTitle:  String { get }
    var loading:  Observable<DataLoading?> { get }
    var emptyDataTitle: String { get }
    var errorTitle: String { get }
    var isFavouriteView: Bool { get }
    
}
protocol AlbumViewModel: AlbumViewModelInput, AlbumViewModelOutput{}

final class DefaultAlbumViewModel: AlbumViewModel {
    
    private let fetchPhotosUseCase: FetchPhotosUseCase?
    private let fetchFavouritePhotosUseCase: FetchFavouritePhotosUseCase?
    private let actions: AlbumViewModelActions?
    
    private var isFetching:Bool = false
    
    var pageNumber: Int = 0
    private var photosLoadTask: Cancellable? { willSet { photosLoadTask?.cancel() } }
    
    
    // Outputs
    var images: Observable<[PhotoItemModel]> = Observable([])
    var error: Observable<String> = Observable("")
    var loading: Observable<DataLoading? > = Observable(.none)
    
    var screenTitle: String {
        if (fetchPhotosUseCase != nil) {
            return "Album"
        } else {
            return "Favourites"
        }
    }
    
    let emptyDataTitle = "No Data"
    let errorTitle = "Error"
    var isFavouriteView: Bool { return  fetchFavouritePhotosUseCase != nil}
    
    // MARK: - Init
    
    init(fetchPhotosUseCase: FetchPhotosUseCase? = nil,
         actions: AlbumViewModelActions? = nil, fetchFavouritePhotosUseCase: FetchFavouritePhotosUseCase? = nil) {
        self.fetchPhotosUseCase = fetchPhotosUseCase
        self.fetchFavouritePhotosUseCase = fetchFavouritePhotosUseCase
        self.actions = actions
    }
    
    private func load(photoListQuery: PhotoListQueryModel, loading: DataLoading) {
        self.loading.value = loading
        if let useCase = fetchPhotosUseCase {
            photosLoadTask = useCase.execute(
                requestValue: .init(query: photoListQuery),
                completion: {[weak self] result in
                    guard let self = self else {return}
                    switch result {
                    case .success(let list):
                        self.pageNumber = self.pageNumber + 1
                        self.images.value.append(contentsOf: list.map(PhotoItemModel.init))
                    case .failure(let error):
                        self.handle(error: error)
                    }
                    self.loading.value = .none
                    self.isFetching = false
                })
        } else  {
            fetchFavouritePhotos()
        }
    }
    
    private func fetchFavouritePhotos() {
        fetchFavouritePhotosUseCase?.getFavouritePhotos { result in
            switch result {
            case .success(let models):
                if let list = models {
                    self.images.value = list.map(PhotoItemModel.init)
                }
            case .failure(let error):
                self.handle(error: error)
                break
            }
            
            self.loading.value = .none
        }
        
    }
    
    private func handle(error: Error) {
        self.error.value = error.isInternetConnectionError ?
        NSLocalizedString("No internet connection", comment: "") :
        NSLocalizedString("Failed loading photos", comment: "")
    }
}

// MARK: - INPUT. View event methods

extension DefaultAlbumViewModel {
    
    func onViewDidLoad() {
        self.loading.value = .requesting
        updatePage()
    }
    
    func onViewWillAppear() {
        
        fetchFavouritePhotos()
    }
    
    func onClickForDetails(photo: PhotoItemModel) {
        print("onClickForDetails photo id \(photo.id)")
        actions?.showPhotoDetails(photo)
    }
    
    func updatePage() {
        if !isFetching {
            isFetching = true
            load(photoListQuery: .init(page: String(pageNumber), limit: pageLimitConstant), loading: .requesting)
        }
    }
}
