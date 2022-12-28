import SwiftUI

/// Hosting controller that wraps the `StoreCreationSellingStatusQuestionView`.
final class StoreCreationSellingStatusQuestionHostingController: UIHostingController<StoreCreationSellingStatusQuestionView> {
    init(storeName: String, onContinue: @escaping () -> Void, onSkip: @escaping () -> Void) {
        super.init(rootView: StoreCreationSellingStatusQuestionView(storeName: storeName, onContinue: onContinue, onSkip: onSkip))
    }

    @available(*, unavailable)
    required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTransparentNavigationBar()
    }
}

/// Shows the store selling status question in the store creation flow.
struct StoreCreationSellingStatusQuestionView: View {
    @ObservedObject private var viewModel: StoreCreationSellingStatusQuestionViewModel

    init(storeName: String, onContinue: @escaping () -> Void, onSkip: @escaping () -> Void) {
        self.viewModel = StoreCreationSellingStatusQuestionViewModel(storeName: storeName, onContinue: onContinue, onSkip: onSkip)
    }

    var body: some View {
        OptionalStoreCreationProfilerQuestionView(viewModel: viewModel) {
            VStack(spacing: 16) {
                ForEach(viewModel.sellingStatuses, id: \.self) { sellingStatus in
                    Button(action: {
                        viewModel.selectStatus(sellingStatus)
                    }, label: {
                        HStack {
                            Text(sellingStatus.description)
                            Spacer()
                        }
                    })
                    .buttonStyle(SelectableSecondaryButtonStyle(isSelected: viewModel.selectedStatus == sellingStatus))
                }
            }
        }
    }
}

struct StoreCreationSellingStatusQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        StoreCreationSellingStatusQuestionView(storeName: "New Year Store", onContinue: {}, onSkip: {})
    }
}