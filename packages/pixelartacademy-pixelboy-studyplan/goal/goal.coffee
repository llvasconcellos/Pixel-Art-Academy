AB = Artificial.Babel
AM = Artificial.Mirage
LOI = LandsOfIllusions
PAA = PixelArtAcademy

class PAA.PixelBoy.Apps.StudyPlan.Goal extends AM.Component
  @id: -> 'PixelArtAcademy.PixelBoy.Apps.StudyPlan.Goal'
  @register @id()

  constructor: (goalOrOptions) ->
    if goalOrOptions instanceof PAA.Learning.Goal
      @goal = goalOrOptions

    else
      {@goal, @state, @canvas} = goalOrOptions

      @position = @state.field 'position',
        equalityFunction: EJSON.equals
        lazyUpdates: true

  goalStyle: ->
    return unless @state and @canvas

    # Make sure we have position present, as it will disappear when goal is being deleted.
    return unless position = @position()

    scale = @canvas.camera().scale()

    position: 'absolute'
    transform: "translate3d(#{position.x * scale}rem, #{position.y * scale}rem, 0)"

  events: ->
    super.concat
      'mousedown .pixelartacademy-pixelboy-apps-studyplan-goal': @onMouseDownGoal

  onMouseDownGoal: (event) ->
    # We only deal with drag & drop for goals inside the canvas.
    return unless @canvas
    
    # Prevent browser select/dragging behavior
    event.preventDefault()
    
    @canvas.startDrag
      goalId: @goal.id()
      goalPosition: @position()
