AM = Artificial.Mummification
LOI = LandsOfIllusions

class LOI.StateField
  constructor: (options) ->
    # We want to create an internal computed field that we'll depend upon to isolate reactivity.
    field = new ComputedField =>
      value = _.nestedProperty LOI.adventure.gameState(), options.address.string()

      # If we didn't find the value, see if we have a default value set.
      value ?= options.default

      # Return the final value.
      value
    ,
      true

    # We want the state field to behave as a getter/setter.
    stateField = (value) ->
      # Is this a setter?
      if value?
        # Do we even need to do any change?
        oldValue = field()

        unless value is oldValue
          # We directly change the value of the field and trigger state update.
          _.nestedProperty LOI.adventure.gameState(), options.address.string(), value
          LOI.adventure.gameState.updated()

        return

      # No, this is a getter, so just return the value from the computed field.
      field()

    # Allow correct handling of instanceof operator.
    Object.setPrototypeOf stateField, @constructor.prototype

    # Return the state getter function (return must be explicit).
    return stateField