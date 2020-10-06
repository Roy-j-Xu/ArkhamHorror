module Arkham.Types.Card.Id where

import ClassyPrelude
import Data.Aeson
import Data.UUID

newtype CardId = CardId { unCardId :: UUID }
  deriving newtype (Show, Eq, ToJSON, FromJSON, ToJSONKey, FromJSONKey, Hashable)

newtype CommittedCardId = CommittedCardId { unCommittedCardId :: CardId }
  deriving newtype (Show, Eq, ToJSON, FromJSON, ToJSONKey, FromJSONKey, Hashable)

newtype HandCardId = HandCardId { unHandCardId :: CardId }
  deriving newtype (Show, Eq, ToJSON, FromJSON, ToJSONKey, FromJSONKey, Hashable)

newtype DeckCardId = DeckCardId { unDeckCardId :: CardId }
  deriving newtype (Show, Eq, ToJSON, FromJSON, ToJSONKey, FromJSONKey, Hashable)
