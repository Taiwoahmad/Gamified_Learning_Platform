;; Redemption functions for the gamified learning platform

;; Redeem points for STX
(define-public (redeem-points)
  (let (
    (points-data (default-to { points: u0 } (contract-call? .maps get-user-points tx-sender)))
    (user-point (get points points-data))
    (conversion-rate (contract-call? .variables get-point-conversion-rate))
    (stx-amount (/ user-point conversion-rate))
    (new-point-balance (- user-point (* stx-amount conversion-rate)))
    (admin-address (contract-call? .variables get-admin))
  )
    (begin
      (asserts! (> stx-amount u0) (err u102))

      ;; Update user points
      (match (contract-call? .maps set-user-points tx-sender new-point-balance)
        success (match (contract-call? .maps add-user-redeemed tx-sender (* stx-amount conversion-rate))
          redeemed-success (match (stx-transfer? stx-amount admin-address tx-sender)
            transfer-success (ok transfer-success)
            transfer-error (err u108) ;; STX transfer failed
          )
          redeemed-error (err u107) ;; Failed to update redeemed points
        )
        error (err u106) ;; Failed to update user points
      )
    )
  )
)

;; Get user redeemed points
(define-read-only (get-user-redeemed (user principal))
  (let ((redeemed-data (default-to { amount: u0 } (contract-call? .maps get-user-redeemed user))))
    (ok (get amount redeemed-data))
  )
)
