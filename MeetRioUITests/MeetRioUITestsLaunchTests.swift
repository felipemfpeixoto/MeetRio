//
//  MeetRioUITestsLaunchTests.swift
//  MeetRioUITests
//
//  Created by Felipe on 27/09/24.
//

import XCTest

final class MeetRioUITestsLaunchTests: XCTestCase {
    
    var app: XCUIApplication!

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments.append("--reset-app")
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

//        let attachment = XCTAttachment(screenshot: app.screenshot())
//        attachment.name = "Launch Screen"
//        attachment.lifetime = .keepAlways
//        add(attachment)
    }
    
    
    @MainActor
    func testLoginAnonimous() throws {
        let app = XCUIApplication()
        app.launchArguments.append("--reset-app")
        app.launch()
        
        let continueButton = app.buttons["InitialButton"]
        
        let continueButtonExpectation = XCTNSPredicateExpectation(predicate: NSPredicate(format: "exists == true"), object: continueButton)
        let result = XCTWaiter.wait(for: [continueButtonExpectation], timeout: 5.0)
        XCTAssertEqual(result, .completed, "O botão continuar não apareceu a tempo.")
        
        XCTAssertTrue(continueButton.exists, "O botão inicial não existe na tela inicial.")
        XCTAssertTrue(continueButton.isEnabled, "O botão inicial está desativado.")
        
        continueButton.tap()
        
        let enterWithoutLogin = app.buttons["signInAnonymous"]
        
        let anonymousButtonExpectation = XCTNSPredicateExpectation(predicate: NSPredicate(format: "exists == true"), object: enterWithoutLogin)
        let anonymousResult = XCTWaiter.wait(for: [anonymousButtonExpectation], timeout: 5.0)
        XCTAssertEqual(anonymousResult, .completed, "O botão de entrar sem login não apareceu a tempo.")
        
        XCTAssertTrue(enterWithoutLogin.exists, "O botão sem login não existe na tela inicial.")
        XCTAssertTrue(enterWithoutLogin.isEnabled, "O botão sem login está desativado.")
        
        enterWithoutLogin.tap()
    }
    
    
    func testNavigation() throws {
        let app = XCUIApplication()
        app.launchArguments.append("--reset-app")
        app.launch()
        
        let continueButton = app.buttons["InitialButton"]
        
        let continueButtonExpectation = XCTNSPredicateExpectation(predicate: NSPredicate(format: "exists == true"), object: continueButton)
        let result = XCTWaiter.wait(for: [continueButtonExpectation], timeout: 5.0)
        XCTAssertEqual(result, .completed, "O botão continuar não apareceu a tempo.")
        
        XCTAssertTrue(continueButton.exists, "O botão inicial não existe na tela inicial.")
        XCTAssertTrue(continueButton.isEnabled, "O botão inicial está desativado.")
        
        continueButton.tap()
        
        let enterWithoutLogin = app.buttons["signInAnonymous"]
        
        let anonymousButtonExpectation = XCTNSPredicateExpectation(predicate: NSPredicate(format: "exists == true"), object: enterWithoutLogin)
        let anonymousResult = XCTWaiter.wait(for: [anonymousButtonExpectation], timeout: 5.0)
        XCTAssertEqual(anonymousResult, .completed, "O botão de entrar sem login não apareceu a tempo.")
        
        XCTAssertTrue(enterWithoutLogin.exists, "O botão sem login não existe na tela inicial.")
        XCTAssertTrue(enterWithoutLogin.isEnabled, "O botão sem login está desativado.")
        
        enterWithoutLogin.tap()
    }
    
}

//
