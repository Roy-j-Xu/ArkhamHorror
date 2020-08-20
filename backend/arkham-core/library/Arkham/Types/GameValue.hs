module Arkham.Types.GameValue
  ( GameValue(..)
  , fromGameValue
  )
where

import ClassyPrelude
import Data.Aeson

data GameValue a
  = Static a
  | PerPlayer a
  deriving stock (Show, Generic)
  deriving anyclass (ToJSON, FromJSON)

instance Functor GameValue where
  fmap f (Static n) = Static (f n)
  fmap f (PerPlayer n) = PerPlayer (f n)

fromGameValue :: GameValue Int -> Int -> Int
fromGameValue (Static n) _ = n
fromGameValue (PerPlayer n) pc = n * pc
