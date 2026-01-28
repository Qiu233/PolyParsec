module

public import Std.Internal.Parsec
public import PolyParsec.Basic

/-!
This module provides scoped instance of `MonadPolyParsec String Std.Internal.Parsec.String.Parser`.
-/

public section

namespace PolyParsec.Std

open Std.Internal.Parsec Std.Internal.Parsec.String in
@[always_inline]
scoped instance : MonadPolyParsec String Parser where
  satisfy := satisfy
  pchar := pchar
  pstring := pstring
  skipChar := skipChar
  skipString := skipString
  attempt := attempt
  optional := optional
  many := many
  many1 := many1
  manyChars := manyChars
  many1Chars := many1Chars
  fail := fail
  notFollowedBy := notFollowedBy
  peek? := peek?
