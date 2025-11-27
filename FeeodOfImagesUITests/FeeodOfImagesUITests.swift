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
        let tablesQuery = app.tables
        let firstCell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))
        
        let tabBar = app.tabBars.element
        XCTAssertTrue(tabBar.waitForExistence(timeout: 5))
        
        let tabButtons = tabBar.buttons
        XCTAssertTrue(tabButtons.count >= 2, "В таб баре должно быть минимум 2 кнопки")
        
        let profileTabButton = tabButtons.element(boundBy: 1)
        XCTAssertTrue(profileTabButton.waitForExistence(timeout: 5))
        XCTAssertTrue(profileTabButton.isHittable)
        profileTabButton.tap()
        
        sleep(2)
        
        let nameLabel = app.staticTexts["evelyn kebich"]
        let usernameLabel = app.staticTexts["@liebessensation"]
        
        XCTAssertTrue(nameLabel.waitForExistence(timeout: 5), "Имя 'evelyn kebich' не найдено")
        XCTAssertTrue(usernameLabel.waitForExistence(timeout: 5), "Юзернейм '@liebessensation' не найден")
        
        let exitButton = app.buttons["logout_button"]
        //"logout button"
        XCTAssertTrue(exitButton.waitForExistence(timeout: 5))
        XCTAssertTrue(exitButton.isHittable)
        exitButton.tap()
        
        let alert = app.alerts["Пока, пока!"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5))
        
        let confirmButton = alert.scrollViews.otherElements.buttons["Да"]
        XCTAssertTrue(confirmButton.waitForExistence(timeout: 5))
        XCTAssertTrue(confirmButton.isHittable)
        confirmButton.tap()
        
        let authenticateButton = app.buttons["Authenticate"]
        XCTAssertTrue(authenticateButton.waitForExistence(timeout: 10))
    }
}
