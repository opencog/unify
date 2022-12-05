;
; unifier-tree.scm -- Build a small proof-tree, using the unifier.
;
; This is a rather long demo, because its got many parts to it.
;
; First: build two rules. These rules will be "connectable", in
; that the premise of one can be unified with the conclusion of
; the other.
;
; Next: a demo of extracting the premise and the conclusion.
;
; Finally: run the unifier on the extracted parts.
;
(use-modules (opencog) (opencog exec))
(use-modules (opencog unify))

; ---------------------------------------------------------------
; Define two rules. These will be the two rules of minimal implication
; logic, written in the natural deduction style. (We ignore that the
; AtomSpace means that all rules are always Gentzen-like, and just
; pretend we are doing plain natural deduction.) Well make things
; interesting by using typed variables.
;
; First, implication introduction:
; If B is true, then A->B (anything proves B).
(define intro
	(Rule
		; Typed variables appearing in the terms
		(VariableList
			(TypedVariable (Variable "$A") (Type 'ConceptNode))
			(TypedVariable (Variable "$B") (Type 'ConceptNode)))

		; Assumption aka premise
		(Variable "$B")

		; Deduction aka conclusion
		(Implication (Variable "$A") (Variable "$B"))))

; Next, implication elimination aka Modus Ponens:
; If A->B and A is true, then B.
(define elim
	(Rule
		; Typed variables appearing in the terms
		(VariableList
			(TypedVariable (Variable "$A") (Type 'ConceptNode))
			(TypedVariable (Variable "$B") (Type 'ConceptNode)))

		; Assumptions (list of premises)
		(SequentialAnd
			(Implication (Variable "$A") (Variable "$B"))
			(Variable "$A"))

		; Deduction aka conclusion
		(Variable "$B")))

; ---------------------------------------------------------------
; Lets dissect these two rules into thier parts, and make sure that
; the parts are as expected:

(cog-execute! (VardeclOf intro))
(cog-execute! (PremiseOf intro))
(cog-execute! (ConclusionOf intro))

(cog-execute! (VardeclOf elim))
(cog-execute! (PremiseOf elim (Number 0)))
(cog-execute! (PremiseOf elim (Number 1)))
(cog-execute! (ConclusionOf elim))

; ---------------------------------------------------------------
; This is perhaps silly, but the conclusion of the introduction rule
; is exactly the same as the first assumption of the elimination rule.
; So we already know that these will unify. Lets try this.

(cog-execute! (Unifier
	(cog-execute! (ConclusionOf intro))
	(cog-execute! (PremiseOf elim (Number 0)))
	(List (Variable "$A") (Variable "$B"))))
