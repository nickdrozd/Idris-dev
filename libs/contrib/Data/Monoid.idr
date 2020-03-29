||| Ported from Haskell:
||| https://hackage.haskell.org/package/base-4.9.0.0/docs/src/Data.Monoid.html
module Data.Monoid

%access public export
%default total

-- TODO: These instances exist, but can't be named the same.
-- Decide on names for these

Semigroup () where
  (<+>) _ _ = ()

  semigroupOpIsAssociative _ _ _ = Refl

Monoid () where
  neutral = ()

  monoidNeutralIsNeutralL () = Refl
  monoidNeutralIsNeutralR () = Refl

(Semigroup m, Semigroup n) => Semigroup (m, n) where
  (a, b) <+> (c, d) = (a <+> c, b <+> d)

  semigroupOpIsAssociative (a, x) (b, y) (c, z) =
    rewrite semigroupOpIsAssociative a b c in
      rewrite semigroupOpIsAssociative x y z in
        Refl

(Monoid m, Monoid n) => Monoid (m, n) where
  neutral = (neutral, neutral)

  monoidNeutralIsNeutralL (a, b) =
    rewrite monoidNeutralIsNeutralL a in
      rewrite monoidNeutralIsNeutralL b in
        Refl
  monoidNeutralIsNeutralR (a, b) =
    rewrite monoidNeutralIsNeutralR a in
      rewrite monoidNeutralIsNeutralR b in
        Refl
