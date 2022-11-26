;; Copyright (c) 2022
;; Author: Jeff Weisberg <tcp4me.com!jaw>
;; Created: 2022-Oct-22 11:06 (EDT)
;; Function: for eshell (+ similar)


(setq eshell-buffer-maximum-lines 8192) ; limit shell buffer sizes
(setq comint-buffer-maximum-size  8192)
(setq term-buffer-maximum-size    8192)
(setq eshell-prompt-function #'jaw-eshell-prompt)
(setq eshell-banner-message "")
(setq eshell-hist-ignoredups 'erase)
(setq eshell-save-history-on-exit nil)
(setq eshell-aliases-file "/nosuchfile") ; don't use an alias file


;; turn on header
(dolist (hook '(term-mode-hook shell-mode-hook eshell-mode-hook))
  (add-hook hook #'jaw-shell-header))

(add-hook 'term-exec-hook (lambda ()
                            (define-key term-raw-escape-map "\C-y" 'term-paste)
                            ;; fix utf-8 prompt under x11 (?)
                            ;; otherwise we see \xxx\xxx\xxx
                            ;; now we see ?. non-x11, we see a correct prompt
                           (set-buffer-process-coding-system 'utf-8-unix 'utf-8-unix)))


(when  (>= emacs-major-version 27)
  (add-hook 'eshell-expand-input-functions
            #'eshell-expand-history-references))


(add-hook 'comint-mode-hook
          (lambda ()
            (add-hook 'comint-output-filter-functions #'comint-truncate-buffer)))

(add-hook 'eshell-first-time-mode-hook
          (lambda ()
            (add-hook 'eshell-output-filter-functions #'eshell-truncate-buffer)))


(add-hook 'eshell-first-time-mode-hook
          (lambda ()
            (setenv "PAGER"     "cat")
            (setenv "GIT_PAGER" "cat")
            (eshell/alias ","        "cd -")
            (eshell/alias ".."       "cd ..")
            (eshell/alias "..."      "cd ../..")
            (eshell/alias "...."     "cd ../../..")
            (eshell/alias "c"        "clear")
            (eshell/alias "h"        "head $*")
            (eshell/alias "t"        "tail $*")
            (eshell/alias "l"        "ls $*")
            (eshell/alias "ll"       "ls -lah $*")
            (eshell/alias "lz"       "ls -lahSr $*")
            (eshell/alias "md"       "mkdir $*")
            (eshell/alias "!"        "history")
            (eshell/alias "compile"  "jaw-eshell-compile - $*")
            (eshell/alias "m"        "jaw-eshell-compile make $*")
            (eshell/alias "go"       "jaw-eshell-compile \"env TMPDIR=. go\" $*")
            (eshell/alias "ff"       "jaw-find-name-dired $*")    ; dir regexp
            (eshell/alias "g"        "grep  $*")            ; regexp fileglob
            (eshell/alias "lgrep"    "jaw-eshell-lgrep $*") ; regexp fileglob dir
            (eshell/alias "rgrep"    "jaw-eshell-rgrep $*") ; regexp fileglob dir
            (eshell/alias "srch"     "jaw-eshell-rgrep $*")
            ;;(eshell/alias "procg"    "jaw-eshell-proced-grep $1") ; bug#58748
            (eshell/alias "psw"      "ps axuww")
            (eshell/alias "psg"      "ps axuww | grep $* | grep -v grep")
            (eshell/alias "de"       "jaw-eshell-dired $*")
            (eshell/alias "dir"      "jaw-eshell-dired $*")
            (eshell/alias "eo"       "find-file-other-window $1")
            (eshell/alias "em"       "find-file $1")))


;; display directory nicer in eshell prompt
(defun jaw-directory-display (dirname)
  ;; abbreviate and ~ify
  (let
      ((dir (abbreviate-file-name dirname))
       (dir-alist '( ("/home/\[^/\]+/jaw/" . "~@/")
                     ("/home/jaw/"         . "~@/"))))
    (dolist (pair dir-alist)
      (setq dir (replace-regexp-in-string (car pair) (cdr pair) dir)))
    ;; truncate
    (let*
        ((dl (split-string dir "/")))
      (if (> (length dl) 4)
          (string-join (last dl 4) "/")
        dir))))

(defun jaw-parse-user-host-directory ()
  (let*
      ((dirname (or (if (fboundp 'eshell/pwd) (eshell/pwd) nil) default-directory))
       (trampsd (split-string dirname ":")) ; ssh:[user@]host:dir
       (tramphd (if (> (length trampsd) 1) (split-string (cadr trampsd) "@") nil))
       (hostname (or (nth 1 tramphd) (nth 1 trampsd) (system-name)))
       (host (car (split-string hostname "\\.")))
       (user (if (> (length tramphd) 1) (nth 0 tramphd) (user-login-name)))
       (dir  (or (nth 2 trampsd) dirname)))
    (list user host dir)))


;; prompt for eshell: "user@host dir $ "
(defun jaw-eshell-prompt ()
  (let*
      ((uhd (jaw-parse-user-host-directory))
       (dir (jaw-directory-display (nth 2 uhd)))
       (host (nth 1 uhd))
       (user (nth 0 uhd))
       (userface (if (equal user "root") 'eshell-prompt-root 'eshell-prompt-user)))
  (concat
   (propertize (concat user "@" host " ") 'face userface)
   (propertize dir  'face 'eshell-prompt-dir)
   (propertize " $" 'face userface)
   (propertize " "  'face 'default))))


(defun jaw-shell-header-dingbat (user)
  (cond
   ((equal user "root")
    (propertize "⚠" 'face 'error))
   ((not (eq window-system 'x))
    "◀")
   (t "*")))

;; "* host : /path/name"
(defun jaw-shell-header-line (pretext posttext)
  (let*
      ((uhd (jaw-parse-user-host-directory)))
    (list pretext (jaw-shell-header-dingbat (nth 0 uhd))
          " " (nth 1 uhd) " : " (nth 2 uhd) posttext)))

(defun jaw-shell-header-centered ()
  (let*
      ((line (jaw-shell-header-line "  " ""))
       (pad  (/ (- (window-width) (string-width (apply 'concat line))) 2)))
    (append (list (make-string (max 0 (floor pad)) ? )) line)))

;; header on shell windows with directory centered
(defun jaw-shell-header ()
  (interactive)
  (setq-local header-line-format (if header-line-format nil
              '(:eval (jaw-shell-header-centered)))))


;; directory in mode-line at right
(defun jaw-shell-ml-directory ()
  (interactive)
  (setq mode-line-format (append mode-line-format
                                 '((:eval (jaw-shell-ml-directory-text))))))

;; right-aligned in mode-line
(defun jaw-shell-ml-directory-text ()
  (let*
      ((txt (apply 'concat (jaw-shell-header-line "" "")))
       (pad (- (window-width) (string-width txt) 1)))
    (concat
     (propertize " " 'display `((space :align-to ,pad)))
     (propertize txt 'face 'mode-line-directory-face))))

;; ################################################################

(defun jaw-eshell-rgrep (args)
  (interactive)
  "rgrep regexp [fileglob dir]"
  ;; if not specified - all files
  (if (< (length args) 2) (nconc args (list "*")))
  (grep-compute-defaults)
  (apply 'rgrep args))

(defun jaw-eshell-lgrep (args)
  (interactive)
  "lgrep regexp [fileglob dir]"
  ;; if not specified - all files
  (if (< (length args) 2) (nconc args (list "*")))
  (grep-compute-defaults)
  (apply 'lgrep args))

(defun jaw-eshell-dired (args)
  (interactive)
  ;; if not specified, current directory
  (apply 'dired (if args args '("."))))

(defun jaw-eshell-compile (cmd args)
  (interactive)
  (compile (string-join
            (if (equal cmd "-") args (append (list cmd) args)) " ")))


;; bug#58748 - proced filter doesn't quite work...
(defun jaw-eshell-proced-grep (reg)
  (interactive "Mregex? ")
  (proced)
  (proced-filter-interactive (list (cons 'args reg))))

(defun jaw-find-name-dired (args)
  (interactive)
  ;; [dir] glob
  (apply 'find-name-dired (if (< (length args) 2) (append '(".") args) args)))
