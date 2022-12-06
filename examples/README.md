Examples
--------

A very simple example, that points out that basic unification can
also be accomplished with the IdenticalLink.

* `unifier-basic.scm` -- the simplest example.

The following are translated from earlier unit tests. They represent
"typical" cases that might be encountered in URE. They are very "meta"
in what it is they are trying to do.

To understand the "meta" character here, note that URE rules have the
general form
```
(Rule
	(VariableList X ...)
		(And
			(Premise A)
			(Premise B)
			...)
	(Conclusion F))
```
Now, consider the need to join the above rule, with another, of the
same general form:
`(Rule (VariableList Y...)(And (Premise C) (Premise D) ...) (Conclusion G))`

If it helps, think of these rules as being in "Natural Deduction Style",
although the presence of the AtomSpace means that these are also kind-of
like Gentzen-style rules. If you don't know what Natural Deduction and
Gentzen means, just ignore this comment; it has no real bearing on the
demos.

Suppose that `(Conclusion F)` can be unified with `(Premise C)`.
Thus, the URE constructs, on the fly, expressions of the general form of
```
(Unifier
	(Lambda
		(VariableList vars X ... that are in F)
		(Conclusion F))
	(Lambda
		(VariableList vars Y... that are in C)
		(Premise C))
	(Rule
		(Varible List X... Y...)
		(And
			(Premise A)
			(Premise B)
			...
			(Premise D)
			...))
	 (Conclusion G)))
```

The examples below demonstrate that such complex reductions are
actually possible, and that they work correctly.

* `unifier-w-types.scm` -- Unifier with typed variables.
* `unify-complex-1.scm` -- A more complex example.

A longer demo, but "simpler" than the above.
* `unifier-tree.scm` -- Create a short proof tree, by chaining together
   two rules. The rules are from Minimal Implication Logic, written in
   Natural Deduction Style. Demonstrates how to do a single chaining
   step.
