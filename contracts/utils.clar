;; Utility functions for the gamified learning platform

;; Check if a principal is the admin
(define-read-only (is-admin (sender principal))
  (is-eq sender (contract-call? .variables get-admin))
)

;; Convert points to STX amount
(define-read-only (points-to-stx (points uint))
  (let ((rate (contract-call? .variables get-point-conversion-rate)))
    (/ points rate)
  )
)

;; Convert STX amount to points
(define-read-only (stx-to-points (stx-amount uint))
  (let ((rate (contract-call? .variables get-point-conversion-rate)))
    (* stx-amount rate)
  )
)
