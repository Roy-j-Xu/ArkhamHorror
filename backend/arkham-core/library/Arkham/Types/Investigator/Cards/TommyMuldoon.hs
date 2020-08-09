{-# LANGUAGE UndecidableInstances #-}
module Arkham.Types.Investigator.Cards.TommyMuldoon where

import Arkham.Types.Classes
import Arkham.Types.ClassSymbol
import Arkham.Types.Investigator.Attrs
import Arkham.Types.Investigator.Runner
import Arkham.Types.Message
import Arkham.Types.Stats
import Arkham.Types.Token
import Arkham.Types.Trait
import ClassyPrelude
import Data.Aeson

newtype TommyMuldoon = TommyMuldoon Attrs
  deriving newtype (Show, ToJSON, FromJSON)

tommyMuldoon :: TommyMuldoon
tommyMuldoon = TommyMuldoon $ baseAttrs
  "06001"
  "Tommy Muldoon"
  Guardian
  Stats
    { health = 8
    , sanity = 6
    , willpower = 3
    , intellect = 3
    , combat = 4
    , agility = 2
    }
  [Police, Warden]

instance (InvestigatorRunner env) => RunMessage env TommyMuldoon where
  runMessage msg i@(TommyMuldoon attrs@Attrs {..}) = case msg of
    ResolveToken ElderSign iid _skillValue | iid == investigatorId -> pure i
    _ -> TommyMuldoon <$> runMessage msg attrs
