Package.describe({
  name: 'retronator:artificialengines-pages',
  version: '1.0.0'
});

Npm.depends({
  'archiver': '3.0.0'
});

Package.onUse(function(api) {
  api.use('retronator:artificialengines');
  api.use('retronator:retronator');
  api.use('retronator:retronator-accounts');

  api.use('jparker:crypto-aes');

  api.use('webapp');

  api.export('Artificial');

  api.addFile('pages');

  api.addFile('babel/pages');
  api.addUnstyledComponent('babel/admin..');
  api.addUnstyledComponent('babel/admin/scripts..');
  api.addServerFile('babel/admin/scripts/methods-server/generatebesttranslations');

  api.addFile('mummification/pages');
  api.addUnstyledComponent('mummification/admin..');
  api.addUnstyledComponent('mummification/admin/databasecontent..');
  api.addServerFile('mummification/admin/databasecontent/server');
});
