AE = Artificial.Everywhere
LOI = LandsOfIllusions

LOI.GameState._insertForCurrentUser.method (state) ->
  check state, Object

  user = Retronator.user()
  throw new AE.UnauthorizedException "You must be logged in to insert game state." unless user

  existingGameState = LOI.GameState.documents.findOne 'user._id': user._id
  throw new AE.InvalidOperationException "This user already has a game state. Update it instead." if existingGameState
  
  # Insert the state.
  LOI.GameState.documents.insert
    user:
      _id: user._id
    state: state
    stateLastUpdatedAt: new Date()
    readOnlyState: {}
    events: []

LOI.GameState._clearForCurrentUser.method ->
  user = Retronator.user()
  throw new AE.UnauthorizedException "You must be logged in to update game state." unless user

  gameState = LOI.GameState.documents.findOne 'user._id': user._id
  throw new AE.ArgumentException "User does not have a game state." unless gameState

  # Everything seems OK, set an empty state.
  LOI.GameState.documents.update gameState._id,
    $set:
      state: {}
      stateLastUpdatedAt: new Date()
      readOnlyState: {}
      events: []

LOI.GameState._replaceForCurrentUser.method (state) ->
  check state, Object

  user = Retronator.user()
  throw new AE.UnauthorizedException "You must be logged in to update game state." unless user

  gameState = LOI.GameState.documents.findOne 'user._id': user._id
  throw new AE.ArgumentException "User does not have a game state." unless gameState

  # Everything seems OK, replace the state. This is considered the same as starting over (inserting)
  # from the perspective of the server which starts with an empty read-only state again.
  LOI.GameState.documents.update gameState._id,
    $set:
      state: state
      stateLastUpdatedAt: new Date()
      readOnlyState: {}
      events: []

LOI.GameState._insertForCharacter.method (characterId) ->
  check characterId, Match.DocumentId

  LOI.Authorize.player()
  LOI.Authorize.characterAction characterId

  existingGameState = LOI.GameState.documents.findOne 'character._id': characterId
  throw new AE.InvalidOperationException "This character already has a game state. Update it instead." if existingGameState

  # Insert an empty state (it shouldn't be null because other systems would think the state hasn't loaded.
  LOI.GameState.documents.insert
    character:
      _id: characterId
    state:
      gameTime: 0
    stateLastUpdatedAt: new Date()
    readOnlyState:
      simulatedGameTime: 0
    events: []

LOI.GameState._clearForCharacter.method (characterId) ->
  check characterId, Match.DocumentId

  LOI.Authorize.player()
  LOI.Authorize.characterAction characterId

  gameState = LOI.GameState.documents.findOne 'character._id': characterId
  throw new AE.ArgumentException "Character does not have a game state." unless gameState

  # Everything seems OK, set an empty state.
  LOI.GameState.documents.update gameState._id,
    $set:
      state: {}
      stateLastUpdatedAt: new Date()
      readOnlyState: {}
      events: []

LOI.GameState._replaceForCharacter.method (characterId, state) ->
  check characterId, Match.DocumentId
  check state, Object

  LOI.Authorize.player()
  LOI.Authorize.characterAction characterId

  gameState = LOI.GameState.documents.findOne 'character._id': characterId
  throw new AE.ArgumentException "Character does not have a game state." unless gameState

  # Everything seems OK, replace the state.
  LOI.GameState.documents.update gameState._id,
    $set:
      state: state
      stateLastUpdatedAt: new Date()
      readOnlyState: {}
      events: []

LOI.GameState._update.method (gameStateId, state) ->
  check gameStateId, Match.DocumentId
  check state, Object

  console.log "Updating game state in the database.", gameStateId if LOI.debug or LOI.Adventure.debugState

  user = Retronator.user()

  # On the client, the user might have just logged out so this is fine. On the server it's an error.
  return if Meteor.isClient and not user
  throw new AE.UnauthorizedException "You must be logged in to update game state." unless user

  gameState = LOI.GameState.documents.findOne gameStateId

  # On the client it's OK if the game state is not present anymore. It means this is a delayed update and the
  # subscription to the game state document has already been released (to switch to another state).
  return if Meteor.isClient and not gameState
  throw new AE.ArgumentNullException "Provided game state does not exist." unless gameState

  # See if this is a user or character state.
  gameStateUser = gameState.user

  if gameState.character
    character = LOI.Character.documents.findOne gameState.character._id
    gameStateUser = character.user

  throw new AE.UnauthorizedException "This game state does not belong to you." unless gameStateUser._id is user._id

  # Everything seems OK, write the state.
  LOI.GameState.documents.update gameStateId,
    $set:
      state: state
      # We manually update this field (instead of let's say with
      # triggers), so that it atomically updates with the state.
      stateLastUpdatedAt: new Date()

LOI.GameState._resetNamespaces.method (gameStateId, namespaces) ->
  check gameStateId, Match.DocumentId
  check namespaces, [String]

  console.log "Resetting namespaces", namespaces, "in state", gameStateId if LOI.debug or LOI.Adventure.debugState

  user = Retronator.user()
  throw new AE.UnauthorizedException "You must be logged in to reset game state." unless user

  gameState = LOI.GameState.documents.findOne gameStateId
  throw new AE.ArgumentNullException "Provided game state does not exist." unless gameState

  # See if this is a user or character state.
  gameStateUser = gameState.user

  if gameState.character
    character = LOI.Character.documents.findOne gameState.character._id
    gameStateUser = character.user

  throw new AE.UnauthorizedException "This game state does not belong to you." unless gameStateUser._id is user._id

  # Delete everything in the namespace of things and scripts in the state and read-only state.
  for namespace in namespaces
    _.nestedProperty gameState.state.things, namespace, {}
    _.nestedProperty gameState.state.scripts, namespace, {}
    _.nestedProperty gameState.readOnlyState.things, namespace, {}

  # On the client also prepare the state for database since it's been transformed on retrieval.
  if Meteor.isClient
    gameState[field] = LOI.GameState._prepareStateForDatabase gameState[field] for field in ['state', 'readOnlyState']

  # Everything seems OK, update the states.
  LOI.GameState.documents.update gameStateId,
    $set:
      state: gameState.state
      readOnlyState: gameState.readOnlyState
      # We manually update this field (instead of let's say with
      # triggers), so that it atomically updates with the state.
      stateLastUpdatedAt: new Date()
