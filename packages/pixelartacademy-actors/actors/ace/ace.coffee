LOI = LandsOfIllusions
PAA = PixelArtAcademy

class PAA.Actors.Ace extends LOI.Character.Actor
  @id: -> 'PixelArtAcademy.Actors.Ace'
  @fullName: -> "Ace"
  @description: -> "It's Ace, a towering, but charming guy."
  @pronouns: -> LOI.Avatar.Pronouns.Masculine
  @color: ->
    hue: LOI.Assets.Palette.Atari2600.hues.yellow
    shade: LOI.Assets.Palette.Atari2600.characterShades.normal

  @assetUrls: -> '/pixelartacademy/actors/ace'

  @initialize()

  constructor: ->
    super arguments...

    @require PAA.Student
