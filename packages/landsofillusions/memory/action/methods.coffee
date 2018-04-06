AE = Artificial.Everywhere
LOI = LandsOfIllusions

LOI.Memory.Action.do.method (type, characterId, situation, content, memoryId) ->
  check type, typePattern
  check characterId, Match.DocumentId
  check situation,
    timelineId: String
    locationId: String
    contextId: Match.Optional String
  check content, LOI.Memory.Action.contentPatterns[type] if LOI.Memory.Action.contentPatterns[type]
  check memoryId, Match.Optional Match.DocumentId

  LOI.Authorize.characterAction characterId

  action =
    type: type
    time: new Date()
    timelineId: situation.timelineId
    locationId: situation.locationId
    character:
      _id: characterId

  action.contextId = situation.contextId if situation.contextId
  action.content = content if content

  if memoryId
    # Memory must exist.
    memory = LOI.Memory.documents.findOne memoryId
    throw new AE.ArgumentException "Memory not found." unless memory

    # Within memories, we insert this as a new action.
    action.memory = _id: memoryId

    LOI.Memory.Action.documents.insert action

  else
    # Outside of memories, this replaces this character's last action.
    LOI.Memory.Action.documents.upsert
      'character._id': characterId
      memoryId: $exists: false
    ,
      action

LOI.Memory.Action.changeContent.method (memoryId, content) ->
  check memoryId, Match.DocumentId
  check content, actionContentPattern

  # Make sure the user can change this action.
  authorizeMemoryAction memoryId

  LOI.Memory.Action.documents.update
    $set: {content}

authorizeMemoryAction = (memoryId) ->
  # Action must exist.
  action = LOI.Memory.Action.documents.findOne memoryId
  throw new AE.ArgumentException "Line not found." unless action

  # Make sure the user controls the character of this line.
  LOI.Authorize.characterAction action.character._id
  
typePattern = Match.Where (value) ->
  check value, String
  
  value in _.values LOI.Memory.Action.getTypes()
