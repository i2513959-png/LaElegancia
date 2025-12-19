from capaDatos.conexion import obtener_tabla
import pandas as pd

def obtener_dataframe(tabla: str):
    datos = obtener_tabla(tabla)
    return pd.DataFrame(datos)
