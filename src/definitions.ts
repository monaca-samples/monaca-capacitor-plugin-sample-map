export interface MonacaCapacitorPlugin {
  openMap(options: OpenMapOptions): Promise<void>;
}

export interface OpenMapOptions {
  latitude: number;
  longitude: number;
}
