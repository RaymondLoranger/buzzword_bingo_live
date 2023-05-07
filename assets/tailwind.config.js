// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require('tailwindcss/plugin')
const fs = require('fs')
const path = require('path')

module.exports = {
  content: [
    './js/**/*.js',
    '../lib/*_web.ex',
    '../lib/*_web/**/*.*ex',
    '../lib/*/{game_size,user}.ex'
  ],
  theme: {
    extend: {
      screens: {
        xs: '320px'
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
        brand: '#FD4F00',
        'cool-gray': {
          50: '#f8fafc',
          100: '#f1f5f9',
          200: '#e2e8f0',
          300: '#cfd8e3',
          400: '#97a6ba',
          500: '#64748b',
          600: '#475569',
          700: '#364152',
          800: '#27303f',
          900: '#1a202e'
        },
        deluge: {
          light: '#a48fbc',
          DEFAULT: '#8064A2',
          dark: '#634d80'
        },
        'carrot-orange': {
          light: '#f3b359',
          DEFAULT: '#ee961b',
          dark: '#d58310'
        },
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
    plugin(({ addVariant }) => addVariant('phx-0', '&[phx-0]')),
    plugin(({ addVariant }) => addVariant('phx-1', '&[phx-1]')),
    plugin(({ addVariant }) => addVariant('phx-2', '&[phx-2]')),
    plugin(({ addVariant }) => addVariant('phx-3', '&[phx-3]')),
    plugin(({ addVariant }) => addVariant('phx-4', '&[phx-4]')),
    plugin(({ addVariant }) => addVariant('phx-5', '&[phx-5]')),
    plugin(({ addVariant }) => addVariant('phx-6', '&[phx-6]')),
    plugin(({ addVariant }) => addVariant('phx-7', '&[phx-7]')),
    plugin(({ addVariant }) => addVariant('phx-8', '&[phx-8]')),

    // Embeds Hero Icons (https://heroicons.com) into your app.css bundle
    // See your `CoreComponents.icon/1` for more information.
    //
    plugin(function ({ matchComponents, theme }) {
      let iconsDir = path.join(__dirname, './vendor/heroicons/optimized')
      let values = {}
      let icons = [
        ['', '/24/outline'],
        ['-solid', '/24/solid'],
        ['-mini', '/20/solid']
      ]
      icons.forEach(([suffix, dir]) => {
        fs.readdirSync(path.join(iconsDir, dir)).map((file) => {
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
            return {
              [`--hero-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
              '-webkit-mask': `var(--hero-${name})`,
              mask: `var(--hero-${name})`,
              'background-color': 'currentColor',
              'vertical-align': 'middle',
              display: 'inline-block',
              width: theme('spacing.5'),
              height: theme('spacing.5')
            }
          }
        },
        { values }
      )
    })
  ]
}
