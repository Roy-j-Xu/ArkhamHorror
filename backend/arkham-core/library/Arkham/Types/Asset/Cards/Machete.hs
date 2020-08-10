{-# LANGUAGE UndecidableInstances #-}
module Arkham.Types.Asset.Cards.Machete where

import Arkham.Json
import Arkham.Types.Ability
import qualified Arkham.Types.Action as Action
import Arkham.Types.Asset.Attrs
import Arkham.Types.Asset.Runner
import Arkham.Types.AssetId
import Arkham.Types.Classes
import Arkham.Types.Message
import Arkham.Types.Modifier
import Arkham.Types.Query
import Arkham.Types.SkillType
import Arkham.Types.Slot
import Arkham.Types.Source
import ClassyPrelude

newtype Machete = Machete Attrs
  deriving newtype (Show, ToJSON, FromJSON)

machete :: AssetId -> Machete
machete uuid = Machete $ (baseAttrs uuid "01020")
  { assetSlots = [HandSlot]
  , assetAbilities =
    [ ( AssetSource uuid
      , AssetSource uuid
      , 1
      , ActionAbility 1 (Just Action.Fight)
      , NoLimit
      )
    ]
  }

instance (AssetRunner env) => RunMessage env Machete where
  runMessage msg a@(Machete attrs@Attrs {..}) = case msg of
    UseCardAbility iid (AssetSource aid, _, 1, _, _) | aid == assetId -> do
      engagedEnemiesCount <- unEnemyCount <$> asks (getCount iid)
      let
        damageDealtModifiers = if engagedEnemiesCount == 1
          then [DamageDealt 1 (AssetSource aid)]
          else []
      unshiftMessage
        (ChooseFightEnemy
          iid
          SkillCombat
          (damageDealtModifiers
          <> [SkillModifier SkillCombat 1 (AssetSource aid)]
          )
          mempty
          False
        )
      pure a
    _ -> Machete <$> runMessage msg attrs
