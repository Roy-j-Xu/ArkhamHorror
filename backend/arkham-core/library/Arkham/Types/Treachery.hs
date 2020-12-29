{-# LANGUAGE UndecidableInstances #-}
module Arkham.Types.Treachery
  ( lookupTreachery
  , Treachery(..)
  , isWeakness
  , treacheryTarget
  )
where

import Arkham.Import

import Arkham.Types.Trait (Trait)
import Arkham.Types.Treachery.Attrs
import Arkham.Types.Treachery.Cards
import Arkham.Types.Treachery.Runner
import Data.Coerce

data Treachery
  = CoverUp' CoverUp
  | HospitalDebts' HospitalDebts
  | AbandonedAndAlone' AbandonedAndAlone
  | Amnesia' Amnesia
  | Paranoia' Paranoia
  | Haunted' Haunted
  | Psychosis' Psychosis
  | Hypochondria' Hypochondria
  | HuntingShadow' HuntingShadow
  | FalseLead' FalseLead
  | UmordhothsWrath' UmordhothsWrath
  | GraspingHands' GraspingHands
  | AncientEvils' AncientEvils
  | RottingRemains' RottingRemains
  | FrozenInFear' FrozenInFear
  | DissonantVoices' DissonantVoices
  | CryptChill' CryptChill
  | ObscuringFog' ObscuringFog
  | MysteriousChanting' MysteriousChanting
  | OnWingsOfDarkness' OnWingsOfDarkness
  | LockedDoor' LockedDoor
  | TheYellowSign' TheYellowSign
  | OfferOfPower' OfferOfPower
  | DreamsOfRlyeh' DreamsOfRlyeh
  | SmiteTheWicked' SmiteTheWicked
  | RexsCurse' RexsCurse
  | SearchingForIzzie' SearchingForIzzie
  | FinalRhapsody' FinalRhapsody
  | WrackedByNightmares' WrackedByNightmares
  | Indebted' Indebted
  | InternalInjury' InternalInjury
  | Chronophobia' Chronophobia
  | VisionsOfFuturesPast' VisionsOfFuturesPast
  | BeyondTheVeil' BeyondTheVeil
  | LightOfAforgomon' LightOfAforgomon
  | UnhallowedCountry' UnhallowedCountry
  | EagerForDeath' EagerForDeath
  | CursedLuck' CursedLuck
  | TwistOfFate' TwistOfFate
  | AlteredBeast' AlteredBeast
  | HuntedDown' HuntedDown
  | PushedIntoTheBeyond' PushedIntoTheBeyond
  | TerrorFromBeyond' TerrorFromBeyond
  | ArcaneBarrier' ArcaneBarrier
  | EphemeralExhibits' EphemeralExhibits
  | SlitheringBehindYou' SlitheringBehindYou
  | TheZealotsSeal' TheZealotsSeal
  | MaskedHorrors' MaskedHorrors
  | VaultOfEarthlyDemise' VaultOfEarthlyDemise
  | UmordhothsHunger' UmordhothsHunger
  | ChillFromBelow' ChillFromBelow
  | MaskOfUmordhoth' MaskOfUmordhoth
  | Atychiphobia' Atychiphobia
  | CursedSwamp' CursedSwamp
  | SpectralMist' SpectralMist
  | DraggedUnder' DraggedUnder
  | RipplesOnTheSurface' RipplesOnTheSurface
  | CurseOfTheRougarou' CurseOfTheRougarou
  | OnTheProwl' OnTheProwl
  | BeastOfTheBayou' BeastOfTheBayou
  | InsatiableBloodlust' InsatiableBloodlust
  deriving stock (Show, Generic)
  deriving anyclass (ToJSON, FromJSON)

deriving anyclass instance ActionRunner env => HasActions env Treachery
deriving anyclass instance TreacheryRunner env => RunMessage env Treachery
deriving anyclass instance
  ( HasCount PlayerCount env ()
  , HasId LocationId env InvestigatorId
  , HasId (Maybe OwnerId) env AssetId
  , HasSet Trait env LocationId
  , HasSet UniqueEnemyId env ()
  )
  => HasModifiersFor env Treachery

instance Entity Treachery where
  type EntityId Treachery = TreacheryId
  toId = toId . treacheryAttrs
  toTarget = toTarget . treacheryAttrs
  isTarget = isTarget . treacheryAttrs
  toSource = toSource . treacheryAttrs
  isSource = isSource . treacheryAttrs

instance IsCard Treachery where
  getCardId = getCardId . treacheryAttrs
  getCardCode = getCardCode . treacheryAttrs
  getTraits = getTraits . treacheryAttrs
  getKeywords = getKeywords . treacheryAttrs

instance HasCount DoomCount env Treachery where
  getCount = pure . DoomCount . treacheryDoom . treacheryAttrs

instance HasCount (Maybe ClueCount) env Treachery where
  getCount = pure . (ClueCount <$>) . treacheryClues . treacheryAttrs

instance HasId (Maybe OwnerId) env Treachery where
  getId = pure . (OwnerId <$>) . treacheryOwner . treacheryAttrs

lookupTreachery
  :: CardCode -> (TreacheryId -> Maybe InvestigatorId -> Treachery)
lookupTreachery cardCode =
  fromJustNote ("Unknown treachery: " <> pack (show cardCode))
    $ lookup cardCode allTreacheries

allTreacheries
  :: HashMap CardCode (TreacheryId -> Maybe InvestigatorId -> Treachery)
allTreacheries = mapFromList
  [ ("01007", (CoverUp' .) . coverUp)
  , ("01011", (HospitalDebts' .) . hospitalDebts)
  , ("01015", (AbandonedAndAlone' .) . abandonedAndAlone)
  , ("01096", (Amnesia' .) . amnesia)
  , ("01097", (Paranoia' .) . paranoia)
  , ("01098", (Haunted' .) . haunted)
  , ("01099", (Psychosis' .) . psychosis)
  , ("01100", (Hypochondria' .) . hypochondria)
  , ("01135", (HuntingShadow' .) . huntingShadow)
  , ("01136", (FalseLead' .) . falseLead)
  , ("01158", (UmordhothsWrath' .) . umordhothsWrath)
  , ("01162", (GraspingHands' .) . graspingHands)
  , ("01166", (AncientEvils' .) . ancientEvils)
  , ("01163", (RottingRemains' .) . rottingRemains)
  , ("01164", (FrozenInFear' .) . frozenInFear)
  , ("01165", (DissonantVoices' .) . dissonantVoices)
  , ("01167", (CryptChill' .) . cryptChill)
  , ("01168", (ObscuringFog' .) . obscuringFog)
  , ("01171", (MysteriousChanting' .) . mysteriousChanting)
  , ("01173", (OnWingsOfDarkness' .) . onWingsOfDarkness)
  , ("01174", (LockedDoor' .) . lockedDoor)
  , ("01176", (TheYellowSign' .) . theYellowSign)
  , ("01178", (OfferOfPower' .) . offerOfPower)
  , ("01182", (DreamsOfRlyeh' .) . dreamsOfRlyeh)
  , ("02007", (SmiteTheWicked' .) . smiteTheWicked)
  , ("02009", (RexsCurse' .) . rexsCurse)
  , ("02011", (SearchingForIzzie' .) . searchingForIzzie)
  , ("02013", (FinalRhapsody' .) . finalRhapsody)
  , ("02015", (WrackedByNightmares' .) . wrackedByNightmares)
  , ("02037", (Indebted' .) . indebted)
  , ("02038", (InternalInjury' .) . internalInjury)
  , ("02039", (Chronophobia' .) . chronophobia)
  , ("02083", (VisionsOfFuturesPast' .) . visionsOfFuturesPast)
  , ("02084", (BeyondTheVeil' .) . beyondTheVeil)
  , ("02085", (LightOfAforgomon' .) . lightOfAforgomon)
  , ("02088", (UnhallowedCountry' .) . unhallowedCountry)
  , ("02091", (EagerForDeath' .) . eagerForDeath)
  , ("02092", (CursedLuck' .) . cursedLuck)
  , ("02093", (TwistOfFate' .) . twistOfFate)
  , ("02096", (AlteredBeast' .) . alteredBeast)
  , ("02099", (HuntedDown' .) . huntedDown)
  , ("02100", (PushedIntoTheBeyond' .) . pushedIntoTheBeyond)
  , ("02101", (TerrorFromBeyond' .) . terrorFromBeyond)
  , ("02102", (ArcaneBarrier' .) . arcaneBarrier)
  , ("02145", (EphemeralExhibits' .) . ephemeralExhibits)
  , ("02146", (SlitheringBehindYou' .) . slitheringBehindYou)
  , ("50024", (TheZealotsSeal' .) . theZealotsSeal)
  , ("50031", (MaskedHorrors' .) . maskedHorrors)
  , ("50032b", (VaultOfEarthlyDemise' .) . vaultOfEarthlyDemise)
  , ("50037", (UmordhothsHunger' .) . umordhothsHunger)
  , ("50040", (ChillFromBelow' .) . chillFromBelow)
  , ("50043", (MaskOfUmordhoth' .) . maskOfUmordhoth)
  , ("60504", (Atychiphobia' .) . atychiphobia)
  , ("81024", (CursedSwamp' .) . cursedSwamp)
  , ("81025", (SpectralMist' .) . spectralMist)
  , ("81026", (DraggedUnder' .) . draggedUnder)
  , ("81027", (RipplesOnTheSurface' .) . ripplesOnTheSurface)
  , ("81029", (CurseOfTheRougarou' .) . curseOfTheRougarou)
  , ("81034", (OnTheProwl' .) . onTheProwl)
  , ("81035", (BeastOfTheBayou' .) . beastOfTheBayou)
  , ("81036", (InsatiableBloodlust' .) . insatiableBloodlust)
  ]

isWeakness :: Treachery -> Bool
isWeakness = treacheryWeakness . treacheryAttrs

instance CanBeWeakness env Treachery where
  getIsWeakness = pure . isWeakness

treacheryTarget :: Treachery -> Maybe Target
treacheryTarget = treacheryAttachedTarget . treacheryAttrs

treacheryAttrs :: Treachery -> Attrs
treacheryAttrs = \case
  CoverUp' attrs -> coerce attrs
  HospitalDebts' attrs -> coerce attrs
  AbandonedAndAlone' attrs -> coerce attrs
  Amnesia' attrs -> coerce attrs
  Paranoia' attrs -> coerce attrs
  Haunted' attrs -> coerce attrs
  Psychosis' attrs -> coerce attrs
  Hypochondria' attrs -> coerce attrs
  HuntingShadow' attrs -> coerce attrs
  FalseLead' attrs -> coerce attrs
  UmordhothsWrath' attrs -> coerce attrs
  GraspingHands' attrs -> coerce attrs
  AncientEvils' attrs -> coerce attrs
  RottingRemains' attrs -> coerce attrs
  FrozenInFear' attrs -> coerce attrs
  DissonantVoices' attrs -> coerce attrs
  CryptChill' attrs -> coerce attrs
  ObscuringFog' attrs -> coerce attrs
  MysteriousChanting' attrs -> coerce attrs
  OnWingsOfDarkness' attrs -> coerce attrs
  LockedDoor' attrs -> coerce attrs
  TheYellowSign' attrs -> coerce attrs
  OfferOfPower' attrs -> coerce attrs
  DreamsOfRlyeh' attrs -> coerce attrs
  SmiteTheWicked' attrs -> coerce attrs
  RexsCurse' attrs -> coerce attrs
  SearchingForIzzie' attrs -> coerce attrs
  FinalRhapsody' attrs -> coerce attrs
  WrackedByNightmares' attrs -> coerce attrs
  Indebted' attrs -> coerce attrs
  InternalInjury' attrs -> coerce attrs
  Chronophobia' attrs -> coerce attrs
  VisionsOfFuturesPast' attrs -> coerce attrs
  BeyondTheVeil' attrs -> coerce attrs
  LightOfAforgomon' attrs -> coerce attrs
  UnhallowedCountry' attrs -> coerce attrs
  EagerForDeath' attrs -> coerce attrs
  CursedLuck' attrs -> coerce attrs
  TwistOfFate' attrs -> coerce attrs
  AlteredBeast' attrs -> coerce attrs
  HuntedDown' attrs -> coerce attrs
  PushedIntoTheBeyond' attrs -> coerce attrs
  TerrorFromBeyond' attrs -> coerce attrs
  ArcaneBarrier' attrs -> coerce attrs
  EphemeralExhibits' attrs -> coerce attrs
  SlitheringBehindYou' attrs -> coerce attrs
  TheZealotsSeal' attrs -> coerce attrs
  MaskedHorrors' attrs -> coerce attrs
  VaultOfEarthlyDemise' attrs -> coerce attrs
  UmordhothsHunger' attrs -> coerce attrs
  ChillFromBelow' attrs -> coerce attrs
  MaskOfUmordhoth' attrs -> coerce attrs
  Atychiphobia' attrs -> coerce attrs
  CursedSwamp' attrs -> coerce attrs
  SpectralMist' attrs -> coerce attrs
  DraggedUnder' attrs -> coerce attrs
  RipplesOnTheSurface' attrs -> coerce attrs
  CurseOfTheRougarou' (CurseOfTheRougarou (attrs `With` _)) -> attrs
  OnTheProwl' attrs -> coerce attrs
  BeastOfTheBayou' attrs -> coerce attrs
  InsatiableBloodlust' attrs -> coerce attrs
