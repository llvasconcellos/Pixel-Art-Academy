AB = Artificial.Base
AM = Artificial.Mirage
LOI = LandsOfIllusions
PAA = PixelArtAcademy

Yearbook = PAA.PixelBoy.Apps.Yearbook

class Yearbook.ProfileForm extends AM.Component
  @id: -> 'PixelArtAcademy.PixelBoy.Apps.Yearbook.ProfileForm'
  @register @id()

  constructor: (@yearbook) ->
    super
    
    @pages = [
      new @constructor.General @
      new @constructor.Favorites @
    ]

  onCreated: ->
    super
    
    @currentPageNumber = new ReactiveField 1
    
    @currentPage = new ComputedField =>
      @pages[@currentPageNumber() - 1]
    
  positionClass: ->
    return unless playerCharacterPage = @yearbook.playerCharacterPage()

    # Place the form on the opposite page of where the player is.
    if playerCharacterPage % 2 then 'right' else 'left'

  previousPageVisibleClass: ->
    'visible' if @currentPageNumber() > 1

  nextPageVisibleClass: ->
    'visible' if @currentPageNumber() < @pages.length

  events: ->
    super.concat
      'click .previous.page-button': @onClickPreviousPageButton
      'click .next.page-button': @onClickNextPageButton

  onClickPreviousPageButton: (event) ->
    @currentPageNumber Math.max 1, @currentPageNumber() - 1

  onClickNextPageButton: (event) ->
    @currentPageNumber Math.min @pages.length, @currentPageNumber() + 1