;; Copyright (c) 2007 by Jeff Weisberg
;; Author: Jeff Weisberg <jaw @ tcp4me.com>
;; Created: 2007-Feb-22 11:37 (EST)
;; Function: x windows startup stuff
;;
;; $Id: jaw-xwin.el,v 1.8 2016/09/07 20:52:37 jaw Exp $


(if (string-match "Emacs 19" (version))
    (progn
      (load-library "hilit19")
      (setq hilit-quietly t)
      (load-library "jaw-hilit"))
  (global-font-lock-mode t))


(show-paren-mode t)
(tooltip-mode -1)	; disable it
(scroll-bar-mode -1)

;; mac native puts the menu bar in the mac menu-bar
;; x puts it at top of frame
(when (not (eq window-system 'x))
  (menu-bar-mode t))

(if (fboundp 'blink-cursor-mode) (blink-cursor-mode -1))
(if (fboundp 'tool-bar-mode)     (tool-bar-mode -1))
(if (fboundp 'fringe-mode)       (fringe-mode 0))


(if (eq window-system 'ns)
    ;; make command key a meta key
    (setq ns-command-modifier 'meta))

(setq tab-bar-close-button-show nil)
(setq tab-bar-tab-hints t)
(setq minimap-window-location 'right)
(setq minimap-hide-fringes t)
(setq frame-title-format (list "Emacs : " user-login-name "@" system-name))
(setq frame-inhibit-implied-resize t) ; prevent frame resizing dance at startup

; proper key mappings
(global-set-key [home]      'beginning-of-buffer)
(global-set-key [end]       'end-of-buffer)
(global-set-key [f11]	    'jaw-toggle-fullscreen)
(global-set-key [C-f11]	    'jaw-xreverse-toggle)
(global-set-key [f27]       'beginning-of-buffer)
(global-set-key [f33]       'end-of-buffer)
(global-set-key [f29]       'scroll-down)
(global-set-key [f35]       'scroll-up)
(global-set-key [S-mouse-1] 'mouse-set-mark)
(global-set-key [mouse-4]   'scroll-down-1line)		; wheel
(global-set-key [mouse-5]   'scroll-up-1line)		; wheel
(global-set-key [wheel-right]  'scroll-left-1line)
(global-set-key [wheel-left]   'scroll-right-1line)

(global-set-key [vertical-line drag-mouse-1] 'jaw-mouse-drag-border)
(global-set-key [mode-line drag-mouse-1]     'jaw-mouse-drag-mode-line)
(global-set-key "\C-xz"	    'repeat)			; undo the remapping
(global-set-key "\M-c"	    'kill-ring-save)		; so that CMD-C copies to clipboard, even when CMD is meta


(when (boundp 'flyspell-mouse-map)
  (define-key flyspell-mouse-map [down-mouse-3] #'flyspell-correct-word))

; and unmap a few
(global-set-key [mode-line mouse-1]   'undefined)
(global-set-key [mode-line mouse-3]   'undefined)
(global-set-key [mode-line S-mouse-2] 'undefined)

(if (x-list-fonts "all-the-icons")
    (add-hook 'dired-mode-hook (lambda ()
                                 (if (fboundp 'all-the-icons-dired-mode)
                                     (all-the-icons-dired-mode)))))


;; font?
; NB - xlsfonts, fc-list
;    VictorMono has a cool handwritey italic
(defvar jaw-default-font
      (if (>= emacs-major-version 27)
          (seq-find 'x-list-fonts
                    '("Fira Code-12" "JetBrains Mono-12" "Lotion-12"
                      "Victor Mono-12:weight=semi-bold" "Menlo-12" "6x13"))
        "7x14"))

; get the "right" look
(if (eq window-system 'x)
    (setq default-frame-alist `(
                                (font           . ,jaw-default-font)))
  ; mac native - (mac,ns)
  (setq default-frame-alist `(
                              (alpha            .  (100 . 95))	; RSN - alpha-background
                              (font             . ,jaw-default-font))))

(if (boundp 'jaw-italic-font)
    (set-face-attribute 'italic nil :font jaw-italic-font))

; test alternate font:
;  (set-face-attribute 'default (selected-frame) :font "Fira Code-12")
;  (set-frame-parameter (selected-frame) 'alpha '(98 90))
;  (set-background-color "#fffffa")


(make-face 'tab-bar-buffer)
(make-face 'tab-bar-emacs)
(make-face 'tab-bar-spacer)
(make-face 'comment-keyword-tags)
(make-face 'eshell-prompt-user)
(make-face 'eshell-prompt-root)
(make-face 'eshell-prompt-dir)
(make-face 'mode-line-directory-face)

(defun jaw-xalpha (n)
  (interactive "nalpha: ")
  (set-frame-parameter (selected-frame) 'alpha (list n 90)))

(defun jaw-theme-is-dark ()
  (< (car (color-name-to-rgb (face-attribute 'default :background)))
     0.5))

; toggle "dark" mode / "light" mode
(defun jaw-xreverse-toggle ()
  (interactive)
  (if (jaw-theme-is-dark)
      (enable-theme 'jaw-theme-light)
    (enable-theme 'jaw-theme-dark)))


; get Mr. Mouse set up right
; see .../lisp/term/x-win.el for list of pointer names
; or "xfd -fn cursor"
; The set shape will not take effect till after a set-color

; NB - neither of these works for 'ns
(if (eq window-system 'x)
    (progn
      (setq x-pointer-shape x-pointer-top-left-arrow)
      (setq void-text-area-pointer 'text))
  (setq x-pointer-shape 0)
  (setq void-text-area-pointer 'arrow))

; (set-mouse-color "#f66")


;; enable fancy ligatures
;   https://github.com/tonsky/FiraCode/wiki/Emacs-instructions
;   https://github.com/mickeynp/ligature.el
(when (>= emacs-major-version 28)
  (ligature-set-ligatures 'text-mode '("www" "ff" "fi" "ffi" "fl" "fj" "ft" "Fl" "Tl" "..."
                               "!=" ">="
                               ("<"  "<?-+>*")	; <--, <--->
                               ("<"  "<?=+>*")	; <==, <===>
                               ("-"  "-*>*")	; lines of -- of ->
                               ("="  "=*>*")	; lines of == or =>
                               ("#"  "#+")	; lines of #
                               ("_"  "_+")))	; lines of _

  (ligature-set-ligatures 'prog-mode '("|||>" "<|||" "<!--" "~~>" "***" "||=" "||>"
                                       ":::" "::=" "=:=" "=!=" "=<<" "=/=" "!=="
                                       "!!." ">=>" ">>=" ">>>" ">>-" ">->"  "-<<"
                                       "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<=<"
                                       ">=" "<-<" "<<<" "<+>" "</>" "#_(" "..<"
                                       "..." "++" "+++" "/==" "///" "_|_" "www" "&&" "^=" "~~" "~@" "~="
                                       "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
                                       "[|" "]#" "::" ":=" ":>" ":<" "$>" "!=" "!!" ">:"
                                       ">>" ">-" "-~" "-|" "-<" "<~" "<*" "<|" "<:"
                                       "<$" "<>" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
                                       "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:"
                                       "?=" "?." "??" ";;" "/*" "/=" "/>" "//" "~~" "(*" "*)"
                                       "\\\\" "://" "=~" "!~" ".="

                                       ("<"  "<?-+>*")	; <--, <--->
                                       ("<"  "<?=+>*")	; <==, <===>
                                       ("-"  "-*>*")	; lines of -- of ->
                                       ("="  "=*>*")	; lines of == or =>
                                       ("#"  "#+")	; lines of #
                                       ("_"  "_+")))	; lines of _


  ;; Enables ligature checks globally in all buffers. You can also do it
  ;; per mode with `ligature-mode'.
  (global-ligature-mode t))


; lets make a menu!
(defvar menu-bar-jeffs-menu (make-sparse-keymap "Misc"))
(define-key global-map [menu-bar more] (cons "Misc" menu-bar-jeffs-menu))
(define-key menu-bar-jeffs-menu [invis]   '("Invis Frame"   . make-frame-invisible))
(define-key menu-bar-jeffs-menu [splitv]  '("Split ---"     . split-window-vertically))
(define-key menu-bar-jeffs-menu [splith]  '("Split  |"      . split-window-horizontally))
(define-key menu-bar-jeffs-menu [date]    '("Insert Date"   . insert-date))
(define-key menu-bar-jeffs-menu [cal]     '("Calendar"      . calendar))
(define-key menu-bar-jeffs-menu [mailnf]  '("Mail New Frame". mail-other-frame))
(define-key menu-bar-jeffs-menu [mail]    '("Mail"          . mail))
(define-key menu-bar-jeffs-menu [minimap] '("Minimap"       . minimap-mode))
(define-key menu-bar-jeffs-menu [tabbar]  '("Tab Bar"       . tab-bar-mode))
(define-key menu-bar-jeffs-menu [fullscr] '("Full Screen"   . jaw-toggle-fullscreen))

; and also put it in the mouse
(global-set-key [S-down-mouse-2] (cons "Misc" menu-bar-jeffs-menu))

(defhydra hydra-zoom (global-map "C-c w")
  "zoom window"
  ( "<left>"  (lambda () (interactive) (jaw-zoom-width+    1)) "+w")
  ( "<right>" (lambda () (interactive) (jaw-zoom-width+   -1)) "-w")
  ( "<up>"    (lambda () (interactive) (jaw-zoom-height+   1)) "+h")
  ( "<down>"  (lambda () (interactive) (jaw-zoom-height+  -1)) "-h")
  ( "+"       (lambda () (interactive) (text-scale-adjust  1)) "+z")
  ( "-"       (lambda () (interactive) (text-scale-adjust -1)) "-z")
  ( "_"       (lambda () (interactive) (text-scale-adjust -1)) "-z")
  ( "0"       (lambda () (interactive) (text-scale-adjust  0)) "z0")
  ( "o"       other-window "other"))


; get rid of the "Edit" menu
;(global-set-key [menu-bar edit] 'undefined)


(if (>= emacs-major-version 23)
    (setq mouse-drag-copy-region t))


(cond
 ((>= emacs-major-version 25)
  (setq select-enable-primary t))
 ((>= emacs-major-version 24)
  (setq x-select-enable-primary t)))

