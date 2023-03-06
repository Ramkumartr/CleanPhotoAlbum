//
//  AlbumViewModelTests.swift
//  CleanPhotoAlbumTests
//
//  Created by Ramkumar Thiyyakat on 04/03/23.
//

import XCTest

class AlbumViewModelTests: XCTestCase {
    
    private enum UseCaseError: Error {
        case someError
    }
    
    let photoList: [PhotoModel] = {
        let photo1 = PhotoModel(id: "1", author: "test1", download_url: "downloadUrl1", url: "url1", width: 100, height: 100)
        let photo2 = PhotoModel(id: "2", author: "test1", download_url: "downloadUrl1", url: "url1", width: 100, height: 100)
        return [photo1, photo2]
    }()
    
    let photoList2: [PhotoModel] = {
        let photo1 = PhotoModel(id: "3", author: "test1", download_url: "downloadUrl1", url: "url1", width: 100, height: 100)
        let photo2 = PhotoModel(id: "4", author: "test1", download_url: "downloadUrl1", url: "url1", width: 100, height: 100)
        return [photo1, photo2]
    }()
    
    class FetchPhotosUseCaseMock: FetchPhotosUseCase {
        var expectation: XCTestExpectation?
        var error: Error?
        var photoList: [PhotoModel] = [PhotoModel]()
        
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
    
    
    func test_whenFetchPhotosUseCaseRetrivesTwoPhotos_thenViewModelContainsOnlyTwoPhotos() {
        // given
        let fetchPhotosUseCaseMock = FetchPhotosUseCaseMock()
        fetchPhotosUseCaseMock.expectation = self.expectation(description: "contains only two photos")
        //        fetchPhotosUseCaseMock.expectation?.expectedFulfillmentCount = 2
        fetchPhotosUseCaseMock.photoList = photoList
        let viewModel = DefaultAlbumViewModel(fetchPhotosUseCase: fetchPhotosUseCaseMock)
        
        //when
        viewModel.onViewDidLoad()
        
        //then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.images.value.map { $0.id }, photoList.map { $0.id })
        XCTAssertEqual(viewModel.pageNumber, 1)
    }
    
    
    func test_whenFetchPhotosUseCaseRetrivesPhotosTwice_thenViewModelContainsFourPhotos() {
        // given
        let fetchPhotosUseCaseMock = FetchPhotosUseCaseMock()
        fetchPhotosUseCaseMock.expectation = self.expectation(description: "contains only four photos")
        fetchPhotosUseCaseMock.expectation?.expectedFulfillmentCount = 2
        fetchPhotosUseCaseMock.photoList = photoList
        let viewModel = DefaultAlbumViewModel(fetchPhotosUseCase: fetchPhotosUseCaseMock)
        
        //when
        viewModel.onViewDidLoad()
        fetchPhotosUseCaseMock.photoList = photoList2
        viewModel.updatePage()

        
        //then
        var photoListFull = photoList
        photoListFull.append(contentsOf: photoList2)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.images.value.map { $0.id }, photoListFull.map { $0.id })
        XCTAssertEqual(viewModel.pageNumber, 2)
    }
    
    func test_whenFetchPhotosUseCaseReturnsError_thenViewModelContainsError() {
        // given
        let fetchPhotosUseCaseMock = FetchPhotosUseCaseMock()
        fetchPhotosUseCaseMock.expectation = self.expectation(description: "contains error")
        fetchPhotosUseCaseMock.error = UseCaseError.someError
        let viewModel = DefaultAlbumViewModel(fetchPhotosUseCase: fetchPhotosUseCaseMock)
        
        //when
        viewModel.onViewDidLoad()
        
        //then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.error.value, "Failed loading photos")
        XCTAssertEqual(viewModel.pageNumber, 0)
    }
    
    //When Fetching Favourite Photos
    
    class FetchFavouritePhotosUseCaseMock: FetchFavouritePhotosUseCase {
        
        var expectation: XCTestExpectation?
        var error: Error?
        var photoList: [PhotoModel] = [PhotoModel]()
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
                completion(.success(true))
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
    
    
    func test_whenFetchFavouritePhotosUseCaseRetrivesTwoPhotos_thenViewModelContainsTwoPhotos() {
        // given
        let fetchFavouritePhotosUseCaseMock = FetchFavouritePhotosUseCaseMock()
        fetchFavouritePhotosUseCaseMock.expectation = self.expectation(description: "contains only two photos")
      //  fetchPhotosUseCaseMock.expectation?.expectedFulfillmentCount = 2
        fetchFavouritePhotosUseCaseMock.photoList = photoList
        let viewModel = DefaultAlbumViewModel(fetchFavouritePhotosUseCase: fetchFavouritePhotosUseCaseMock)

        //when
        viewModel.onViewDidLoad()

        //then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.images.value.map { $0.id }, photoList.map { $0.id })
    }
    
    func test_whenFetchFavouritePhotosUseCaseReturnsError_thenViewModelContainsErrorValue() {
        // given
        let fetchFavouritePhotosUseCaseMock = FetchFavouritePhotosUseCaseMock()
        fetchFavouritePhotosUseCaseMock.expectation = self.expectation(description: "contains only two photos")
      //  fetchPhotosUseCaseMock.expectation?.expectedFulfillmentCount = 2
        fetchFavouritePhotosUseCaseMock.error = UseCaseError.someError
        let viewModel = DefaultAlbumViewModel(fetchFavouritePhotosUseCase: fetchFavouritePhotosUseCaseMock)

        //when
        viewModel.onViewDidLoad()

        //then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.error.value, "Failed loading photos")
    }
  
}
