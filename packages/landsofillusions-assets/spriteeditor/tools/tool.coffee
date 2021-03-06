AC = Artificial.Control
FM = FataMorgana
LOI = LandsOfIllusions

class LOI.Assets.SpriteEditor.Tools.Tool extends LOI.Assets.Editor.Tools.Tool
  @icon: -> "/landsofillusions/assets/spriteeditor/tools/#{_.kebabCase @displayName()}.png"
  
  onMouseMove: (event) ->
    return unless pixelCoordinate = @editor().mouse().pixelCoordinate()
    
    @mouseState.x = pixelCoordinate.x
    @mouseState.y = pixelCoordinate.y
