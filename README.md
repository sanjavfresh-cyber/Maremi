# MARKEMI

App para administrar **varios comercios independientes** desde una misma liga: catálogo, ventas, notas de remisión, gastos, préstamos y caja — **cada comercio con sus propios datos**.

Corre en **Supabase** (base de datos) + **Vercel** (hosting) + **GitHub** (código). Funciona en celular y computadora con la misma liga, y los datos se sincronizan entre dispositivos.

> Este es un proyecto **nuevo e independiente** de SANJAF. Usa su propia base de datos de Supabase (no compartas el proyecto ni las llaves con SANJAF).

---

## Qué incluye este paquete

| Archivo | Para qué sirve |
|---|---|
| `index.html` | La app completa. Es lo único que se publica en Vercel. |
| `schema.sql` | Crea las tablas y la seguridad en Supabase. **Se corre 1 vez.** |
| `vercel.json` | Configuración mínima para Vercel. |

El catálogo arranca **vacío**: cada comercio va agregando sus propios productos desde la pantalla **Catálogo**.

---

## Puesta en marcha (una sola vez, ~15 minutos)

### 1) Crea tu base de datos en Supabase
1. Entra a **https://supabase.com** → *Start your project* → crea una cuenta (gratis).
2. **New project**. Ponle nombre (ej. `markemi`), elige una contraseña de base de datos y la región más cercana. Espera ~2 min a que se cree.

### 2) Crea las tablas
1. En el menú izquierdo abre **SQL Editor** → **New query**.
2. Abre `schema.sql`, **copia todo** el contenido, pégalo y presiona **Run**.

### 3) Crea tu usuario para entrar a la app
1. Menú **Authentication** → **Users** → **Add user** → **Create new user**.
2. Escribe tu **correo** y una **contraseña**. Marca "Auto Confirm User" si aparece.
3. Ese correo y contraseña serán tu login en la app.

### 4) Copia tus llaves de conexión
1. Menú **Project Settings** (engrane) → **API**.
2. Copia dos cosas y guárdalas a la mano:
   - **Project URL** (algo como `https://xxxxx.supabase.co`)
   - **anon public** key (una cadena larga que empieza con `eyJ...`)

> La llave `anon public` es segura para usarse en la app: la seguridad real la da tu login + las reglas (RLS) que ya vienen en `schema.sql`.

### 5) Sube el código a GitHub
**Opción fácil (sin instalar nada):**
1. Entra a **https://github.com**, crea cuenta y luego **New repository** → nómbralo `markemi` → **Create**.
2. En el repo vacío: **Add file → Upload files**, arrastra **todos** los archivos de esta carpeta y **Commit changes**.

### 6) Publica en Vercel
1. Entra a **https://vercel.com** → *Sign up* con tu cuenta de GitHub.
2. **Add New… → Project** → importa tu repo `markemi`.
3. Deja todo por defecto (Framework: *Other*) y presiona **Deploy**. En ~1 min te da una liga tipo `https://markemi.vercel.app`.

### 7) Entra y conéctala
1. Abre la liga de Vercel en tu celular o compu.
2. La primera vez te pide la **Project URL** y la **anon public key** (las del paso 4). Pégalas → **Conectar**.
3. Inicia sesión con el correo y contraseña del paso 3.
4. Verás la pantalla **"Elige tu comercio"**. Toca **Nuevo comercio**, ponle nombre y entra. ¡Listo!

> **Consejo:** en el celular, abre la liga en Chrome/Safari y elige **"Agregar a pantalla de inicio"**. Queda como una app.

---

## Cómo funcionan los comercios

- Al entrar eliges un comercio. Todo lo que registras (catálogo, ventas, gastos, préstamos, caja) **pertenece solo a ese comercio**.
- Para cambiar de comercio, toca el ícono de **tienda** arriba a la derecha. Vuelves al selector.
- Los **folios de las notas empiezan en 1 en cada comercio**, por separado.
- Puedes crear todos los comercios que quieras; son totalmente independientes entre sí.

---

## Cómo se usa (en cada comercio)

- **Vender:** eliges cliente, buscas el producto del catálogo (se llenan costo/precio solos y los puedes ajustar) o agregas un "producto libre". Al guardar se crea la nota con folio automático.
- **Notas:** todas tus ventas con su estatus. Cada nota tiene **Pago** (por cobrar / pagado) y **Factura** (por facturar / facturada). Adentro: **WhatsApp** (comparte la nota como imagen) e **Imprimir/PDF**.
- **Catálogo:** agrega y edita productos. Costo + % de ganancia calcula el precio solo.
- **Caja:** pones un **fondo** en efectivo y de ahí se descuenta lo que gastas. El **costo de cada nota se descuenta al crearla**; la **venta se suma cuando la marcas como pagada**. Registras también **gastos** y **préstamos**.
- **Panel:** venta, utilidad y margen de hoy / semana / mes, más los más vendidos.

### Cómo se calcula la caja
- **Saldo = Fondo + Cobrado (pagadas) − Costo de la mercancía (todas las notas) − Gastos − Retiros.**
- **Utilidad del periodo = Cobrado − Costo − Gastos.**
- Es decir: en cuanto registras una nota, su costo **ya cuenta como gastado**; la venta empieza a sumar **hasta que la cobras**.

---

## Notas importantes

- **Cambiar la conexión:** si te equivocas de llaves, en la pantalla de login puedes reconectar (o borra los datos del sitio en el navegador).
- **Fijar las llaves (opcional):** si no quieres pegarlas en cada dispositivo, abre `index.html`, busca `window.MARKEMI_CONFIG` y escribe ahí tu `url` y `anon`.
- **Seguridad:** solo quien tenga usuario y contraseña (los que creaste en el paso 3) puede entrar y ver los datos.

---

## Próximas fases (cuando quieras)
- Ficha de cliente con saldo y precios especiales por cliente.
- Control de compra diaria e inventario por comercio.
- Reporte comparativo entre comercios.
- Facturación CFDI real ante el SAT (requiere contratar un timbrador / PAC).
