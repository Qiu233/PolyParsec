module
namespace PolyParsec

/--
  The primitive effects required to implement a parser (combinator).
  Some of the functions are overlapping for performance reason. -/
public class MonadPolyParsec (ε : outParam Type) (m : Type → Type) [Monad m] [instOrElse : ∀ α, OrElse (m α)] where
  /-- parse a character with condition -/
  satisfy : (Char → Bool) → m Char
  /-- fail with error -/
  fail : ε → m α
  /-- `notFollowedBy x` fails when `x` succeeds -/
  notFollowedBy : m α → m Unit
  /-- peek for the next character, `none` when EOF. -/
  peek? : m (Option Char)
  /-- `attempt x` runs `x` atomically -/
  attempt : m α → m α
  /-- parse the given character -/
  pchar : Char → m Char := fun c => satisfy (· == c)
  /-- parse the given string, fails atomically, i.e. without swallowing any input -/
  pstring : String → m String := fun s => s.toList.foldlM (init := "") (fun acc c => do return acc ++ (← Char.toString <$> pchar c))
  /-- `pchar` without result -/
  skipChar : Char → m Unit := fun c => discard (pchar c)
  /-- `pstring` without result -/
  skipString : String → m Unit := fun c => discard (pstring c)
  /-- `optional x ≡ (some <$> attempt x) <|> (pure none)` -/
  optional : m α → m (Option α) := fun x => (some <$> attempt x) <|> (pure none)
  /--
    `many x ≡ fix (fun k x => (optional x).mapM (fun h => do return #[h] ++ (← k x)) |>.toArray.flatten)`

    Instances must provide efficient implementation of this function. Also, Lean 4 does not have `fix`.
  -/
  many : m α → m (Array α)
  /--
    `many1 x ≡ do return #[← x] ++ (← many x)`

    Instances may provide efficient implementation of this function.
  -/
  many1 : m α → m (Array α) := fun x => do return #[← x] ++ (← many x)
  /-- `manyChars x ≡ (String.ofList ∘ Array.toList) <$> many x` -/
  manyChars : m Char → m String := fun x => (String.ofList ∘ Array.toList) <$> many x
  /-- `many1Chars x ≡ (String.ofList ∘ Array.toList) <$> many1 x` -/
  many1Chars : m Char → m String := fun x => (String.ofList ∘ Array.toList) <$> many1 x
