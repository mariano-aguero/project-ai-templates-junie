# Tailwind CSS Guidelines

Guidelines for using Tailwind CSS with utility-first styling, responsive design, and modern CSS patterns.

## Language & Code Standards

**MANDATORY**: All code, comments, documentation, variable names, function names, and commit messages must be in **English**.

## Core Principles

- **Utility-first** - Compose designs using utility classes
- **Mobile-first responsive** - Start with mobile, scale up with breakpoints
- **Consistent spacing** - Use 4-unit spacing scale (4, 8, 12, 16, 24, 32, 48, 64)
- **Semantic colors** - Use design tokens and CSS variables
- **Performance** - Optimize with PurgeCSS and JIT mode

## Best Practices

### Component Extraction

Extract repeated patterns to reusable components instead of repeating utility classes.

### Use Logical Properties

Use logical properties for internationalization and RTL support:
- `ms-4` instead of `ml-4` (margin-inline-start)
- `me-2` instead of `mr-2` (margin-inline-end)
- `ps-4` instead of `pl-4` (padding-inline-start)
- `pe-2` instead of `pr-2` (padding-inline-end)

### Semantic Colors

Always use semantic color variables instead of hardcoded colors:
- `bg-primary` instead of `bg-blue-600`
- `text-muted-foreground` instead of `text-gray-500`
- `bg-card` instead of `bg-white`

### Consistent Spacing

Use the 4-unit spacing scale: 4, 8, 12, 16, 24, 32, 48, 64

### Responsive Design

Mobile-first approach with breakpoints:
- `sm`: 640px
- `md`: 768px
- `lg`: 1024px
- `xl`: 1280px
- `2xl`: 1536px

### Accessibility

- Use `sr-only` for screen reader only text
- Include proper focus states with `focus:ring-2`
- Support reduced motion with `motion-reduce:transition-none`

## Resources

- [Tailwind CSS Documentation](https://tailwindcss.com/docs)
- [Tailwind UI](https://tailwindui.com)
- [Headless UI](https://headlessui.com)

---

**Remember: Utility-first, Mobile-first, Performance-first!**
