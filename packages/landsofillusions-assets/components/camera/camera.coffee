AM = Artificial.Mirage
LOI = LandsOfIllusions

class LOI.Assets.Components.Camera extends AM.Component
  @register 'LandsOfIllusions.Assets.Components.Camera'

  constructor: (@options) ->
    super

  onCreated: ->
    super

  vectors: ->
    vectors = []
    camera = @options.load()

    for name in ['position', 'target', 'up']
      vector = camera[name]
      vectors.push _.extend {name, x: 0, y: 0, z: 0}, vector

    vectors

  # Events

  events: ->
    super.concat
      'change .coordinate-input': @onChangeCoordinate

  onChangeCoordinate: (event) ->
    vector = @currentData()
    $vector = $(event.target).closest('.vector')

    newVector = {}

    for property in ['x', 'y', 'z']
      newVector[property] = @_parseFloatOrZero $vector.find(".coordinate-#{property} .coordinate-input").val()

    @options.save "#{vector.name}": newVector

  _parseFloatOrZero: (string) ->
    float = parseFloat string

    if _.isNaN float then 0 else float
