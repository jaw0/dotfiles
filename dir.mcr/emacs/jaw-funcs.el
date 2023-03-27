;; Copyright (c) 2007 by Jeff Weisberg
;; Author: Jeff Weisberg <jaw @ tcp4me.com>
;; Created: 2007-Feb-22 11:37 (EST)
;; Function: define a nice set of functions
;;
;; $Id: jaw-funcs.el,v 1.11 2016/03/21 01:50:22 jaw Exp $


(defun jaw-mk-tab-stop-list (max wid)
  "create list of tab stops"
  (if (< max wid)
      nil
    (append (jaw-mk-tab-stop-list (- max wid) wid)
	  (list max))))

(defun jaw-tab4 ()
  (interactive)
  (setq-local tab-width 4))

;; provide the line number to org-capture template
(defun jaw-line-number-org ()
  (with-current-buffer (org-capture-get :original-buffer)
    (number-to-string (line-number-at-pos))))

(defun scroll-up-1line ()
  (interactive)
  (scroll-up 1))

(defun scroll-down-1line ()
  (interactive)
  (scroll-down 1))

(defun scroll-right-1line ()
  (interactive)
  (scroll-right 1))

(defun scroll-left-1line ()
  (interactive)
  (scroll-left 1))

(defun kill-backwards-line ()
  "kill from point to beginning of line"
  (interactive)
  (let ((here (point)))
    (if (fboundp 'eshell-bol) (eshell-bol)
      (beginning-of-line))
    (kill-region (point) here)))

(defun jaw-insert-timestamp (&optional arg)
  "insert the current unix timestamp, with prefix use iso format"
  (interactive "P")
  (let ((now (current-time))
        (fmt (if arg "%Y-%m-%d T%H:%M:%S%z(%Z)" "%s")))
    (insert (format-time-string fmt now))))

(defun jaw-format-timestamp (ts &optional arg)
  "format + display a provided timestamp"
  (interactive "nTimestamp? \nP")
  (let* ((kt 1600000000) ; now-ish
         (ns 1000000000) ; for go nanosecs
         (ms 1000)	 ; for js millisecs
         (tt (cond
              ((> ts (* kt (sqrt ns)))  (/ ts ns))
              ((> ts (* kt (sqrt ms)))  (/ ts ms))
              (t ts)))
         (res (concat
               (format-time-string "Local: %Y-%m-%d %H:%M:%S %z(%Z) | " tt)
               (format-time-string "UTC: %Y-%m-%d %H:%M:%S Z" tt 0))))
    (if arg (insert res) (message res))))


(defun jaw-insert-uuid ()
  "insert a uuid"
  (interactive)
  (insert
   (substring (shell-command-to-string "uuidgen") 0 36)))

(defun jaw-fringe-left0 ()
  "set left fringe width to 0"
  (interactive)
  (set-window-fringes nil 0 nil nil t))

(defvar-local jaw-not-other-mode nil)
(defun jaw-not-other (arg)
  "prevent window from being the other window"
  (interactive "P")
  (setq minor-mode-alist (assq-delete-all 'jaw-not-other-mode minor-mode-alist))
  (setq-local jaw-not-other-mode nil)
  (cond
   ((equal arg 0)
    ;; remove effect
    (message "not-other removed")
    (set-window-dedicated-p nil nil)
    (set-window-parameter nil 'no-other-window nil))
   (arg
    (setq-local jaw-not-other-mode "X")
    (setq minor-mode-alist (append minor-mode-alist '((jaw-not-other-mode  jaw-not-other-mode))))
    ;; usually far too restrictive
    ;; 'side -> prevents quit-window from deleting the window
    (set-window-dedicated-p nil 'side)
    (set-window-parameter nil 'no-other-window t))
   (t
    (setq-local jaw-not-other-mode "x")
    (setq minor-mode-alist (append minor-mode-alist '((jaw-not-other-mode  jaw-not-other-mode))))
    ;; alternates between too restricive + not enough ... :-(
    (set-window-parameter nil 'no-other-window t)
    (set-window-dedicated-p nil nil)))) ; in case it was already on

(defun jaw-clear-priority ()
  (interactive)
  (walk-window-tree (lambda (w)
                      (if (window-parameter w 'jaw-window-primary)
                          (set-window-parameter w 'jaw-window-primary   nil))
                      (if (window-parameter w 'jaw-window-secondary)
                          (set-window-parameter w 'jaw-window-secondary til)))))

(defun jaw-mark-priority (arg)
  (interactive "P")
  (cond
   ((equal arg 0)
    (set-window-parameter nil 'jaw-window-primary   nil)
    (set-window-parameter nil 'jaw-window-secondary nil))
   ((equal arg 1)
    (set-window-parameter nil 'jaw-window-secondary nil)
    (set-window-parameter nil 'jaw-window-primary   t))
   ((equal arg 2)
    (set-window-parameter nil 'jaw-window-primary   nil)
    (set-window-parameter nil 'jaw-window-secondary t))
   (t
    (set-window-parameter nil 'jaw-window-primary   nil)
    (set-window-parameter nil 'jaw-window-secondary nil))))


(defmacro jaw-with-same-window (&rest body)
  "execute body in the current window"
  `(let
       ((save-dedicated (window-dedicated-p nil))
        (save-not-mode  jaw-not-other-mode))
     (set-window-dedicated-p nil nil)
     ;; (if jaw-not-other-mode
     ;;    (setq-local jaw-not-other-mode "x"))
     (unwind-protect
         (progn
           (same-window-prefix)
           ,@body)
       (set-window-dedicated-p nil save-dedicated)
       ;; (setq-local jaw-not-other-mode save-not-mode)
       )))


(defun jaw-zoom-size ()
  (cond
   ;; -> (setq-local jaw-default-zoom-size (cons w h))
   ((local-variable-p 'jaw-default-zoom-size) jaw-default-zoom-size)
   ;; RSN [jaw 2022-Oct-21] window param?
   ((equal (buffer-name) "COMMIT_EDITMSG")       (cons 100 25))
   ((equal (buffer-name) "*scratch*")            (cons 100 35))
   ((equal (buffer-name) "x")                    (cons 100 35))
   ((equal (buffer-name) "*Help*")               (cons 100 35))
   ((derived-mode-p   'magit-mode)               (cons 100 25))
   ((equal major-mode 'eshell-mode)              (cons 100 25))
   ((equal major-mode 'shell-mode)               (cons 100 25))
   ((equal major-mode 'term-mode)                (cons 100 25))
   ((equal major-mode 'org-mode)                 (cons 100 40))
   ((derived-mode-p   'text-mode)                (cons 100 40))
   ((equal major-mode 'magit-status-mode)        (cons 100 25))
   ((equal major-mode 'calc-mode)                (cons  50 20))
   ((bound-and-true-p dired-hide-details-mode)   (cons  40 40))
   ((equal major-mode 'dired-mode)               (cons  90 40))
   ((equal major-mode 'wdired-mode)              (cons  90 40))
   ((equal major-mode 'compilation-mode)         (cons 100 35))
   ((equal major-mode 'grep-mode)                (cons 120 35))
   ((equal major-mode 'calendar-mode)            (cons  90 15))
   ((boundp 'jaw-default-zoom-size)              jaw-default-zoom-size)
   (t                                            (cons 120 40))))

(defun jaw-zoom-update (&rest args)
  (if (fboundp 'zoom--update)
      (zoom--update)))

(defun jaw-zoom-width+ (arg)
  (interactive "P")
  (when (not (boundp 'jaw-default-zoom-size))
    (setq-local jaw-default-zoom-size (cons (window-width) (window-height))))
  (let ((n (or arg 1))
        (w (car jaw-default-zoom-size))
        (h (cdr jaw-default-zoom-size)))
    (setq-local jaw-default-zoom-size
                (cons (+ w n) h))
    (message (format "%s" jaw-default-zoom-size))
    (zoom--update)))

(defun jaw-zoom-height+ (arg)
  (interactive "P")
  (when (not (boundp 'jaw-default-zoom-size))
    (setq-local jaw-default-zoom-size (cons (window-width) (window-height))))
  (let ((n (or arg 1))
        (w (car jaw-default-zoom-size))
        (h (cdr jaw-default-zoom-size)))
    (setq-local jaw-default-zoom-size
                (cons w (+ h n)))
    (message (format "%s" jaw-default-zoom-size))
    (zoom--update)))


;; copy current region + yank it into buffer 'x'
;; if no active region, switch to x
(defun jaw-send-to-x ()
  "send region to buffer-x"
  (interactive)
  (if (use-region-p)
      (let ((text (buffer-substring (region-beginning) (region-end))))
        (with-current-buffer "x"
          (end-of-buffer)
          (if (> (current-column) 0) (insert "\n"))
          (insert text)
          (if (> (current-column) 0) (insert "\n"))))
    (switch-to-buffer-other-window "x")))

(autoload 'time-stamp-string "time-stamp")
(defun new-info-block (cc)
  "add info block to file"
  (interactive "Mcomment character? ")
  (insert cc (time-stamp-string " Copyright (c) %:y\n")
	  cc " Author: " jaw-info-name " <" jaw-info-addr ">\n"
	  ;; format documented in: /usr/local/share/emacs/20.4/lisp/time-stamp.el
	  cc (time-stamp-string " Created: %:y-%3b-%02d %02H:%02M (%Z)\n")
	  cc " Function: \n")
  (if (file-accessible-directory-p "CVS")
      (insert cc "\n" cc " $I" "d$\n"))
  (insert "\n"))

(defun jaw-insert-todo-comment (&optional arg)
  (interactive "P")
  "insert keyword/todo/tag comment"
  ; prompt for tag if called with prefix-arg
  (let ((tag (if arg
                 (read-string "tag? " nil nil (list "TODO" "RSN" "QQQ" "XXX"))
               "TODO")))
    (insert (string-trim comment-start) " " (upcase tag)
            " [" jaw-todo-tag " "
            (time-stamp-string "%:y-%3b-%02d")
            "] "
            comment-end)
    (backward-char (length comment-end))))

;; hightlight todo comments
(defun jaw-highlight-keyword-tags ()
  (interactive)
  (font-lock-add-keywords
   nil '(("\\(\\w+ \\[jaw [^]]*\\]\\)" 1 'comment-keyword-tags t)
         ("\\<\\(XXX\\|TODO\\|QQQ\\|RSN\\|FIXME\\)\\>"
          1 'comment-keyword-tags t))))

;; text in top tab bar
(defun jaw-emacs-title ()
  (concat "  [ "
          (propertize (buffer-name) 'face 'tab-bar-buffer)
          " ]     "
          (propertize " " 'face 'tab-bar-spacer) ; to adjust height of tab-bar
          (propertize (concat "Emacs : " user-login-name "@" system-name) 'face 'tab-bar-emacs)))

;; toggle-frame-fullscreen + top-bar + fringes in fullscreen mode
;; top-bar = tab-bar mode w/o tabs
;; fullboth - takes over the full screen; maximized keeps window manager decor
(defun jaw-toggle-fullscreen ()
  "Toggle full screen"
  (interactive)

  (if (frame-parameter nil 'fullscreen)
      (progn
        (fringe-mode 0)
        ; (setq tab-bar-format nil) ; put display-time back in mode-line?
        (set-frame-parameter (selected-frame) 'tab-bar-lines 0)
        (set-frame-parameter nil 'fullscreen nil))
    (set-frame-parameter nil 'fullscreen
                         (if (boundp 'jaw-fullscreen-mode) jaw-fullscreen-mode 'fullboth))
    (when (>= emacs-major-version 28)
      ; simple no-tab tab-bar to clear notch
      (setq tab-bar-format (list 'jaw-emacs-title
                                 'tab-bar-format-align-right
                                 'tab-bar-format-global
                                 (lambda () " ")))
      (display-time)
      (display-battery-mode t)
      (tab-bar-mode))
    (fringe-mode 8)))



;; have magit reuse a magit window, or split the window
;; instead of using a random window
(defun jaw-magit-display-buffer (buffer)
  (let* ((mode (with-current-buffer buffer major-mode))
         (how  (cond
                ((derived-mode-p 'magit-mode) '(display-buffer-same-window))
                ((memq mode '(magit-process-mode
                              magit-revision-mode
                              magit-diff-mode
                              magit-stash-mode))
                 nil)
                (t '(display-buffer-below-selected)))))
    (display-buffer buffer how)))


(defun jaw-setup-311 ()
  (interactive)
  (if (boundp 'jaw-setup-file-list)
      (dolist (file jaw-setup-file-list)
        (find-file file t)))
  (switch-to-buffer "*scratch*")
  (let*
      ;; a0  b0  c0
      ;; a1
      ;; a2
      ((a0 (car (window-list)))
       (b0 (split-window a0 nil 'right))
       (c0 (split-window b0 nil 'right))
       (a1 (split-window a0 nil 'below))
       (a2 (split-window a1 nil 'below)))
    (set-window-fringes b0 0 nil nil t)
    (set-window-fringes c0 0 nil nil t)
    (with-selected-window a2 (eshell))
    (with-selected-window a1 (eshell 1))
    (with-selected-window a0 (switch-to-buffer "x"))
    (jaw-clear-priority)
    (set-window-parameter b0 'jaw-window-primary   t)
    (set-window-parameter a0 'jaw-window-secondary t)

    ;; (set-window-parameter a1 'no-other-window t)
    ;; (set-window-parameter a2 'no-other-window t)
    (zoom-mode)))

(defun jaw-setup-21 ()
  (interactive)
  (let*
      ;; a0  b0
      ;; a1
      ((a0 (car (window-list)))
       (b0 (split-window a0 nil 'right))
       (a1 (split-window a0 nil 'below)))
    (set-window-fringes b0 0 nil nil t)
    (with-selected-window a1 (eshell))
    (setq jaw-default-zoom-size (cons 100 40))
    (jaw-clear-priority)
    (set-window-parameter b0 'jaw-window-primary   t)
    (set-window-parameter a0 'jaw-window-secondary t)
    (zoom-mode)))


;; portions borrowed from x-sb-mouse package
(defun jaw-mouse-drag-mode-line (click)
  "drag window mode-line with mouse"
  (interactive "@e")

    (let* (
	 (oyr (cdr (posn-col-row (event-start click))))
	 (nyr (cdr (posn-col-row (event-end   click))))
	 (oxr (car (posn-col-row (event-start click))))
	 (nxr (car (posn-col-row (event-end   click))))
	 (sw (selected-window))
	 (ow (posn-window (event-start click)))
	 (nw (posn-window (event-end click)))
	 (nedges (window-edges ow))
	 (oedges (window-edges nw))
	 (oya  (+ oyr (nth 1 nedges)))
	 (nya  (+ nyr (nth 1 oedges)))
	 (bot  (nth 3 nedges))
	 (top  (nth 1 nedges)))
      (cond
       (
	;; drag bml up
	(and
	 (not (window-minibuffer-p nw))
	 (or (= oya (1- bot)) (= oya (1- top)))  ; bounds check
	 (window-minibuffer-p (window-at oxr (1+ oya)))) ; line below here a mb?
	(select-window (window-at oxr (1+ oya))) ; the mb
	(enlarge-window (- oya nya))
	(select-window  ow))
       (
	;; drag a reglar ml
	(and
	 (not (window-minibuffer-p nw))
	 (or (= oya (1- bot)) (= oya (1- top))))  ; bounds check
	(select-window ow)
	(enlarge-window (- nya oya)))
       (
	;; drag bml down
	(and
	 (window-minibuffer-p nw)
	 (= oya (- (1- (frame-height)) (window-height nw)))
	 (> (- (window-height nw) (- nya oya)) 0))
	(select-window nw)  ; the mb
	(enlarge-window (- oya nya))
	(select-window ow)))
      (select-window sw)))

(defun insert-nroff-comment ()
  (interactive)
  (insert ".\\\" "))

(defun insert-headers ()
  (goto-line 3)
  (insert "X-Organization-URL: http://www.op.net\n")
  (insert "X-Zippy: " ) (yow t)
  (insert "Keywords: ") (shell-command "randomline -s -l 5 -n 5 -C /usr/opnet/dict biology yiddish cartoon jargon jargon shakespeare common-passwords.txt" t))

(defun jaw-is-mac-ws ()
  (or (eq window-system 'ns) (eq window-system 'mac)))

(defun jaw-zap ()
  (interactive)
  "remove text properties from region"
  (set-text-properties (region-beginning) (region-end) nil))

;;; ================================================================
;;; new file init functions
;;; ================================================================


(defun new-perl-file ()
  "set up file for perl code"
  (interactive)
  (perl-mode)
  (if (string-match "\\.pm$" (buffer-name))
      (insert "# -*- perl -*-\n\n")
    (insert "#!/usr/local/bin/perl\n# -*- perl -*-\n\n"))
  (new-info-block "#"))

(defun new-ruby-file ()
  "set up file for ruby code"
  (interactive)
  (ruby-mode)
  (insert "#!/usr/local/bin/ruby\n# -*- mode: ruby; coding: utf-8 -*-\n")
  (new-info-block "#"))

(defun new-shell-file ()
  "set up file for shell script"
  (interactive)
  (defvar sh-shell-file "/bin/sh")
  (insert "#!/bin/sh\n\n")
  (new-info-block "#")
  (shell-script-mode))

(defun new-sql-file ()
  (interactive)
  (new-info-block "--"))

(defun new-mason-file ()
  (interactive)
  (mason-mode)
  (insert "%# -*- mason -*-\n")
  (new-info-block "%#"))

(defun new-c-file ()
  (interactive)
  (insert "/*\n")
  (new-info-block " ")
  (insert "*/\n"))

(defun new-java-file ()
  (interactive)
  (new-info-block "//"))

(defun new-go-file ()
  (interactive)
  (go-mode)
  (new-info-block "//"))

(defun new-vxml-file ()
  "set up file for vxml code"
  (interactive)
  (make-variable-buffer-local 'tab-stop-list)
  (setq tab-stop-list (jaw-mk-tab-stop-list 200 2))
  (insert "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n")
  (insert "<vxml version=\"2.0\">\n")
  (insert "<!--\n")
  (new-info-block "  ")
  (insert "-->\n"))

(defun new-xpl-file ()
  "set up file for xpl code"
  (interactive)
  (make-variable-buffer-local 'tab-stop-list)
  (setq tab-stop-list (jaw-mk-tab-stop-list 200 4))
  (insert "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n")
  (insert "<!DOCTYPE methoddef SYSTEM \"rpc-method.dtd\">\n")
  (insert "<!--\n")
  (new-info-block "  ")
  (insert "-->\n")
  (insert "<methoddef>
<name><!-- METHOD NAME --></name>
<version>1.0</version>
<signature><!-- RETURN-TYPE ARG-TYPES --></signature>

<help>
<!-- HELP -->
</help>

<code language=\"perl\">
<![CDATA[

sub _METHOD {
#line 26 file.xpl
    package AT::API::XMLRPC;
    my $me  = shift;
    my( $cmp, $start, $end ) = @_;

    my $sess  = current_user();
    return fault(400, 'Invalid User', $me) unless $sess->{user};

    return fault( 400, 'Permission Denied' , $me, @_)
	unless chk_perm( $sess, 'user', cmp => $cmp );

    my $db = AT::SQL->connection();

}
__END__
]]></code>
</methoddef>
"))

