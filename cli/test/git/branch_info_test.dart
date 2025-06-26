import 'package:stax/git/branch_info.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test(
    '  rchan2-attachmentinvalidURL ccf7ce2d606 [origin/rchan2/attachmentinvalidURL: gone] Initial',
    () {
      final branch =
          '  rchan2-attachmentinvalidURL ccf7ce2d606 [origin/rchan2/attachmentinvalidURL: gone] Initial';
      final branchInfo = BranchInfo.parse(branch);
      expect(
        branchInfo.toString(),
        'rchan2-attachmentinvalidURL ccf7ce2d606 origin/rchan2/attachmentinvalidURL gone Initial',
      );
      expect(branchInfo.gone, true);
      expect(branchInfo.commitHash, 'ccf7ce2d606');
    },
  );
}
