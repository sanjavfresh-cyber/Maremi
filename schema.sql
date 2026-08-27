-- ============================================================
--  MARKEMI — Esquema de base de datos (Supabase / Postgres)
--  Proyecto NUEVO, independiente de SANJAF.
--  Ejecuta este archivo completo en:  Supabase > SQL Editor > New query
-- ============================================================

create extension if not exists pgcrypto;

-- Comercios (cada uno con datos independientes)
create table if not exists comercios (
  id      uuid primary key default gen_random_uuid(),
  nombre  text not null,
  creado  timestamptz default now()
);

-- Catálogo de productos (por comercio)
create table if not exists productos (
  id          uuid primary key default gen_random_uuid(),
  comercio_id uuid not null references comercios(id) on delete cascade,
  nombre      text not null,
  categoria   text default 'Otro',
  udm         text default '',
  costo       numeric,
  pct         numeric,
  precio      numeric,
  activo      boolean default true,
  created_at  timestamptz default now()
);
create index if not exists productos_com_idx on productos(comercio_id);

-- Clientes (por comercio)
create table if not exists clientes (
  id          uuid primary key default gen_random_uuid(),
  comercio_id uuid not null references comercios(id) on delete cascade,
  nombre      text not null,
  rfc         text,
  telefono    text,
  notas       text,
  created_at  timestamptz default now(),
  unique (comercio_id, nombre)
);

-- Ventas / notas de remisión (por comercio; folio se asigna por comercio en la app)
create table if not exists ventas (
  id          uuid primary key default gen_random_uuid(),
  comercio_id uuid not null references comercios(id) on delete cascade,
  folio       integer,
  fecha       date not null default current_date,
  cliente     text not null default '',
  venta       numeric not null default 0,
  costo       numeric not null default 0,
  util        numeric not null default 0,
  pago        text not null default 'pendiente',    -- 'pendiente' | 'pagado'
  factura     text not null default 'por_facturar', -- 'por_facturar' | 'facturado'
  borrador    boolean not null default false,
  creado      timestamptz default now()
);
create index if not exists ventas_com_idx on ventas(comercio_id);
create index if not exists ventas_fecha_idx on ventas(fecha);

-- Renglones de cada venta
create table if not exists venta_items (
  id        uuid primary key default gen_random_uuid(),
  venta_id  uuid not null references ventas(id) on delete cascade,
  nombre    text not null,
  udm       text,
  cant      numeric not null default 0,
  precio    numeric not null default 0,
  costo     numeric not null default 0
);
create index if not exists venta_items_venta_idx on venta_items(venta_id);

-- Gastos (por comercio)
create table if not exists gastos (
  id          uuid primary key default gen_random_uuid(),
  comercio_id uuid not null references comercios(id) on delete cascade,
  fecha       date not null default current_date,
  concepto    text not null,
  categoria   text default 'Otro',
  monto       numeric not null default 0,
  nota        text,
  creado      timestamptz default now()
);
create index if not exists gastos_com_idx on gastos(comercio_id);

-- Préstamos (por comercio)
create table if not exists prestamos (
  id          uuid primary key default gen_random_uuid(),
  comercio_id uuid not null references comercios(id) on delete cascade,
  persona     text not null,
  tipo        text not null default 'me_deben',  -- 'me_deben' | 'yo_debo'
  monto       numeric not null default 0,
  fecha       date not null default current_date,
  estado      text not null default 'activo',     -- 'activo' | 'saldado'
  nota        text,
  creado      timestamptz default now()
);
create index if not exists prestamos_com_idx on prestamos(comercio_id);

-- Caja / fondo en efectivo (por comercio)
create table if not exists caja_movimientos (
  id          uuid primary key default gen_random_uuid(),
  comercio_id uuid not null references comercios(id) on delete cascade,
  fecha       date not null default current_date,
  tipo        text not null default 'fondo',   -- 'fondo' | 'retiro'
  concepto    text,
  monto       numeric not null default 0,
  creado      timestamptz default now()
);
create index if not exists caja_com_idx on caja_movimientos(comercio_id);

-- ============================================================
--  Seguridad (RLS): solo usuarios con sesión pueden ver/editar
-- ============================================================
alter table comercios        enable row level security;
alter table productos        enable row level security;
alter table clientes         enable row level security;
alter table ventas           enable row level security;
alter table venta_items      enable row level security;
alter table gastos           enable row level security;
alter table prestamos        enable row level security;
alter table caja_movimientos enable row level security;

do $$
declare t text;
begin
  foreach t in array array['comercios','productos','clientes','ventas','venta_items','gastos','prestamos','caja_movimientos'] loop
    execute format('drop policy if exists "acceso_autenticado" on %I', t);
    execute format($f$create policy "acceso_autenticado" on %I
      for all to authenticated using (true) with check (true)$f$, t);
  end loop;
end $$;
