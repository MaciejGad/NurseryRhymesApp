import Foundation

final class RhymeViewControllerFactory {
    func makeViewController(viewModel: ListViewModel) -> RhymeViewController {
        return RhymeViewController(viewModel: viewModel)
    }
}
