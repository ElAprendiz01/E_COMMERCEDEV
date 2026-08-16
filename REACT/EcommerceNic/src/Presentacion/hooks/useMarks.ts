import { useState, useEffect, useCallback } from 'react';
import { Mark } from '../../Domain/entities/Mark';
import { MarkRemoteDataSource } from '../../Data/dataSources/MarkRemoteDataSource';

const markDataSource = new MarkRemoteDataSource();

export const useMarks = () => {
  const [marcas, setMarcas] = useState<Mark[]>([]);
  const [marcaSeleccionadaId, setMarcaSeleccionadaId] = useState<number | null>(null);
  const [cargandoMarcas, setCargandoMarcas] = useState<boolean>(false);

  const cargarMarcas = useCallback(async () => {
    setCargandoMarcas(true);
    try {
      const data = await markDataSource.getMarks();
      setMarcas(data);
    } catch (e) {
      console.log('Error en useMarks:', e);
    } finally {
      setCargandoMarcas(false);
    }
  }, []);

  useEffect(() => {
    cargarMarcas();
  }, [cargarMarcas]);

  const seleccionarMarca = (id: number | null) => {
    if (marcaSeleccionadaId === id) {
      setMarcaSeleccionadaId(null); // Deseleccionar al presionar de nuevo
    } else {
      setMarcaSeleccionadaId(id);
    }
  };

  return {
    marcas,
    marcaSeleccionadaId,
    cargandoMarcas,
    seleccionarMarca,
    refetchMarcas: cargarMarcas,
  };
};
