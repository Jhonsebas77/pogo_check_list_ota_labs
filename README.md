# PoGo Check List

Aplicación **Flutter** para llevar el seguimiento personal de progreso en
**Pokémon GO**: qué Pokémon has capturado, cuáles te faltan, versiones *shiny*,
mega evoluciones, gigantamax, células de Zygarde, amigos de la suerte,
Pokémon para intercambio y más.

> App personal (`publish_to: none`). Los datos se sincronizan en tiempo real con
> Firebase Realtime Database.

---

## Plataformas

Proyecto Flutter multiplataforma. Hay configuración para:

| Móvil | Escritorio | Web |
|-------|------------|-----|
| Android, iOS | macOS, Windows, Linux | Web |

El uso principal es **móvil en orientación vertical** (`portraitUp` fijado en
`main.dart`).

---

## Stack tecnológico

- **Flutter / Dart** (SDK `^3.7.2`).
- **Riverpod** (`flutter_riverpod`) — gestión de estado.
- **Firebase** (`firebase_core`, `firebase_database`) — Realtime Database como
  backend de datos.
- **PokeAPI** (`https://pokeapi.co`) vía `http` — detalle de cada Pokémon.
- Utilidades de UI/UX: `shimmer` (placeholders), `percent_indicator`,
  `flutter_native_splash`, `screenshot` + `image_gallery_saver_plus` /
  `file_saver` (exportar capturas), `package_info_plus`, `intl`, `path_provider`.

---

## Funcionalidades

- **Pokédex** completa con progreso `capturados/total` y buscador por nombre.
- **ShinyDex** — seguimiento de versiones shiny.
- **Mega evoluciones** y **Gigantamax** en listas propias.
- **Células de Zygarde** — seguimiento de formas (10% / 50% / 100%) y conteo de
  células.
- **Formas alternativas** de una especie (p. ej. *Raichu* y *Raichu-Alola*)
  manteniendo el ID de especie (ver [Modelo de formas](#modelo-de-formas)).
- **Amigos de la suerte**, **Pokémon para intercambio**, **tabla de tipos**,
  edición de **perfil de entrenador** y **tema de color**.
- Ordenar por nombre / número de Pokédex y filtrar "solo faltantes".
- Exportar capturas de pantalla de las vistas.

---

## Arquitectura

Separación clara entre lógica (`core`) y presentación (`ui`). Cada capa se
organiza como una **librería Dart con archivos `part`** (un `library` +
múltiples `part of`), lo que permite compartir imports y mantener el código
modular.

```
lib/
├── main.dart                 # Bootstrap: Firebase, splash, ProviderScope
├── firebase_options.dart
├── core/
│   ├── enums/                # PokemonSortCriteria, etc.
│   ├── models/               # PokemonModel, ZygardeCells, Trainer, ...
│   ├── providers/            # Riverpod providers (firebase.dart = notifier RTDB)
│   ├── services/             # poke_api.dart (PokeAPI HTTP)
│   ├── state/                # Estado (incl. screenshot)
│   ├── utils/                # constants.dart (paths, tipos), helpers
│   └── mocks/                # Export de referencia de la RTDB (NO se usa en runtime)
└── ui/
    ├── theme.dart, navigator.dart
    ├── views/                # Pantallas (part of ...app.views)
    │   ├── home/ list/ details/ zygarde/ settings/
    └── widgets/              # Componentes reutilizables (part of ...app.widgets)
```

### Estado y datos

- `firebasePokemonProvider` (`AsyncNotifierProvider`) carga todo el estado desde
  Firebase RTDB y expone métodos de actualización (`updatePokemon`,
  `updatePokemonForm`, `updateMegaEvolutionPokemon`, `updateZygardeInformation`,
  ...).
- La app **lee siempre de Firebase**, no del mock. El archivo en `core/mocks/`
  es solo un *export de referencia* del esquema de la base de datos.

### Nodos de Firebase Realtime Database

Raíz: `/po_go_check_list`

| Nodo | Contenido |
|------|-----------|
| `pokemon` | **Array indexado por id** (índice == id) de la Pokédex |
| `megaevolution`, `gigantamax` | Mapas keyed por id |
| `zygarde_cells` | Formas de Zygarde + `actual_form`, `limit`, `quantity` |
| `traded_pokemon`, `lucky_friends`, `trainer` | Intercambios, amigos, perfil |

---

## Modelo de formas

Una especie puede tener varias **formas** (regionales como Alola, o las formas de
Zygarde). El modelo lo resuelve con dos conceptos **distintos y complementarios**:

- **`alternativeForms`** (`List<PokemonModel>`) — el **contenedor**: la lista de
  formas anidada dentro de la entrada base de la especie.
- **`formTag`** (`PokemonAlternativeForm { id, name, order }`) — la **etiqueta**
  de cada forma, que indica *cuál* es. La entrada base la tiene vacía.

En JSON estas dos claves son `alternative_forms` (lista) y `alternative_form`
(etiqueta). El mismo esquema se usa tanto en la Pokédex como en `zygarde_cells`
(su lista de formas también es `alternative_forms`).

Ejemplo (Raichu con su forma de Alola):

```json
{
  "id": 26,
  "name": "Raichu",
  "available": true,
  "alternative_forms": [
    {
      "id": 26,
      "name": "Raichu",
      "shiny_available": true,
      "alternative_form": { "id": "alola", "name": "Alola", "order": 1 }
    }
  ]
}
```

En la UI, cada especie se **expande** a `[base, ...formas]` (`PokemonModel.withForms`)
para mostrarlas como filas independientes, cada una con su propio estado de
captura.

---

## Sprites (assets)

Los sprites viven en carpetas declaradas a nivel de directorio en `pubspec.yaml`
(agregar un PNG nuevo **no** requiere editar `pubspec.yaml`):

| Carpeta | Uso |
|---------|-----|
| `assets/pokedex_sprites/` | Sprites normales |
| `assets/pokedex_sprites_shiny/` | Sprites shiny |
| `assets/pokedex_mega_evolutions/`, `assets/pokedex_gigantamax/` | Mega / Gigantamax |

**Convención de nombre:** `${id}.png` para la forma base y
`${id}-${formTag.id}.png` para una forma alternativa.

Ejemplo — Raichu de Alola (`formTag.id = "alola"`):

- Normal: `assets/pokedex_sprites/26-alola.png`
- Shiny: `assets/pokedex_sprites_shiny/26-alola.png`

Si falta el PNG de una forma, la UI cae automáticamente al sprite base
(`26.png`) mediante `errorBuilder`, sin romper la app.

---

## Puesta en marcha

Requisitos: Flutter SDK compatible con Dart `^3.7.2` y las credenciales de
Firebase del proyecto (`lib/firebase_options.dart` ya incluido).

```bash
flutter pub get          # instalar dependencias
flutter run              # ejecutar en el dispositivo/emulador conectado
flutter analyze          # análisis estático (lint)
flutter test             # tests
```

Regenerar el splash tras cambiar su imagen:

```bash
dart run flutter_native_splash:create
```

---

## Convenciones de código

- Lint de `flutter_lints` con **límite de 80 columnas** por línea.
- Cada capa es un `library` con archivos `part of`; los imports se centralizan en
  el archivo de la librería (`views.dart`, `widgets.dart`, `models.dart`, ...).
- Lógica compartida entre vistas se centraliza en **mixins** (p. ej.
  `PokemonListScrollMixin`, `PokemonSearchMixin`).
