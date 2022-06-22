module Arkham.Asset.Cards.Machete
  ( Machete(..)
  , machete
  ) where

import Arkham.Prelude

import Arkham.Ability
import qualified Arkham.Action as Action
import qualified Arkham.Asset.Cards as Cards
import Arkham.Asset.Runner
import Arkham.Cost
import Arkham.Criteria
import Arkham.Matcher
import Arkham.SkillTest
import Arkham.SkillType
import Arkham.Source
import Arkham.Target

newtype Machete = Machete AssetAttrs
  deriving anyclass IsAsset
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

machete :: AssetCard Machete
machete = asset Machete Cards.machete

instance HasModifiersFor Machete where
  getModifiersFor _ (InvestigatorTarget iid) (Machete attrs) = do
    mSkillTestSource <- getSkillTestSource
    mSkillTestTarget <- getSkillTestTarget
    case (mSkillTestTarget, mSkillTestSource) of
      (Just (EnemyTarget eid), Just (SkillTestSource iid' _ source _))
        | isSource attrs source && iid == iid' -> do
          engagedEnemies <- selectList $ EnemyIsEngagedWith $ InvestigatorWithId
            iid
          pure $ toModifiers attrs [ DamageDealt 1 | engagedEnemies == [eid] ]
      _ -> pure []


  getModifiersFor _ _ _ = pure []

instance HasAbilities Machete where
  getAbilities (Machete a) =
    [ restrictedAbility a 1 OwnsThis
        $ ActionAbility (Just Action.Fight)
        $ ActionCost 1
    ]

instance RunMessage Machete where
  runMessage msg a@(Machete attrs) = case msg of
    UseCardAbility iid source _ 1 _ | isSource attrs source -> do
      a <$ pushAll
        [ skillTestModifier
          attrs
          (InvestigatorTarget iid)
          (SkillModifier SkillCombat 1)
        , ChooseFightEnemy iid source Nothing SkillCombat mempty False
        ]
    _ -> Machete <$> runMessage msg attrs
