//
//  Transaction+RLP.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 4/25/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import BigInt

extension Transaction: RLP {
  func rlpEncode(offset: UInt8? = nil) -> Data? {
    return self.rlpData().rlpEncode()
  }
  
  internal func rlpData(chainID: BigInt? = nil, forSignature: Bool = false) -> [RLP] {
    var fields: [RLP] = [self._nonce.toRLP(), self._gasPrice.toRLP(), self._gasLimit.toRLP()]
    if let address = self.to?.address {
      fields.append(address)
    } else {
      fields.append("")
    }
    fields += [self._value.toRLP(), self.data]
    if let signature = self.signature, !forSignature {
        fields += [signature.v, signature.r, signature.s]
    } else if let chainID = chainID ?? self.chainID {
        fields += [chainID.toRLP(), 0, 0]
    }
    return fields
  }
}
