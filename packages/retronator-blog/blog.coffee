AM = Artificial.Mirage
AB = Artificial.Base

class Retronator.Blog
  @id: -> 'Retronator.Blog'
  @getData: new AB.Method name: "#{@id()}.getData"
  @refreshData: new AB.Method name: "#{@id()}.refreshData"

  constructor: ->
    Retronator.App.addAdminPage '/admin/blog', @constructor.Pages.Admin
    Retronator.App.addAdminPage '/admin/blog/scripts', @constructor.Pages.Admin.Scripts
