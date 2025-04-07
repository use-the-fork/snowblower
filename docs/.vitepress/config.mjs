import { defineConfig } from 'vitepress'

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "Snow Blower",
  description: "A Nix-based development environment manager",
  
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    nav: [
      { text: 'Home', link: '/' },
      { text: 'Guide', link: '/integrations' }
    ],

    sidebar: [
      {
        text: 'Getting Started',
        items: [
          { text: 'Introduction', link: '/' },
          { text: 'Integrations', link: '/integrations' }
        ]
      },
      {
        text: 'Core Features',
        items: [
          { text: 'Just Commands', link: '/just' },
          { text: 'Languages', link: '/languages' },
          { text: 'Services', link: '/services' },
          { text: 'Scripts', link: '/scripts' },
          { text: 'Processes', link: '/processes' }
        ]
      },
      {
        text: 'Examples',
        items: [
          { text: 'Template Example', link: '/template-example' }
        ]
      }
    ],

    socialLinks: [
      { icon: 'github', link: 'https://github.com/snowblower/snow-blower' }
    ],

    footer: {
      message: 'Released under the MIT License.',
      copyright: 'Copyright © 2023-present Snow Blower Contributors'
    },

    search: {
      provider: 'local'
    }
  }
})
