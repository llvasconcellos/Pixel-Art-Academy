AC = Artificial.Control
AM = Artificial.Mummification
LOI = LandsOfIllusions

class LOI.Interface.Components.CommandInput
  constructor: (@options) ->
    @command = new ReactiveField ""

    # How long is the string before the caret position.
    @caretPosition = new ReactiveField 0

    @storedCommandHistory = new ReactiveField []
    @persistHistoryAutorun = AM.PersistentStorage.persist
      storageKey: 'LandsOfIllusions.Interface.Components.CommandInput.commandHistory'
      field: @storedCommandHistory

    # Start with the stored history, but at a new index.
    @commandHistory = @storedCommandHistory()
    @commandHistoryIndex = @commandHistory.length
    @confirmedHistoryLength = @commandHistory.length

    @updateHistoryAutorun = Tracker.autorun (computation) =>
      # React to command changes.
      command = @command()

      # Only ever update the command after confirmed commands.
      return if @commandHistoryIndex < @confirmedHistoryLength

      @commandHistory[@commandHistoryIndex] = command

    # Capture key events.
    $(document).on 'keypress.commandInput', (event) =>
      @onKeyPress event

    $(document).on 'keydown.commandInput', (event) =>
      @onKeyDown event

    console.log "Command input constructed." if LOI.debug

    @idle = new ReactiveField true

    @_resumeIdle = _.debounce =>
      @idle true
    ,
      1000

  destroy: ->
    console.log "Command input destroyed." if LOI.debug

    # Remove key events.
    $(document).off('.commandInput')

    @updateHistoryAutorun.stop()
    @persistHistoryAutorun.stop()

  commandBeforeCaret: ->
    @command().substring 0, @caretPosition()

  commandAfterCaret: ->
    @command().substring @caretPosition()

  clear: ->
    @command ""
    @caretPosition 0

  confirm: ->
    # Make sure the command to be stored into history matches what is in the command.
    @commandHistoryIndex = @confirmedHistoryLength
    @commandHistory[@commandHistoryIndex] = @command()

    # Update store history.
    @confirmedHistoryLength++
    confirmedHistory = @commandHistory[...@confirmedHistoryLength]

    # Store only the last 10 commands.
    @storedCommandHistory confirmedHistory[-10..]

    # Start new history entry.
    @commandHistoryIndex++
    @clear()

  _notIdle: ->
    @idle false
    @_resumeIdle()

  onKeyPress: (event) ->
    # Don't capture events when interface is not active (some other dialog
    # is blocking it) or when the interface itself is doing something else.
    busyConditions = [
      not @options.interface.active()
      @options.interface.waitingKeypress()
      @options.interface.showDialogueSelection()
    ]

    return if _.some busyConditions

    # Ignore control characters.
    charCode = event.which
    return if charCode <= AC.Keys.lastControlCharacter

    character = String.fromCharCode charCode

    newCommand = "#{@commandBeforeCaret()}#{character}#{@commandAfterCaret()}"

    @_updateCommand newCommand
    @caretPosition @caretPosition() + 1

    # Don't let space scroll.
    return false if event.which is AC.Keys.space

  _updateCommand: (newCommand) ->
    # Always update the new command.
    @commandHistoryIndex = @confirmedHistoryLength
    @command newCommand

    @_notIdle()

  onKeyDown: (event) ->
    interfaceActive = @options.interface.active()

    console.log "Command input detected a key down and is checking if interface is active:", interfaceActive if LOI.debug

    # Don't capture events when interface is not active.
    return unless interfaceActive

    keyCode = event.which

    switch keyCode
      when AC.Keys.backspace
        event.preventDefault()

        commandBeforeCaret = @commandBeforeCaret()
        return unless commandBeforeCaret.length

        newCommand = "#{commandBeforeCaret.substring 0, commandBeforeCaret.length - 1}#{@commandAfterCaret()}"

        @_updateCommand newCommand
        @caretPosition @caretPosition() - 1

      when AC.Keys.enter
        @options?.onEnter?()

      when AC.Keys.left
        @caretPosition Math.max 0, @caretPosition() - 1
        @_notIdle()

      when AC.Keys.right
        @caretPosition Math.min @command().length, @caretPosition() + 1
        @_notIdle()

      when AC.Keys.up
        @_changeHistoryIndex Math.max 0, @commandHistoryIndex - 1

      when AC.Keys.down
        # Don't allow to go further down than an empty string.
        @_changeHistoryIndex @commandHistoryIndex + 1 if @command().length

    # Trigger event for any key down.
    @options?.onKeyDown?()

  _changeHistoryIndex: (newIndex) ->
    return if @commandHistoryIndex is newIndex

    @commandHistoryIndex = newIndex
    newCommand = @commandHistory[@commandHistoryIndex] or ""

    @command newCommand
    @caretPosition newCommand.length

    @_notIdle()
