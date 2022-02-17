export class DelayUtils {
  public static async waitFor(durationInMs: number): Promise<void> {
    await new Promise((resolve => {
      setTimeout(resolve, durationInMs);
    }));
  }
}
