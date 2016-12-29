AT = Artificial.Telepathy

class Retronator.Accounts
  constructor: ->
    Retronator.Accounts.addAdminPage '/admin/accounts', 'Retronator.Accounts.Pages.Admin'
    Retronator.Accounts.addAdminPage '/admin/accounts/import-users', 'Retronator.Accounts.Pages.Admin.ImportUsers'
    Retronator.Accounts.addAdminPage '/admin/accounts/scripts', 'Retronator.Accounts.Pages.Admin.Scripts'

  # Routing helpers for default layouts

  @addPublicPage: (url, page) ->
    AT.addRoute page, url, 'Retronator.Accounts.Layouts.PublicAccess', page

  @addUserPage: (url, page) ->
    AT.addRoute page, url, 'Retronator.Accounts.Layouts.UserAccess', page

  @addAdminPage: (url, page) ->
    AT.addRoute page, url, 'Retronator.Accounts.Layouts.AdminAccess', page

  @authorizeAdmin: ->
    user = Retronator.user()

    return if user.hasItem Retronator.Store.Items.CatalogKeys.Retronator.Admin
  
    throw new AE.UnauthorizedException "You do not have administrator privileges to perform this action."
