LOI = LandsOfIllusions
HQ = Retronator.HQ
PAA = PixelArtAcademy

Vocabulary = LOI.Parser.Vocabulary

Action = LOI.Adventure.Ability.Action
Talking = LOI.Adventure.Ability.Talking

class HQ.Locations.Entrance extends LOI.Adventure.Location
  @id: -> 'Retronator.HQ.Locations.Entrance'
  @url: -> 'retronator/entrance'
  @scriptUrls: -> [
    'retronator-hq/hq.script'
  ]

  @version: -> '0.0.1'

  @fullName: -> "Retronator HQ entrance"
  @shortName: -> "entrance"
  @description: ->
    "
      You're on the streets of San Francisco. To the west is the lobby of Retronator HQ. Possibilities are endless,
      yet there is nowhere to go but _in_. You might want to _read sign_ if you're new to all of this.
    "
  
  @initialize()

  constructor: ->
    super

  things: -> [HQ.Locations.Entrance.Sign.id()]

  exits: ->
    exits = {}
    exits[Vocabulary.Keys.Directions.West] = HQ.Locations.Lobby.id()
    exits[Vocabulary.Keys.Directions.In] = HQ.Locations.Lobby.id()
    exits[Vocabulary.Keys.Directions.Out] = PixelArtAcademy.LandingPage.Locations.Retropolis.id()
    exits