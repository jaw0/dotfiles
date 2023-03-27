;; -*- mode: emacs-lisp; -*-
;; Copyright (c) Jeff Weisberg
;; Author: Jeff Weisberg <jaw @ tcp4me.com>
;; Created: 1991-Oct
;; Function: dot emacs

(setq load-path (cons
		 (expand-file-name "~/mcr/emacs")
		 load-path))

;; load host specific config: "jaw-init-magoo1.el"
(load (concat "jaw-init-" (car (split-string system-name "\\."))) :noerror)
(load "jaw-init-localhost" :noerror)

;; load 3rd party packages
(load "jaw-package")

(require 'ispell)
(require 'flyspell)
(require 'generic-x)	; simple mode for various special files
(require 'cc-styles)

(setq org-default-notes-file (expand-file-name  "~/.note-log.org"))
(setq org-agenda-files (list org-default-notes-file))


(menu-bar-mode   -1)
(show-paren-mode 1)
(global-flycheck-mode 1)

(add-hook 'text-mode-hook (lambda ()
			    (local-set-key "\t" 'tab-to-tab-stop)
                            (setq-local indent-line-function 'indent-to-left-margin)
                            (if (not (eq window-system 'x))
                                (flyspell-mode))))

(add-hook 'org-mode-hook (lambda ()
                           ;; don't highlight plain urls
                           (setq  org-highlight-links (remove 'plain org-highlight-links))
                           ;; remove = as =emphasis=, so it can be used as a horiz line
                           ;;(setq org-emphasis-alist (delq (assoc "=" org-emphasis-alist) org-emphasis-alist))
                           (add-to-list 'org-emphasis-alist '("=" org-warning))
                           ;; restore default behavior
			   (local-set-key "\t" 'org-cycle)))

(add-hook 'org-present-mode-hook (lambda ()
                                   (setq visual-fill-column-width 120)
                                   (setq visual-fill-column-center-text t)
                                   (setq org-hide-emphasis-markers t)
                                   (org-display-inline-images nil t)
                                   (flyspell-mode -1)
                                   (hide-mode-line-mode t)
                                   (visual-fill-column-mode t)))

(add-hook 'org-present-mode-quit-hook (lambda ()
                                        (setq org-hide-emphasis-markers nil)
                                        (hide-mode-line-mode -1)
                                        (visual-fill-column-mode -1)))


(add-hook 'nroff-mode-hook (lambda ()
			     (define-key nroff-mode-map "\C-c\\" 'insert-nroff-comment)))

(add-hook 'go-mode-hook (lambda ()
                          (local-unset-key "\C-c\C-a")))

(add-hook 'prog-mode-hook (lambda ()
                            (jaw-highlight-keyword-tags)
			    (local-set-key "\C-c\C-t" 'jaw-insert-todo-comment)))

(dolist (hook '(term-mode-hook shell-mode-hook calendar-mode-hook Buffer-menu-mode-hook
                               eshell-mode-hook compilation-mode-hook))
  (add-hook hook (lambda ()
                   (setq show-trailing-whitespace nil))))


(add-hook 'dired-mode-hook (lambda ()
                             (hl-line-mode)
                             ;; replace the ridiculous lighter
                             (if (boundp 'all-the-icons-dired-mode)
                               (setcar (cdr (assq 'all-the-icons-dired-mode  minor-mode-alist))
                                       (if (jaw-is-mac-ws) " 🅐" " @")))
                             (define-key dired-mode-map "\t" 'dired-subtree-toggle)
                             (define-key dired-mode-map "/"  dired-filter-map)
                             ;; ^ + <ret> -> open in same buffer
                             ;; disable mouse click to open directory
                             (setq-local mouse-1-click-follows-link nil)))

(add-hook 'dired-hide-details-mode-hook 'jaw-zoom-update)
(add-hook 'calendar-today-visible-hook 'calendar-mark-today)
(add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)

(when window-system
  (add-hook 'ibuffer-mode-hook #'all-the-icons-ibuffer-mode))

(when (>= emacs-major-version 25)
  (add-hook 'before-save-hook 'gofmt-before-save))

(when (>= emacs-major-version 21)
  (set-default-coding-systems 'utf-8)
  (set-language-environment "UTF-8"))

(when (>= emacs-major-version 22)
  ;; these bindings were removed in 22
  (global-set-key "\C-x/" 'point-to-register)
  (global-set-key "\C-xj" 'jump-to-register))


;; load more
(load "jaw-info")
(load "jaw-funcs")
(load "jaw-filters")
(load "jaw-mode")
(load "jaw-mason")
(load "jaw-email")
(load "jaw-eshell")
(load "jaw-dba")


; load up the proper set of stuff
(if (or (eq window-system 'x )  (eq window-system 'ns ) (eq window-system 'mac ))
    (load "jaw-xwin")
  (load "jaw-vt100"))

(when (>= emacs-major-version 27)
  (load "jaw-theme")
  (if window-system
      (enable-theme 'jaw-theme-light)
    (enable-theme 'jaw-theme-terminal)))


(setq bookmark-save-flag 5)
(setq calendar-latitude 40)
(setq calendar-longitude -75)
(setq calendar-location-name "Philadelphia, PA")
(setq mark-holidays-in-calendar t)

(setq c-default-style "stroustrup")

(defalias 'perl-mode 'cperl-mode)
(setq cperl-invalid-face nil)
(setq cperl-indent-parens-as-block t)
(setq cperl-indent-level 4)

;; NB - most 'default-*' were changed in 26
(if (>= emacs-major-version 26)
    (setq-default major-mode 'text-mode)
  (setq default-major-mode 'text-mode))

(setq tramp-terminal-type "tramp")
(setq comint-terminfo-terminal "dumb-emacs-ansi")
(setq flyspell-issue-message-flag nil)
(setq vc-cvs-stay-local nil)
(setq make-backup-files nil)
(setq enable-local-variables  t)      ; 1 = ask first
(setq calc-display-trail nil)
(setq org-log-done t)
(setq org-log-into-drawer t)
(setq org-pretty-entities t)	; \alpha see also: org-entities-help
(setq-default indent-tabs-mode nil)
(setq-default show-trailing-whitespace t)
(setq display-time-mail-file "NoSuchFile") ; I don't want you telling me
(setq display-time-day-and-date t)
(setq display-time-24hr-format t)
(setq display-time-format "%a %e %b %k:%M ")
(setq display-time-default-load-average nil)
(setq magit-margin-default-time-format "%Y-%b-%d " )	; used after cycling
(setq magit-buffer-margin '(nil "%Y-%b-%d " 30 t 18))	; initial format
(setq magit-save-repository-buffers nil)
(setq magit-todos-keywords-list '("TODO" "RSN" "XXX" "FIXME"))
(setq magit-display-buffer-function #'jaw-magit-display-buffer)
(setq magit-commit-show-diff nil)
(setq grep-save-buffers nil)
(setq ediff-window-setup-function 'ediff-setup-windows-plain)
(setq ibuffer-expert t)
(setq zoom-size #'jaw-zoom-size)
(setq flycheck-global-modes '(go-mode cc-mode cperl-mode ruby-mode))
(setq dired-kill-when-opening-new-dired-buffer t)
(setq dired-listing-switches "-ahl")		; add 'h' (prettify sizes)
(setq dired-omit-files-regexp "^\\.\\(_\\|DS_\\)")
(setq window-divider-default-right-width 4)
(setq wdired-allow-to-change-permissions t)
(setq wdired-allow-to-redirect-links t)
(setq wdired-use-dired-vertical-movement t)
(setq find-ls-option (cons "-exec ls -ld {} +" "-ld")) ; less verbose than the default
(setq all-the-icons-dired-monochrome nil)
(setq temp-buffer-resize-mode t)    ; bigger *completion* window in zoom-mode
(setq windmove-allow-all-windows t) ; ignore no-other-window when moving
(setq-default help-window-select t) ; set focus on help window
(setq project-switch-commands 'project-find-dir)
(setq all-the-icons-ibuffer-icon t)
(setq all-the-icons-ibuffer-color-icon t)
(setq all-the-icons-ibuffer-human-readable-size t)

(setq inhibit-startup-message t)
(setq inhibit-startup-echo-area-message "jaw")
(if (>= emacs-major-version 23)
    (setq initial-scratch-message nil))

(put 'eval-expression 'disabled nil)
(put 'upcase-region   'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)
(put 'set-goal-column 'disabled nil)	; C-x C-n

(fset 'yes-or-no-p 'y-or-n-p)


(global-set-key (kbd "C-=")  'er/expand-region)
(global-set-key "\C-\M-k"    'kill-backwards-line)
(global-set-key "\C-c4"      'jaw-tab4)
(global-set-key "\C-c="      'align-current)
(global-set-key "\C-c\C-a"   'org-agenda)
(global-set-key "\C-c\C-l"   'org-store-link)
(global-set-key "\C-c\C-o"   'org-capture)
(global-set-key "\C-cb"      'insert-buffer)
(global-set-key "\C-cc"      'new-c-file)
(global-set-key "\C-cf"      'flyspell-mode)
(global-set-key "\C-cg"      'new-go-file)
(global-set-key "\C-ci"      'indent-region)
(global-set-key "\C-cp"      'new-perl-file)
(global-set-key "\C-cr"      'new-ruby-file)
(global-set-key "\C-cs"      'new-shell-file)
(global-set-key "\C-cx"      'jaw-send-to-x)
(global-set-key "\C-c~"      'diff-buffer-with-file)
(global-set-key "\C-x\C-b"   'ibuffer)			; instead of the std buffer list
(global-set-key "\C-xvt"     'git-timemachine)		; scroll through git revisions
(global-set-key "\C-z"       'undefined)
(global-set-key "\M- "       'hippie-expand)
(global-set-key "\M-g"       'goto-line)
(global-set-key "\e$"        'ispell-word)
(global-set-key "\eOF"       'end-of-buffer)
(global-set-key "\eOH"       'beginning-of-buffer)
(global-set-key "\e\e"       'eval-expression)
(global-set-key "\r"         'newline-and-indent)
(global-set-key [insert]     'undefined)
(define-key comint-mode-map (kbd "<up>")   'comint-previous-input) ; up/dn arrow for history
(define-key comint-mode-map (kbd "<down>") 'comint-next-input)


(window-divider-mode)	; slightly wider vertical divider
(windmove-default-keybindings)

(when (and window-system (not (eq window-system 'x)))
  (global-auto-revert-mode)
  (setq auto-revert-check-vc-info t))

(define-abbrev-table 'global-abbrev-table '(
    ("iferr" "if err != nil {")))
(setq save-abbrevs nil)


(org-babel-do-load-languages
 'org-babel-load-languages
  '((calc . t)
    (restclient . t)
    (sqlite . t)
    (gnuplot . t)
    (pikchr . t)
    (dot . t)
    (ruby . t)))

(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "" "Tasks")
         "* TODO %?\n  %U")
        ("j" "Journal" entry (file+datetree "" "Log")
         "* %U %?")
        ("n" "Note" entry (file+headline "" "Notes")
         "* %U %?")
        ;; save bookmark link using C-c C-l
        ("b" "Bookmark" entry (file+headline "" "Boomarks")
         "* %U %?\n  %a")
        ;; snip code in region, create link, add notes
        ("c" "Code Snippet" entry (file "~/.note-code.org")
         "* %U\n  [[file:%F::%(jaw-line-number-org)][%F]]\n  %?\n#+begin_src go\n  %i\n#+end_src\n")
        ))


;; load host specific config
(run-hooks 'jaw-after-configure)

