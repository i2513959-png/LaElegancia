# conexion.py
from supabase import create_client, Client
from dotenv import load_dotenv
import os

# Cargar variables de entorno desde .env
load_dotenv()

SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_KEY")

# Crear cliente de Supabase
supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

# Función genérica para obtener todos los registros de una tabla
def obtener_tabla(tabla: str):
    """
    Devuelve todos los registros de la tabla especificada en Supabase.
    
    Parámetros:
        tabla (str): Nombre de la tabla en Supabase
    
    Retorna:
        lista de diccionarios
    """
    respuesta = supabase.table(tabla).select("*").execute()
    if respuesta.data:
        return respuesta.data
    return []

# Función para insertar un registro en cualquier tabla
def insertar_registro(tabla: str, datos: dict):
    """
    Inserta un registro en la tabla indicada.
    
    Parámetros:
        tabla (str): Nombre de la tabla
        datos (dict): Diccionario con los campos y valores a insertar
    """
    respuesta = supabase.table(tabla).insert(datos).execute()
    return respuesta.data
