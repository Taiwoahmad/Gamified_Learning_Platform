;; Points management functions for the gamified learning platform

;; Earn points
(define-public (earn-points (points uint))
  (begin
    (asserts! (is-some (contract-call? .maps get-user-points tx-sender)) (err u101))
    (match (contract-call? .maps add-user-points tx-sender points)
      success (ok success)
      error (err u109) ;; Failed to add points
    )
  )
)

;; Get user points
(define-read-only (get-user-points (user principal))
  (let ((points-data (default-to { points: u0 } (contract-call? .maps get-user-points user))))
    (ok (get points points-data))
  )
)
