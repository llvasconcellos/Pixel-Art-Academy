LOI = LandsOfIllusions
PAA = PixelArtAcademy
C1 = PAA.Season1.Episode1.Chapter1
HQ = Retronator.HQ

class C1.Inventory extends LOI.Adventure.Scene
  @id: -> 'PixelArtAcademy.Season1.Episode1.Chapter1.Inventory'

  @location: -> LOI.Adventure.Inventory

  @initialize()

  constructor: ->
    super arguments...

  things: ->
    items = [
      C1.Mixer.NameTag if C1.Mixer.Marker.Listener.Script.state 'GetNameTag'
    ]
    
    obtainableItems = [
      PAA.PixelBoy
      SanFrancisco.Soma.Items.Map
      C1.Mixer.Marker
      C1.Mixer.Stickers
    ]

    for itemClass in obtainableItems
      hasItem = itemClass.state 'inInventory'
      items.push itemClass if hasItem

    items
