;; Copyright (c) 2009 by Jeff Weisberg
;; Author: Jeff Weisberg <jaw @ tcp4me.com>
;; Created: 2009-Feb-22 11:54 (EST)
;; Function: email stuff
;;
;; $Id: jaw-email.el,v 1.2 2009/02/28 18:28:33 jaw Exp $

(add-hook 'mail-send-hook 'flyspell-mode-off)

(add-hook 'mail-mode (lambda ()
                       (setq flyspell-generic-check-word-p 'mail-mode-flyspell-verify)))

(add-hook 'mail-mode-hook (lambda ()
			    (local-set-key "\C-cm" 'jaw-mail-from-fixup)))

(add-hook 'mail-send-hook  'jaw-mail-from-fixup)

(defun jaw-mail-from-fixup ()
  (interactive)
  (let* ((end (copy-marker (mail-header-end)))
	(to (progn
	      (goto-char (point-min))
	      (buffer-substring (re-search-forward "^\\(to\\|cc\\):[ \t]*" end t)
				(re-search-forward "$" end t))))
	(from (progn
		(goto-char (point-min))
		(let ((pos (re-search-forward "^from:[ \t]*" end t)))
		  (if pos
		      (buffer-substring pos
					(re-search-forward "$" end t))))))
	(val (cdr (assoc to mail-from-alist))))
    (if (and val (not (equal val from)))
	;; need to fix from
	(if from (progn
		   ;; change from
		   (goto-char (point-min))
		   (re-search-forward "^from:[ \t]*" end t)
		   (kill-line)
		   (insert val))
	  ;; insert new from
	  (goto-char (point-min))
	  (insert "From: " val "\n")))))




; load in GPG stuff
(mc-setversion "gpg")
(add-hook 'mail-mode-hook 'mc-install-write-mode)

(setq mail-use-rfc822 t)
(setq mail-spool-file "")

(setq mail-archive-file-name (expand-file-name "~/mail/sent-mail-archive"))
(setq message-signature-separator "^-- *$")	; workaround flyspell bug

(setq mail-user-agent 'message-user-agent)
(setq compose-mail-user-agent-warnings nil)
(setq message-send-mail-function 'message-smtpmail-send-it)
(setq send-mail-function 'smtpmail-send-it)

(setq smtpmail-smtp-server "mail.tcp4me.com")
(setq smtpmail-smtp-service 587)
; (setq smtpmail-debug-info t)
