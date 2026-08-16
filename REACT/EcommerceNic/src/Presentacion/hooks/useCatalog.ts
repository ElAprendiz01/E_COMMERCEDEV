import { useState, useEffect } from 'react';
import { Product } from '../../Domain/entities/Product';
import { getProductsUseCase } from '../../di/DI';

export const useCatalog = () => {
  const [productos, setProductos] = useState<Product[]>([]);
  const [estaCargandoCatalog, setEstaCargandoCatalog] = useState<boolean>(false);

  const cargarProductos = async () => {
    setEstaCargandoCatalog(true);
    try {
      const resultado = await getProductsUseCase.execute();
      setProductos(resultado);
    } catch (error) {
      console.error('Error al cargar el catálogo de productos:', error);
    } finally {
      setEstaCargandoCatalog(false);
    }
  };

  useEffect(() => {
    cargarProductos();
  }, []);

  return {
    productos,
    estaCargandoCatalog,
    cargarProductos,
  };
};
