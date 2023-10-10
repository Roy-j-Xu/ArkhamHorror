module Arkham.Asset.Cards.EsotericAtlas1 (
  esotericAtlas1,
  EsotericAtlas1 (..),
) where

import Arkham.Prelude

import Arkham.Ability
import Arkham.Asset.Cards qualified as Cards
import Arkham.Asset.Runner
import Arkham.Matcher
import Arkham.Movement

newtype EsotericAtlas1 = EsotericAtlas1 AssetAttrs
  deriving anyclass (IsAsset, HasModifiersFor)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

esotericAtlas1 :: AssetCard EsotericAtlas1
esotericAtlas1 = asset EsotericAtlas1 Cards.esotericAtlas1

instance HasAbilities EsotericAtlas1 where
  getAbilities (EsotericAtlas1 a) =
    [ controlledAbility
        a
        1
        (exists (LocationWithDistanceFrom 2 (RevealedLocation <> CanEnterLocation You)))
        $ actionAbilityWithCost (assetUseCost a Secret 1)
    ]

instance RunMessage EsotericAtlas1 where
  runMessage msg a@(EsotericAtlas1 attrs) = case msg of
    UseCardAbility iid (isSource attrs -> True) 1 _ _ -> do
      locations <- selectList $ LocationWithDistanceFrom 2 (RevealedLocation <> canEnterLocation iid)
      player <- getPlayer iid
      push
        $ chooseOne
          player
          [ targetLabel location [MoveTo $ move (toSource attrs) iid location]
          | location <- locations
          ]
      pure a
    _ -> EsotericAtlas1 <$> runMessage msg attrs
