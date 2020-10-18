{-# LANGUAGE UndecidableInstances #-}
module Arkham.Types.Enemy.Cards.DarkYoungHost where

import Arkham.Import

import Arkham.Types.Enemy.Attrs
import Arkham.Types.Enemy.Helpers
import Arkham.Types.Enemy.Runner
import Arkham.Types.Trait

newtype DarkYoungHost = DarkYoungHost Attrs
  deriving newtype (Show, ToJSON, FromJSON)

darkYoungHost :: EnemyId -> DarkYoungHost
darkYoungHost uuid = DarkYoungHost $ (baseAttrs uuid "81033")
  { enemyHealthDamage = 2
  , enemySanityDamage = 1
  , enemyFight = 4
  , enemyHealth = Static 5
  , enemyEvade = 2
  }

instance HasModifiersFor env DarkYoungHost where
  getModifiersFor _ _ _ = pure []

instance HasModifiers env DarkYoungHost where
  getModifiers _ (DarkYoungHost Attrs {..}) =
    pure . concat . toList $ enemyModifiers

instance ActionRunner env => HasActions env DarkYoungHost where
  getActions i window (DarkYoungHost attrs) = getActions i window attrs

instance (EnemyRunner env) => RunMessage env DarkYoungHost where
  runMessage msg e@(DarkYoungHost attrs@Attrs {..}) = case msg of
    InvestigatorDrawEnemy _ _ eid | eid == enemyId -> do
      leadInvestigatorId <- getLeadInvestigatorId
      bayouLocations <- asks $ setToList . getSet [Bayou]
      e <$ spawnAtOneOf leadInvestigatorId enemyId bayouLocations
    _ -> DarkYoungHost <$> runMessage msg attrs
