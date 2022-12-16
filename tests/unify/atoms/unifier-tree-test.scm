;
; unifier-tree-test.scm -- Unit test for the unifier-tree.scm demo
;
(use-modules (opencog) (opencog exec))
(use-modules (opencog unify))
(use-modules (opencog test-runner))

; ---------------------------------------------------------------
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
; If P->Q and P is true, then Q.
(define elim
	(Rule
		; Typed variables appearing in the terms
		(VariableList
			(TypedVariable (Variable "$P") (Type 'ConceptNode))
			(TypedVariable (Variable "$Q") (Type 'ConceptNode)))

		; Pssumptions (list of premises)
		(SequentialAnd
			(Implication (Variable "$P") (Variable "$Q"))
			(Variable "$P"))

		; Deduction aka conclusion
		(Variable "$Q")))

; ---------------------------------------------------------------

(define rule-reduce (UnifyReduce
	(ConclusionOf intro)
	(PremiseOf elim (Number 0))
	(Rule
		(SequentialAnd
			(PremiseOf intro)
			(PremiseOf elim (Number 1)))
		(ConclusionOf elim))))

; ---------------------------------------------------------------

(opencog-test-runner)
(test-begin "rule-reduce")

(define expected
	(LinkValue
		(Rule
			(TypedVariable (Variable "$B") (Type 'ConceptNode))
			(SequentialAnd
				(Variable "$B")
				(Variable "$B"))
			(Variable "$B"))))

(test-assert "minimal-implication"
	(equal? expected (cog-execute! rule-reduce)))

(test-end "rule-reduce")
(opencog-test-end)

; ---------------------------------------------------------------
