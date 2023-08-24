;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; RUN: foreach %s %t wasm-opt --inlining --enable-memory64 -S -o - | filecheck %s

(module
  ;; CHECK:      (type $0 (func (result i64)))

  ;; CHECK:      (memory $0 i64 256 256)
  (memory $0 i64 256 256)

  ;; CHECK:      (func $call-size (result i64)
  ;; CHECK-NEXT:  (block $__inlined_func$size (result i64)
  ;; CHECK-NEXT:   (memory.size)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $call-size (result i64)
    (call $size)
  )

  (func $size (result i64)
    ;; Upon inlining this code is copied, and as the memory is 64-bit the copied
    ;; instruction must remain 64-bit (and not have the default 32-bit size). If
    ;; we get that wrong then validation would fail here.
    (memory.size)
  )

  ;; CHECK:      (func $call-grow (result i64)
  ;; CHECK-NEXT:  (block $__inlined_func$grow$1 (result i64)
  ;; CHECK-NEXT:   (memory.grow
  ;; CHECK-NEXT:    (i64.const 1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $call-grow (result i64)
    ;; As above, but for grow instead of size.
    (call $grow)
  )

  (func $grow (result i64)
    (memory.grow
      (i64.const 1)
    )
  )
)
