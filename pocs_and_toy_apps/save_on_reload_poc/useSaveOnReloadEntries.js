import { useCallback, useEffect, useMemo, useRef, useState } from 'react';

const DEFAULT_STORAGE_KEY = 'pocEntries';

function parseStore(raw) {
  if (!raw) return {};

  try {
    const parsed = JSON.parse(raw);
    return parsed && typeof parsed === 'object' ? parsed : {};
  } catch (_error) {
    return {};
  }
}

function nextTimestampKey(store) {
  const base = new Date().toISOString();
  if (!(base in store)) return base;

  let suffix = 1;
  let key = `${base}-${suffix}`;
  while (key in store) {
    suffix += 1;
    key = `${base}-${suffix}`;
  }

  return key;
}

export function useSaveOnReloadEntries(storageKey = DEFAULT_STORAGE_KEY) {
  const [store, setStore] = useState({});
  const storeRef = useRef(store);

  useEffect(() => {
    storeRef.current = store;
  }, [store]);

  const saveStore = useCallback(
    (nextStore = storeRef.current) => {
      if (typeof window === 'undefined') return;
      window.localStorage.setItem(storageKey, JSON.stringify(nextStore));
    },
    [storageKey],
  );

  const loadStore = useCallback(() => {
    if (typeof window === 'undefined') return;
    const raw = window.localStorage.getItem(storageKey);
    setStore(parseStore(raw));
  }, [storageKey]);

  useEffect(() => {
    loadStore();
  }, [loadStore]);

  useEffect(() => {
    saveStore(store);
  }, [saveStore, store]);

  const addEntry = useCallback((value) => {
    const trimmed = String(value ?? '').trim();
    if (!trimmed) return false;

    setStore((prev) => {
      const key = nextTimestampKey(prev);
      return {
        ...prev,
        [key]: trimmed,
      };
    });

    return true;
  }, []);

  const deleteEntry = useCallback((key) => {
    setStore((prev) => {
      if (!(key in prev)) return prev;

      const next = { ...prev };
      delete next[key];
      return next;
    });
  }, []);

  const resetStore = useCallback(() => {
    setStore({});
  }, []);

  useEffect(() => {
    if (typeof window === 'undefined') return undefined;

    const handleKeyDown = (event) => {
      const isReload =
        (event.metaKey || event.ctrlKey) &&
        (event.key === 'r' || event.key === 'R');

      if (isReload) {
        saveStore();
      }
    };

    const handleBeforeUnload = () => {
      saveStore();
    };

    window.addEventListener('keydown', handleKeyDown);
    window.addEventListener('beforeunload', handleBeforeUnload);

    return () => {
      window.removeEventListener('keydown', handleKeyDown);
      window.removeEventListener('beforeunload', handleBeforeUnload);
    };
  }, [saveStore]);

  const entries = useMemo(
    () => Object.keys(store).sort().map((key) => ({ key, value: store[key] })),
    [store],
  );

  return {
    entries,
    store,
    addEntry,
    deleteEntry,
    resetStore,
    loadStore,
    saveStore,
  };
}
