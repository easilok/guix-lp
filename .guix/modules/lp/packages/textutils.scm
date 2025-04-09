(define-module (lp packages textutils)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (gnu packages julia)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages ruby)
  #:use-module (gnu packages textutils)
  #:use-module (guix download))

(define-public utf8proc-2.10.0
  (package
    (inherit utf8proc-2.7.0)
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
        (base32 "1n1k67x39sk8xnza4w1xkbgbvgb1g7w2a7j2qrqzqaw1lyilqsy2"))))
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
          ,ruby
          ,julia)))))
