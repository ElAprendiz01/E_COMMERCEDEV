import { useState, useEffect, useCallback } from 'react';
import { UserAddress } from '../../Domain/entities/UserAddress';
import { User } from '../../Domain/entities/User';
import { UserAddressRemoteDataSource } from '../../Data/dataSources/UserAddressRemoteDataSource';

const addressDataSource = new UserAddressRemoteDataSource();
const STORAGE_KEY_ADDRESSES = 'NIC_STORE_LOCAL_ADDRESSES_V1';

export const useUserAddresses = (usuario: User) => {
  const [direcciones, setDirecciones] = useState<UserAddress[]>([]);
  const [direccionSeleccionada, setDireccionSeleccionada] = useState<UserAddress | null>(null);
  const [cargandoDirecciones, setCargandoDirecciones] = useState<boolean>(false);
  const [procesandoAccion, setProcesandoAccion] = useState<boolean>(false);

  const idBruto = parseInt(usuario?.id || '1', 10);
  const idUsuarioNumerico = (isNaN(idBruto) || idBruto <= 0 || idBruto > 2147483647) ? 1 : idBruto;

  const cargarDirecciones = useCallback(async () => {
    if (!idUsuarioNumerico) return;
    setCargandoDirecciones(true);
    try {
      const result = await addressDataSource.getAddressesByUser(idUsuarioNumerico);

      const listaFinal = result || [];
      setDirecciones(listaFinal);

      // Establecer dirección principal por defecto de la BD si existe
      const principal = listaFinal.find(d => d.userAddressIsPrincipal) || listaFinal[0] || null;
      setDireccionSeleccionada(principal);
    } catch (error) {
      console.log('Error al cargar direcciones:', error);
      setDirecciones([]);
      setDireccionSeleccionada(null);
    } finally {
      setCargandoDirecciones(false);
    }
  }, [idUsuarioNumerico]);

  useEffect(() => {
    cargarDirecciones();
  }, [cargarDirecciones]);

  const agregarNuevaDireccion = async (descripcion: string, esPrincipal: boolean = false) => {
    if (!descripcion || descripcion.trim().length === 0) return false;
    setProcesandoAccion(true);
    try {
      const res = await addressDataSource.createAddress(idUsuarioNumerico, descripcion.trim(), esPrincipal);
      const nuevaDir: UserAddress = {
        userAddressId: res.addressId || Math.floor(Math.random() * 9000) + 1000,
        userAddressUserId: idUsuarioNumerico,
        userAddressDescription: descripcion.trim(),
        userAddressIsPrincipal: esPrincipal,
      };

      setDirecciones(prev => {
        const actualizadas = esPrincipal 
          ? prev.map(d => ({ ...d, userAddressIsPrincipal: false }))
          : [...prev];
        return [nuevaDir, ...actualizadas];
      });

      if (esPrincipal || !direccionSeleccionada) {
        setDireccionSeleccionada(nuevaDir);
      }

      await cargarDirecciones();
      return true;
    } catch (error) {
      console.log('Error al registrar dirección:', error);
      return false;
    } finally {
      setProcesandoAccion(false);
    }
  };

  const seleccionarDireccionActiva = (direccion: UserAddress) => {
    setDireccionSeleccionada(direccion);
  };

  const eliminarDireccion = async (addressId?: number) => {
    if (!addressId) return false;
    setProcesandoAccion(true);
    try {
      await addressDataSource.deleteAddress(addressId, idUsuarioNumerico);
      setDirecciones(prev => {
        const filtradas = prev.filter(d => d.userAddressId !== addressId);
        if (direccionSeleccionada?.userAddressId === addressId) {
          setDireccionSeleccionada(filtradas[0] || null);
        }
        return filtradas;
      });
      return true;
    } catch (error) {
      console.log('Error al eliminar dirección:', error);
      return false;
    } finally {
      setProcesandoAccion(false);
    }
  };

  return {
    direcciones,
    direccionSeleccionada,
    cargandoDirecciones,
    procesandoAccion,
    seleccionarDireccionActiva,
    agregarNuevaDireccion,
    eliminarDireccion,
    refetchDirecciones: cargarDirecciones,
  };
};
