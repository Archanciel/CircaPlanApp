import 'dart:io';

class DirUtil {
  /// If the filePathNameStr file exists, it is renamed and the
  /// renamed File is returned. Otherwise, null is returned.
  static File? renameFile({
    required String filePathNameStr,
    required String newFileNameStr,
  }) {
    File file = File(filePathNameStr);

    bool fileExist = file.existsSync();

    if (!fileExist) {
      return null;
    }

    var lastSeparator = filePathNameStr.lastIndexOf(Platform.pathSeparator);
    var newPath =
        filePathNameStr.substring(0, lastSeparator + 1) + newFileNameStr;

    return file.renameSync(newPath);
  }
}

void main() {
  File? renamedFile = DirUtil.renameFile(
      filePathNameStr: 'c:\\temp\\circadian.json',
      newFileNameStr: '2022-08-07 02.30.json');

  print(renamedFile);

  renamedFile = DirUtil.renameFile(
      filePathNameStr: 'c:\\temp\\CircadianData\\circadian.json',
      newFileNameStr: '2022-08-07 02.30.json');

  print(renamedFile);

  renamedFile = DirUtil.renameFile(
      filePathNameStr: 'c:\\temp\\CircadianData\\2022-08-07 02.30.json',
      newFileNameStr: 'circadian.json');

  print(renamedFile);
}
