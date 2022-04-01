import SwiftUI
import Yosemite

/// A view for Adding or Editing a Coupon.
///
struct AddEditCoupon: View {

    @ObservedObject private var viewModel: AddEditCouponViewModel
    @Environment(\.presentationMode) var presentation

    init(_ viewModel: AddEditCouponViewModel) {
        self.viewModel = viewModel
        //TODO: add analytics
    }

    var body: some View {
        NavigationView {

            //TODO: implement the content of the view
            Text("Hello, World!")
                .toolbar {
                                    ToolbarItem(placement: .cancellationAction) {
                                        Button("Cancel", action: {
                                            presentation.wrappedValue.dismiss()
                                        })
                                    }
                                }
        }
        .navigationTitle(viewModel.title)
        .wooNavigationBarStyle()
    }
}

// MARK: - Constants
//
private extension AddEditCoupon {
    enum Localization {
        static let titleEditPercentageDiscount = NSLocalizedString(
            "Cancel",
            comment: "Cancel button in the navigation bar of the view for adding or editing a coupon.")
    }
}

#if DEBUG
struct AddEditCoupon_Previews: PreviewProvider {
    static var previews: some View {

        /// Edit Coupon
        ///
        let editingViewModel = AddEditCouponViewModel(existingCoupon: Coupon.sampleCoupon)
        AddEditCoupon(editingViewModel)
    }
}
#endif