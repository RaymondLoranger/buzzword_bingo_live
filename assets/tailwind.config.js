// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require('tailwindcss/plugin')
const fs = require('fs')
const path = require('path')

module.exports = {
  content: [
    './js/**/*.js',
    '../lib/buzzword_bingo_live_web.ex',
    '../lib/buzzword_bingo_live_web/**/*.*ex',
    '../lib/*/{game_size,user}.ex'
  ],
  theme: {
    extend: {
      screens: {
        xs: '320px'
      },
      keyframes: {
        'open-menu': {
          '0%': { transform: 'scaleY(0)' },
          '80%': { transform: 'scaleY(1.2)' },
          '100%': { transform: 'scaleY(1)' }
        }
      },
      animation: {
        'open-menu': 'open-menu 0.5s ease-in-out forwards'
      },
      letterSpacing: {
        tightest: '-.075em'
      },
      fontSize: {
        '2xs': ['0.625rem', '0.875rem'],
        '3xs': ['0.5rem', '0.75rem']
      },
      backgroundImage: {
        tapestry: "url('/images/tapestry.svg')"
      },
      colors: {
        // Orange color used on the home landing page...
        brand: '#FD4F00',
        // Color of unmarked squares when hovered over...
        wheatfield: {
          light: '#f9faeb',
          DEFAULT: '#f3f4d4',
          dark: '#e2e59a'
        },
        // Panel color...
        deluge: {
          light: '#a48fbc',
          DEFAULT: '#8064A2',
          dark: '#634d80'
        },
        // Button color and more...
        'carrot-orange': {
          light: '#f3b359',
          DEFAULT: '#ee961b',
          dark: '#d58310'
        },
        // Colors for 'Buzzword Bingo' letters...
        'mine-shaft': {
          light: '#808080',
          DEFAULT: '#292929',
          dark: '#1a1a1a'
        },
        silver: {
          light: '#f2f2f2',
          DEFAULT: '#cccccc',
          dark: '#8c8c8c'
        },
        denim: {
          light: '#129ded',
          DEFAULT: '#0d72ad',
          dark: '#094e77'
        },
        tundora: {
          light: '#737373',
          DEFAULT: '#414141',
          dark: '#1a1a1a'
        },
        'half-baked': {
          light: '#a3c7dc',
          DEFAULT: '#7fb1ce',
          dark: '#3f81a6'
        },
        // Color of grid glyphs...
        wedgewood: {
          light: '#77a3bb',
          DEFAULT: '#4f819c',
          dark: '#335466'
        }
      }
    }
  },
  plugins: [
    require('@tailwindcss/forms'),
    // Allows prefixing tailwind classes with LiveView classes to add rules
    // only when LiveView classes are applied, for example:
    //
    //     <div class="phx-click-loading:animate-ping">
    //
    plugin(({ addVariant }) =>
      addVariant('phx-no-feedback', ['.phx-no-feedback&', '.phx-no-feedback &'])
    ),
    plugin(({ addVariant }) =>
      addVariant('phx-click-loading', [
        '.phx-click-loading&',
        '.phx-click-loading &'
      ])
    ),
    plugin(({ addVariant }) =>
      addVariant('phx-submit-loading', [
        '.phx-submit-loading&',
        '.phx-submit-loading &'
      ])
    ),
    plugin(({ addVariant }) =>
      addVariant('phx-change-loading', [
        '.phx-change-loading&',
        '.phx-change-loading &'
      ])
    ),
    // Generic variants...
    plugin(({ addVariant }) => addVariant('phx-1', '&[phx-1]')),
    plugin(({ addVariant }) => addVariant('phx-2', '&[phx-2]')),
    plugin(({ addVariant }) => addVariant('phx-3', '&[phx-3]')),
    plugin(({ addVariant }) => addVariant('phx-4', '&[phx-4]')),
    plugin(({ addVariant }) => addVariant('phx-5', '&[phx-5]')),
    plugin(({ addVariant }) => addVariant('phx-6', '&[phx-6]')),
    plugin(({ addVariant }) => addVariant('phx-7', '&[phx-7]')),
    plugin(({ addVariant }) => addVariant('phx-8', '&[phx-8]')),
    plugin(({ addVariant }) => addVariant('phx-9', '&[phx-9]')),

    // Embeds Heroicons (https://heroicons.com) into your app.css bundle
    // See your `CoreComponents.icon/1` for more information.
    //
    plugin(function ({ matchComponents, theme }) {
      let iconsDir = path.join(__dirname, './vendor/heroicons/optimized')
      let values = {}
      let icons = [
        ['', '/24/outline'],
        ['-solid', '/24/solid'],
        ['-mini', '/20/solid'],
        ['-micro', '/16/solid']
      ]
      icons.forEach(([suffix, dir]) => {
        fs.readdirSync(path.join(iconsDir, dir)).forEach((file) => {
          let name = path.basename(file, '.svg') + suffix
          values[name] = { name, fullPath: path.join(iconsDir, dir, file) }
        })
      })
      matchComponents(
        {
          hero: ({ name, fullPath }) => {
            let content = fs
              .readFileSync(fullPath)
              .toString()
              .replace(/\r?\n|\r/g, '')
            let size = theme('spacing.6')
            if (name.endsWith('-mini')) {
              size = theme('spacing.5')
            } else if (name.endsWith('-micro')) {
              size = theme('spacing.4')
            }
            return {
              [`--hero-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
              '-webkit-mask': `var(--hero-${name})`,
              mask: `var(--hero-${name})`,
              'mask-repeat': 'no-repeat',
              'background-color': 'currentColor',
              'vertical-align': 'middle',
              display: 'inline-block',
              width: size,
              height: size
            }
          }
        },
        { values }
      )
    })
  ]
}
