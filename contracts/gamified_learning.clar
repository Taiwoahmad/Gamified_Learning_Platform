;; Main contract for the gamified learning platform
;; This contract orchestrates all the functionality by calling the modular contracts

;; === Public Functions ===

;; Register a new user
(define-public (register-user)
  (contract-call? .user-management register-user)
)

;; Earn points
(define-public (earn-points (points uint))
  (contract-call? .points-management earn-points points)
)

;; Redeem points for STX
(define-public (redeem-points)
  (contract-call? .redemption redeem-points)
)

;; Set the conversion rate (admin only)
(define-public (set-conversion-rate (new-rate uint))
  (contract-call? .admin set-conversion-rate new-rate)
)

;; === Read-Only Functions ===

;; Get user points
(define-read-only (get-user-points (user principal))
  (contract-call? .points-management get-user-points user)
)

;; Get the current conversion rate
(define-read-only (get-conversion-rate)
  (contract-call? .admin get-conversion-rate)
)

;; Check if a user is registered
(define-read-only (is-user-registered (user principal))
  (contract-call? .user-management is-user-registered user)
)

;; Get user redeemed points
(define-read-only (get-user-redeemed (user principal))
  (contract-call? .redemption get-user-redeemed user)
)
