module Arkham.Types.Query
  ( ClueCount(..)
  , PlayerCount(..)
  , ResourceCount(..)
  , EnemyCount(..)
  , DoomCount(..)
  , AssetCount(..)
  , TreacheryCount(..)
  , RemainingHealth(..)
  , InvestigatorLocation(..)
  , LeadInvestigatorId(..)
  , AllInvestigators(..)
  )
where

import Arkham.Types.InvestigatorId
import ClassyPrelude


newtype AssetCount = AssetCount { unAssetCount :: Int }
newtype TreacheryCount = TreacheryCount { unTreacheryCount :: Int }
newtype EnemyCount = EnemyCount { unEnemyCount :: Int }
newtype ClueCount = ClueCount { unClueCount :: Int }
  deriving newtype (Eq, Hashable)
newtype DoomCount = DoomCount { unDoomCount :: Int }
newtype ResourceCount = ResourceCount { unResourceCount :: Int }
newtype RemainingHealth = RemainingHealth { unRemainingHealth :: Int }
  deriving newtype (Eq, Hashable)

instance Semigroup ClueCount where
  (ClueCount a) <> (ClueCount b) = ClueCount (a + b)

instance Monoid ClueCount where
  mempty = ClueCount 0
  mappend = (<>)

newtype PlayerCount = PlayerCount { unPlayerCount :: Int }
newtype LeadInvestigatorId = LeadInvestigatorId { unLeadInvestigatorId :: InvestigatorId }

newtype InvestigatorLocation = InvestigatorLocation InvestigatorId
data AllInvestigators = AllInvestigators

