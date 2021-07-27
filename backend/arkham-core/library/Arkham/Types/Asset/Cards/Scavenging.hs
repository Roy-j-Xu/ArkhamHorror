module Arkham.Types.Asset.Cards.Scavenging
  ( Scavenging(..)
  , scavenging
  ) where

import Arkham.Prelude

import qualified Arkham.Asset.Cards as Cards
import Arkham.Types.Ability
import qualified Arkham.Types.Action as Action
import Arkham.Types.Asset.Attrs
import Arkham.Types.Asset.Helpers
import Arkham.Types.Asset.Runner
import Arkham.Types.Classes
import Arkham.Types.Cost
import Arkham.Types.Message
import Arkham.Types.Modifier
import Arkham.Types.Target
import Arkham.Types.Trait
import Arkham.Types.Window

newtype Scavenging = Scavenging AssetAttrs
  deriving anyclass IsAsset
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

scavenging :: AssetCard Scavenging
scavenging = asset Scavenging Cards.scavenging

instance HasModifiersFor env Scavenging

ability :: AssetAttrs -> Ability
ability a =
  mkAbility (toSource a) 1 (ReactionAbility $ ExhaustCost (toTarget a))

instance ActionRunner env => HasActions env Scavenging where
  getActions iid (AfterPassSkillTest (Just Action.Investigate) _ You n) (Scavenging a)
    | ownedBy a iid && n >= 2
    = do
      hasItemInDiscard <- any (member Item . toTraits) <$> getDiscardOf iid
      cardsCanLeaveDiscard <-
        notElem CardsCannotLeaveYourDiscardPile
          <$> getModifiers (toSource a) (InvestigatorTarget iid)
      pure
        [ UseAbility iid (ability a)
        | hasItemInDiscard && cardsCanLeaveDiscard
        ]
  getActions i window (Scavenging x) = getActions i window x

instance AssetRunner env => RunMessage env Scavenging where
  runMessage msg a@(Scavenging attrs) = case msg of
    UseCardAbility iid source _ 1 _ | isSource attrs source ->
      a <$ push (SearchDiscard iid (InvestigatorTarget iid) [Item])
    _ -> Scavenging <$> runMessage msg attrs
