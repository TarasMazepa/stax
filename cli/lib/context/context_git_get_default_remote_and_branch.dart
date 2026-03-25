import 'package:stax/context/context.dart';

typedef RemoteInfo = ({String remote, String branch});

extension ContextGitGetDefaultRemoteAndBranch on Context {
  static RemoteInfo? _cache;

  RemoteInfo? getDefaultRemoteAndBranch() {
    if (_cache != null) return _cache;

    final forEachRefOut =
        quietly().git.forEachRef
            .args([
              '--format=%(refname:short) %(symref:short)',
              'refs/remotes/*/HEAD',
            ])
            .runSyncCatching()
            ?.stdout
            .toString()
            .trim() ??
        '';

    final currentTrackingBranchOut =
        quietly().git.revParseAbbrevRef
            .args(['--symbolic-full-name', '@{u}'])
            .runSyncCatching()
            ?.stdout
            .toString()
            .trim() ??
        '';

    final availableRemotes = <String, String>{};

    if (forEachRefOut.isNotEmpty) {
      final lines = forEachRefOut.split('\n');
      for (final line in lines) {
        final parts = line.split(' ');
        if (parts.length == 2 && parts[1].isNotEmpty) {
          final remoteName = parts[0].split('/').first;
          final branchName = parts[1].replaceFirst('$remoteName/', '');
          availableRemotes[remoteName] = branchName;
        }
      }
    }

    String? trackingRemote;
    if (currentTrackingBranchOut.isNotEmpty) {
      trackingRemote = currentTrackingBranchOut.split('/').first;
    }

    final override = effectiveSettings.defaultRemote.value;

    final pushDefault = quietly().git.configGet
        .arg('remote.pushDefault')
        .runSyncCatching()
        ?.stdout
        .toString()
        .trim();

    final checkoutDefault = quietly().git.configGet
        .arg('checkout.defaultRemote')
        .runSyncCatching()
        ?.stdout
        .toString()
        .trim();

    final candidates = <String>[
      if (override.isNotEmpty) override,
      if (pushDefault != null && pushDefault.isNotEmpty) pushDefault,
      if (checkoutDefault != null && checkoutDefault.isNotEmpty)
        checkoutDefault,
      if (trackingRemote != null && trackingRemote.isNotEmpty) trackingRemote,
      if (availableRemotes.length == 1) availableRemotes.keys.first,
      'origin',
      if (availableRemotes.isNotEmpty) availableRemotes.keys.first,
    ];

    for (final candidate in candidates) {
      if (availableRemotes.containsKey(candidate)) {
        return _cache = (
          remote: candidate,
          branch: availableRemotes[candidate]!,
        );
      }
    }

    return null;
  }
}
