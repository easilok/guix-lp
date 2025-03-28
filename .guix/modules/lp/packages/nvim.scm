(define-module (lp packages nvim)
  #:use-module (lp packages tree-sitter)
  #:use-module (lp packages textutils)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (gnu packages textutils)
  #:use-module (gnu packages vim))

(define-public nvim-0.10.4
  (package
    (inherit neovim)
    (name "neovim")
    (version "0.10.4")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/neovim/neovim")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "007v6aq4kdwcshlp8csnp12cx8c0yq8yh373i916ddqnjdajn3z3"))))
    (inputs (modify-inputs
              (package-inputs neovim)
              (replace "tree-sitter" tree-sitter-0.24.7)))))

(define-public nvim-0.11.0
  (package
    (inherit neovim)
    (name "neovim")
    (version "0.11.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/neovim/neovim")
                    (commit "a99c469e547fc59472d6d105c0fae323958297a1")))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1z7xmngjr93dc52k8d3r6x0ivznpa8jbdrw24gqm16lg9gzvma02"))))
    (inputs (modify-inputs
              (package-inputs neovim)
              (replace "tree-sitter" tree-sitter-0.25.3)
              (append utf8proc-2.10.0)))))

