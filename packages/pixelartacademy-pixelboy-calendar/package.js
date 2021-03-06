Package.describe({
  name: 'retronator:pixelartacademy-pixelboy-calendar',
  version: '0.1.0',
  // Brief, one-line summary of the package.
  summary: '',
  // URL to the Git repository containing the source code for this package.
  git: '',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.use('retronator:landsofillusions');
  api.use('retronator:pixelartacademy-pixelboy');
  api.use('retronator:pixelartacademy-practice');

  api.export('PixelArtAcademy');

  api.addComponent('calendar');

  api.addComponent('monthview..');
  api.addComponent('monthview/activities/journalentries..');
  api.addComponent('monthview/activities/tasks..');

  api.addComponent('goalsettings..');
});
