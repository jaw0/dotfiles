;; Copyright (c) 2022
;; Author: Jeff Weisberg <tcp4me.com!jaw>
;; Created: 2022-Oct-26 11:48 (EDT)
;; Function: display-buffer-alist


(defun jaw-display-eshell-same (buffer alist)
  "use the current window, if it is an eshell"
  (if (string-match "\\*eshell\\*" (buffer-name))
      (window--display-buffer buffer (selected-window) 'reuse alist)
    nil))

(defun jaw-buffer-is-dired (buffer unused)
  "is this buffer a dired?"
  (eq (with-current-buffer buffer major-mode) 'dired-mode))

(defun jaw-buffer-is-file-other (buffer action)
  "is this buffer a file for an other window?"
  ;; action: nil | (display-buffer-same-window (inhibit-same-window))
  (and (not action) (with-current-buffer buffer buffer-file-name)))

;; primary/secondary - set in jaw-funcs/jaw-setup*,jaw-mark-priority
;; primary : large central main window
;; secondary : smaller upper-left window
(defun jaw-display-primary (buffer alist)
  (let
      ((win (window-with-parameter 'jaw-window-primary t)))
    (if win
        (window--display-buffer buffer win 'reuse alist)
      nil)))

(defun jaw-display-secondary (buffer alist)
  (let
      ((win (window-with-parameter 'jaw-window-secondary t)))
    (if win
        (window--display-buffer buffer win 'reuse alist)
      nil)))


(setq display-buffer-alist
      '(
        ("\\(\\*Diff\\*\\|magit-diff\\)"
         (display-buffer-reuse-window display-buffer-same-window jaw-display-primary))

        ("\\*\\(grep\\|compilation\\|Find\\|Proced\\)\\*"
         (jaw-display-eshell-same display-buffer-reuse-window display-buffer-same-window jaw-display-secondary))

        (jaw-buffer-is-dired
         (jaw-display-eshell-same display-buffer-reuse-window display-buffer-same-window jaw-display-secondary))

        ("\\*\\(Help\\|Apropos\\)\\*"
         (display-buffer-reuse-window jaw-display-secondary))

        ("\\*\\(Occur\\|Calendar\\)\\*"
         (display-buffer-reuse-window display-buffer--maybe-pop-up-frame-or-window display-buffer-below-selected))

        ("\\*Completions\\*"
         (display-buffer-reuse-window display-buffer--maybe-pop-up-frame-or-window display-buffer-at-bottom)
         (window-height . 15)
         (window-min-height . 15))

        ("\\*info\\*"
         (display-buffer-reuse-window display-buffer-same-window jaw-display-primary))

        ("^\\*"
         (display-buffer-reuse-window display-buffer--maybe-same-window jaw-display-secondary))

        ;; not just any arbitrary 'other' window
        (jaw-buffer-is-file-other
         (display-buffer--maybe-same-window display-buffer-reuse-window jaw-display-primary jaw-display-secondary))

        ))


;; ################################################################
"
 ‘display-buffer-same-window’ -- Use the selected window.
 ‘display-buffer-reuse-window’ -- Use a window already showing the buffer.
 ‘display-buffer-in-previous-window’ -- Use a window that did show the buffer before.
 ‘display-buffer-use-some-window’ -- Use some existing window.
 ‘display-buffer-use-least-recent-window’ -- Try to avoid re-using windows that have recently been switched to.
 ‘display-buffer-pop-up-window’ -- Pop up a new window.
 ‘display-buffer-below-selected’ -- Use or pop up a window below the selected one.
 ‘display-buffer-at-bottom’ -- Use or pop up a window at the bottom of the selected frame.
 ‘display-buffer-pop-up-frame’ -- Show the buffer on a new frame.
 ‘display-buffer-in-child-frame’ -- Show the buffer in a child frame.
 ‘display-buffer-no-window’ -- Do not display the buffer and have ‘display-buffer’ return nil immediately.

 display-buffer--maybe-same-window
 display-buffer-in-side-window - (side, slot)
 display-buffer-in-direction   - (direction [left,right,aboce,below,leftmost,rightmost,top,bottom], window)
"

;; default:
;;   '((display-buffer--maybe-same-window
;;      display-buffer-reuse-window
;;      display-buffer--maybe-pop-up-frame-or-window
;;      display-buffer-in-previous-window
;;      display-buffer-use-some-window
;;      display-buffer-pop-up-frame))
