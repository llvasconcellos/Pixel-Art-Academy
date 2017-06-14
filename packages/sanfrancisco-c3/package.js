Package.describe({
  name: 'retronator:sanfrancisco-c3',
  version: '0.0.1',
  // Brief, one-line summary of the package.
  summary: '',
  // URL to the Git repository containing the source code for this package.
  git: '',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.use('retronator:sanfrancisco');
  api.use('retronator:landsofillusions');
  api.use('retronator:landsofillusions-assets');

  api.export('SanFrancisco');

  api.addFile('c3');

  // Actors

  api.addFile('actors/actors');
  api.addFile('actors/receptionist');
  api.addFile('actors/drshelley');

  // Locations

  api.addFile('behavior/behavior');

  api.addThing('design/design');
  api.addComponent('design/terminal/terminal');
  api.addComponent('design/terminal/screens/mainmenu/mainmenu');
  api.addComponent('design/terminal/screens/character/character');
  api.addComponent('design/terminal/screens/avatarpart/avatarpart');

  api.addFile('design/terminal/components/properties/properties');
  api.addComponent('design/terminal/components/properties/oneof/oneof');
  api.addComponent('design/terminal/components/properties/array/array');
  api.addComponent('design/terminal/components/properties/color/color');
  api.addComponent('design/terminal/components/properties/sprite/sprite');

  api.addFile('hallway/hallway');
  api.addThing('lobby/lobby');
  api.addFile('stasis/stasis');

});
