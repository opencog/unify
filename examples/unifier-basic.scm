;
; unifier-basic.scm -- Very baic unifier demo.
;
(use-modules (opencog) (opencog exec))
(use-modules (opencog unify))

; Populate the AtomSpace with some data.
(Inheritance (Concept "A") (Concept "B"))

; Define an inference rule joiner.
(define joiner
	(Unifier
		(Inheritance (Variable "$X") (Concept "B"))
		(Inheritance (Concept "A") (Variable "$Y"))
		(List (Variable "$X") (Variable "$Y"))))

(cog-execute! joiner)
