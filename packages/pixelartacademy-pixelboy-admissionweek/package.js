Package.describe({
  name: 'retronator:pixelartacademy-pixelboy-admissionweek',
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

  api.export('PixelArtAcademy');

  api.addComponent('admissionweek');

  api.addComponent('instructions..');
  api.addComponent('dayview..');

});
