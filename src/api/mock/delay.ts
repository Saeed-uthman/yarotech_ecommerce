export const delay = (ms = 350) => new Promise<void>((r) => setTimeout(r, ms));
