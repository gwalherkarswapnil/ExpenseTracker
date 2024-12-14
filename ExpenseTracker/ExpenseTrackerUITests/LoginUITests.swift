//
//  OnboardingUITests.swift
//  ExpenseTracker
//
//  Created by Swapnil on 04/12/24.
//

@testable import ExpenseTracker
class LoginUITests: XCTestCase {
    var app: XCUIApplication!

    // MARK: - XCTestCase

    override func setUp() {
        super.setUp()

        // Since UI tests are more expensive to run, it's usually a good idea
        // to exit if a failure was encountered
        continueAfterFailure = false

        app = XCUIApplication()

        // We send a command line argument to our app,
        // to enable it to reset its state
        app.launchArguments.append("--uitesting")
    }

    // MARK: - Tests

    func testGoingThroughOnboarding() {
        app.launch()

        // Make sure we're displaying onboarding
        XCTAssertTrue(app.isDisplayingOnboarding)

        // Swipe left three times to go through the pages
        app.swipeLeft()
        app.swipeLeft()
        app.swipeLeft()

        // Tap the "Done" button
        app.buttons["Done"].tap()

        // Onboarding should no longer be displayed
        XCTAssertFalse(app.isDisplayingOnboarding)
    }
    
    /// Verifies the "Login with Facebook" functionality.
    ///
    /// This test checks if the "Login with Facebook" button is present, interacts with it,
    /// and validates that the login process is completed successfully using expectations.
    ///
    /// **Steps:**
    /// 1. Launch the app.
    /// 2. Locate and interact with the "Login with Facebook" button.
    /// 3. Observe the result and ensure the login process completes.
    ///
    /// **Expected Behavior:**
    /// - The "Login with Facebook" button exists.
    /// - Tapping the button initiates the login process.
    /// - The view or state changes to indicate successful login.
    ///
    /// **Test Dependencies:**
    /// - Proper accessibility identifiers must be set for UI elements.
    /// - Simulated or mocked responses for Facebook login flow.
    ///
    /// - Note: This test assumes that a state or UI change occurs upon successful login.
    func testLoginWithFacebook() {
        let app = XCUIApplication()
        app.launch()
        
        // Verify the first category exists as a precondition for the test.
        //check this Logic later
//        let firstCategory = app.cells.element(boundBy: 0)
//        XCTAssertTrue(firstCategory.exists, "First category should exist before login")
//        
        // Find the "Login with Facebook" button.
        let loginWithFacebookButton = app.buttons["Login with Facebook"]
        XCTAssertTrue(loginWithFacebookButton.exists, "Login with Facebook button is missing")
        
        // Tap the "Login with Facebook" button.
        loginWithFacebookButton.tap()
        
        // Use an expectation to wait for the login process to complete.
        let loginExpectation = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "exists == false"),
            object: firstCategory
        )
        
        // Wait for the expectation with a timeout.
        let result = XCTWaiter().wait(for: [loginExpectation], timeout: 10.0)
        XCTAssertEqual(result, .completed, "Login with Facebook did not complete successfully within the timeout")
    }


}
