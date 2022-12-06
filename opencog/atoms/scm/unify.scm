;
; Opencog unify atom-types module
;
(define-module (opencog unify))

(use-modules (opencog))
(use-modules (opencog unify-config))

; Load the C library that calls the classserver to load the types.
(load-extension
   (string-append opencog-ext-path-unify "libunify-types")
   "unify_types_init")

; Load the shared lib defining the atoms
(load-extension
   (string-append opencog-ext-path-unify-atoms "libunify-atoms")
   "opencog_unify_atoms_init")

(load-from-path "opencog/unify/types/unify_types.scm")
