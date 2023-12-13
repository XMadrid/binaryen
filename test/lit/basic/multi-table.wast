;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; RUN: wasm-opt %s -all -o %t.text.wast -g -S
;; RUN: wasm-as %s -all -g -o %t.wasm
;; RUN: wasm-dis %t.wasm -all -o %t.bin.wast
;; RUN: wasm-as %s -all -o %t.nodebug.wasm
;; RUN: wasm-dis %t.nodebug.wasm -all -o %t.bin.nodebug.wast
;; RUN: cat %t.text.wast | filecheck %s --check-prefix=CHECK-TEXT
;; RUN: cat %t.bin.wast | filecheck %s --check-prefix=CHECK-BIN
;; RUN: cat %t.bin.nodebug.wast | filecheck %s --check-prefix=CHECK-BIN-NODEBUG

(module
  ;; CHECK-TEXT:      (type $none_=>_none (func))
  ;; CHECK-BIN:      (type $none_=>_none (func))
  (type $none_=>_none (func))
  (type $A (struct))
  ;; CHECK-TEXT:      (import "a" "b" (table $t1 1 10 funcref))

  ;; CHECK-TEXT:      (global $g1 (ref null $none_=>_none) (ref.func $f))
  ;; CHECK-BIN:      (import "a" "b" (table $t1 1 10 funcref))

  ;; CHECK-BIN:      (global $g1 (ref null $none_=>_none) (ref.func $f))
  (global $g1 (ref null $none_=>_none) (ref.func $f))
  ;; CHECK-TEXT:      (global $g2 i32 (i32.const 0))
  ;; CHECK-BIN:      (global $g2 i32 (i32.const 0))
  (global $g2 i32 (i32.const 0))

  ;; CHECK-BIN-NODEBUG:      (type $0 (func))

  ;; CHECK-BIN-NODEBUG:      (import "a" "b" (table $timport$0 1 10 funcref))
  (import "a" "b" (table $t1 1 10 funcref))
  ;; CHECK-TEXT:      (table $t2 3 3 funcref)
  ;; CHECK-BIN:      (table $t2 3 3 funcref)
  (table $t2 3 3 funcref)
  ;; CHECK-TEXT:      (table $t3 4 4 funcref)
  ;; CHECK-BIN:      (table $t3 4 4 funcref)
  (table $t3 4 4 funcref)
  ;; CHECK-TEXT:      (table $textern 0 externref)
  ;; CHECK-BIN:      (table $textern 0 externref)
  (table $textern 0 externref)

  ;; A table with a typed function references specialized type.
  ;; CHECK-TEXT:      (table $tspecial 5 5 (ref null $none_=>_none))
  ;; CHECK-BIN:      (table $tspecial 5 5 (ref null $none_=>_none))
  (table $tspecial 5 5 (ref null $none_=>_none))

  ;; add to $t1
  (elem (i32.const 0) $f)

  ;; add to $t2
  (elem (table $t2) (i32.const 0) func $f)
  ;; CHECK-TEXT:      (elem $0 (table $t1) (i32.const 0) func $f)

  ;; CHECK-TEXT:      (elem $1 (table $t2) (i32.const 0) func $f)

  ;; CHECK-TEXT:      (elem $activeNonZeroOffset (table $t2) (i32.const 1) func $f $g)
  ;; CHECK-BIN:      (elem $0 (table $t1) (i32.const 0) func $f)

  ;; CHECK-BIN:      (elem $1 (table $t2) (i32.const 0) func $f)

  ;; CHECK-BIN:      (elem $activeNonZeroOffset (table $t2) (i32.const 1) func $f $g)
  (elem $activeNonZeroOffset (table $t2) (offset (i32.const 1)) func $f $g)

  ;; CHECK-TEXT:      (elem $e3-1 (table $t3) (global.get $g2) funcref (ref.func $f) (ref.null nofunc))
  ;; CHECK-BIN:      (elem $e3-1 (table $t3) (global.get $g2) funcref (ref.func $f) (ref.null nofunc))
  (elem $e3-1 (table $t3) (global.get $g2) funcref (ref.func $f) (ref.null func))
  ;; CHECK-TEXT:      (elem $e3-2 (table $t3) (i32.const 2) (ref null $none_=>_none) (ref.func $f) (ref.func $g))
  ;; CHECK-BIN:      (elem $e3-2 (table $t3) (i32.const 2) (ref null $none_=>_none) (ref.func $f) (ref.func $g))
  (elem $e3-2 (table $t3) (offset (i32.const 2)) (ref null $none_=>_none) (item ref.func $f) (item (ref.func $g)))

  ;; CHECK-TEXT:      (elem $passive-1 func $f $g)
  ;; CHECK-BIN:      (elem $passive-1 func $f $g)
  (elem $passive-1 func $f $g)
  ;; CHECK-TEXT:      (elem $passive-2 funcref (ref.func $f) (ref.func $g) (ref.null nofunc))
  ;; CHECK-BIN:      (elem $passive-2 funcref (ref.func $f) (ref.func $g) (ref.null nofunc))
  (elem $passive-2 funcref (item ref.func $f) (item (ref.func $g)) (ref.null func))
  ;; CHECK-TEXT:      (elem $passive-3 (ref null $none_=>_none) (ref.func $f) (ref.func $g) (ref.null nofunc) (global.get $g1))
  ;; CHECK-BIN:      (elem $passive-3 (ref null $none_=>_none) (ref.func $f) (ref.func $g) (ref.null nofunc) (global.get $g1))
  (elem $passive-3 (ref null $none_=>_none) (item ref.func $f) (item (ref.func $g)) (ref.null $none_=>_none) (global.get $g1))
  ;; CHECK-TEXT:      (elem $empty func)
  ;; CHECK-BIN:      (elem $empty func)
  (elem $empty func)
  (elem $declarative declare func $h)

  ;; This elem will be emitted as usesExpressions because of the type of the
  ;; table.
  ;; CHECK-TEXT:      (elem $especial (table $tspecial) (i32.const 0) (ref null $none_=>_none) (ref.func $f) (ref.func $h))
  ;; CHECK-BIN:      (elem $especial (table $tspecial) (i32.const 0) (ref null $none_=>_none) (ref.func $f) (ref.func $h))
  (elem $especial (table $tspecial) (i32.const 0) (ref null $none_=>_none) $f $h)

  ;; CHECK-TEXT:      (func $f (type $none_=>_none)
  ;; CHECK-TEXT-NEXT:  (drop
  ;; CHECK-TEXT-NEXT:   (ref.func $h)
  ;; CHECK-TEXT-NEXT:  )
  ;; CHECK-TEXT-NEXT: )
  ;; CHECK-BIN:      (func $f (type $none_=>_none)
  ;; CHECK-BIN-NEXT:  (drop
  ;; CHECK-BIN-NEXT:   (ref.func $h)
  ;; CHECK-BIN-NEXT:  )
  ;; CHECK-BIN-NEXT: )
  (func $f (drop (ref.func $h)))

  ;; CHECK-TEXT:      (func $g (type $none_=>_none)
  ;; CHECK-TEXT-NEXT:  (nop)
  ;; CHECK-TEXT-NEXT: )
  ;; CHECK-BIN:      (func $g (type $none_=>_none)
  ;; CHECK-BIN-NEXT:  (nop)
  ;; CHECK-BIN-NEXT: )
  (func $g)

  ;; CHECK-TEXT:      (func $h (type $none_=>_none)
  ;; CHECK-TEXT-NEXT:  (nop)
  ;; CHECK-TEXT-NEXT: )
  ;; CHECK-BIN:      (func $h (type $none_=>_none)
  ;; CHECK-BIN-NEXT:  (nop)
  ;; CHECK-BIN-NEXT: )
  (func $h)
)
;; CHECK-BIN-NODEBUG:      (global $global$0 (ref null $0) (ref.func $0))

;; CHECK-BIN-NODEBUG:      (global $global$1 i32 (i32.const 0))

;; CHECK-BIN-NODEBUG:      (table $0 3 3 funcref)

;; CHECK-BIN-NODEBUG:      (table $1 4 4 funcref)

;; CHECK-BIN-NODEBUG:      (table $2 0 externref)

;; CHECK-BIN-NODEBUG:      (table $3 5 5 (ref null $0))

;; CHECK-BIN-NODEBUG:      (elem $0 (table $timport$0) (i32.const 0) func $0)

;; CHECK-BIN-NODEBUG:      (elem $1 (table $0) (i32.const 0) func $0)

;; CHECK-BIN-NODEBUG:      (elem $2 (table $0) (i32.const 1) func $0 $1)

;; CHECK-BIN-NODEBUG:      (elem $3 (table $1) (global.get $global$1) funcref (ref.func $0) (ref.null nofunc))

;; CHECK-BIN-NODEBUG:      (elem $4 (table $1) (i32.const 2) (ref null $0) (ref.func $0) (ref.func $1))

;; CHECK-BIN-NODEBUG:      (elem $5 func $0 $1)

;; CHECK-BIN-NODEBUG:      (elem $6 funcref (ref.func $0) (ref.func $1) (ref.null nofunc))

;; CHECK-BIN-NODEBUG:      (elem $7 (ref null $0) (ref.func $0) (ref.func $1) (ref.null nofunc) (global.get $global$0))

;; CHECK-BIN-NODEBUG:      (elem $8 func)

;; CHECK-BIN-NODEBUG:      (elem $9 (table $3) (i32.const 0) (ref null $0) (ref.func $0) (ref.func $2))

;; CHECK-BIN-NODEBUG:      (func $0 (type $0)
;; CHECK-BIN-NODEBUG-NEXT:  (drop
;; CHECK-BIN-NODEBUG-NEXT:   (ref.func $2)
;; CHECK-BIN-NODEBUG-NEXT:  )
;; CHECK-BIN-NODEBUG-NEXT: )

;; CHECK-BIN-NODEBUG:      (func $1 (type $0)
;; CHECK-BIN-NODEBUG-NEXT:  (nop)
;; CHECK-BIN-NODEBUG-NEXT: )

;; CHECK-BIN-NODEBUG:      (func $2 (type $0)
;; CHECK-BIN-NODEBUG-NEXT:  (nop)
;; CHECK-BIN-NODEBUG-NEXT: )
