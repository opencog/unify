;
; unify-complex-1.scm -- A more complex example, with types.
;
; This example is copied verbatim from
; `UnifyUTest::test_unify_complex_1()`
;
(use-modules (opencog) (opencog exec))
(use-modules (opencog unify))

(define LHS
	(Implication
		(Lambda
			(TypedVariable (Variable "$X") (Type "ConceptNode"))
			(Evaluation
				(Predicate "take")
				(List
					(Variable "$X")
					(Concept "treatment-1"))))
		(And
			(Quote
				(Lambda
					(Unquote (Variable "$TyVs"))
					(Unquote (Variable "$A1"))))
			(Quote
				(Lambda
					(Unquote (Variable "$TyVs"))
					(Unquote (Variable "$A2")))))))

(define RHS
	(Implication
		(Variable "$P")
		(And
			(Variable "$P")
			(Variable "$Q"))))

(define LHS_vardecl
	(VariableList
		(TypedVariable
			(Variable "$TyVs")
			(TypeChoice
				(Type "TypedVariableLink")
				(Type "VariableNode")
				(Type "VariableList")))
		(TypedVariable (Variable "$A1") (Type "EvaluationLink"))
		(TypedVariable (Variable "$A2") (Type "EvaluationLink"))))

(define RHS_vardecl
	(VariableList
		(TypedVariable
			(Variable "$P")
			(TypeChoice
				(Type "PredicateNode")
				(Type "LambdaLink")))
		(TypedVariable
			(Variable "$Q")
			(TypeChoice
				(Type "PredicateNode")
				(Type "LambdaLink")))))


; Define an inference rule joiner.
; The only variable in the unifier is "?COLL-6c74a409" and we
; expect to have it be unified with `(Concept "Org1-1")`
(define joiner
	(Unifier
		(Lambda LHS_vardecl LHS)
		(Lambda RHS_vardecl RHS)
		(List (Concept "I found this:") (Variable "?COLL-6c74a409"))))

(cog-execute! joiner)