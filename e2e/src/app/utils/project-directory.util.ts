import path = require('path');

export class ProjectDirectoryUtil {
  public static testDataFolderPath(): string {
    let processPath: string = process.cwd();
    if (! processPath.endsWith('e2e'))
    {
      processPath = path.join(processPath, 'e2e');
    }
    return path.join(processPath, 'testdata');
  }
}
