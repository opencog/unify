;
; unifier-tree.scm -- Build a small proof-tree, using the unifier.
;
; This is a rather long demo, because it has many parts to it.
;
; First: define two rules. These rules will be "connectable" or
; "chainable", in that the premise of one can be unified with the
; conclusion of the other.
;
; Next: a demo of how to disassemble a given rule into it's parts:
; the premises and the conclusion.
;
; Next: extract the two parts that we might be able to unify:
; the premise of one rule and the conclusion of the other.
; Stick them into the unifier, and let it write out a new proof
; tree, for us, with the two connected parts discharged.
;
; The above tree is not in reduced form; so, as the final step,
; reduce it.
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
; If P->Q and P is true, then Q.
; Note that Rules are alpha-converible, so this is *identical*
; If A->B and A is true, then B.
; In the AtomSpace, the first declaration wins; subsequent ones
; are always alpha-converted to the first. So, to try to lessen
; confusion, we'll use different variable names from the rule of
; introduction.
(define elim
	(Rule
		; Typed variables appearing in the terms
		(VariableList
			(TypedVariable (Variable "$P") (Type 'ConceptNode))
			(TypedVariable (Variable "$Q") (Type 'ConceptNode)))

		; Assumptions (list of premises)
		(SequentialAnd
			(Implication (Variable "$P") (Variable "$Q"))
			(Variable "$P"))

		; Deduction aka conclusion
		(Variable "$Q")))

; ---------------------------------------------------------------
; Lets dissect these two rules into their parts, and make sure that
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
;
; What is reported back are the variables that went into this,
; which is not terribly enlightening.

(cog-execute! (Unifier
	(ConclusionOf intro)
	(PremiseOf elim (Number 0))
	(List (Variable "$P") (Variable "$Q"))))

; ---------------------------------------------------------------
; Now, do the same thing, but this time, build the full proof tree.
; It consists of the assumption of the rule of intro, which clearly
; has not been dischaged. It also includes the second assumption of
; the rule of elimination, which remains unconnected. The conclusion
; must be, of course, the conclusion of the rule of elimination.
;
; If the unification were to fail, then the empty set would be
; returned. In this case, it was build not to fail, and to return
; only one proof-tree.
(define rule-union (Unifier
	(ConclusionOf intro)
	(PremiseOf elim (Number 0))
	(Rule
		(SequentialAnd
			; The assumption of the rule of intro has not been discharged.
			(PremiseOf intro)
			; The 2nd assumption of the rule of elim has not been discharged.
			(PremiseOf elim (Number 1)))
		; The conclusion of the rule of elim is what we conclude.
		(ConclusionOf elim))))

; Now actually perform the unification, and get the set of proof-trees.
(define proof-tree-set (cog-execute! rule-union))

; Argh! The proof-tree-set is a (Set (Rule (Lambdas...))) Yuck. We
; want the reduced proof tree, with everything plugged through.
; First, unwrap it by hand...
(define proof-tree (cog-outgoing-atom proof-tree-set 0))

; And then, finally, reduce it:
(cog-execute! proof-tree)

; Yayy! That's more like it! A simplified, reduced proof tree; the
; result of chaining together two rules.

; ---------------------------------------------------------------
; The above had to jump through some hoops to get the reduced result
; of unification. The UnifyReduceLink combines the two into one.
; Here it is, exactly the same as the above, except that UnifierLink
; is replaced by UnifyReduceLink:

(define rule-reduce (UnifyReduce
	(ConclusionOf intro)
	(PremiseOf elim (Number 0))
	(Rule
		(SequentialAnd
			(PremiseOf intro)
			(PremiseOf elim (Number 1)))
		(ConclusionOf elim))))

; Run it:
(cog-execute! rule-reduce)

; Ta dah!

; The End. That's all, folks!
; ---------------------------------------------------------------
