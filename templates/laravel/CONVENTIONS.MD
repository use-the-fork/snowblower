# Aider and AI Coding Conventions

## Folder Structure:
root
├── docs
├── app
│   └── domain
│       ├── HTTP
│       ├── Jobs
│       ├── Models
│       └── DomainServiceProvider.php
├── public
├── resources
│   └── js
│       ├── favicon.ico
│       ├── globals.css
│       ├── layout.tsx
│       ├── page.tsx
│       └── components
│           ├── ui
│           ├── hooks
│           └── lib
├── .env
├── .env.local
├── next.config.mjs
├── package.json
├── README.md
├── tailwind.config.ts
└── tsconfig.json

## Conventions:
### Cross Language
- README/DOCS: Keep setup/use instructions current.
- Comments: Only when necessary. Explain complex logic; avoid obvious comments. Keep comments current.
- Naming: Use clear, consistent names. Names should show intent.

### PHP / Laravel
- DRY: Avoid duplication; use functions/modules.
- Use PEST as the testing framework.
- Use strict_types everywhere possible.
- Keep classes and functions documented using PHPDOC Format
- API Docs: Document public APIs clearly.
- Use Domain Driven Architecture.

### TSX / Vite
- Assume all ShadCN components are installed and available to use
- Use ShadCN components and lucide-react icons wherever possible
- Use tailwind
- Use Zod for type inference and validation where appropriate
