-- clang-format config that mimics rustfmt's style as closely as C/C++ allows.
local clang_format = [[
---
# Base style to inherit defaults from
BasedOnStyle: LLVM


# ============================================================================
# Indentation
# ============================================================================

IndentWidth: 4
TabWidth: 4
UseTab: false

# Indent everything inside namespaces, including nested namespaces.
NamespaceIndentation: All

# Keep normal C/C++ indentation behavior inside classes/functions/etc.
IndentCaseLabels: true
IndentGotoLabels: true

# ============================================================================
# Code layout
# ============================================================================

ColumnLimit: 80
MaxEmptyLinesToKeep: 1

# ============================================================================
# Braces
# ============================================================================

BreakBeforeBraces: Custom

# BraceWrapping:
#   AfterClass: true
#   AfterControlStatement: false
#   AfterFunction: true
#   AfterNamespace: false
#   AfterStruct: false
#   AfterUnion: true
#   AfterEnum: true
#   BeforeElse: false
#   BeforeCatch: false

# ============================================================================
# Alignment
# ============================================================================

# Don't vertically align things like Rustfmt tends not to.
AlignConsecutiveAssignments: false
AlignConsecutiveDeclarations: false
AlignConsecutiveBitFields: false
AlignConsecutiveMacros: false
AlignTrailingComments: false

PointerAlignment: Left
ReferenceAlignment: Left
DerivePointerAlignment: false

# ============================================================================
# Spacing
# ============================================================================

SpaceAfterCStyleCast: false
SpaceBeforeAssignmentOperators: true
SpaceBeforeParens: ControlStatements
SpaceBeforeCpp11BracedList: false
SpaceInEmptyBlock: false

# ============================================================================
# Functions / arguments
# ============================================================================

BinPackArguments: false
BinPackParameters: false

# ============================================================================
# Short constructs
# ============================================================================

AllowShortBlocksOnASingleLine: false
AllowShortFunctionsOnASingleLine: true
AllowShortIfStatementsOnASingleLine: false
AllowShortLoopsOnASingleLine: false
AllowShortCaseLabelsOnASingleLine: false


# ============================================================================
# Includes
# ============================================================================

SortIncludes: CaseSensitive
IncludeBlocks: Regroup

# ============================================================================
# Miscellaneous
# ============================================================================

Cpp11BracedListStyle: true
ReflowComments: true
SpacesBeforeTrailingComments: 2
]]

local function bootstrap_cmake_project(project_name, project_type)
   local cwd = vim.fn.getcwd()
   local src_dir = cwd .. "/src"
   local lib_dir = cwd .. "/lib"
   local inc_dir = cwd .. "/include"
   local cmake_path = cwd .. "/CMakeLists.txt"
   local clang_format_path = cwd .. "/.clang-format"
   local main_file = src_dir .. (project_type == "cpp" and "/main.cpp" or "/main.c")

   if vim.fn.filereadable(cmake_path) == 1 then
      vim.notify("CMakeLists.txt already exists.", vim.log.levels.WARN)
      return
   end

   vim.fn.mkdir(src_dir, "p")
   vim.fn.mkdir(lib_dir, "p")
   vim.fn.mkdir(inc_dir, "p")

   -- Write main file
   local main_code = project_type == "cpp" and [[
#include <iostream>

int main() {
    std::cout << "Hello, C++ world!" << std::endl;
    return 0;
}
]] or [[
#include <stdio.h>

int main() {
    printf("Hello, C world!\n");
    return 0;
}
]]
   vim.fn.writefile(vim.fn.split(main_code, "\n"), main_file)

   -- Write CMakeLists.txt
   local lang = project_type == "cpp" and "CXX" or "C"
   local std = project_type == "cpp" and "CXX_STANDARD" or "C_STANDARD"
   local ext = project_type == "cpp" and "cpp" or "c"

   local cmake_code = string.format([[
cmake_minimum_required(VERSION 3.16)
project(%s %s)

set(CMAKE_%s 20)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS src/*.%s)
add_executable(%s ${SOURCES})
target_include_directories(%s PUBLIC include)
]], project_name, lang, std, ext, project_name, project_name)

   vim.fn.writefile(vim.fn.split(cmake_code, "\n"), cmake_path)

   -- Write .clang-format (Rust/rustfmt-inspired style)
   vim.fn.writefile(vim.fn.split(clang_format, "\n"), clang_format_path)

   vim.notify(string.format("✅ Bootstrapped %s CMake project '%s'", project_type:upper(), project_name),
      vim.log.levels.INFO)
end


local function create_gitignore(project_name)
   local gitignore_path = vim.fn.getcwd() .. "/.gitignore"
   local gitignore_code = string.format([[
   # Build artifacts
   build/
   %s
   # Generated files
   .clang-format
   CMakeLists.txt
]], project_name)
   vim.fn.writefile(vim.fn.split(gitignore_code, "\n"), gitignore_path)
end

local function init_git()
   vim.fn.system("git init")
   vim.fn.system("git add .")
   vim.fn.system("git commit -m 'chore: init CMake project via neovim'")
end

vim.api.nvim_create_user_command("CMakeInit", function(opts)
   local project = opts.fargs[1] or vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
   local type_flag = opts.fargs[2] or "c" -- default to C
   local ptype = (type_flag == "cpp" or type_flag == "cxx") and "cpp" or "c"

   bootstrap_cmake_project(project, ptype)
   create_gitignore(project)
   init_git()
end, {
   nargs = "*",
   desc = "Bootstrap a basic C or C++ CMake project. Usage: :CMakeInit [project_name] [c|cpp]",
})
