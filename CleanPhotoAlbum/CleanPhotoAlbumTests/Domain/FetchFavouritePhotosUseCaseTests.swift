//
//  FetchFavouritePhotosUseCaseTests.swift
//  CleanPhotoAlbumTests
//
//  Created by Ramkumar Thiyyakat on 06/03/23.
//

import XCTest

class FetchFavouritePhotosUseCaseTests: XCTestCase {
    
    let photoList: [PhotoModel] = {
        let photo1 = PhotoModel(id: "1", author: "test1", download_url: "downloadUrl1", url: "url1", width: 100, height: 100)
        let photo2 = PhotoModel(id: "1", author: "test1", download_url: "downloadUrl1", url: "url1", width: 100, height: 100)
        return [photo1, photo2]
    }()
    let photo1 = PhotoModel(id: "1", author: "test1", download_url: "downloadUrl1", url: "url1", width: 100, height: 100)
    
    enum RepositoryTestError: Error {
        case failedFetching
        case failedSaving
        case failedChecking

    }
    
    struct FavouritePhotosRepositoryMock: FavouritePhotosRepository {
        var result1: Result<PhotoModelList?, Error>
        var result2: Result<PhotoModel, Error>
        var result3: Result<Bool, Error>
        
        func getFavouritePhotos(completion: @escaping (Result<PhotoModelList?, Error>) -> Void) {
            completion(result1)
        }
        
        func saveFavouritePhoto(photo: PhotoModel, completion: @escaping (Result<PhotoModel, Error>) -> Void) {
            completion(result2)
        }
        
        func deleteFavouritePhoto(photo: PhotoModel, completion: @escaping (Result<PhotoModel, Error>) -> Void) {
            completion(result2)
        }
        
        func checkFavouritePhoto(photo: PhotoModel, completion: @escaping (Result<Bool, Error>) -> Void) {
            completion(result3)
        }
        
    }
    
    func testFetchFavouritePhotosUseCase_whenSuccessfullyFetchesFavouritePhotos() {
        // given
        let expectation = self.expectation(description: "Fetched Photos")
        let favouritePhotosRepository = FavouritePhotosRepositoryMock(result1: .success(photoList), result2: .success(photo1), result3:.success( true))
        let fetchFavouritePhotosUseCase = DefaultFetchFavouritePhotosUseCase(favouritePhotosRepository: favouritePhotosRepository)
        //When
        var photos = [PhotoModel]()
        let photo1 = PhotoModel(id: "1", author: "test1", download_url: "downloadUrl1", url: "url1", width: 100, height: 100)
        fetchFavouritePhotosUseCase.getFavouritePhotos { result in
            //then
            photos = (try? result.get()) ?? []
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(photos.contains(where: {$0 == photo1}))
    }
    
    
    func testFetchFavouritePhotosUseCase_whenFailedFetchingPhotos() {
        // given
        let expectation = self.expectation(description: "Failed Fetching Photos")
        let favouritePhotosRepository = FavouritePhotosRepositoryMock(result1: .failure(RepositoryTestError.failedFetching), result2: .success(photo1), result3:.success( true))
        let fetchFavouritePhotosUseCase = DefaultFetchFavouritePhotosUseCase(favouritePhotosRepository: favouritePhotosRepository)
        //When
        var photos = [PhotoModel]()
        
        fetchFavouritePhotosUseCase.getFavouritePhotos { result in
            //then
            photos = (try? result.get()) ?? []
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(photos.isEmpty)
    }
    
    func testFetchFavouritePhotosUseCase_whenSuccessfullySavedFavouritePhoto() {
        // given
        let expectation = self.expectation(description: "Saved Favourite Photos")
        let favouritePhotosRepository = FavouritePhotosRepositoryMock(result1: .success(photoList), result2: .success(photo1), result3:.success( true))
        let fetchFavouritePhotosUseCase = DefaultFetchFavouritePhotosUseCase(favouritePhotosRepository: favouritePhotosRepository)
        //When
        let photo1 = PhotoModel(id: "1", author: "test1", download_url: "downloadUrl1", url: "url1", width: 100, height: 100)
        var photo:PhotoModel?
        fetchFavouritePhotosUseCase.deleteFavouritePhoto(photo: photo1, completion: { result in
            //then
            photo = (try? result.get()) 
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(photo, photo1)

    }
    
    
    func testFetchFavouritePhotosUseCase_whenFailedSavingFavouritePhoto() {
        // given
        let expectation = self.expectation(description: "Failed Saving Favourite Photos")
        let favouritePhotosRepository = FavouritePhotosRepositoryMock(result1: .success(photoList), result2: .failure(RepositoryTestError.failedSaving), result3:.success( true))
        let fetchFavouritePhotosUseCase = DefaultFetchFavouritePhotosUseCase(favouritePhotosRepository: favouritePhotosRepository)
        //When
        let photo1 = PhotoModel(id: "1", author: "test1", download_url: "downloadUrl1", url: "url1", width: 100, height: 100)
        var photo:PhotoModel?
        fetchFavouritePhotosUseCase.deleteFavouritePhoto(photo: photo1, completion: { result in
            //then
            photo = (try? result.get())
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssert(photo == nil)

    }
    
    
    func testFetchFavouritePhotosUseCase_whenSuccessfullyDeletedFavouritePhoto() {
        // given
        let expectation = self.expectation(description: "Deleted Favourite Photos")
        let favouritePhotosRepository = FavouritePhotosRepositoryMock(result1: .success(photoList), result2: .success(photo1), result3:.success( true))
        let fetchFavouritePhotosUseCase = DefaultFetchFavouritePhotosUseCase(favouritePhotosRepository: favouritePhotosRepository)
        //When
        let photo1 = PhotoModel(id: "1", author: "test1", download_url: "downloadUrl1", url: "url1", width: 100, height: 100)
        var photo:PhotoModel?
        fetchFavouritePhotosUseCase.saveFavouritePhoto(photo: photo1, completion: { result in
            //then
            photo = (try? result.get())
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(photo, photo1)

    }
    
    
    func testFetchFavouritePhotosUseCase_whenFailedDeletingFavouritePhotos() {
        // given
        let expectation = self.expectation(description: "Failed Deleting Favourite Photos")
        let favouritePhotosRepository = FavouritePhotosRepositoryMock(result1: .success(photoList), result2: .failure(RepositoryTestError.failedSaving), result3:.success( true))
        let fetchFavouritePhotosUseCase = DefaultFetchFavouritePhotosUseCase(favouritePhotosRepository: favouritePhotosRepository)
        //When
        let photo1 = PhotoModel(id: "1", author: "test1", download_url: "downloadUrl1", url: "url1", width: 100, height: 100)
        var photo:PhotoModel?
        fetchFavouritePhotosUseCase.saveFavouritePhoto(photo: photo1, completion: { result in
            //then
            photo = (try? result.get())
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssert(photo == nil)

    }
    
    func testFetchFavouritePhotosUseCase_whenSuccessfullyCheckingFavouritePhoto() {
        // given
        let expectation = self.expectation(description: "Successfully Checking Favourite Photos")
        let favouritePhotosRepository = FavouritePhotosRepositoryMock(result1: .success(photoList), result2: .success(photo1), result3:.success( true))
        let fetchFavouritePhotosUseCase = DefaultFetchFavouritePhotosUseCase(favouritePhotosRepository: favouritePhotosRepository)
        //When
        let photo1 = PhotoModel(id: "1", author: "test1", download_url: "downloadUrl1", url: "url1", width: 100, height: 100)
        var status:Bool?
        fetchFavouritePhotosUseCase.checkFavouritePhoto(photo: photo1, completion: { result in
            //then
            status = (try? result.get())
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(status, true)

    }
    
    
    func testFetchFavouritePhotosUseCase_whenFailedCheckingFavouritePhotos() {
        // given
        let expectation = self.expectation(description: "Failed checkinh Favourite Photos")
        let favouritePhotosRepository = FavouritePhotosRepositoryMock(result1: .success(photoList), result2: .failure(RepositoryTestError.failedSaving), result3:.failure(RepositoryTestError.failedChecking))
        let fetchFavouritePhotosUseCase = DefaultFetchFavouritePhotosUseCase(favouritePhotosRepository: favouritePhotosRepository)
        //When
        let photo1 = PhotoModel(id: "1", author: "test1", download_url: "downloadUrl1", url: "url1", width: 100, height: 100)
        var status:Bool?
        fetchFavouritePhotosUseCase.checkFavouritePhoto(photo: photo1, completion: { result in
            //then
            status = (try? result.get())
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssert(status == nil)

    }
    
   
}
