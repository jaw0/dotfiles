;; Copyright (c) 2007 by Jeff Weisberg
;; Author: Jeff Weisberg <jaw @ tcp4me.com>
;; Created: 2007-Feb-22 11:37 (EST)
;; Function: mode related functions


(setq auto-mode-alist
      (append '(
                ;("\\.c$"      . c-mode)
		;("\\.h$"      . c++-mode)
		;("\\.C$"      . c++-mode)
		;("\\.cc$"     . c++-mode)
		("\\.eqn$"    . nroff-mode)
		("\\.pic$"    . nroff-mode)
		("\\.tbl$"    . nroff-mode)
		("\\.p$"      . pascal-mode)
		("\\.s$"      . asm-mode)
		("\\.asm$"    . asm-mode)
		("\\.hs$"     . asm-mode)
	;	("\\.awk$"    . awk-mode)        broken
		("\\.yp$"     . yacc-mode)
		("\\.yh$"     . yacc-mode)
		("\\.yy$"     . yacc-mode)
		("\\.l$"      . lex-mode)
		; ("\\.sh$"     . sh-mode)
		; ("\\.csh$"    . csh-mode)
		("\\.jl$"     . jeff-lisp-mode)
		; ("\\.pl$"     . perl-mode)
		("\\.ps$"     . postscript-mode)
		; ("\\.html$"   . html-mode)
		; ("\\.shtml$"  . html-mode)
	;	("[mM]akefile". makefile-mode)   too fascist
		("\\.i96$"    . i96-mode)
                ("COMMIT_EDITMSG" . jaw-text-plus-mode)
                ("notes$"     . org-mode )
                (".scad$"     . scad-mode )
		)
	      auto-mode-alist))



(define-derived-mode jaw-text-plus-mode text-mode "Text#"
  "text mode with # comments"
  (setq-local comment-start "#")
  (font-lock-add-keywords nil '(("#+\\([[:space:]]\\|$\\).*" . font-lock-comment-face))))

(defun mason-mode ()
  (interactive)
  (text-mode)
  (flyspell-mode -1)	; turn off
  (make-variable-buffer-local 'tab-stop-list)
  (setq tab-stop-list (jaw-mk-tab-stop-list 200 4))
  (setq mode-name "mason")
  (setq major-mode 'mason-mode)
  (run-hooks 'mason-mode-hook)
  (set (make-local-variable 'font-lock-defaults) '(mason-font-lock-keywords)))

(defun jeff-lisp-mode ()
  "mode for editting jlisp code"
  (interactive)
  (emacs-lisp-mode)
  (setq mode-name "jeff-lisp")
  (setq major-mode 'jeff-lisp-mode)

  ;; get indent nice...
  (modify-syntax-entry ?\{ "(}  " emacs-lisp-mode-syntax-table)
  (modify-syntax-entry ?\} "){  " emacs-lisp-mode-syntax-table)

  (put 'do                'lisp-indent-hook 2)
  (put 'do*               'lisp-indent-hook 2)
  (put 'dolist            'lisp-indent-hook 1)
  (put 'dotimes           'lisp-indent-hook 1)
  (put 'case              'lisp-indent-hook 1)
  (put 'when              'lisp-indent-hook 1)
  (put 'unless            'lisp-indent-hook 1)
  (put 'while             'lisp-indent-hook 1)
  (put 'macro             'lisp-indent-hook 1)
  (put 'closure           'lisp-indent-hook 1)
  (put 'defmac            'lisp-indent-hook 'defun)

  (run-hooks 'jeff-lisp-mode-hook))

(defun lex-mode ()
  "mode for editting lex code"
  (interactive)
  (text-mode)
  (setq mode-name "lex")
  (setq major-mode 'lex-mode)
  (run-hooks 'lex-mode-hook))

(defun yacc-mode ()
  "mode for editting yacc code"
  (interactive)
  (text-mode)
  (setq mode-name "yacc")
  (setq major-mode 'yacc-mode)
  (run-hooks 'yacc-mode-hook))

(defun i96-mode ()
  "mode for editting i96 code"
  (interactive)
  (text-mode)
  (setq mode-name "i96")
  (setq major-mode 'i96-mode)
  (run-hooks 'i96-mode-hook))

