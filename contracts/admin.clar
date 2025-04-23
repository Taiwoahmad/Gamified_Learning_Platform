;; Admin functions for the gamified learning platform

;; Set the conversion rate (admin only)
(define-public (set-conversion-rate (new-rate uint))
  (contract-call? .variables set-point-conversion-rate new-rate)
)

;; Get the current conversion rate
(define-read-only (get-conversion-rate)
  (ok (contract-call? .variables get-point-conversion-rate))
)
