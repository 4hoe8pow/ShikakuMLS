// ライブラリエントリーポイント

import Foundation

@available(iOS 17.0, *)
public struct ShikakuMLS {
    public let handler: ShikakuMLSHandler

    public init() {
        // Cohort
        let cohortPresenter = CohortPresenter()
        let cohortInteractor = CohortInteractor(outputPort: cohortPresenter)
        let cohortController = CohortController(inputPort: cohortInteractor)

        // KeyManagement
        let keyManagementPresenter = KeyManagementPresenter()
        let keyManagementInteractor = KeyManagementInteractor(
            outputPort: keyManagementPresenter
        )
        let keyManagementController = KeyManagementController(
            inputPort: keyManagementInteractor
        )

        // Message
        let messagePresenter = MessagePresenter()
        let messageInteractor = MessageInteractor(outputPort: messagePresenter)
        let messageController = MessageController(inputPort: messageInteractor)

        self.handler = ShikakuMLSHandler(
            cohortController: cohortController,
            keyManagementController: keyManagementController,
            messageController: messageController,
            cohortPresenter: cohortPresenter,
            keyManagementPresenter: keyManagementPresenter,
            messagePresenter: messagePresenter
        )
    }
}
