import UIKit

class TalksPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    
    // MARK: - Properties

    private var talkViewControllers = [UIViewController]()
    private let pageControl = UIPageControl()

    /// Conference talks to display (swipe left/right to navigate)
    private let talks = [
        Talk(title: "The Art of Underwater Basket Weaving", speaker: "John Doe", time: "10:00 AM", summary: "A deep dive into the history and techniques of underwater basket weaving."),
        Talk(title: "Modern Basket Weaving Materials", speaker: "Jane Smith", time: "11:00 AM", summary: "Exploring new and sustainable materials for basket weaving."),
        Talk(title: "Basket Weaving for Fun and Profit", speaker: "Peter Jones", time: "1:00 PM", summary: "How to turn your hobby into a successful business.")
    ]

    // MARK: - Lifecycle

    init() {
        // UIPageViewController transitions between view controllers with gestures
        // .scroll gives us horizontal swiping between pages
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "Talks"

        dataSource = self
        delegate = self

        configurePages()
        configurePageControl()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Setup

    private func configurePages() {
        talkViewControllers = talks.map { TalkViewController(talk: $0) }
        if let first = talkViewControllers.first { setViewControllers([first], direction: .forward, animated: false)}
        pageControl.numberOfPages = talkViewControllers.count
        pageControl.currentPage = 0
    }

    private func configurePageControl() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false

        // Style the page control dots
        pageControl.currentPageIndicatorTintColor = .label // Active dot
        pageControl.pageIndicatorTintColor = UIColor.label.withAlphaComponent(0.2) // Inactive dots

        pageControl.isUserInteractionEnabled = false // User can't tap dots, only swipe
        pageControl.hidesForSinglePage = true // Hide if only one page

        // Add page control on top of page view controller's content
        view.addSubview(pageControl)
        view.bringSubviewToFront(pageControl) // Ensure it's visible above other views

        // Position at bottom center of screen
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    // MARK: - UIPageViewControllerDataSource

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = talkViewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = currentIndex - 1
        guard previousIndex >= 0 else { return nil }
        return talkViewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = talkViewControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = currentIndex + 1
        guard nextIndex < talkViewControllers.count else { return nil }
        return talkViewControllers[nextIndex]
    }

    // MARK: - UIPageViewControllerDelegate

    /// Sync the page control dots once a swipe actually completes
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed,
              let current = viewControllers?.first,
              let index = talkViewControllers.firstIndex(of: current)
        else { return }
        pageControl.currentPage = index
    }
}
