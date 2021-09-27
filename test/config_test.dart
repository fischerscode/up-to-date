import 'package:test/test.dart';
import 'package:uptodate/config.dart';
import 'package:uptodate/dependencies/dependency.dart';
import 'package:version/version.dart';

main() {
  group('Test Config', () {
    var configString = '''
dependencies:
  - name: webdependency
    type: webjson
    currentVersion: 1.2.3
    url: 'http://example.com'
  - name: webjsondependency
    type: webjson
    path: args.version
    currentVersion: v1.2.3
    prefix: v
    url: 'https://postman-echo.com/get?version=v1.2.4'
  - name: gitdependency
    type: git
    repo: fischerscode/UpToDate
    currentVersion: v1.2.3
    prefix: v
''';
    var config = Config.string(configString);
    test('Test web', () {
      expect(config.dependencies[0], TypeMatcher<WebDependency>());
      var dependency = config.dependencies[0] as WebDependency;
      expect(dependency.name, 'webdependency');
      expect(dependency.currentVersion, Version(1, 2, 3));
      expect(dependency.url.toString(), 'http://example.com');
    });
    test('Test webjson', () {
      expect(config.dependencies[1], TypeMatcher<WebJsonDependency>());
      var dependency = config.dependencies[1] as WebJsonDependency;
      expect(dependency.name, 'webjsondependency');
      expect(dependency.currentVersion, Version(1, 2, 3));
      expect(dependency.url.toString(),
          'https://postman-echo.com/get?version=v1.2.4');
      expect(dependency.prefix, 'v');
      expect(dependency.path, 'args.version');
    });
    test('Test git', () {
      expect(config.dependencies[2], TypeMatcher<GitDependency>());
      var dependency = config.dependencies[2] as GitDependency;
      expect(dependency.name, 'gitdependency');
      expect(dependency.currentVersion, Version(1, 2, 3));
      expect(dependency.repo, 'fischerscode/UpToDate');
      expect(dependency.url.toString(),
          'https://api.github.com/repos/fischerscode/UpToDate/releases/latest');
      expect(dependency.prefix, 'v');
      expect(dependency.path, 'tag_name');
    });
  });
}
