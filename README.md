# ShikakuMLS

ShikakuMLSは、iOS/Swift環境向けに設計された端末完結型E2EEライブラリです。  
1:1通信およびCohort（グループ）通信に対応し、Forward SecrecyやPost-Compromise Securityを保証します。  

---

## 1. 特徴

- **端末完結型E2EE**  
  平文は端末メモリ上でのみ処理され、永続化されません。  
- **1:1通信・Cohort通信対応**  
  - 1:1: Double Ratchet Protocol（X25519 + AES-GCM + Ed25519）  
  - Cohort: Messaging Layer Security (MLS) Protocol (TreeKEM + Sender Key)  
- **Forward Secrecy / Post-Compromise Security**  
  過去メッセージや旧セッション鍵の漏洩があっても、将来のメッセージは安全です。  
- **Swift + CryptoKitのみで実装**  
  外部依存を最小化、単体テストやセキュリティテストも容易。  
- **DDDベースのドメイン設計**  
  Participant・Cohort・Messageをエンティティ、鍵・暗号文・CohortStateを値オブジェクトとして設計。

---

## 2. ドメインモデル

### エンティティ

| エンティティ | 説明 |
|--------------|------|
| **Participant** | 通信主体、鍵ペアを保持 |
| **Cohort** | メンバー集合とTreeKEM状態を保持 |
| **Message** | 暗号文・送信者・ContextInfoを保持 |
| **Commit** | Cohort状態更新を表現 |

### 値オブジェクト

| 値オブジェクト | 説明 |
|----------------|------|
| **PublicKey / PrivateKey** | 鍵ペア |
| **CipherText / PlainText** | 暗号文 / 平文 |
| **ContextInfo** | チケットID、タイムスタンプ等 |
| **Signature** | Ed25519署名 |
| **CohortState** | TreeKEMツリー状態 |

---

## 3. ドメインサービス

- `KeyManagementService`: 鍵生成・ラチェット更新・Forward Secrecy管理  
- `MessageService`: メッセージ暗号化／復号（1:1およびCohort対応）  
- `CohortService`: Cohort作成、メンバー管理、CohortState更新、Commit適用  

---

## 4. 使用例

```swift
import ShikakuMLS

@available(iOS 17.0, *)
func sampleUsage() async throws {
  let shikaku = ShikakuMLS()

  // Cohort作成
  let memberPublicKeys = [Data()] // 公開鍵リスト
  let initialState = Data()       // TreeKEM初期状態
  let cohortResponse = try await shikaku.handler.createCohort(
    memberPublicKeys: memberPublicKeys,
    initialState: initialState
  )

  // メンバー追加
  let newMemberPublicKey = Data()
  let senderPrivateKey = Data()
  let addMemberResponse = try await shikaku.handler.addMember(
    cohortID: cohortResponse?.cohortID ?? "",
    newMemberPublicKey: newMemberPublicKey,
    senderPrivateKey: senderPrivateKey
  )

  // Cohort状態取得
  let stateResponse = try await shikaku.handler.getCohortState(
    cohortID: cohortResponse?.cohortID ?? ""
  )

  // 鍵生成
  let keyPairResponse = try await shikaku.handler.generateKeyPair(
    participantID: "test-participant"
  )

  // メッセージ送信
  let plaintext = "Hello!"
  let recipientPublicKey = Data()
  let contextInfo: [String: Any] = [
    "ticketID": "TICKET1", "timestamp": Date()
  ]
  let sendResponse = try await shikaku.handler.sendMessage(
    plaintext: plaintext,
    senderPrivateKey: senderPrivateKey,
    recipientPublicKey: recipientPublicKey,
    contextInfo: contextInfo
  )

  // メッセージ復号
  let decryptResponse = try await shikaku.handler.decryptMessage(
    ciphertext: sendResponse?.ciphertext ?? Data(),
    senderPublicKey: recipientPublicKey,
    recipientPrivateKey: senderPrivateKey,
    contextInfo: contextInfo
  )
}
```
