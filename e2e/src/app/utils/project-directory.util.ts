import path = require('path');

export class ProjectDirectoryUtil {
  public static testDataFolderPath(): string {
    return path.join(this.e2eFolder(), 'testdata');
  }
  public static e2eFolder(): string {
    let processPath: string = process.cwd();
    if (! processPath.endsWith('e2e')) {
      processPath = path.join(processPath, 'e2e');
    }
    return processPath;
  }
}
