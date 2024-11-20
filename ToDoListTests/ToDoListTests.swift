//
//  ToDoListTests.swift
//  ToDoListTests
//
//  Created by Evgenii Mikhailov on 20.11.2024.
//

import XCTest
@testable import ToDoList

class MainScreenInteractorTests: XCTestCase {
    var interactor: MainScreenInteractor!
    var mockNetworkService: MockNetworkService!
    var mockCoreDataStack: MockCoreDataStack!
    var mockPresenter: MockMainScreenPresenter!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        mockCoreDataStack = MockCoreDataStack()
        mockPresenter = MockMainScreenPresenter()
        interactor = MainScreenInteractor(coreData: mockCoreDataStack, networkService: mockNetworkService)
        interactor.presenter = mockPresenter
    }
    
    override func tearDown() {
        interactor = nil
        mockNetworkService = nil
        mockCoreDataStack = nil
        mockPresenter = nil
        super.tearDown()
    }
    
    func testFetchTasksSuccess() {
        // Подготовка данных
        let task1 = TaskModel(id: 1, description: "Test Description", todo: "Test Todo", completed: false, userId: 1, date: "01/01/23")
        let task2 = TaskModel(id: 1, description: "Test Description", todo: "Test Todo", completed: false, userId: 1, date: "01/01/23")
        
        let tasks = [task1, task2]
        let tasksResponse = TasksResponse(todos: tasks, total: 2, skip: 0, limit: 0)
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(tasksResponse) else {
            XCTFail("Не удалось закодировать тестовые данные")
            return
        }
        mockNetworkService.mockData = data
        mockNetworkService.shouldReturnError = false
        let expectation = self.expectation(description: "FetchTasksSuccess")
        
        mockPresenter.didFetchTasksCalled = false
        mockPresenter.didFailToFetchTasksCalled = false
        interactor.fetchTasks()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.mockPresenter.didFetchTasksCalled, "Метод didFetchTasks не был вызван")
            XCTAssertFalse(self.mockPresenter.didFailToFetchTasksCalled, "Метод didFailToFetchTasks не должен быть вызван")
            XCTAssertEqual(self.mockPresenter.fetchedTasks?.count, 2, "Должен быть загружен один таск")
            XCTAssertEqual(self.mockPresenter.fetchedTasks?.first?.todo, "Test Todo", "Таск должен иметь правильное значение todo")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchTasksFailure() {
        // Подготовка ошибки
        mockNetworkService.shouldReturnError = true
        mockNetworkService.mockError = NSError(domain: "NetworkError", code: -1009, userInfo: nil)
        let expectation = self.expectation(description: "FetchTasksFailure")
        
        mockPresenter.didFetchTasksCalled = false
        mockPresenter.didFailToFetchTasksCalled = false
        interactor.fetchTasks()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertFalse(self.mockPresenter.didFetchTasksCalled, "Метод didFetchTasks не должен быть вызван")
            XCTAssertTrue(self.mockPresenter.didFailToFetchTasksCalled, "Метод didFailToFetchTasks должен быть вызван")
            XCTAssertNotNil(self.mockPresenter.fetchError, "Ошибка должна быть передана презентеру")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
}
