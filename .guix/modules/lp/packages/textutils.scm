(define-module (lp packages textutils)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages ruby)
  #:use-module (gnu packages textutils)
  #:use-module (guix build-system gnu)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix utils))

(define-public utf8proc-2.10.0
  (package
    (name "utf8proc")
    (version "2.10.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/JuliaStrings/utf8proc")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1n1k67x39sk8xnza4w1xkbgbvgb1g7w2a7j2qrqzqaw1lyilqsy2"))
       (patches `(".guix/modules/lp/packages/patches/utf8proc-2.10.0-remove-julia-dependency.patch"))))
    (build-system gnu-build-system)
    (native-inputs
      (let ((UNICODE_VERSION "16.0.0"))
        `(,(origin
             (method url-fetch)
             (uri (string-append "https://www.unicode.org/Public/"
                                 UNICODE_VERSION "/ucd/DerivedCoreProperties.txt"))
             (sha256
               (base32 "1gfsq4vdmzi803i2s8ih7mm4fgs907kvkg88kvv9fi4my9hm3lrr")))
          ,(origin
             (method url-fetch)
             (uri (string-append "https://www.unicode.org/Public/"
                                 UNICODE_VERSION "/ucd/NormalizationTest.txt"))
             (sha256
              (base32 "1cffwlxgn6sawxb627xqaw3shnnfxq0v7cbgsld5w1z7aca9f4fq")))
          ,(origin
             (method url-fetch)
             (uri (string-append "https://www.unicode.org/Public/"
                                 UNICODE_VERSION
                                 "/ucd/auxiliary/GraphemeBreakTest.txt"))
             (sha256
              (base32 "1d9w6vdfxakjpp38qjvhgvbl2qx0zv5655ph54dhdb3hs9a96azf")))
          ;; For tests
          ,perl
          ,ruby)))
    (arguments
      `(#:make-flags (list ,(string-append "CC=" (cc-for-target))
                           (string-append "prefix=" (assoc-ref %outputs "out")))
        #:phases
        (modify-phases %standard-phases
         (delete 'configure)
         (add-before 'check 'remove-julia
                     (lambda _
                       (substitute* "data/Makefile"
                                    (("^\\$\\(JULIA\\).*Uppercase.*") "\\$\\(RUBY\\) -e 'puts File.read\\(\"DerivedCoreProperties.txt\"\\)\\[/# Derived Property: Uppercase\\.\\*\\?# Total code points:/m\\]' > \\$@"))
                       #t))
         (add-before 'check 'check-data
             (lambda* (#:key inputs native-inputs #:allow-other-keys)
               (for-each (lambda (i)
                           (copy-file (assoc-ref (or native-inputs inputs) i)
                                      (string-append "data/" i)))
                         '("NormalizationTest.txt" "GraphemeBreakTest.txt"
                           "DerivedCoreProperties.txt")))))))
    (home-page "https://juliastrings.github.io/utf8proc/")
    (synopsis "C library for processing UTF-8 Unicode data")
    (description "utf8proc is a small C library that provides Unicode
normalization, case-folding, and other operations for data in the UTF-8
encoding, supporting Unicode version 9.0.0.")
    (license license:expat)))
