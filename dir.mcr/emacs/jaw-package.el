;; Copyright (c) 2022
;; Author: Jeff Weisberg <tcp4me.com!jaw>
;; Created: 2022-Aug-14 13:08 (EDT)
;; Function: 3rd party packages

;; see:
;;   https://github.com/radian-software/straight.el


;; bootstrap straight
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; load packages
(straight-use-package '(org :type built-in)) ; otherwise org-roam will download from github
(straight-use-package 'go-mode)
(straight-use-package 'mmm-mode)
(straight-use-package 'org-roam)
(straight-use-package 'org-present)	; left/right arrow to nav
(straight-use-package 'hide-mode-line)
(straight-use-package 'visual-fill-column)
;(straight-use-package 'org-extra-emphasis)	; dependency problem...
(straight-use-package 'magit)
; (straight-use-package 'magit-todos)
(straight-use-package 'mailcrypt)
(straight-use-package 'flycheck)
; (straight-use-package 'svg-tag-mode)
(straight-use-package 'restclient)
(straight-use-package 'ob-restclient)
(straight-use-package 'json-mode)
(straight-use-package 'gnuplot)
; (straight-use-package 'esup)
(straight-use-package 'wgrep)		; editable rgrep results
;(straight-use-package 'doremi)
;(straight-use-package 'doremi-cmd)	; "C-x t w" to resize windows
(straight-use-package 'hydra)
(straight-use-package 'zoom)		; auto-resize windows
(straight-use-package 'expand-region)	; C-=
(straight-use-package 'git-timemachine)	; scroll through git revisions
; (straight-use-package 'treemacs)
; (straight-use-package 'neotree)
; (straight-use-package 'dired-sidebar)
(straight-use-package 'dired-subtree)
(straight-use-package 'dired-filter)
;(straight-use-package 'dired+)

(straight-use-package '(scad-mode :type git :host github :repo "openscad/openscad"
                                  :files ("contrib/scad-mode.el")))


(when window-system
  (straight-use-package 'all-the-icons)
  (straight-use-package 'all-the-icons-dired)
  (straight-use-package 'all-the-icons-ibuffer)
  (straight-use-package 'minimap)
  (straight-use-package  '(ligature :type git :host github :repo "mickeynp/ligature.el")))

