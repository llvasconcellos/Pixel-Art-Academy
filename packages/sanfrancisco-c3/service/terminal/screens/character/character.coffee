AM = Artificial.Mirage
LOI = LandsOfIllusions
C3 = SanFrancisco.C3

class C3.Service.Terminal.Character extends AM.Component
  @register 'SanFrancisco.C3.Service.Terminal.Character'

  constructor: (@terminal) ->
    super arguments...
    
    @characterId = new ReactiveField null
    
    @character = new ComputedField =>
      LOI.Character.getInstance @characterId()

  onCreated: ->
    super arguments...
    
    @fullNameInput = new LOI.Components.Account.Characters.CharacterNameTranslationInput characterId: @characterId

    @_initialPreviewViewingAngle = -Math.PI / 4
    @previewViewingAngle = new ReactiveField @_initialPreviewViewingAngle

  setCharacterId: (characterId) ->
    @characterId characterId

  renderFullNameInput: ->
    @fullNameInput.renderComponent @currentComponent()

  dialogPreviewStyle: ->
    # Set the color to character's color.
    character = @currentData()

    color: "##{character.avatar.colorObject()?.getHexString()}"

  backButtonCallback: ->
    # We return to main menu.
    @_returnToMenu()

    # Instruct the back button to cancel closing (so it doesn't disappear).
    cancel: true

  traits: ->
    @character()?.behavior.part.properties.personality.part.traitsString() or "None"

  activities: ->
    @character()?.behavior.part.properties.activities.toString() or "None"

  environment: ->
    @character()?.behavior.part.properties.environment.part

  perks: ->
    @character()?.behavior.part.properties.perks.toString() or "None"

  avatarPreviewOptions: ->
    rotatable: true
    viewingAngle: @previewViewingAngle
    originOffset:
      x: -3
      y: 8

  events: ->
    super(arguments...).concat
      'click .done-button': @onClickDoneButton
      'click .delete-button': @onClickDeleteButton

  onClickDoneButton: (event) ->
    @_returnToMenu()

  onClickDeleteButton: (event) ->
    character = @currentData()
    activated = character.document().activated

    if activated
      message = "Do you really want to retire this agent? You will lose control of them and you cannot undo this action."

    else
      message = "Do you really want to delete this agent design? You cannot undo this action."

    # Double check that the user wants to be removed from their character.
    @terminal.showDialog
      message: message
      confirmButtonText: if activated then "Retire" else "Delete"
      confirmButtonClass: "danger-button"
      cancelButtonText: "Cancel"
      confirmAction: =>
        # Remove the user from the character.
        LOI.Character.removeUser character._id, (error) =>
          if error
            console.error error
            return

          # Return to main menu.
          @_returnToMenu()

  _returnToMenu: ->
    @terminal.switchToScreen @terminal.screens.mainMenu
