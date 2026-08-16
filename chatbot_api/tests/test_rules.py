from app.repositories.reglas_repository import cargar_reglas

reglas = cargar_reglas()

for regla in reglas:
    print(regla)