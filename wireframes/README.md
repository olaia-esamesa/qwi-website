# Wireframes de la web de Qwi · v0.8

Página de revisión de los wireframes (Figma «Wireframes v4»). El cliente navega las 11 páginas, propone textos y deja feedback de cualquier tipo. Todo se guarda en Supabase y lo ve todo el equipo.

- `index.html`: la página completa (HTML, CSS y JS en un solo archivo).
- `config.js`: URL y clave pública de Supabase.
- `supabase.sql`: tablas y reglas de la base de datos.

## Puesta en marcha

1. Crea un proyecto gratuito en [supabase.com](https://supabase.com).
2. En **SQL Editor**, pega el contenido de `supabase.sql` y pulsa **Run**.
3. En **Project Settings → API**, copia la **Project URL** y la clave **publishable** (o la antigua **anon public**) en `config.js`.
4. Sube los cambios. Con GitHub Pages activo (Settings → Pages → rama `main`, carpeta `/`), la página queda en `https://olaia-esamesa.github.io/qwi-website/wireframes/`.

## Uso

- **Cliente**: enlace normal. Al entrar ve la pantalla «Cómo funciona». Firma cada propuesta con su nombre, que se recuerda en su navegador.
- **Equipo de Esamesa**: añade `?equipo` al enlace (`…/wireframes/?equipo`) para marcar propuestas y feedback como aceptados, resueltos o descartados.

`?equipo` solo muestra los botones; no es una contraseña. Cualquiera con el enlace puede leer, añadir y cambiar el estado, pero nadie puede borrar ni editar textos ya enviados. Para revisar o exportar todo: Supabase → **Table Editor** (`propuestas` y `feedback`).
