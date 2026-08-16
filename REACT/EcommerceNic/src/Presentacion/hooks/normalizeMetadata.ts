export const normalizeMetadata = (metadata: any): { productos?: any[] } | null => {
  if (!metadata) return null;
  if (typeof metadata === 'string') {
    try {
      const parsed = JSON.parse(metadata);
      if (Array.isArray(parsed)) return { productos: parsed };
      if (parsed.productos) return { productos: parsed.productos };
      return { productos: [] };
    } catch {
      return null;
    }
  }
  if (Array.isArray(metadata)) return { productos: metadata };
  if (typeof metadata === 'object') return metadata as { productos?: any[] };
  return null;
};
