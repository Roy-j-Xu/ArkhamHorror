module Arkham.Trait (
  Trait (..),
  EnemyTrait (..),
  HasTraits (..),
) where

import Arkham.Prelude

newtype EnemyTrait = EnemyTrait {unEnemyTrait :: Trait}

data Trait
  = Abomination
  | Agency
  | Ally
  | Altered
  | Ancient
  | AncientOne
  | Arkham
  | ArkhamAsylum
  | Armor
  | Artist
  | Assistant
  | Augury
  | Avatar
  | Bayou
  | Believer
  | Blessed
  | Blunder
  | Boat
  | Bold
  | Boon
  | Bridge
  | Byakhee
  | Bystander
  | Campsite
  | Carnevale
  | Cave
  | Central
  | Charm
  | Chosen
  | Circle
  | Civic
  | Clairvoyant
  | Clothing
  | CloverClub
  | Composure
  | Condition
  | Connection
  | Conspirator
  | Courage
  | Creature
  | Criminal
  | Cultist
  | Curse
  | Cursed
  | DarkYoung
  | DeepOne
  | Desperate
  | Detective
  | Developed
  | Dhole
  | Dreamer
  | Dreamlands
  | Drifter
  | Dunwich
  | Eldritch
  | Elite
  | Endtimes
  | Evidence
  | Exhibit
  | Expert
  | Extradimensional
  | Eztli
  | Familiar
  | Fated
  | Favor
  | Firearm
  | Flaw
  | Flora
  | Footwear
  | Forgotten
  | Fortune
  | Future
  | Gambit
  | Geist
  | Ghoul
  | Grant
  | GroundFloor
  | Gug
  | Hazard
  | Hex
  | HistoricalSociety
  | Human
  | Humanoid
  | Hunter
  | Illicit
  | Improvised
  | Injury
  | Innate
  | Insight
  | Instrument
  | Item
  | Job
  | Jungle
  | Key
  | Lodge
  | Lunatic
  | Madness
  | Mask
  | Medic
  | Melee
  | MexicoCity
  | Miskatonic
  | Monster
  | Mystery
  | NewOrleans
  | Nightgaunt
  | Obstacle
  | Occult
  | Omen
  | Otherworld
  | Pact
  | Paradox
  | Paris
  | Passageway
  | Patron
  | Performer
  | Pnakotus
  | Poison
  | Police
  | Power
  | Practiced
  | PresentDay
  | Private
  | Rail
  | Ranged
  | Relic
  | Reporter
  | Research
  | Ritual
  | River
  | Riverside
  | Ruins
  | Salem
  | Sanctum
  | Scheme
  | Scholar
  | Science
  | SecondFloor
  | SentinelHill
  | Serpent
  | Service
  | Servitor
  | Shattered
  | Shoggoth
  | SilverTwilight
  | Socialite
  | Song
  | Sorcerer
  | Spectral
  | Spell
  | Spirit
  | Summon
  | Supply
  | Syndicate
  | Tactic
  | Talent
  | Tarot
  | Task
  | Tenochtitlan
  | Tentacle
  | Terror
  | ThirdFloor
  | Tindalos
  | Tome
  | Tool
  | Train
  | Trap
  | Trick
  | Unhallowed
  | Upgrade
  | Venice
  | Veteran
  | Warden
  | Wayfarer
  | Weapon
  | Wilderness
  | Witch
  | WitchHouse
  | Woods
  | Yithian
  | Yoth
  deriving stock (Show, Eq, Generic, Ord, Enum, Bounded, Read)
  deriving anyclass (ToJSON, FromJSON, Hashable)

class HasTraits a where
  toTraits :: a -> Set Trait
