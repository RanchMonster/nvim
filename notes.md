# Neovim DAP Configuration Improvements

This document summarizes the changes made to your Neovim Debug Adapter Protocol (DAP) configuration, focusing on improving modularity, correctness, and introducing project-level debugging capabilities.

## Summary of Changes

1.  **Centralized Plugin Configuration:**
    *   The core DAP setup, including plugin dependencies (`nvim-dap`, `nvim-dap-ui`, `nvim-dap-virtual-text`, `mason-nvim-dap.nvim`), global adapters (Python, CodeLLDB, Node.js), and default configurations, is now consolidated into `lua/config/plugins/dap.lua`.
    *   This file now serves as the single entry point for `lazy.nvim` to manage your DAP setup.
    *   The old `lua/config/DAP/nvim-debug-config.lua` file has been removed.

2.  **Correct Initialization Order:**
    *   A critical fix addresses the timing of loading project-specific configurations. The `project_loader` is now called using `vim.defer_fn` *after* `nvim-dap` has been fully initialized. This ensures that any configurations you define at the project level correctly merge with the global DAP settings.

3.  **Refactored Project-Level Configurations:**
    *   The `lua/config/DAP/project_loader.lua` file has been completely rewritten.
    *   It is now solely responsible for finding and merging project-specific debug configurations.
    *   It no longer defines global adapters or default configurations, avoiding redundancy and potential conflicts.
    *   It supports loading configurations from two common project-level files:
        *   `.nvim/dap.lua` (preferred for Neovim-native Lua configurations)
        *   `.vscode/launch.json` (for compatibility with projects already configured for VSCode debugging)
    *   Basic handling for comments in `.vscode/launch.json` has been added.
    *   The use of `loadfile` with a limited environment for Lua files improves security slightly over `dofile`.

4.  **Cleaned-up Rust Configuration:**
    *   The default Rust configuration in `lua/config/plugins/dap.lua` has been simplified, removing redundant keys and using a more straightforward approach for building the project if the executable is not found.

## How to Use Project-Level Configurations

You can now define debug configurations that are specific to a particular project by creating one of the following files in the project's root directory:

*   **For Neovim-native Lua configurations (`.nvim/dap.lua`):**

    Create a file named `.nvim/dap.lua` in your project's root. This file should `return` a table containing `adapters` and/or `configurations`, which will be merged into the global DAP settings.

    **Example (`/path/to/your/project/.nvim/dap.lua`):**

    ```lua
    -- in /path/to/your/project/.nvim/dap.lua
    return {
      -- You can define project-specific adapters here if needed,
      -- but usually, global adapters are sufficient.
      -- adapters = {
      --   my_custom_adapter = { ... },
      -- },

      configurations = {
        -- Add configurations for specific filetypes
        python = {
          {
            name = "Run Current Python File (Project Specific)",
            type = "python",
            request = "launch",
            program = "${file}", -- Debugs the current file
            console = "integratedTerminal",
            justMyCode = false, -- Often useful for debugging project code
          },
          {
            name = "Attach to remote debugger",
            type = "python",
            request = "attach",
            connect = {
                host = "localhost",
                port = 5678,
            },
          },
        },
        -- You can add configurations for other filetypes (e.g., 'rust', 'javascript')
        -- rust = {
        --   {
        --     name = "Run Project Tests",
        --     type = "codelldb",
        --     request = "launch",
        --     program = "cargo test",
        --     cwd = "${workspaceFolder}",
        --   },
        -- },
      },
    }
    ```

*   **For VSCode-compatible JSON configurations (`.vscode/launch.json`):**

    If your project already has a `.vscode/launch.json` file, it will be automatically detected and its configurations merged.

    **Example (`/path/to/your/project/.vscode/launch.json`):**

    ```json
    {
        "version": "0.2.0",
        "configurations": [
            {
                "name": "Launch via Node (VSCode Example)",
                "type": "node",
                "request": "launch",
                "program": "${workspaceFolder}/src/app.js",
                "cwd": "${workspaceFolder}",
                "skipFiles": [
                    "<node_internals>/**"
                ]
            },
            {
                "name": "Python: Current File (VSCode Example)",
                "type": "python",
                "request": "launch",
                "program": "${file}",
                "console": "integratedTerminal"
            }
        ]
    }
    ```

When you open Neovim in a project directory containing one of these files, the configurations defined within them will be automatically added to your available DAP configurations, alongside your global defaults. This allows you to tailor your debugging experience specifically for each project.
