module Arkham.Types.Act.Cards.Trapped where

import Arkham.Prelude

import Arkham.Types.Act.Attrs
import Arkham.Types.Act.Helpers
import Arkham.Types.Act.Runner
import Arkham.Types.Classes
import Arkham.Types.GameValue
import Arkham.Types.Message
import Arkham.Types.Target

newtype Trapped = Trapped ActAttrs
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity, HasModifiersFor env)

trapped :: Trapped
trapped = Trapped $ baseAttrs
  "01108"
  "Trapped"
  (Act 1 A)
  (Just $ RequiredClues (PerPlayer 2) Nothing)

instance ActionRunner env => HasActions env Trapped where
  getActions i window (Trapped x) = getActions i window x

instance ActRunner env => RunMessage env Trapped where
  runMessage msg a@(Trapped attrs@ActAttrs {..}) = case msg of
    AdvanceAct aid _ | aid == actId && onSide A attrs -> do
      leadInvestigatorId <- getLeadInvestigatorId
      investigatorIds <- getInvestigatorIds
      requiredClues <- getPlayerCountValue (PerPlayer 2)
      unshiftMessages
        [ SpendClues requiredClues investigatorIds
        , chooseOne leadInvestigatorId [AdvanceAct aid $ toSource attrs]
        ]
      pure $ Trapped $ attrs & sequenceL .~ Act 1 B
    AdvanceAct aid _ | aid == actId && onSide B attrs -> do
      studyId <- getJustLocationIdByName "Study"
      enemyIds <- getSetList studyId
      hallwayId <- getRandom
      atticId <- getRandom
      cellarId <- getRandom
      parlorId <- getRandom
      a <$ unshiftMessages
        ([ PlaceLocation "01112" hallwayId
         , PlaceLocation "01114" cellarId
         , PlaceLocation "01113" atticId
         , PlaceLocation "01115" parlorId
         ]
        <> map (Discard . EnemyTarget) enemyIds
        <> [ RevealLocation Nothing hallwayId
           , MoveAllTo hallwayId
           , RemoveLocation studyId
           , NextAct aid "01109"
           ]
        )
    _ -> Trapped <$> runMessage msg attrs
