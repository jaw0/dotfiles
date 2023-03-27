
;; under x, Fira won't italicize. use a different font
(when (>= emacs-major-version 28)
  (setq jaw-default-font      "Fira Code-8")
  (setq jaw-face-comment-font '(:font "mononoki" :height 1.15))
  (setq jaw-italic-font       "mononoki-9"))


;; "Fira Code-8" "ProggyCrossed-8"
;; "Source Code Pro-9" "JetBrains Mono-8"
;; "mononoki-10" "Hack-8" "Lotion-10"
;; "Victor Mono-9:weight=semi-bold" "6x13"

