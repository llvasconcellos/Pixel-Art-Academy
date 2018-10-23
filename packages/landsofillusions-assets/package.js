Package.describe({
  name: 'retronator:landsofillusions-assets',
  version: '0.0.1',
  // Brief, one-line summary of the package.
  summary: '',
  // URL to the Git repository containing the source code for this package.
  git: '',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: 'README.md'
});

Npm.depends({
  'pngjs': '2.3.0',
  'bresenham-zingl': '0.1.1'
});

Package.onUse(function(api) {
  api.use('retronator:landsofillusions');
  api.use('edgee:slingshot');
  api.use('froatsnook:request');

  api.use('webapp');
  api.use('http');

  api.export('LandsOfIllusions');

  api.addFile('assets');

  api.addStyle('style/editor');
  api.addComponent('layout/layout');

  // Documents
  
  api.addFile('documents/image..');
  api.addFile('documents/image/methods');

  api.addFile('documents/palette..');
  api.addFile('documents/palette/methods');
  api.addFile('documents/palette/atari2600');
  api.addServerFile('documents/palette/subscriptions');

  api.addServerFile('documents/palette/palettes-server/atari2600');
  api.addServerFile('documents/palette/palettes-server/pico8');
  api.addServerFile('documents/palette/palettes-server/black');
  api.addServerFile('documents/palette/palettes-server/zxspectrum');

  api.addClientFile('documents/asset/asset-cache-client');
  api.addServerFile('documents/asset/asset-cache-server');
  api.addFile('documents/asset..');
  api.addFile('documents/asset/methods..');
  api.addFile('documents/asset/methods/history');
  api.addServerFile('documents/asset/subscriptions');

  api.addFile('documents/visualasset..');
  api.addFile('documents/visualasset/methods..');
  api.addFile('documents/visualasset/methods/references');

  api.addFile('documents/sprite..');
  api.addServerFile('documents/sprite/subscriptions');
  api.addServerFile('documents/sprite/server');
  api.addFile('documents/sprite/methods..');
  api.addFile('documents/sprite/methods/addpixel');
  api.addFile('documents/sprite/methods/removepixel');
  api.addFile('documents/sprite/methods/colorfill');
  api.addFile('documents/sprite/methods/replacepixels');

  api.addFile('documents/mesh..');

  api.addFile('documents/audio..');
  api.addFile('documents/audio/methods/addnode');
  api.addFile('documents/audio/methods/removenode');
  api.addFile('documents/audio/methods/updatenode');
  api.addFile('documents/audio/methods/updateconnections');

  // Upload

  api.addFile('upload..');
  api.addFile('upload/context..');
  api.addServerFile('upload/context/server');
  api.addClientFile('upload/context/client');
  
  // Tools

  api.addFile('tools/tools');
  api.addFile('tools/tool');

  // Components

  api.addFile('components/components');

  api.addUnstyledComponent('components/assetslist..');
  api.addUnstyledComponent('components/assetinfo..');
  api.addUnstyledComponent('components/navigator..');
  api.addUnstyledComponent('components/palette..');
  api.addUnstyledComponent('components/materials..');
  api.addUnstyledComponent('components/landmarks..');
  api.addUnstyledComponent('components/toolbox..');
  api.addUnstyledComponent('components/spriteimage..');

  api.addUnstyledComponent('components/references..');
  api.addUnstyledComponent('components/references/reference..');

  api.addUnstyledComponent('components/shadingsphere..');
  api.addFile('components/shadingsphere/normalpicker');

  api.addUnstyledComponent('components/pixelcanvas..');
  api.addFile('components/pixelcanvas/mouse');
  api.addFile('components/pixelcanvas/grid');
  api.addFile('components/pixelcanvas/cursor');
  api.addFile('components/pixelcanvas/camera');

  // Engine

  api.addFile('engine..');
  api.addFile('engine/sprite');

  api.addFile('engine/audio..');
  api.addFile('engine/audio/node');
  api.addFile('engine/audio/nodes/sound');
  api.addFile('engine/audio/nodes/output');

  // Sprite editor

  api.addComponent('spriteeditor/spriteeditor');
  api.addFile('spriteeditor/tools/tools');
  api.addFile('spriteeditor/tools/pencil');
  api.addFile('spriteeditor/tools/eraser');
  api.addFile('spriteeditor/tools/colorpicker');
  api.addFile('spriteeditor/tools/colorfill');
  api.addFile('spriteeditor/tools/paintnormals');
  api.addFile('spriteeditor/tools/symmetry');
  api.addFile('spriteeditor/tools/undo');
  api.addFile('spriteeditor/tools/redo');

  // Audio editor

  api.addComponent('audioeditor..');

  api.addComponent('audioeditor/audiocanvas..');
  api.addFile('audioeditor/audiocanvas/camera');
  api.addFile('audioeditor/audiocanvas/flowchart');
  api.addFile('audioeditor/audiocanvas/grid');
  api.addFile('audioeditor/audiocanvas/mouse');

  api.addComponent('audioeditor/node..');
  api.addComponent('audioeditor/nodelibrary..');

  api.addFile('audioeditor/tools..');
  api.addFile('audioeditor/tools/undo');
  api.addFile('audioeditor/tools/redo');
});
