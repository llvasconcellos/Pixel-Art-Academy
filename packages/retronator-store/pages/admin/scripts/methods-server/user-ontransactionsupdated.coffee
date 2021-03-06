RA = Retronator.Accounts
RS = Retronator.Store

Meteor.methods
  # For all users, call onTransactionsUpdated.
  'Retronator.Store.Pages.Admin.Scripts.UserOnTransactionsUpdated': ->
    RA.authorizeAdmin()

    count = 0

    console.log "Processing transactions for all users."

    RA.User.documents.find().forEach (user) ->
      user.onTransactionsUpdated()
      count++

    console.log "#{count} users were processed."
