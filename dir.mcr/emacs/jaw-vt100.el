;; Copyright (c) 2007 by Jeff Weisberg
;; Author: Jeff Weisberg <jaw @ tcp4me.com>
;; Created: 2007-Feb-22 11:37 (EST)
;; Function: map keys for vt100 in my office
;;
;; $Id: jaw-vt100.el,v 1.2 2009/02/21 18:45:35 jaw Exp $


(global-set-key [kp-2] 'next-line)
(global-set-key [kp-8] 'previous-line)
(global-set-key [kp-4] 'backward-char)
(global-set-key [kp-6] 'forward-char)
(global-set-key [kp-3] 'scroll-up)
(global-set-key [kp-9] 'scroll-down)
(global-set-key [kp-enter] 'newline-and-indent)
(global-set-key [kp-period] 'vt100-wide-mode)
(global-set-key [kp-comma] 'undefined)
(global-set-key [kp-0] 'save-buffer)
(global-set-key [kp-minus] 'undefined)
(global-set-key [kp-7] 'beginning-of-buffer)
(global-set-key [kp-1] 'end-of-buffer)
(global-set-key [kp-f1] 'undefined)
(global-set-key [kp-f2] 'undefined)
(global-set-key [kp-f3] 'undefined)
(global-set-key [kp-f4] 'undefined)

  ; also: find, insertchar, deletechar, select, prior, next,
  ;       help, menu, f{6,7,8,9,10,12,13,14,17,18,19,20}
  ; most of which seem not to work ...

;;; C-c does not work right on terminal in office
;;; grumble, grumble
(global-set-key "\C-x\C-@" 'kill-emacs)

;; remove trailing ----[...] in modeline
(setq-default mode-line-end-spaces nil)
;; because the default colors are just god-awful (black on almost black)
(setq dired-subtree-use-backgrounds nil)

; enable colors + mouse on color terminal
(when (and (>= emacs-major-version 24) (>= (tty-display-color-cells) 256))
  (xterm-mouse-mode)
  (global-set-key (kbd "<mouse-4>") 'scroll-down-line)
  (global-set-key (kbd "<mouse-5>") 'scroll-up-line))

