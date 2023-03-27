
(when window-system
  (setq jaw-theme-light-bg-color "#ffffe8")
  (setq jaw-face-comment-font '(:font "mononoki" :height 1.15))
  (setq jaw-variable-font     '(:font "ETBembo"  :height 1.20))
  ;; embiggen tab-bar to avoid notch
  (make-face 'tab-bar-spacer)
  (set-face-attribute 'tab-bar-spacer nil :height 250))
