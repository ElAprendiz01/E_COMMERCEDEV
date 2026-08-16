import { useState, useEffect, useCallback } from 'react';
import { SubCategory } from '../../Domain/entities/SubCategory';
import { SubCategoryRemoteDataSource } from '../../Data/dataSources/SubCategoryRemoteDataSource';

const subCategoryDataSource = new SubCategoryRemoteDataSource();

export const useSubCategories = () => {
  const [subCategorias, setSubCategorias] = useState<SubCategory[]>([]);
  const [subCategoriaSeleccionadaId, setSubCategoriaSeleccionadaId] = useState<number | null>(null);
  const [cargandoSubCategorias, setCargandoSubCategorias] = useState<boolean>(false);

  const cargarSubCategorias = useCallback(async () => {
    setCargandoSubCategorias(true);
    try {
      const data = await subCategoryDataSource.getSubCategories();
      setSubCategorias(data);
    } catch (e) {
      console.log('Error en useSubCategories:', e);
    } finally {
      setCargandoSubCategorias(false);
    }
  }, []);

  useEffect(() => {
    cargarSubCategorias();
  }, [cargarSubCategorias]);

  const seleccionarSubCategoria = (id: number | null) => {
    if (subCategoriaSeleccionadaId === id) {
      setSubCategoriaSeleccionadaId(null);
    } else {
      setSubCategoriaSeleccionadaId(id);
    }
  };

  return {
    subCategorias,
    subCategoriaSeleccionadaId,
    cargandoSubCategorias,
    seleccionarSubCategoria,
    refetchSubCategorias: cargarSubCategorias,
  };
};
