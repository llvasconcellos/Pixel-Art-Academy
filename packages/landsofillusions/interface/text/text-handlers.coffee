AE = Artificial.Everywhere
AM = Artificial.Mirage
LOI = LandsOfIllusions

class LOI.Interface.Text extends LOI.Interface.Text
  initializeHandlers: ->
    # Listen for command input changes.
    @autorun (computation) =>
      @commandInput.command()
      @onCommandInputChanged()

    # Pause dialog selection when we're waiting for a key press ourselves.
    @autorun (computation) =>
      @dialogSelection.paused @waitingKeypress()

  onLocationChanged: ->
    location = @location()

    # Wait for narrative to be created and location to load.
    Tracker.autorun (computation) =>
      return unless @isCreated()
      return unless location.ready()
      computation.stop()

      # If we've been here before, just start with a fresh narrative. This is the persistent visited, not the
      # per-session one, since we want to do the intro only when it's really the first time to see the location.
      if location.stateObject 'visited'
        @narrative.clear()

      else
        # We haven't been here yet, so completely reset the interface into intro mode.
        @resetInterface()

      # We have cleared the interface so it can now start processing any scripts.
      @interfaceReady true

      # Wait one frame so that any script nodes are processed. Then we can
      # see if the interface is empty, or it is already paused on something.
      Meteor.setTimeout =>
        @narrative.addText "What do you want to do?", scroll: false unless @_pausedNode()
  
        # All the texts have been loaded from the DB at this point.
        # Wait for all the reactivity to finish reflowing the page.
        Meteor.setTimeout =>
          @resize()

          # Set scroll position to reveal the top or the bottom of the UI.
          scrollPosition = if location.constructor.visited() then @maxScrollTop() else 0
          @scroll position: scrollPosition
        ,
          0
      ,
        0



  onCommandInputEnter: ->
    # Stop intro on enter.
    if @inIntro()
      @stopIntro()
      return

    # After intro is stopped, enter resumes dialogs.
    if pausedLineNode = @_pausedNode()
      # Clear the paused node and handle it.
      @_pausedNode null
      @_handleNode pausedLineNode

      # Clear the command input in case it accumulated any text in the mean time.
      @commandInput.clear()
      return

    # At this point, enter confirms the command that has been entered.
    @_executeCommand @hoveredCommand() or @commandInput.command().trim()

    # Scroll to bottom on enter.
    @narrative.scroll()

  _executeCommand: (command) ->
    return unless command.length

    @narrative.addText "> #{command.toUpperCase()}"
    LOI.adventure.parser.parse command
    @commandInput.clear()

  onCommandInputChanged: ->
    # Scroll to bottom to reveal new command.
    @narrative.scroll()
    
  onDialogSelectionEnter: ->
    # Continue with the selection.
    @_dialogSelectionConfirm()

  _dialogSelectionConfirm: ->
    @dialogSelection.confirm()