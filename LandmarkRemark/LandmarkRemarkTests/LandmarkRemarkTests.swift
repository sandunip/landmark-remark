//
//  LandmarkRemarkTests.swift
//  LandmarkRemarkTests
//
//  Created by Sanduni Perera on 19/2/22.
//  Copyright © 2022 Sanduni Perera. All rights reserved.
//

import XCTest
@testable import LandmarkRemark

class LandmarkRemarkTests: XCTestCase {
    
    var vc : WelcomeViewController!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testUsernameTextFieldLimit() {
        // Set up view before interacting with the text field
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
        vc.loadView()
        
        // Test one more than the maximum number of allowable characters
        let overTheLimitString = String(repeating: Character("a"), count: vc.maxNumCharacters)
        let overTheLimitResult = vc.textField(vc.userNameTextField, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: overTheLimitString)
        XCTAssertFalse(overTheLimitResult, "The text field should not allow \(vc.maxNumCharacters+1) characters")
    }
}
