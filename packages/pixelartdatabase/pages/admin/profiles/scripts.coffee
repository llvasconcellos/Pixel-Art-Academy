AB = Artificial.Base
AM = Artificial.Mirage
PADB = PixelArtDatabase

class PADB.Pages.Admin.Profiles.Scripts extends Artificial.Mummification.Admin.Components.Document
  @id: -> 'PixelArtDatabase.Pages.Admin.Profiles.Scripts'
  @register @id()

  @refreshAll: new AB.Method name: "#{@id()}.refreshAll"
  @twitterRefreshAll: new AB.Method name: "#{@id()}.twitterRefreshAll"

  events: ->
    super(arguments...).concat
      'click .refresh-all-button': @onClickRefreshAllButton
      'click .refresh-one-hour-button': @onClickRefreshOneHourButton
      'click .twitter-refresh-all-button': @onClickTwitterRefreshAllButton
      'click .twitter-refresh-one-hour-button': @onClickTwitterRefreshOneHourButton

  onClickRefreshAllButton: (event) ->
    @constructor.refreshAll()

  onClickRefreshOneHourButton: (event) ->
    oneHourAgo = new Date Date.now() - 60 * 1000 * 1000
    @constructor.refreshAll oneHourAgo

  onClickTwitterRefreshAllButton: (event) ->
    @constructor.twitterRefreshAll()

  onClickTwitterRefreshOneHourButton: (event) ->
    oneHourAgo = new Date Date.now() - 60 * 1000 * 1000
    @constructor.twitterRefreshAll oneHourAgo
