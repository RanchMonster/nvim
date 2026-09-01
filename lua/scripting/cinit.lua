-- clang-format config that mimics rustfmt's style as closely as C/C++ allows.
local clang_format = [[
---
# Closest approximation of rustfmt's defaults for C/C++ code.
BasedOnStyle: LLVM
IndentWidth: 4
TabWidth: 4
UseTab: Never
ColumnLimit: 100
ContinuationIndentWidth: 4
BreakBeforeBraces: Custom
BraceWrapping:
  AfterCaseLabel: false
  AfterClass: false
  AfterControlStatement: Never
  AfterEnum: false
  AfterFunction: false
  AfterNamespace: true
  AfterObjCDeclaration: false
  AfterStruct: false
  AfterUnion: false
  BeforeCatch: false
  BeforeElse: false
  BeforeLambdaBody: false
  IndentBraces: false
  SplitEmptyFunction: false
  SplitEmptyRecord: false
AllowShortFunctionsOnASingleLine: Empty
AllowShortIfStatementsOnASingleLine: Never
AllowShortLoopsOnASingleLine: false
AllowShortCaseLabelsOnASingleLine: false
BinPackArguments: false
BinPackParameters: false
AllowAllArgumentsOnNextLine: true
AllowAllParametersOfDeclarationOnNextLine: true
AllowAllConstructorInitializersOnNextLine: true
AlignAfterOpenBracket: BlockIndent
IndentCaseLabels: true
PointerAlignment: Right
DerivePointerAlignment: false
SortIncludes: CaseSensitive
]]

local function bootstrap_cmake_project(project_name, project_type)
   local cwd = vim.fn.getcwd()
   local src_dir = cwd .. "/src"
   local cmake_path = cwd .. "/CMakeLists.txt"
   local clang_format_path = cwd .. "/.clang-format"
   local main_file = src_dir .. (project_type == "cpp" and "/main.cpp" or "/main.c")

   if vim.fn.filereadable(cmake_path) == 1 then
      vim.notify("CMakeLists.txt already exists.", vim.log.levels.WARN)
      return
   end

   vim.fn.mkdir(src_dir, "p")

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
]], project_name, lang, std, ext, project_name)

   vim.fn.writefile(vim.fn.split(cmake_code, "\n"), cmake_path)

   -- Write .clang-format (Rust/rustfmt-inspired style)
   vim.fn.writefile(vim.fn.split(clang_format, "\n"), clang_format_path)

   vim.notify(string.format("✅ Bootstrapped %s CMake project '%s'", project_type:upper(), project_name),
      vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("CMakeInit", function(opts)
   local project = opts.fargs[1] or vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
   local type_flag = opts.fargs[2] or "c" -- default to C
   local ptype = (type_flag == "cpp" or type_flag == "cxx") and "cpp" or "c"

   bootstrap_cmake_project(project, ptype)
end, {
   nargs = "*",
   desc = "Bootstrap a basic C or C++ CMake project. Usage: :CMakeInit [project_name] [c|cpp]",
})
vim.api.nvim_create_user_command("CBuild", function(opts)
   local build_cmd = "cmake --build . --config Debug"
   vim.fn.jobstart(build_cmd, {
      on_stdout = function(_, data)
         print(data)
      end,
      on_stderr = function(_, data)
         print(data)
      end,
      on_exit = function(_, code)
         if code == 0 then
            vim.notify("✅ Built successfully.", vim.log.levels.INFO)
         else
            vim.notify("❌ Build failed.", vim.log.levels.ERROR)
         end
      end,
   })
end, {
   desc = "Build the current CMake project.",
})
