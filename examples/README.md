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
(Bind
	(VariableList X ...)
		(And
			(Premise A)
			(Premise B)
			...)
	(Conclusion F))
```
Now, consider the need to join the above rule, with another, of the
same general form:
`(Bind (VariableList Y...)(And (Premise C) (Premise D) ...) (Conclusion G))`

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
	(Bind
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
