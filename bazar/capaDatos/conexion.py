from supabase import create_client, Client
from dotenv import load_dotenv
import os

load_dotenv()

SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_KEY")

if not SUPABASE_URL or not SUPABASE_KEY:
    raise ValueError("Las variables de entorno SUPABASE_URL o SUPABASE_KEY no están definidas correctamente")

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

def obtener_tabla(tabla: str):
    """Devuelve todos los registros de la tabla indicada"""
    respuesta = supabase.table(tabla).select("*").execute()
    return respuesta.data if respuesta.data else []
