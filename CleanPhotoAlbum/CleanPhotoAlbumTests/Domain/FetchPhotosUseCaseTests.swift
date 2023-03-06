//
//  FetchPhotosUseCaseTests.swift
//  CleanPhotoAlbumTests
//
//  Created by Ramkumar Thiyyakat on 03/03/23.
//


import XCTest

class FetchPhotosUseCaseTests: XCTestCase {
    
     let photoList: [PhotoModel] = {
        let photo1 = PhotoModel(id: "1", author: "test1", download_url: "downloadUrl1", url: "url1", width: 100, height: 100)
        let photo2 = PhotoModel(id: "1", author: "test1", download_url: "downloadUrl1", url: "url1", width: 100, height: 100)
        return [photo1, photo2]
    }()
    
    enum PhotosListRepositoryTestError: Error {
        case failedFetching
    }
        
    struct PhotosListRepositoryMock: PhotosListRepository {
        var result: Result<PhotoModelList, Error>
        
        func fetchPhotosList(query: PhotoListQueryModel,
                             completion: @escaping (Result<PhotoModelList, Error>) -> Void) -> Cancellable? {
            completion(result)
            return nil
        }
    }
    
    
    func testFetchPhotosUseCase_whenSuccessfullyFetchesPhotos() {
        // given
        let expectation = self.expectation(description: "Fetched Photos")
        let photoListRepository = PhotosListRepositoryMock(result: .success(photoList))
        let fetchPhotoUseCase = DefaultFetchPhotosUseCase(photosListRepository: photoListRepository)
        //When
        let requestValue = FetchPhotosUseCaseRequestValue(query: PhotoListQueryModel(page: "1", limit: "2"))
        
        //then
        var photos = [PhotoModel]()
        let photo1 = PhotoModel(id: "1", author: "test1", download_url: "downloadUrl1", url: "url1", width: 100, height: 100)
     _ = fetchPhotoUseCase.execute(requestValue: requestValue) { result in
            photos = (try? result.get()) ?? []
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(photos.contains(where: {$0 == photo1}))
    }
    
    func testFetchPhotosUseCase_whenFailedFetchingPhotos() {
        // given
        let expectation = self.expectation(description: "Failed Fetching Photos")
        let photoListRepository = PhotosListRepositoryMock(result: .failure(PhotosListRepositoryTestError.failedFetching))
        let fetchPhotoUseCase = DefaultFetchPhotosUseCase(photosListRepository: photoListRepository)
        //When
        let requestValue = FetchPhotosUseCaseRequestValue(query: PhotoListQueryModel(page: "1", limit: "2"))
        
        //then
        var photos = [PhotoModel]()
     
     _ = fetchPhotoUseCase.execute(requestValue: requestValue) { result in
            photos = (try? result.get()) ?? []
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(photos.isEmpty)
    }

}
