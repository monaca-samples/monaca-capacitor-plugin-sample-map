import { registerPlugin } from '@capacitor/core';

import type { MonacaCapacitorPlugin } from './definitions';

const MonacaCapacitor = registerPlugin<MonacaCapacitorPlugin>('MonacaCapacitor', {
  web: () => import('./web').then((m) => new m.MonacaCapacitorWeb()),
});

export * from './definitions';
export { MonacaCapacitor };
