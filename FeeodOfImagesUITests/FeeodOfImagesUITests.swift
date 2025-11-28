import XCTest

class Image_FeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAuth() throws {
        let app = XCUIApplication()
        app.launch()
        
        let authenticateButton = app.buttons["Войти"]
        XCTAssertTrue(authenticateButton.waitForExistence(timeout: 5))
        authenticateButton.tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 10))
        sleep(3)
        
        let loginTextField = webView.textFields.element(boundBy: 0)
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 10))
        loginTextField.tap()
        sleep(2)
        loginTextField.typeText("...")
        
        webView.tap()
        sleep(1)
        
        let passwordTextField = webView.secureTextFields.element(boundBy: 0)
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 10))
        
        passwordTextField.tap()
        sleep(3)
        
        passwordTextField.typeText("..")
        sleep(1)
        
        if passwordTextField.value as? String != "..." {
            UIPasteboard.general.string = "..."
            passwordTextField.doubleTap()
            sleep(1)
            if app.menuItems["Paste"].waitForExistence(timeout: 2) {
                app.menuItems["Paste"].tap()
            }
        }
        
        sleep(1)
        
        let loginButton = webView.buttons["Login"]
        if loginButton.waitForExistence(timeout: 5) {
            loginButton.tap()
        }
        
        let cell = app.tables.cells.element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 15))
    }
    
    func testFeed() throws {
        let app = XCUIApplication()
        
        let exists = app.wait(for: .runningForeground, timeout: 10)
        XCTAssertTrue(exists, "Приложение не запустилось")
        
        let anyInteractiveElement = app.buttons.firstMatch
        let hasContent = anyInteractiveElement.waitForExistence(timeout: 15)
        
        XCTAssertTrue(hasContent, "Приложение не показывает интерактивный контент")
        
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["evelyn kebich"].exists)
        XCTAssertTrue(app.staticTexts["@liebessensation"].exists)
        
        app.buttons["logout button"].tap()
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
       // let authenticateButton = app.buttons["Authenticate"]
        let authenticateButton = app.buttons["Войти"]
        XCTAssertTrue(authenticateButton.waitForExistence(timeout: 5))
    }
}
