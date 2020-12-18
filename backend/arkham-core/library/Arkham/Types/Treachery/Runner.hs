module Arkham.Types.Treachery.Runner where

import ClassyPrelude

import Arkham.Types.Ability
import Arkham.Types.AssetId
import Arkham.Types.Card
import Arkham.Types.Card.CardCode
import Arkham.Types.Classes
import Arkham.Types.EnemyId
import Arkham.Types.InvestigatorId
import Arkham.Types.LocationId
import Arkham.Types.Query
import Arkham.Types.Trait

type TreacheryRunner env
  = ( HasQueue env
    , HasCount ActsRemainingCount env ()
    , HasCount CardCount env InvestigatorId
    , HasCount ClueCount env InvestigatorId
    , HasCount ClueCount env LocationId
    , HasCount DamageCount env InvestigatorId
    , HasCount PlayerCount env ()
    , HasCount ResourceCount env InvestigatorId
    , HasCount Shroud env LocationId
    , HasCount SpendableClueCount env InvestigatorId
    , HasCount TreacheryCount env (LocationId, CardCode)
    , HasId (Maybe StoryEnemyId) env CardCode
    , HasId LocationId env EnemyId
    , HasId LocationId env InvestigatorId
    , HasList UsedAbility env ()
    , HasSet AssetId env InvestigatorId
    , HasSet ClosestEnemyId env (LocationId, [Trait])
    , HasSet ConnectedLocationId env LocationId
    , HasSet DiscardableAssetId env InvestigatorId
    , HasSet FarthestLocationId env InvestigatorId
    , HasSet InvestigatorId env LocationId
    , HasSet InvestigatorId env ()
    , HasSet LocationId env ()
    , HasSet LocationId env TreacheryCardCode
    , HasSet LocationId env [Trait]
    , HasSet Trait env LocationId
    , HasSet FarthestEnemyId env (InvestigatorId, EnemyTrait)
    , HasSet UniqueEnemyId env ()
    , HasSet EnemyId env ()
    )

