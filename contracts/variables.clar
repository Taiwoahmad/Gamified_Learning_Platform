;; Global variables for the gamified learning platform
(define-data-var point-conversion-rate uint u100) ;; 100 points = 1 STX
(define-constant admin tx-sender) ;; Will be set by contract deployer

;; Getter for admin
(define-read-only (get-admin)
  admin
)

;; Getter for point-conversion-rate
(define-read-only (get-point-conversion-rate)
  (var-get point-conversion-rate)
)

;; Setter for point-conversion-rate (admin only)
(define-public (set-point-conversion-rate (new-rate uint))
  (begin
    (asserts! (is-eq tx-sender admin) (err u103))
    (var-set point-conversion-rate new-rate)
    (ok new-rate)
  )
)
