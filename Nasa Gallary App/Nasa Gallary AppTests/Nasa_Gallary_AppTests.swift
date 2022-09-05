//
//  Nasa_Gallary_AppTests.swift
//  Nasa Gallary AppTests
//
//  Created by ADMIN on 01/09/22.
//

import XCTest
@testable import Nasa_Gallary_App

class Nasa_Gallary_AppTests: XCTestCase {

    var originalViewController: NasaImageListViewController!
    
    var interactorSpy: InteractorSpy!
  
    class PresenterSpy: NasaImageListPresenter {
        
        var isPresenterCalled = false
        
        var presenterSendFeedbackModel: NasaImageList.ImageViewModel?
        
        /// Present Send Feedback Response
        ///
        /// - Parameters:
        ///   - message: API Message
        ///   - successCode: API Success Code
        override func presentFetchedImageData(response: [NasaImageList.ImageViewModel]?, message: String, statusCode: Int) {
            isPresenterCalled = true
          
        }
    }
    
    class NasaImageListWorkerSpy: NasaImageListWorker {
        
        var isGetDataCalled = false
        
        override func getImageDataFromJson(completionHandler: @escaping ([NasaImageList.ImageViewModel]?, String?, Int?) -> Void) {
            isGetDataCalled = true
            if let path = Bundle.main.path(forResource: "data", ofType: "json") {
                    do {
                          let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)

                        do {
                            let decoder = JSONDecoder()
                            //                            decoder.dateDecodingStrategy = .formatted(DateFormatter.customFormat)
                            let decodedValue = try decoder.decode(Array<NasaImageList.ImageViewModel>.self, from: data)
                            completionHandler(decodedValue    ,"List feteched successfully",1)

                        } catch (let error) {
                            completionHandler(nil,"\(error.localizedDescription)",0)
                        }

                    }catch(let error) {
                        completionHandler(nil,"\(error.localizedDescription)",0)
                    }

                }
        }
            
        }
        
    
    // MARK: - Test doubles
    class ViewControllerSpy: NasaImageListDisplayLogic {
        var displayFetchedResult = false
        
        /// Did Receive response for feedback
        ///
        /// - Parameters:
        ///   - message: API Message
        ///   - successCode: API Success
        func didReceiveFetchedImageData(response: [NasaImageList.ImageViewModel]?, message: String, statusCode: Int) {
            displayFetchedResult = true
        }
        
    }
    
    // MARK: - Test doubles
    class InteractorSpy: NasaImageListBusinessLogic {
        func fetchImageData()
      {
          self.isInteractorCalled = true
          self.worker?.isMocking = true
          worker?.getImageDataFromJson(completionHandler: {response,message,statusCode in
            
              self.presenter?.presentFetchedImageData(response: response, message: message ?? "", statusCode: statusCode ?? 0)
              
          })
      }
        
        
        var isInteractorCalled = false
        /// Presentor instance
        var presenter: NasaImageListPresenter?
        /// Worker instance
        var worker: NasaImageListWorker?
        
        
    }
    
    
    //testing presenter
    // MARK: - Tests
    func testDataFetchedByPresenter() {
        // Given
        let viewControllerSpy = ViewControllerSpy()
        let presenter = NasaImageListPresenter()
        let moviesWorkerSpy = NasaImageListWorkerSpy()
        let sut = InteractorSpy()
        sut.presenter = presenter
        sut.worker = moviesWorkerSpy
        presenter.viewController = viewControllerSpy
        
        sut.fetchImageData()
        // Then
        XCTAssert(viewControllerSpy.displayFetchedResult,
                  "presnter should ask the controller to display them")
    }
    
    //testing worker
    
    func testFetchStaticWorkerToFetch() {
        // Given
        let moviesWorkerSpy = NasaImageListWorker()
        let sut = InteractorSpy()
        sut.presenter = PresenterSpy()
        sut.worker = moviesWorkerSpy
        // When
        sut.fetchImageData()
        // Then
        XCTAssert(moviesWorkerSpy.isMocking, "callStaticPageAPI() should ask the worker to fetch page")
    }
    
    //test view controller
    
    func testShouldFetchMoviesWhenViewDidLoad() {
        originalViewController.interactor = interactorSpy
        originalViewController.interactor?.fetchImageData()
        
        // Then
        XCTAssert(interactorSpy.isInteractorCalled,"Should fetch data when view is loaded")
    }
    
    
    //testing interactor
    
    func testFetchStaticPageCallInteractor() {
        
        // Given
        let moviesWorkerSpy = NasaImageListWorkerSpy()
        let presenterSpy = PresenterSpy()
        let sut = NasaImageListInteractor()
        sut.presenter = presenterSpy
        sut.worker = moviesWorkerSpy
        // When
        sut.fetchImageData()
        // Then
        XCTAssert(presenterSpy.isPresenterCalled,
                  "fetchData() should ask the presenter to format the movies")
    }
    
 
    
    override func setUp() {
        super.setUp()
        interactorSpy = InteractorSpy()
        originalViewController = NasaImageListViewController.instance()
        
        originalViewController.beginAppearanceTransition(true, animated: false)
        originalViewController.endAppearanceTransition()
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
