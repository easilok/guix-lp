(define-module (lp packages nvim)
  #:use-module (lp packages tree-sitter)
  #:use-module (lp packages textutils)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages gperf)
  #:use-module (gnu packages jemalloc)
  #:use-module (gnu packages libevent)
  #:use-module (gnu packages lua)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages serialization)
  #:use-module (gnu packages terminals)
  #:use-module (gnu packages textutils)
  #:use-module (gnu packages vim)
  #:use-module (guix build-system cmake)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  )

(define-public neovim-0.11.0
  (package
    (name "neovim")
    (version "0.11.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/neovim/neovim")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1z7xmngjr93dc52k8d3r6x0ivznpa8jbdrw24gqm16lg9gzvma02"))))
    (build-system cmake-build-system)
    (arguments
     (list #:modules
           '((srfi srfi-26) (guix build cmake-build-system)
             (guix build utils))
           #:configure-flags
           #~(list #$@(if (member (if (%current-target-system)
                                      (gnu-triplet->nix-system (%current-target-system))
                                      (%current-system))
                                  (package-supported-systems luajit))
                          '()
                          '("-DPREFER_LUA:BOOL=YES")))
           #:phases
           #~(modify-phases %standard-phases
               (add-after 'unpack 'set-lua-paths
                 (lambda* _
                   (let* ((lua-version "5.1")
                          (lua-cpath-spec (lambda (prefix)
                                            (let ((path (string-append
                                                         prefix
                                                         "/lib/lua/"
                                                         lua-version)))
                                              (string-append
                                               path
                                               "/?.so;"
                                               path
                                               "/?/?.so"))))
                          (lua-path-spec (lambda (prefix)
                                           (let ((path (string-append prefix
                                                        "/share/lua/"
                                                        lua-version)))
                                             (string-append path "/?.lua;"
                                                            path "/?/?.lua"))))
                          (lua-inputs (list (or #$(this-package-input "lua")
                                                #$(this-package-input "luajit"))
                                            #$lua5.1-luv
                                            #$lua5.1-lpeg
                                            #$lua5.1-bitop
                                            #$lua5.1-libmpack)))
                     (setenv "LUA_PATH"
                             (string-join (map lua-path-spec lua-inputs) ";"))
                     (setenv "LUA_CPATH"
                             (string-join (map lua-cpath-spec lua-inputs) ";"))
                     #t)))
               (add-after 'unpack 'prevent-embedding-gcc-store-path
                 (lambda _
                   ;; nvim remembers its build options, including the compiler with
                   ;; its complete path.  This adds gcc to the closure of nvim, which
                   ;; doubles its size.  We remove the reference here.
                   (substitute* "cmake.config/versiondef.h.in"
                     (("\\$\\{CMAKE_C_COMPILER\\}") "/gnu/store/.../bin/gcc"))
                   #t)))))
    (inputs (list libuv-for-luv
                  msgpack
                  libtermkey
                  libvterm
                  unibilium
                  jemalloc
                  (if (member (if (%current-target-system)
                                  (gnu-triplet->nix-system (%current-target-system))
                                  (%current-system))
                              (package-supported-systems luajit))
                      luajit
                      lua-5.1)
                  lua5.1-luv
                  lua5.1-lpeg
                  lua5.1-bitop
                  lua5.1-libmpack
                  tree-sitter-0.25.3
                  utf8proc-2.10.0))
    (native-inputs (list pkg-config gettext-minimal gperf))
    (home-page "https://neovim.io")
    (synopsis "Fork of vim focused on extensibility and agility")
    (description
     "Neovim is a project that seeks to aggressively
refactor Vim in order to:

@itemize
@item Simplify maintenance and encourage contributions
@item Split the work between multiple developers
@item Enable advanced external UIs without modifications to the core
@item Improve extensibility with a new plugin architecture
@end itemize
")
    ;; Neovim is licensed under the terms of the Apache 2.0 license,
    ;; except for parts that were contributed under the Vim license.
    (license (list license:asl2.0 license:vim))))
