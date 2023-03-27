;;; ob-pikchr.el --- Babel Functions for pikchr -*- lexical-binding: t; -*-

;; Org-Babel support for pikchr: https://pikchr.org


(require 'ob)

(defvar org-babel-default-header-args:pikchr
  '((:results . "file graphics") (:exports . "results"))
  "Default arguments to use when evaluating a pikchr source block.")

(defun org-babel-execute:pikchr (body params)
  "Execute a block of pic code with org-babel.  This function is
called by `org-babel-execute-src-block' via multiple-value-bind."
  (let*
      ((processed-params (org-babel-process-params params))
       (out-file (cdr (or (assq :file processed-params)
                          (user-error "You need to specify a :file parameter"))))
       (file-ext (file-name-extension out-file))
       (darkmode (if (assq :darkmode processed-params) "--dark-mode " ""))
       (in-file (org-babel-temp-file "pikchr-" ".pic"))
       (svg-file (if (or (null file-ext) (string-equal file-ext "svg"))
                     out-file
                   (org-babel-temp-file "pikchr-" ".svg")))
       (cmd (concat "pikchr --svg-only " darkmode in-file)))

    ;; actually execute the source-code block either in a session or
    ;; possibly by dropping it to a temporary file and evaluating the
    ;; file.
    (with-temp-file in-file
      (insert body))
    (with-temp-file svg-file
      (insert (org-babel-eval cmd "")))
    (unless (string-equal svg-file out-file)
      (with-temp-buffer
        (let ((exit-code (call-process "convert" nil t nil svg-file out-file)))
          (when (/= exit-code 0)
            (org-babel-eval-error-notify exit-code (buffer-string))))))))


(defun org-babel-prep-session:pikchr (_session _params)
  "Return an error because pikchr does not support sessions."
  (user-error "pikchr does not support sessions"))

(provide 'ob-pikchr)


;;; example:
;;;
;;; #+begin_src pikchr :darkmode :file picout.svg
;;; circle "words"
;;; arrow
;;; box "images" rad 0.2
;;; #+end_src
