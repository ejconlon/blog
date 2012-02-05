---
layout: post
category : exathunk
tags : [intro, exathunk]
---

# An introduction to the Exathunk project

The next big thing in computing is making computation as mobile as
data.  You could argue that we are already seeing this in the
distributed database scene with structured-query map-reduces.
However, the set of all programs that can be easily expressed as a
map-reduce is quite small.     Generally, computations require control
flows of arbitrary shape and complexity.  Mobile computations need
flexible inter-process communication, failure- and latency- tolerance,
and runtime-agnosticism.

One particular model that fits these constraints quite well is that of
lazy and pure functional programming.  Even in languages like Haskell,
purity is a well-maintained fiction (hidden by monadic I/O), but it is
still a useful one.  We should consider a solution accessible to
strict, imperative languages that presents a lazy, pure facade between
components.  (An aside: if you don't consider yourself part of "we" here then
let that be [James](https://github.com/wolfwood) and I.)

The first step is to suggest a grammar for such a system.  Here, too,
Haskell presents us with an appealing model - a strong, expressive
type system would aid program verifiability and programmer
productivity.  A multi-language IDL + RPC framework like Apache Thrift
provides a useful medium in which we can describe and on which we can
share messages.  We can follow a Haskell model of declaring
typeclasses whose dispatch is left to a runtime, entirely outside the
description of plain-old data types.  (Contrast this to a C++ model in
which class instances share a vtable.)  We can use these typeclasses
identically to exported RPC endpoints, using them to declare and
resolve dependencies between service implementations.

This protocol is still in its infancy, but already one can perform
some basic operations.  Here is part of the current definition of a
remote execution provider:

    service RemoteExecutionService {
        list<FuncDef> getFuncDefs(1: list<FuncId> funcIds)
        RemoteThunk submitEvalRequest(1: EvalRequest evalRequest)
        VarCont thunkGet(1: RemoteThunk thunk)
    }

An implementation exposes the definitions of the functions is support
through "getFuncDefs."  For instance, an arithmetic server would
report that the function "+" takes two integer parameters.  A client
could take an untyped but well-structured expression like "(+ 1 2)"
and request its definition.  The client would then create a typed AST
for the expression and submit it to the server for evaluation with
"submitEvalRequest."  Currently there is only a future-value
mechanism, but clients could conceivably choose a blocking or callback
form of submission.

Conventional RPC frameworks require arguments to be fully-evaluated,
but for our purposes this is only a specialization of a general case.
We want to support the transmission of entire program ASTs for
evaluation however service providers should see fit, applying any
prefetching or caching optimizations, for example.  The client above
can just as easily type and send an expression like "(+ 1 (/ 4 2))"
and receive the same result.

Defining a common language is only the first step.  When many nodes
can perform the same workloads with varying efficiency (not known a
priori), how does one schedule work in an an optimal, adapatable way?
How does one deal with faulty or hostile nodes?  It is here that we
hope a market-based approach with oracle logic and reputation-tracking
will prevail.

Check out the project at <https://github.com/ejconlon/exathunk>.