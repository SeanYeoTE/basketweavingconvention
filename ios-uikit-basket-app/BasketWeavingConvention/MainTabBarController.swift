import UIKit

class MainTabBarController: UITabBarController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let infoVC = GeneralInfoViewController()
        let talksVC = TalksPageViewController()
        let nameCardVC = NameCardDisplayViewController()

        let infoNav = createNavigationController(for: infoVC)
        let talksNav = createNavigationController(for: talksVC)
        let nameCardNav = createNavigationController(for: nameCardVC)

        infoNav.tabBarItem = UITabBarItem(title: "Info", image: UIImage(systemName: "info.circle"), tag:0)
        talksNav.tabBarItem = UITabBarItem(title: "Talks", image: UIImage(systemName: "speaker"), tag:1)
        nameCardNav.tabBarItem = UITabBarItem(title: "Name Card", image: UIImage(systemName: "person.crop.rectangle"), tag:2)
        self.viewControllers = [infoNav, talksNav, nameCardNav]

    }

    // MARK: - Helper Methods

    /// Creates a navigation controller with large titles enabled
    /// - Parameter rootViewController: The view controller to wrap in navigation
    /// - Returns: Navigation controller containing the root view controller
    private func createNavigationController(for rootViewController: UIViewController) -> UINavigationController {
        // Enable large titles for this view controller
        rootViewController.navigationItem.largeTitleDisplayMode = .always

        // Create navigation controller with this view controller as root
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.navigationBar.prefersLargeTitles = true

        return navigationController
    }
}


#Preview("Tabs") {
    MainTabBarController()
}