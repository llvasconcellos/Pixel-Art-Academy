LOI = LandsOfIllusions
PAA = PixelArtAcademy
C1 = PAA.Season1.Episode1.Chapter1

Vocabulary = LOI.Parser.Vocabulary

class C1.PostPixelBoy.DrawingChallenges extends LOI.Adventure.Scene
  @id: -> 'PixelArtAcademy.Season1.Episode1.Chapter1.PostPixelBoy.DrawingChallenges'

  @location: -> PAA.Practice.Challenges.Drawing

  @initialize()

  destroy: ->
    super

    @_pixelArtSoftware?.destroy()
    @_tutorialBasics?.destroy()
    @_tutorialColors?.destroy()
    @_tutorialHelpers?.destroy()

  things: ->
    things = []
    DrawingApp = PAA.PixelBoy.Apps.Drawing

    # If the player has an editor or external software selected, we show the Pixel Art Tools challenge.
    if DrawingApp.state('editorId') or DrawingApp.state('externalSoftware')
      @_pixelArtSoftware ?= new C1.Challenges.Drawing.PixelArtSoftware
      things.push @_pixelArtSoftware

    # Player needs the Desktop editor selected for the tutorial to display.
    if DrawingApp.state('editorId') is PAA.PixelBoy.Apps.Drawing.Editor.Desktop.id()
      @_tutorialBasics ?= new C1.Challenges.Drawing.Tutorial.Basics
      things.push @_tutorialBasics

      if @_tutorialBasics.completed()
        @_tutorialColors ?= new C1.Challenges.Drawing.Tutorial.Colors
        @_tutorialHelpers ?= new C1.Challenges.Drawing.Tutorial.Helpers

        things.push @_tutorialColors, @_tutorialHelpers

    things
