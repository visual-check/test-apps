import {fileURLToPath} from 'node:url';

export const managerEntries = [
  fileURLToPath(new URL('./manager.tsx', import.meta.url)),
];
