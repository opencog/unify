;
; unifier-w-types.scm -- A more complex example, with types.
;
(use-modules (opencog) (opencog exec))
(use-modules (opencog unify))

; Populate the AtomSpace with some data.
(Inheritance (Concept "A") (Concept "B"))

(define LHS
 	(Exists
	  (TypedVariable
		 (Variable "?MEMBER")
		 (TypeChoice
			(Type 'ConceptNode)
			(Type 'SchemaNode)
			(Type 'PredicateNode)))
	  (MemberLink
		 (Variable "?MEMBER")
		 (Concept "Org1-1"))))

(define RHS
	(ExistsLink
		(TypedVariable
			 (Variable "?OBJ")
			 (TypeChoice
				(Type 'ConceptNode)
				(Type 'SchemaNode)
				(Type 'PredicateNode)))
		  (Member
			 (Variable "?OBJ")
			 (Variable "?COLL-6c74a409"))))

(define RHS_vardel
	(TypedVariable
	  (Variable "?COLL-6c74a409")
	  (TypeChoice
		 (Type 'ConceptNode)
		 (Type 'SchemaNode)
		 (Type 'PredicateNode))))

; Define an inference rule joiner.
; The only variable in the unifier is "?COLL-6c74a409" and we
; expect to have it be unified with `(Concept "Org1-1")`
(define joiner
	(Unifier
		(Lambda (VariableList) LHS)
		(Lambda RHS_vardecl RHS)
		(List (Concept "I found this:") (Variable "?COLL-6c74a409"))))

(cog-execute! joiner)
