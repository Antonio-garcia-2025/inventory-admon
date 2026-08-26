# inventory — Gestión de Inventario y Ventas

> [Read in English](README.md)

Aplicación web de control de inventario y ventas desarrollada con **Ruby on Rails 8**. Cuenta con autenticación de usuarios, aislamiento de datos, control de existencias, transacciones de venta, métricas en tiempo real, categorización y exportación de reportes a Excel (CSV).

---

##  Funcionalidades Principales

 **Autenticación Multi-Usuario:** Registro, inicio y cierre de sesión seguro mediante `Devise`, con aislamiento total de datos por usuario.
 **CRUD Completo de Productos:** Alta, edición, visualización y eliminación de artículos con validación de datos.
 **Sistema de Categorías (1 a N):** Organización de catálogo por categorías asociadas a cada usuario.
 **Búsqueda y Filtros Combinados:** Búsqueda en tiempo real por nombre de producto y filtrado por categoría.
 **Gestión de Stock y Ventas:** Botón "Vender 1" con decremento de existencias y registro histórico mediante transacciones atómicas de base de datos.
 **Dashboard de Métricas:** Tarjetas informativas con cálculo automático de:
 Ganancias totales por ventas realizadas.
 Valor total acumulado en inventario.
 Contador de artículos agotados (stock en 0).
 **Exportación a CSV:** Descarga del inventario completo en formato CSV compatible con Microsoft Excel y Google Sheets.

---

##  Tecnologías Utilizadas

**Backend:** Ruby on Rails 8
**Base de Datos:** SQLite3
**Autenticación:** Devise
**Manejo de Reportes:** Librería estándar `csv` de Ruby
**Frontend:** Vistas dinámicas con ERB y diseño estructurado

---

##  Instalación y Configuración Local

### Requisitos Previos

**Ruby** (>= 3.3.0)
**Rails** (>= 8.0)
**Git**

### Render 
https://shopify-z885.onrender.com/users/sign_in