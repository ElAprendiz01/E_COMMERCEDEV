import { useInfiniteQuery } from '@tanstack/react-query';
import { getProductsPagedUseCase } from '../../di/DI';
import { mapApiToProduct } from '../../Data/mappers/ProductMapper';
import { Product } from '../../Domain/entities/Product';

export function useProducts(searchTerm: string = '') {
  return useInfiniteQuery({
    queryKey: ['products', searchTerm],
    queryFn: async ({ pageParam = 1 }) => {
      const response = await getProductsPagedUseCase.execute(pageParam as number, undefined, searchTerm);
      const mappedProducts: Product[] = (response.data || []).map(mapApiToProduct);
      return {
        ...response,
        mappedProducts,
      };
    },
    getNextPageParam: (lastPage) => {
      if (!lastPage || lastPage.codigo === 204 || !lastPage.data || lastPage.data.length === 0) {
        return undefined;
      }
      const loadedCount = lastPage.pageNumber * lastPage.pageSize;
      if (loadedCount >= lastPage.totalRows) {
        return undefined;
      }
      return lastPage.pageNumber + 1;
    },
    initialPageParam: 1,
    staleTime: 1000 * 60 * 5,
  });
}
