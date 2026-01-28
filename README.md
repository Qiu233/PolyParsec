# PolyParsec
This Lean 4 package provides nothing more than
* a typeclass `PolyParsec.MonadPolyParsec` enabling polymorphic parser combinator, and
* a scoped instance `MonadPolyParsec String Std.Internal.Parsec.String.Parser` in `PolyParsec.Std` for convenience.
