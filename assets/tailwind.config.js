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
  safelist: [
    'gap-2',
    'gap-1.5',
    'gap-1',
    'gap-0.5', // invalid game size
    'grid-cols-3',
    'grid-cols-4',
    'grid-cols-5',
    'grid-cols-6', // invalid game size
    'bg-[#a4deff]',
    'bg-[#f9cedf]',
    'bg-[#d3c5f1]',
    'bg-[#acc9f5]',
    'bg-[#aeeace]',
    'bg-[#96d7b9]',
    'bg-[#fce8bd]',
    'bg-[#fcd8ac]',
    'bg-[#fefbe7]', // invalid player color
    'border-[#a4deff]',
    'border-[#f9cedf]',
    'border-[#d3c5f1]',
    'border-[#acc9f5]',
    'border-[#aeeace]',
    'border-[#96d7b9]',
    'border-[#fce8bd]',
    'border-[#fcd8ac]',
    'border-[#fefbe7]', // invalid player color
    // 'border-rose-700',
    // 'border-pink-600',

    // 'text-rose-700',
    // 'text-pink-600',
    {
      pattern: /(border|text)-(rose|pink)-(6|7)00/
    }
  ],
  theme: {
    extend: {
      colors: {
        brand: '#FD4F00'
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
