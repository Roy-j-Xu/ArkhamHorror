{-# LANGUAGE UndecidableInstances #-}
module Arkham.Types.Investigator.Cards.DaisyWalker where

import Arkham.Types.Ability
import Arkham.Types.Window
import Arkham.Types.Classes
import Arkham.Types.ClassSymbol
import Arkham.Types.Investigator.Attrs
import Arkham.Types.Investigator.Runner
import Arkham.Types.Message
import Arkham.Types.Modifier
import Arkham.Types.Query
import Arkham.Types.Source
import Arkham.Types.Stats
import Arkham.Types.Token
import Arkham.Types.Trait
import ClassyPrelude
import Data.Aeson
import qualified Data.HashMap.Strict as HashMap
import Safe (fromJustNote)

newtype DaisyWalker = DaisyWalker Attrs
  deriving newtype (Show, ToJSON, FromJSON)

daisyWalker :: DaisyWalker
daisyWalker =
  DaisyWalker $ (baseAttrs "01002" "Daisy Walker" Seeker stats [Miskatonic])
    { investigatorTomeActions = Just 1
    }
 where
  stats = Stats
    { health = 5
    , sanity = 9
    , willpower = 3
    , intellect = 5
    , combat = 2
    , agility = 2
    }

becomesFailure :: Token -> Modifier -> Bool
becomesFailure token (ForcedTokenChange fromToken AutoFail) =
  token == fromToken
becomesFailure _ _ = False

instance HasActions env investigator DaisyWalker where
  getActions i window (DaisyWalker attrs) = getActions i window attrs

instance (InvestigatorRunner Attrs env) => RunMessage env DaisyWalker where
  runMessage msg i@(DaisyWalker attrs@Attrs {..}) = case msg of
    ResetGame -> do
      attrs' <- runMessage msg attrs
      pure $ DaisyWalker $ attrs' { investigatorTomeActions = Just 1 }
    ActivateCardAbilityAction iid ability@Ability {..}
      | iid == investigatorId && sourceIsAsset abilitySource -> do
        let (AssetSource aid) = abilitySource
        traits <- asks (getSet aid)
        if Tome
          `elem` traits
          && fromJustNote "Must be set" investigatorTomeActions
          > 0
        then
          case abilityType of
            FastAbility _ -> DaisyWalker <$> runMessage msg attrs
            ReactionAbility _ -> DaisyWalker <$> runMessage msg attrs
            ActionAbility n actionType -> if n > 0
              then DaisyWalker <$> runMessage
                (ActivateCardAbilityAction
                  iid
                  (ability { abilityType = ActionAbility (n - 1) actionType })
                )
                (attrs
                  { investigatorTomeActions =
                    max 0 . subtract 1 <$> investigatorTomeActions
                  }
                )
              else DaisyWalker <$> runMessage msg attrs
        else
          DaisyWalker <$> runMessage msg attrs
    PlayerWindow iid additionalActions | iid == investigatorId ->
      if investigatorRemainingActions
          == 0
          && fromJustNote "Must be set" investigatorTomeActions
          > 0
        then do
          tomeActions' <- join
            $ asks (getActions attrs NonFast . (AssetActionType, Tome, ))
          DaisyWalker
            <$> runMessage
                  (PlayerWindow iid (additionalActions <> tomeActions'))
                  attrs
        else DaisyWalker <$> runMessage msg attrs
    ResolveToken ElderSign iid skillValue | iid == investigatorId ->
      if any
          (becomesFailure ElderSign)
          (concat . HashMap.elems $ investigatorModifiers)
        then i <$ unshiftMessage (ResolveToken AutoFail iid skillValue)
        else do
          tomeCount <- unAssetCount <$> asks (getCount (iid, [Tome]))
          runTest investigatorId skillValue 0 -- Because this unshifts we need to call this before the on success is added
          when (tomeCount > 0) $ unshiftMessage
            (AddOnSuccess
              (Ask iid
              $ ChooseOne
                  [ DrawCards iid tomeCount False
                  , Continue "Do not use Daisy's ability"
                  ]
              )
            )
          pure i
    BeginRound -> DaisyWalker
      <$> runMessage msg (attrs { investigatorTomeActions = Just 1 })
    _ -> DaisyWalker <$> runMessage msg attrs
