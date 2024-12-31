;; Royalties Management Contract
;; Manages royalty distributions for digital assets

(define-constant contract-owner tx-sender)
(define-constant royalty-percentage u500) ;; 5% represented as basis points
(define-constant min-payment u1000000) ;; Minimum payment in microSTX

;; Data maps
(define-map creator-royalties 
    principal 
    {total-earned: uint, last-payout: uint})

(define-map asset-creators 
    uint 
    {creator: principal, active: bool})

;; Errors
(define-constant err-unauthorized (err u100))
(define-constant err-invalid-payment (err u101))
(define-constant err-no-creator (err u102))
(define-constant err-inactive (err u103))

;; Public functions
(define-public (register-asset (asset-id uint) (creator principal))
    (begin
        (asserts! (is-eq tx-sender contract-owner) err-unauthorized)
        (ok (map-set asset-creators 
            asset-id 
            {creator: creator, active: true}))))

(define-public (deactivate-asset (asset-id uint))
    (let ((asset (unwrap! (map-get? asset-creators asset-id) err-no-creator)))
        (begin
            (asserts! (is-eq tx-sender contract-owner) err-unauthorized)
            (ok (map-set asset-creators 
                asset-id 
                {creator: (get creator asset), active: false})))))

(define-public (pay-royalty (asset-id uint))
    (let (
        (asset (unwrap! (map-get? asset-creators asset-id) err-no-creator))
        (payment (stx-get-balance tx-sender))
        (creator (get creator asset))
        (royalty-amount (/ (* payment royalty-percentage) u10000))
    )
        (begin
            (asserts! (>= payment min-payment) err-invalid-payment)
            (asserts! (get active asset) err-inactive)
            (try! (stx-transfer? royalty-amount tx-sender creator))
            (map-set creator-royalties creator
                {
                    total-earned: (+ (default-to u0 (get total-earned 
                        (map-get? creator-royalties creator))) royalty-amount),
                    last-payout: block-height
                })
            (ok royalty-amount))))

;; Read-only functions
(define-read-only (get-creator-stats (creator principal))
    (default-to 
        {total-earned: u0, last-payout: u0} 
        (map-get? creator-royalties creator)))

(define-read-only (get-asset-info (asset-id uint))
    (map-get? asset-creators asset-id))

(define-read-only (calculate-royalty (payment uint))
    (/ (* payment royalty-percentage) u10000))