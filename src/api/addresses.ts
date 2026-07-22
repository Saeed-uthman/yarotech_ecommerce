/**
 * Addresses service — frontend stubs.
 *
 * Real endpoints (PHP/MySQL):
 *   GET    /api/addresses/list.php
 *   POST   /api/addresses/save.php          (create + update)
 *   POST   /api/addresses/set-primary.php
 *   POST   /api/addresses/delete.php
 *
 * Currently backed by the persistent client-side `addresses` zustand store.
 */
import { delay } from "./mock/delay";
import { useAddressesStore, type UserAddress } from "@/stores/addresses";

export type Address = UserAddress;

export async function fetchUserAddresses(): Promise<Address[]> {
  await delay(160);
  return useAddressesStore.getState().items;
}

export async function saveAddress(
  input: Omit<Address, "id" | "isPrimary"> & { id?: string; isPrimary?: boolean },
): Promise<Address> {
  await delay(180);
  const store = useAddressesStore.getState();
  if (input.id) {
    store.update(input.id, input);
    return store.items.find((a) => a.id === input.id)!;
  }
  return store.add(input);
}

export async function deleteAddress(id: string): Promise<{ ok: true }> {
  await delay(120);
  useAddressesStore.getState().remove(id);
  return { ok: true };
}

export async function setPrimaryAddress(id: string): Promise<{ ok: true }> {
  await delay(120);
  useAddressesStore.getState().setPrimary(id);
  return { ok: true };
}
