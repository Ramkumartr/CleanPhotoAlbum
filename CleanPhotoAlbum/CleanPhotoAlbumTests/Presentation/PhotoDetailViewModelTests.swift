//
//  PhotoDetailViewModelTests.swift
//  CleanPhotoAlbumTests
//
//  Created by Ramkumar Thiyyakat on 06/03/23.
//

import XCTest

class PhotoDetailViewModelTests: XCTestCase {
    
    private enum UseCaseError: Error {
        case someError
    }
    
    let photo1 = PhotoItemModel(id: "1", author: "test1", download_url: "downloadUrl1", url: "url1", width: 100, height: 100)
    
    let photo2 = PhotoModel(id: "2", author: "test2", download_url: "downloadUrl2", url: "url2", width: 100, height: 100)
    class FetchFavouritePhotosUseCaseMock: FetchFavouritePhotosUseCase {
        
        var expectation: XCTestExpectation?
        var error: Error?
        var photoList: [PhotoModel] = [PhotoModel]()
        var storePhoto:PhotoModel?
        func getFavouritePhotos(completion: @escaping (Result<PhotoModelList?, Error>) -> Void) {
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(photoList))
            }
            expectation?.fulfill()
            return
        }
        
        func saveFavouritePhoto(photo: PhotoModel, completion: @escaping (Result<PhotoModel, Error>) -> Void) {
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(photo))
            }
            expectation?.fulfill()
            return
        }
        
        func deleteFavouritePhoto(photo: PhotoModel, completion: @escaping (Result<PhotoModel, Error>) -> Void) {
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(photo))
            }
            expectation?.fulfill()
            return
        }
        
        func checkFavouritePhoto(photo: PhotoModel, completion: @escaping (Result<Bool, Error>) -> Void) {
            if let error = error {
                completion(.failure(error))
            } else {
                if let ph = storePhoto {
                    completion(.success(ph.id == photo.id))
                }else{
                    
                    completion(.success(true))
                }
            }
            expectation?.fulfill()
            return
        }
        
        
        
        func execute(requestValue: FetchPhotosUseCaseRequestValue,
                     completion: @escaping (Result<PhotoModelList, Error>) -> Void) -> Cancellable? {
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(photoList))
            }
            expectation?.fulfill()
            return nil
        }
    }
    
    
    func test_whenFetchFavouritePhotosUseCaseCheckingFavouritePhotoThatStoredAsFavourite_thenViewModelContainsIsFavouriteTrue() {
        // given
        let fetchFavouritePhotosUseCaseMock = FetchFavouritePhotosUseCaseMock()
        fetchFavouritePhotosUseCaseMock.expectation = self.expectation(description: "isFavourite is true")
        let viewModel = DefaultPhotoDetailViewModel(photo: photo1, fetchFavouritePhotosUseCase: fetchFavouritePhotosUseCaseMock)
        
        //when
        viewModel.onViewDidLoad()
        
        //then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.isFavourite.value, true)
    }
    
    func test_whenFetchFavouritePhotosUseCaseCheckingFavouritePhotoThatReturnsError_thenViewModelContainsError() {
        // given
        let fetchFavouritePhotosUseCaseMock = FetchFavouritePhotosUseCaseMock()
        fetchFavouritePhotosUseCaseMock.expectation = self.expectation(description: "Error when checking is favourite")
        fetchFavouritePhotosUseCaseMock.error = UseCaseError.someError
        let viewModel = DefaultPhotoDetailViewModel(photo: photo1, fetchFavouritePhotosUseCase: fetchFavouritePhotosUseCaseMock)
        
        //when
        viewModel.onViewDidLoad()
        
        //then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.error.value, "Stotage error")
    }
    
    func test_whenFetchFavouritePhotosUseCaseCheckingFavouritePhotoThatNotStoredAsFavourite_thenViewModelContainsIsFavouriteFalse() {
        // given
        let fetchFavouritePhotosUseCaseMock = FetchFavouritePhotosUseCaseMock()
        fetchFavouritePhotosUseCaseMock.expectation = self.expectation(description: "isFavourite is false")
        fetchFavouritePhotosUseCaseMock.storePhoto = photo2
        let viewModel = DefaultPhotoDetailViewModel(photo: photo1, fetchFavouritePhotosUseCase: fetchFavouritePhotosUseCaseMock)
        
        //when
        viewModel.onViewDidLoad()
        
        //then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.isFavourite.value, false)
    }
    
    func test_whenFetchFavouritePhotosUseCaseToggleFavouriteStatusOnce_thenViewModelContainsIsFavouriteAlsoChangesOnce() {
        // given
        let fetchFavouritePhotosUseCaseMock = FetchFavouritePhotosUseCaseMock()
        fetchFavouritePhotosUseCaseMock.expectation = self.expectation(description: "isFavourite is changed")
        let viewModel = DefaultPhotoDetailViewModel(photo: photo1, fetchFavouritePhotosUseCase: fetchFavouritePhotosUseCaseMock)
        
        //when
        viewModel.toggleFavourite()
        
        //then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.isFavourite.value, true)
    }
    
    func test_whenFetchFavouritePhotosUseCaseToggleFavouriteStatusTwice_thenViewModelContainsIsFavouriteAlsoChangesTwice() {
        // given
        let fetchFavouritePhotosUseCaseMock = FetchFavouritePhotosUseCaseMock()
        fetchFavouritePhotosUseCaseMock.expectation = self.expectation(description: "isFavourite is changed")
        fetchFavouritePhotosUseCaseMock.expectation?.expectedFulfillmentCount = 2
        let viewModel = DefaultPhotoDetailViewModel(photo: photo1, fetchFavouritePhotosUseCase: fetchFavouritePhotosUseCaseMock)
        
        //when
        viewModel.toggleFavourite()
        viewModel.toggleFavourite()
        //then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.isFavourite.value, false)
    }
    
    
    func test_whenFetchFavouritePhotosUseCaseToggleFavouriteStatusWithError_thenViewModelContainsError() {
        // given
        let fetchFavouritePhotosUseCaseMock = FetchFavouritePhotosUseCaseMock()
        fetchFavouritePhotosUseCaseMock.expectation = self.expectation(description: "Error occured")
        fetchFavouritePhotosUseCaseMock.error = UseCaseError.someError
        let viewModel = DefaultPhotoDetailViewModel(photo: photo1, fetchFavouritePhotosUseCase: fetchFavouritePhotosUseCaseMock)
        
        //when
        viewModel.toggleFavourite()
        
        //then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.error.value, "Stotage error")
    }
    
    func test_whenFetchFavouritePhotosUseCaseToggleFavouriteStatusTwiceWithError_thenViewModelContainsError() {
        // given
        let fetchFavouritePhotosUseCaseMock = FetchFavouritePhotosUseCaseMock()
        fetchFavouritePhotosUseCaseMock.expectation = self.expectation(description: "isFavourite is changed")
        fetchFavouritePhotosUseCaseMock.expectation?.expectedFulfillmentCount = 2
        fetchFavouritePhotosUseCaseMock.error = UseCaseError.someError
        let viewModel = DefaultPhotoDetailViewModel(photo: photo1, fetchFavouritePhotosUseCase: fetchFavouritePhotosUseCaseMock)
        
        //when
        viewModel.toggleFavourite()
        viewModel.toggleFavourite()
        //then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.error.value, "Stotage error")
    }
    
    func test_whenFetchFavouritePhotosUseCaseRemoveFavouritePhotoWithError_thenViewModelContainsError() {
        // given
        let fetchFavouritePhotosUseCaseMock = FetchFavouritePhotosUseCaseMock()
        fetchFavouritePhotosUseCaseMock.expectation = self.expectation(description: "Error occured")
        fetchFavouritePhotosUseCaseMock.error = UseCaseError.someError
        let viewModel = DefaultPhotoDetailViewModel(photo: photo1, fetchFavouritePhotosUseCase: fetchFavouritePhotosUseCaseMock)
        viewModel.isFavourite.value = true
        //when
        viewModel.toggleFavourite()
        
        //then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.error.value, "Stotage error")
    }
}
