import 'dart:io';

import 'package:circa_plan/utils/date_time_parser.dart';
import 'package:circa_plan/utils/dir_util.dart';
import 'package:test/test.dart';

void main() {
  group(
    'DirUtil()',
    () {
      test(
        'renameFile()',
        () {
          String notExistfilePathNameStr = 'c:\\temp\\circadian.json';

          File? renamedFile = DirUtil.renameFile(
              filePathNameStr: notExistfilePathNameStr,
              newFileNameStr: '2022-08-07 02.30.json');

          expect(null, renamedFile);

          String originalFilePathNameStr = 'c:\\temp\\CircadianData\\circadian.json';

          renamedFile = DirUtil.renameFile(
              filePathNameStr: originalFilePathNameStr,
              newFileNameStr: '2022-08-07 02.30.json');

          String renamedFilePathNameStr = 'c:\\temp\\CircadianData\\2022-08-07 02.30.json';

          expect(renamedFilePathNameStr, renamedFile!.path);

          renamedFile = DirUtil.renameFile(
              filePathNameStr: renamedFilePathNameStr,
              newFileNameStr: 'circadian.json');

          expect(originalFilePathNameStr, renamedFile!.path);
        },
      );
    },
  );
}
