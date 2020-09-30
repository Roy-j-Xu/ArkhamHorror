{-# LANGUAGE UndecidableInstances #-}
module Arkham.Types.Asset.Cards.Duke where

import Arkham.Json
import Arkham.Types.Ability
import qualified Arkham.Types.Action as Action
import Arkham.Types.Asset.Attrs
import Arkham.Types.Asset.Helpers
import Arkham.Types.Asset.Runner
import Arkham.Types.AssetId
import Arkham.Types.Classes
import Arkham.Types.Message
import Arkham.Types.Modifier
import Arkham.Types.SkillType
import Arkham.Types.Source
import Arkham.Types.Window
import ClassyPrelude
import Lens.Micro

newtype Duke = Duke Attrs
  deriving stock (Show, Generic)
  deriving anyclass (ToJSON, FromJSON)

duke :: AssetId -> Duke
duke uuid =
  Duke $ (baseAttrs uuid "02014") { assetHealth = Just 2, assetSanity = Just 3 }

instance (ActionRunner env investigator) => HasActions env investigator Duke where
  getActions i NonFast (Duke Attrs {..})
    | Just (getId () i) == assetInvestigator = do
      fightAvailable <- hasFightActions i NonFast
      investigateAvailable <- hasInvestigateActions i NonFast
      pure
        $ [ ActivateCardAbilityAction
              (getId () i)
              (mkAbility
                (AssetSource assetId)
                1
                (ActionAbility 1 (Just Action.Fight))
              )
          | fightAvailable && canDo Action.Fight i
          ]
        <> [ ActivateCardAbilityAction
               (getId () i)
               (mkAbility
                 (AssetSource assetId)
                 1
                 (ActionAbility 2 (Just Action.Fight))
               )
           | investigateAvailable && canDo Action.Investigate i
           ]
  getActions i window (Duke x) = getActions i window x

instance (AssetRunner env) => RunMessage env Duke where
  runMessage msg (Duke attrs@Attrs {..}) = case msg of
    UseCardAbility iid _ (AssetSource aid) _ 1 | aid == assetId -> do
      unshiftMessage
        (ChooseFightEnemy
          iid
          SkillCombat
          [BaseSkillOf 4, DamageDealt 1]
          mempty
          False
        )
      pure . Duke $ attrs & exhausted .~ True
    _ -> Duke <$> runMessage msg attrs
