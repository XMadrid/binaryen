;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.

;; Check that heap types are emitted properly in the binary format. This file
;; contains small modules that each use a single instruction with a heap type.
;; If we forgot to update collectHeapTypes then we would not write out their
;; type, and hit an error during --roundtrip.

;; RUN: foreach %s %t wasm-opt -all --roundtrip -S -o - | filecheck %s

(module
  ;; CHECK:      (type $struct.A (struct (field i32)))
  (type $struct.A (struct i32))
  (type $struct.B (struct i32))
  ;; CHECK:      (func $test (type $0)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.test (ref $struct.A)
  ;; CHECK-NEXT:    (ref.null none)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test
    (drop
      (ref.test (ref $struct.B) (ref.null $struct.A))
    )
  )
)

(module
  (type $struct.A (struct i32))
  (type $struct.B (struct i32))
  ;; CHECK:      (func $test (type $0)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.cast nullref
  ;; CHECK-NEXT:    (ref.null none)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test
    ;; Note that this will not round-trip precisely because Binaryen IR will
    ;; apply the more refined type to the cast automatically (in finalize).
    (drop
      (ref.cast (ref null $struct.B) (ref.null $struct.A))
    )
  )
)

(module
  ;; CHECK:      (type $struct.A (struct (field i32)))
  (type $struct.A (struct i32))
  ;; CHECK:      (func $test (type $0)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.new_default $struct.A)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test
    (drop
      (struct.new_default $struct.A)
    )
  )
)

(module
  ;; CHECK:      (type $vector (array (mut f64)))
  (type $vector (array (mut f64)))
  ;; CHECK:      (func $test (type $0)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (array.new $vector
  ;; CHECK-NEXT:    (f64.const 3.14159)
  ;; CHECK-NEXT:    (i32.const 3)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test
    (drop
      (array.new $vector
        (f64.const 3.14159)
        (i32.const 3)
      )
    )
  )
)

(module
  ;; CHECK:      (type $vector (array (mut f64)))
  (type $vector (array (mut f64)))
  ;; CHECK:      (func $test (type $0)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (array.new_fixed $vector 4
  ;; CHECK-NEXT:    (f64.const 1)
  ;; CHECK-NEXT:    (f64.const 2)
  ;; CHECK-NEXT:    (f64.const 4)
  ;; CHECK-NEXT:    (f64.const 8)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test
    (drop
      (array.new_fixed $vector 4
        (f64.const 1)
        (f64.const 2)
        (f64.const 4)
        (f64.const 8)
      )
    )
  )
)

(module
  ;; CHECK:      (type $vector (array (mut f64)))
  (type $vector (array (mut f64)))
  ;; CHECK:      (func $test (type $1) (param $ref (ref $vector)) (param $index i32) (param $value f64) (param $size i32)
  ;; CHECK-NEXT:  (array.fill $vector
  ;; CHECK-NEXT:   (local.get $ref)
  ;; CHECK-NEXT:   (local.get $index)
  ;; CHECK-NEXT:   (local.get $value)
  ;; CHECK-NEXT:   (local.get $size)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test (param $ref (ref $vector))
              (param $index i32)
              (param $value f64)
              (param $size i32)
    (array.fill $vector
      (local.get $ref)
      (local.get $index)
      (local.get $value)
      (local.get $size)
    )
  )
)

(module
  ;; CHECK:      (type $vector (array (mut i32)))
  (type $vector (array (mut i32)))
  (data "")
  ;; CHECK:      (func $test (type $1) (param $ref (ref $vector)) (param $index i32) (param $offset i32) (param $size i32)
  ;; CHECK-NEXT:  (array.init_data $vector $0
  ;; CHECK-NEXT:   (local.get $ref)
  ;; CHECK-NEXT:   (local.get $index)
  ;; CHECK-NEXT:   (local.get $offset)
  ;; CHECK-NEXT:   (local.get $size)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test (param $ref (ref $vector))
              (param $index i32)
              (param $offset i32)
              (param $size i32)
    (array.init_data $vector 0
      (local.get $ref)
      (local.get $index)
      (local.get $offset)
      (local.get $size)
    )
  )
)

(module
  ;; CHECK:      (type $vector (array (mut funcref)))
  (type $vector (array (mut funcref)))
  (elem func)
  ;; CHECK:      (func $test (type $1) (param $ref (ref $vector)) (param $index i32) (param $offset i32) (param $size i32)
  ;; CHECK-NEXT:  (array.init_elem $vector $0
  ;; CHECK-NEXT:   (local.get $ref)
  ;; CHECK-NEXT:   (local.get $index)
  ;; CHECK-NEXT:   (local.get $offset)
  ;; CHECK-NEXT:   (local.get $size)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test (param $ref (ref $vector))
              (param $index i32)
              (param $offset i32)
              (param $size i32)
    (array.init_elem $vector 0
      (local.get $ref)
      (local.get $index)
      (local.get $offset)
      (local.get $size)
    )
  )
)
