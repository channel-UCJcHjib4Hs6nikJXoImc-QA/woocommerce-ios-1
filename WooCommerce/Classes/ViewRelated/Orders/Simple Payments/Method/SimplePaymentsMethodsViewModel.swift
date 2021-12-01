import Foundation
import Yosemite
import Combine

/// ViewModel for the `SimplePaymentsMethods` view.
///
final class SimplePaymentsMethodsViewModel: ObservableObject {

    /// Navigation bar title.
    ///
    let title: String

    /// Defines if the view should show a loading indicator.
    /// Currently set while marking the order as complete
    ///
    @Published private(set) var showLoadingIndicator = false

    /// Defines if the view should be disabled to prevent any further action.
    /// Useful to prevent any double tap while a network operation is being performed.
    ///
    var disableViewActions: Bool {
        showLoadingIndicator
    }

    /// Store's ID.
    ///
    private let siteID: Int64

    /// Order's ID to update
    ///
    private let orderID: Int64

    /// Formatted total to charge.
    ///
    private let formattedTotal: String

    /// Transmits notice presentation intents.
    ///
    private let presentNoticeSubject: PassthroughSubject<SimplePaymentsNotice, Never>

    /// Store manager to update order.
    ///
    private let stores: StoresManager

    init(siteID: Int64 = 0,
         orderID: Int64 = 0,
         formattedTotal: String,
         presentNoticeSubject: PassthroughSubject<SimplePaymentsNotice, Never> = PassthroughSubject(),
         stores: StoresManager = ServiceLocator.stores) {
        self.siteID = siteID
        self.orderID = orderID
        self.formattedTotal = formattedTotal
        self.presentNoticeSubject = presentNoticeSubject
        self.stores = stores
        self.title = Localization.title(total: formattedTotal)
    }

    /// Creates the info text when the merchant selects the cash payment method.
    ///
    func payByCashInfo() -> String {
        Localization.markAsPaidInfo(total: formattedTotal)
    }

    /// Mark an order as paid and notify if successful.
    ///
    func markOrderAsPaid(onSuccess: @escaping () -> ()) {
        showLoadingIndicator = true
        let action = OrderAction.updateOrderStatus(siteID: siteID, orderID: orderID, status: .completed) { [weak self] error in
            guard let self = self else { return }
            self.showLoadingIndicator = false

            if error == nil {
                onSuccess()
            } else {
                self.presentNoticeSubject.send(.error(Localization.markAsPaidError))
            }
            // TODO: Analytics
        }
        stores.dispatch(action)
    }
}

private extension SimplePaymentsMethodsViewModel {
    enum Localization {
        static let markAsPaidError = NSLocalizedString("There was an error while marking the order as paid.",
                                                       comment: "Text when there is an error while marking the order as paid for simple payments.")

        static func title(total: String) -> String {
            NSLocalizedString("Take Payment (\(total))", comment: "Navigation bar title for the Simple Payments Methods screens")
        }

        static func markAsPaidInfo(total: String) -> String {
            NSLocalizedString("This will mark your order as complete if you received \(total) outside of WooCommerce",
                              comment: "Alert info when selecting the cash payment method for simple payments")
        }
    }
}