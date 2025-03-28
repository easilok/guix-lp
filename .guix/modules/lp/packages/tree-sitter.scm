(define-module (lp packages tree-sitter)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (gnu packages tree-sitter))

(define-public tree-sitter-0.24.7
  (package
    (inherit tree-sitter)
    (name "tree-sitter")
    (version "0.24.7")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/tree-sitter/tree-sitter")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1shg4ylvshs9bf42l8zyskfbkpzpssj6fhi3xv1incvpcs2c1fcw"))))))

(define-public tree-sitter-cli-0.24.7
  (package
    (inherit tree-sitter-cli)
    (name "tree-sitter-cli")
    (version "0.24.7")
    (inputs (modify-inputs
              (package-inputs tree-sitter-cli)
              (replace "tree-sitter" tree-sitter-0.24.7)))))

(define-public tree-sitter-0.25.3
  (package
    (inherit tree-sitter)
    (name "tree-sitter")
    (version "0.25.3")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/tree-sitter/tree-sitter")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                 "0cck2wa17figxww7lb508sgwy9sbyqj89vxci07hiscr5sgdx9y5"))))))

(define-public tree-sitter-cli-0.25.3
  (package
    (inherit tree-sitter-cli)
    (name "tree-sitter-cli-")
    (version "0.25.3")
    (inputs (modify-inputs
              (package-inputs tree-sitter-cli)
              (replace "tree-sitter" tree-sitter-0.25.3)))))
