;; Maps for the gamified learning platform

;; Map to store user points
(define-map user-points principal { points: uint })

;; Map to store redeemed points
(define-map user-redeemed principal { amount: uint })

;; Get user points
(define-read-only (get-user-points (user principal))
  (map-get? user-points user)
)

;; Set user points
(define-public (set-user-points (user principal) (points uint))
  (begin
    ;; Check if points is valid (can add more validation if needed)
    (asserts! (<= points u1000000000) (err u104)) ;; Limit to a reasonable maximum
    (map-set user-points user { points: points })
    (ok points)
  )
)

;; Add points to user
(define-public (add-user-points (user principal) (points uint))
  (begin
    ;; Check if points is valid
    (asserts! (<= points u1000000000) (err u104)) ;; Limit to a reasonable maximum
    (let ((current-data (default-to { points: u0 } (map-get? user-points user))))
      (let ((new-total (+ (get points current-data) points)))
        ;; Check if new total is valid
        (asserts! (<= new-total u1000000000) (err u105)) ;; Prevent overflow
        (map-set user-points user { points: new-total })
        (ok new-total)
      )
    )
  )
)

;; Get user redeemed points
(define-read-only (get-user-redeemed (user principal))
  (map-get? user-redeemed user)
)

;; Set user redeemed points
(define-public (set-user-redeemed (user principal) (amount uint))
  (begin
    ;; Check if amount is valid
    (asserts! (<= amount u1000000000) (err u106)) ;; Limit to a reasonable maximum
    (map-set user-redeemed user { amount: amount })
    (ok amount)
  )
)

;; Add redeemed points to user
(define-public (add-user-redeemed (user principal) (amount uint))
  (begin
    ;; Check if amount is valid
    (asserts! (<= amount u1000000000) (err u106)) ;; Limit to a reasonable maximum
    (let ((current-data (default-to { amount: u0 } (map-get? user-redeemed user))))
      (let ((new-total (+ (get amount current-data) amount)))
        ;; Check if new total is valid
        (asserts! (<= new-total u1000000000) (err u107)) ;; Prevent overflow
        (map-set user-redeemed user { amount: new-total })
        (ok new-total)
      )
    )
  )
)
