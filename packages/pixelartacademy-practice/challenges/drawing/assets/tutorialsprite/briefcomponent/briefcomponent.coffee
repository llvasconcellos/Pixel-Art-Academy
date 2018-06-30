AM = Artificial.Mirage
PAA = PixelArtAcademy
LOI = LandsOfIllusions

class PAA.Practice.Challenges.Drawing.TutorialSprite.BriefComponent extends AM.Component
  @register 'PixelArtAcademy.Practice.Challenges.Drawing.TutorialSprite.BriefComponent'

  constructor: (@sprite) ->
    super
    
  onCreated: ->
    super
    
    @parent = @ancestorComponentWith 'editAsset'

  events: ->
    super.concat
      'click .start-button': @onClickStartButton
      'click .reset-button': @onClickResetButton

  onClickStartButton: (event) ->
    @parent.editAsset()

  onClickResetButton: (event) ->
    PAA.Practice.Challenges.Drawing.TutorialSprite.reset @sprite.id(), @sprite.spriteId()