---
description: How to access and use Figma designs using the MCP server
---

# Figma MCP Server Workflow

When the user mentions "Figma" or provides a Figma URL, **always use the Figma MCP server tools** to access their designs.

## Available MCP Tools

1. **`mcp_figma-local-server_get_figma_data`** - Get comprehensive Figma file data including layout, content, visuals, and component information
   - `fileKey`: Extract from URL (e.g., `fCr8sRky8onhCMz3IVVaMA` from `figma.com/design/fCr8sRky8onhCMz3IVVaMA/...`)
   - `nodeId`: Extract from URL parameter `node-id` (e.g., `3-787` from `node-id=3-787`)

2. **`mcp_figma-local-server_download_figma_images`** - Download SVG and PNG images from a Figma file
   - Use this to download icons, images, or assets for implementation

## URL Parsing

Figma URLs follow this pattern:
```
https://www.figma.com/design/<fileKey>/<ProjectName>?node-id=<nodeId>&...
```

Examples:
- File key: `fCr8sRky8onhCMz3IVVaMA`
- Node ID: `3-787` (convert from `3-787` format)

## Default Project

The user's primary Figma project is **PTG (Pakistan Tourism Guide)**:
- File Key: `fCr8sRky8onhCMz3IVVaMA`

## Workflow Steps

1. **If user provides a Figma URL**: Parse the `fileKey` and `nodeId` from the URL
2. **If user mentions a screen name**: Use the default project file key and search for the node
3. **Always call** `mcp_figma-local-server_get_figma_data` first to retrieve the design data
4. **If implementation is needed**: Download images using `mcp_figma-local-server_download_figma_images`
5. **Present the design structure** to the user before implementing

## Implementation Guidelines

When implementing Figma designs in Flutter:
- Extract colors, typography, and spacing from the design tokens
- Use the component hierarchy to structure Flutter widgets
- Download and save images to `assets/images/` directory
- Follow the project's clean architecture pattern
