AB = Artificial.Babel
AE = Artificial.Everywhere
AM = Artificial.Mirage
LOI = LandsOfIllusions
PAA = PixelArtAcademy

class PAA.PixelBoy.Apps.Calendar.MonthView.JournalEntries extends AM.Component
  @id: -> 'PixelArtAcademy.PixelBoy.Apps.Calendar.MonthView.JournalEntries'
  @version: -> '0.1.0'

  @register @id()
  template: -> @constructor.id()

  multipleClass: ->
    journalEntries = @data()

    'multiple' if journalEntries.length > 1
