module Arkham.Treachery.Cards.ShockingDiscovery (
  shockingDiscovery,
  ShockingDiscovery (..),
)
where

import Arkham.Prelude

import Arkham.Ability
import Arkham.Card
import Arkham.Classes
import Arkham.Deck qualified as Deck
import Arkham.Helpers.Investigator
import Arkham.Matcher
import Arkham.Message
import Arkham.Treachery.Cards qualified as Cards
import Arkham.Treachery.Runner
import Arkham.Window (getBatchId)

newtype ShockingDiscovery = ShockingDiscovery TreacheryAttrs
  deriving anyclass (IsTreachery, HasModifiersFor)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

shockingDiscovery :: TreacheryCard ShockingDiscovery
shockingDiscovery = treachery ShockingDiscovery Cards.shockingDiscovery

instance HasAbilities ShockingDiscovery where
  getAbilities (ShockingDiscovery x) = [mkAbility x 1 $ ForcedAbility (AmongSearchedCards You)]

-- Forced - When you search your deck and this card is among the searched
-- cards: Discard it. Cancel the search and all of its effects. Shuffle the
-- searched deck. Draw the top card of the encounter deck.

instance RunMessage ShockingDiscovery where
  runMessage msg t@(ShockingDiscovery attrs) = case msg of
    Revelation iid (isSource attrs -> True) -> do
      canShuffleDeck <- getCanShuffleDeck iid
      if canShuffleDeck
        then push $ ShuffleIntoDeck (Deck.InvestigatorDeck iid) (toTarget attrs)
        else push $ InvestigatorDrawEncounterCard iid
      pure t
    InSearch (UseCardAbility iid (isSource attrs -> True) 1 (getBatchId -> batchId) _) -> do
      let card = fromJustNote "is player card" $ preview _PlayerCard (toCard attrs)
      pushAll
        [ RemoveCardFromSearch iid (toCardId card)
        , AddToDiscard iid card
        , CancelBatch batchId
        , SearchEnded iid
        , ShuffleDeck (Deck.InvestigatorDeck iid)
        , InvestigatorDrawEncounterCard iid
        ]
      pure t
    _ -> ShockingDiscovery <$> runMessage msg attrs
