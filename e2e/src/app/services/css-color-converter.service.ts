export class CssColorConverterService {

  public static rgba2Hex(rgba: string): string {
    const radix = 16;
    const hexLength = 6;
    const colors = 255;
    const digits = 2;

    const inParts = rgba.substring(rgba.indexOf('(')).split(',');
    const rIndex = 0;
    const gIndex = 1;
    const bIndex = 2;
    const aIndex = 3;

    const r: number = parseInt(CssColorConverterService.trim(inParts[rIndex].substring(1)), 10);
    const g: number = parseInt(CssColorConverterService.trim(inParts[gIndex]), 10);
    const b: number = parseInt(CssColorConverterService.trim(inParts[bIndex]), 10);
    const a: string = parseFloat(CssColorConverterService.trim(inParts[aIndex].substring(0, inParts[aIndex].length - 1))).toFixed(digits);
    const outParts = [
      r.toString(radix),
      g.toString(radix),
      b.toString(radix),
      Math.round(Number(a) * colors).toString(radix).substring(0, digits)
    ];

    // Pad single-digit output values
    CssColorConverterService.pad(outParts);

    return ('#' + outParts.join('').slice(0, hexLength));
  }

  public static rgb2Hex(rgb: string): string {
    const radix = 16;
    const hexLength = 6;

    const inParts = rgb.substring(rgb.indexOf('(')).split(',');
    const rIndex = 0;
    const gIndex = 1;
    const bIndex = 2;

    const r: number = parseInt(CssColorConverterService.trim(inParts[rIndex].substring(1)), 10);
    const g: number = parseInt(CssColorConverterService.trim(inParts[gIndex]), 10);
    const b: number = parseInt(CssColorConverterService.trim(inParts[bIndex]), 10);
    const outParts = [
      r.toString(radix),
      g.toString(radix),
      b.toString(radix)
    ];

    // Pad single-digit output values
    CssColorConverterService.pad(outParts);

    return ('#' + outParts.join('').slice(0, hexLength));
  }

  private static trim(str: string): string {
    return str.replace(/^\s+|\s+$/gm, '');
  }

  private static pad(str: string[]): string[] {
    str.forEach((part: string, i: number) => {
      if (part.length === 1) {
        str[i] = '0' + part;
      }
    });
    return str;
  }
}
