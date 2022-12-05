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

; Run it.
(cog-execute! joiner)

; Here it is, with a more complex rewrite:
(define join-and-make
	(Unifier
		(Inheritance (Variable "$X") (Concept "B"))
		(Inheritance (Concept "A") (Variable "$Y"))
		(Evaluation
			(Predicate "put it together")
			(List (Variable "$X") (Variable "$Y")))))

; Run it.
(cog-execute! join-and-make)

; Because the above is so simple, it provides the same results as
; the IdenticalLink:

(define ident
	(Bind
		(Identical
			(Inheritance (Variable "$X") (Concept "B"))
			(Inheritance (Concept "A") (Variable "$Y")))
		(Evaluation
			(Predicate "put it together")
			(List (Variable "$X") (Variable "$Y")))))

(cog-execute! ident)
