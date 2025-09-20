//
//  MessagePresenter.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/20.
//

import Foundation
import Observation

@available(iOS 17.0, *)
@Observable
public final class MessagePresenter: Observable, MessageOutputPort {
    var sentMessage: SendMessageResponseDTO?
    var decryptedMessage: DecryptMessageResponseDTO?
    var messageError: Error?

    public func didSendMessage(response: SendMessageResponseDTO) {
        sentMessage = response
    }

    public func didDecryptMessage(response: DecryptMessageResponseDTO) {
        decryptedMessage = response
    }

    public func didFailMessageOperation(error: Error) {
        messageError = error
    }
}
