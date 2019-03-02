AS = Artificial.Spectrum
LOI = LandsOfIllusions

class LOI.HumanAvatar.TextureRenderer
  @textureSides = [
    LOI.Engine.RenderingSides.Keys.Front
    LOI.Engine.RenderingSides.Keys.FrontLeft
    LOI.Engine.RenderingSides.Keys.Left
    LOI.Engine.RenderingSides.Keys.BackLeft
    LOI.Engine.RenderingSides.Keys.Back
    LOI.Engine.RenderingSides.Keys.BackRight
    LOI.Engine.RenderingSides.Keys.Right
    LOI.Engine.RenderingSides.Keys.FrontRight
  ]

  constructor: (@options = {}) ->
    @options.createCanvas ?= (width, height) =>
      canvas = $('<canvas>')[0]
      canvas.width = width
      canvas.height = height
      canvas

    # Create and automatically update textures.
    @paletteDataCanvas = @options.createCanvas 1024, 128
    @paletteDataContext = @paletteDataCanvas.getContext '2d'

    @normalsCanvas = @options.createCanvas 1024, 128
    @normalsContext = @normalsCanvas.getContext '2d'

  render: ->
    return unless @options.humanAvatar.dataReady()
    return unless @options.humanAvatarRenderer.ready()

    # Render palette color map.
    @paletteDataContext.setTransform 1, 0, 0, 1, 0, 0
    @paletteDataContext.clearRect 0, 0, @paletteDataCanvas.width, @paletteDataCanvas.height

    @paletteDataContext.save()

    drawOptions = (side, sideIndex) =>
      rootPart: @options.humanAvatarRenderer.options.part
      textureOffset: 100 * sideIndex
      side: side

    for side, sideIndex in @constructor.textureSides
      @options.humanAvatarRenderer.drawToContext @paletteDataContext, _.extend drawOptions(side, sideIndex),
        renderPaletteData: true

      @paletteDataContext.restore()

    @scaledPaletteDataCanvas = AS.Hqx.scale @paletteDataCanvas, 4, AS.Hqx.Modes.Default, false, @options.createCanvas

    # Render normal map.
    @normalsContext.setTransform 1, 0, 0, 1, 0, 0
    @normalsContext.clearRect 0, 0, @normalsCanvas.width, @normalsCanvas.height

    @normalsContext.save()

    for side, sideIndex in @constructor.textureSides
      @options.humanAvatarRenderer.drawToContext @normalsContext, _.extend drawOptions(side, sideIndex),
        renderNormalData: true

      @normalsContext.restore()

    normalImageData = @normalsContext.getImageData 0, 0, @normalsCanvas.width, @normalsCanvas.height
    AS.ImageDataHelpers.expandPixels normalImageData, 1
    @normalsContext.putImageData normalImageData, 0, 0

    @scaledNormalsCanvas = AS.Hqx.scale @normalsCanvas, 4, AS.Hqx.Modes.Default, true, @options.createCanvas

    # Notify that rendering has completed.
    true
