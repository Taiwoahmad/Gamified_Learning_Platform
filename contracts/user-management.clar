;; User management functions for the gamified learning platform

;; Register a new user
(define-public (register-user)
  (begin
    (asserts! (is-none (contract-call? .maps get-user-points tx-sender)) (err u100))
    (match (contract-call? .maps set-user-points tx-sender u0)
      success (ok true)
      error (err u110) ;; Failed to register user
    )
  )
)

;; Check if a user is registered
(define-read-only (is-user-registered (user principal))
  (is-some (contract-call? .maps get-user-points user))
)
