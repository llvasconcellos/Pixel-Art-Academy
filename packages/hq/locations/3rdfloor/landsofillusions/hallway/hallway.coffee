LOI = LandsOfIllusions
HQ = Retronator.HQ
PAA = PixelArtAcademy

Vocabulary = LOI.Adventure.Parser.Vocabulary

Action = LOI.Adventure.Ability.Action
Talking = LOI.Adventure.Ability.Talking

class HQ.Locations.LandsOfIllusions.Hallway extends LOI.Adventure.Location
  @id: -> 'Retronator.HQ.Locations.LandsOfIllusions.Hallway'
  @url: -> 'retronator/landsofillusions/hallway'
  @scriptUrls: -> [
    'retronator_hq/hq.script'
    'retronator_hq/actors/elevatorbutton.script'
    'retronator_hq/locations/3rdfloor/landsofillusions/hallway/operator.script'
  ]

  @version: -> '0.0.1'

  @fullName: -> "Lands of Illusions hallway"
  @shortName: -> "hallway"
  @description: ->
    "
      The narrow hallway leads from the reception deck towards a number of adjacent rooms to the west.
      Elevator access is also available to the east.
    "
  
  @initialize()

  @initialState: ->
    things = {}
    things[HQ.Actors.ElevatorButton.id()] = displayOrder: 1

    exits = {}
    exits[Vocabulary.Keys.Directions.North] = HQ.Locations.LandsOfIllusions.id()
    exits[Vocabulary.Keys.Directions.West] = HQ.Locations.LandsOfIllusions.Room.id()

    _.merge {}, super,
      things: things
      exits: exits

  constructor: ->
    super

    HQ.Locations.Elevator.setupElevatorExit
      location: @
      floor: '3a'
      directions: [Vocabulary.Keys.Directions.In, Vocabulary.Keys.Directions.East]

  onScriptsLoaded: ->
    # Elevator button
    HQ.Actors.ElevatorButton.setupButton
      location: @
      floor: '3a'

    # Operator
    Tracker.autorun (computation) =>
      return unless state = @state()

      unless state.things[HQ.Actors.Operator.id()]
        # Operator is not at this location so quit.
        computation.stop()
        return

      return unless operator = @things HQ.Actors.Operator.id()
      return unless operator.ready()
      computation.stop()

      operatorDialog = @scripts['Retronator.HQ.Locations.LandsOfIllusions.Hallway.Scripts.Operator']

      operatorDialog.setActors
        operator: operator

      operatorDialog.setCallbacks
        Move: (complete) =>
          # Operator leaves to the cabin for you to follow.
          @options.adventure.scriptHelpers.moveThingBetweenLocations
            thing: HQ.Actors.Operator
            sourceLocation: @
            destinationLocation: HQ.Locations.LandsOfIllusions.Room

          complete()

      # Operator starts talking automatically.
      @director().startScript operatorDialog
