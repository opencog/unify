;
; unify-complex-1.scm -- Unifier with multi-part matches.
;
; This example is copied verbatim from
; `UnifyUTest::test_unify_complex_1()`
;
(use-modules (opencog) (opencog exec))
(use-modules (opencog unify))

(define RHS
	(Implication
		(Variable "$P")
		(And
			(Variable "$P")
			(Variable "$Q"))))

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


; Define an inference rule joiner.
; The only variable in the unifier is "?COLL-6c74a409" and we
; expect to have it be unified with `(Concept "Org1-1")`
(define joiner
	(Unifier
		(Lambda LHS_vardecl LHS)
		(Lambda RHS_vardecl RHS)
		(List
			(Ordered (Concept "Var P is: ===--->>>") (Variable "$P"))
			(Ordered (Concept "Var Q is: ===--->>>") (Variable "$Q"))
			(Ordered (Concept "Var TyVs is: ===--->>>") (Variable "$TyVs"))
			(Ordered (Concept "Var A1 is: ===--->>>") (Variable "$A1"))
			(Ordered (Concept "Var A2 is: ===--->>>") (Variable "$A2"))
		)))

(cog-execute! joiner)
