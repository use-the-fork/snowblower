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
          { text: 'Getting Started', link: '/getting-started' },
        ]
      },
      {
        text: 'Core Features',
        items: [
          { text: 'Just Commands', link: '/just' },
          { text: 'Integrations', link: '/integrations/', items: [
              { text: 'Overview', link: '/integrations/' },
              { text: 'Agenix', link: '/integrations/agenix' },
              { text: 'Convco', link: '/integrations/convco' },
              { text: 'Dotenv', link: '/dotenv/' },
              { text: 'Git Cliff', link: '/integrations/git-cliff' },
              { text: 'Git Hooks', link: '/integrations/git-hooks' },
              { text: 'Treefmt', link: '/integrations/treefmt' }
            ] },
          { text: 'Languages', link: '/languages/', items: [
            { text: 'Overview', link: '/languages/' },
            { text: 'Java', link: '/languages/java' },
            { text: 'JavaScript', link: '/languages/javascript' },
            { text: 'PHP', link: '/languages/php' },
            { text: 'Python', link: '/languages/python' },
            { text: 'Ruby', link: '/languages/ruby' }
          ] },
          { text: 'Services', link: '/services/', items: [
            { text: 'Overview', link: '/services/' },
            { text: 'Adminer', link: '/services/adminer' },
            { text: 'Aider', link: '/services/aider' },
            { text: 'Blackfire', link: '/services/blackfire' },
            { text: 'Elasticsearch', link: '/services/elasticsearch' },
            { text: 'Memcached', link: '/services/memcached' },
            { text: 'MySQL', link: '/services/mysql' },
            { text: 'Redis', link: '/services/redis' },
            { text: 'Supervisord', link: '/services/supervisord' }
          ] },
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
