import streamlit as st
import pandas as pd
from capaDatos.conexion import obtener_tabla

# ====== CONFIGURACIÓN DE PÁGINA ======
st.set_page_config(page_title="Bazar La Elegancia", layout="wide")
st.title("Bazar La Elegancia - Gestión de Ventas")

# ====== SELECCIÓN DE TABLA ======
tablas_disponibles = ["categorias", "productos", "clientes", "ventas", "ventas_detalle", "pagos"]
tabla_seleccionada = st.selectbox("Selecciona la tabla a visualizar", tablas_disponibles)

# ====== OBTENER DATOS ======
df_tabla = pd.DataFrame(obtener_tabla(tabla_seleccionada))

if df_tabla.empty:
    st.warning(f"No hay datos disponibles en la tabla '{tabla_seleccionada}'.")
else:
    st.subheader(f"Datos de la tabla: {tabla_seleccionada}")
    st.dataframe(df_tabla)

# ====== FILTRADO DE PRODUCTOS POR CATEGORÍA ======
if tabla_seleccionada == "productos":
    # Obtener categorías
    categorias_df = pd.DataFrame(obtener_tabla("categorias"))
    
    if not categorias_df.empty and "idCategoria" in categorias_df.columns and "nombre" in categorias_df.columns:
        categoria_seleccionada = st.selectbox("Filtrar por categoría", categorias_df["nombre"])
        
        # Filtrar productos usando la columna correcta en productos_df
        productos_df = df_tabla
        prod_col_cat = "idcategoria" if "idcategoria" in productos_df.columns else "idCategoria"
        
        id_categoria = categorias_df[categorias_df["nombre"] == categoria_seleccionada]["idCategoria"].values[0]
        productos_filtrados = productos_df[productos_df[prod_col_cat] == id_categoria]
        
        st.subheader(f"Productos de la categoría: {categoria_seleccionada}")
        if productos_filtrados.empty:
            st.info("No hay productos en esta categoría.")
        else:
            st.dataframe(productos_filtrados)
    else:
        st.warning("No hay categorías disponibles para filtrar.")
