export class StringUtils {
  public static async createTestInputStringOfTypeAndLength(inputType: string, length: number): Promise<string> {
    let randomString = '';
    if (inputType === 'digit') {
      // don't pick 0 for the first char
      let charSet = '123456789';
      for (let i = 0; i < length; i++) {
        const randomPoz = Math.floor(Math.random() * charSet.length);
        randomString += charSet.substring(randomPoz, randomPoz + 1);
        // allow 0s subsequently
        charSet = '0123456789';
      }
    } else if (inputType === 'char') {
      const charSet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
      for (let i = 0; i < length; i++) {
        const randomPoz = Math.floor(Math.random() * charSet.length);
        randomString += charSet.substring(randomPoz, randomPoz + 1);
      }
    }
    return randomString;
  }
}
