AC = Artificial.Control
FM = FataMorgana
LOI = LandsOfIllusions

class LOI.Assets.SpriteEditor.Tools.ColorFill extends LOI.Assets.SpriteEditor.Tools.Pencil
  @id: -> 'LandsOfIllusions.Assets.SpriteEditor.Tools.ColorFill'
  @displayName: -> "Color fill"

  @initialize()

  _callMethod: (spriteId, layer, pixel) ->
    # Make sure we're filling inside of bounds.
    editor = @interface.getEditorForActiveFile()
    spriteData = editor.spriteData()
    
    return unless spriteData.bounds.left <= pixel.x <= spriteData.bounds.right and spriteData.bounds.top <= pixel.y <= spriteData.bounds.bottom

    LOI.Assets.Sprite.colorFill spriteId, layer, pixel
