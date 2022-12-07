Examples
--------
Please also refer to the documentation:
* [UnifierLink](https://wiki.opencog.org/w/UnifierLink)
* [UnifyReduceLink](https://wiki.opencog.org/w/UnifyReduceLink)
* [RuleLink](https://wiki.opencog.org/w/RuleLink)

The `UnifierLink` performs term unification with rewriting. It has the
general form
```
   (Unifier A B R)
```
with `A` and `B` being terms with variables, and `R` being a rewrite.
When executed, the variables apparing in `A` and `B` are aligned and
unified. If this succeeds (if there are results), then, for each result,
a copy of `R` is generated, plugging in groundings for the variables
that were unified.

Note that this is almost the same thing as running
```
	(Bind (Identical A B) R)
```
The primary difference between the `UnifierLink` and the
`BindLink`-`IdenticalLink` combination is how bound variables are
handled.  The variables to be unified in `A` and `B` can be declared
with the `LambdaLink`; any other variables appearing in `A` and `B`
are then treated as constants:
```
   (Unifier
      (Lambda (VariableList vars-in-A ...) A)
      (Lambda (VariableList vars-in-B ...) B)
      R)
```
The rewrite in `R` then only uses the union of the variables in `A`
and `B`, with all other variables in `R` treated as constants. This
will, in general, differ from the form
```
   (Bind
      (VariableList vars-in-A vars-in-B)
      (Identical A B)
      R)
```
An explicit example of such a difference is when `(Variable "$X")`
appears in `vars-in-A` and in `B`, but not in `vars-in-B`. In this
case, the `IdenticalLink` will treat `X` as being bound in `B`
(because of the mash-up of variable decls in the `BindLink`) and will
try to unify it. The `UnifierLink` will keep the variable declarations
distinct.

This difference makes the `UnifierLink` far more suitable for performing
the unification and chaining of inference rules, where there may be
variable name collisions, and explicit call-outs of free and bound
variables. The last demo on this page provides an example of chaining
two rules together.

On the other hand, the `BindLink` allows much more complex expressions,
such as
```
   (Bind
      (VariableList ...)
      (And
         (Identical A B)
         (Identical P Q)
         (Present S T U)
         (Absent L M N))
      R)
```


Demo examples
-------------
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
		(Variable List X... Y...)
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
