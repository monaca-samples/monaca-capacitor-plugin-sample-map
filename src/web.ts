import { WebPlugin } from '@capacitor/core';
import type { MonacaCapacitorPlugin, OpenMapOptions } from './definitions';

export class MonacaCapacitorWeb extends WebPlugin implements MonacaCapacitorPlugin {
  async openMap(location: OpenMapOptions): Promise<void> {
    console.log('Opening map in browser', location);

    // Google Mapsを新しいタブで開く
    const url = `https://www.google.com/maps?q=${location.latitude},${location.longitude}`;
    window.open(url, '_blank');

    return;
  }
}
